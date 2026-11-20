include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/store.view.lkml"
include: "/bronze/store.refinement.lkml"

view: store_monthly_sales_lag_lead {
  # ponytail: single Gold SDT computing monthly category-brand-store-company store sales, annual monthly average, and ranked adjacent-month lag/lead sales in one SQL pass; split v1 into a reusable monthly store sales NDT if standalone unpaired monthly rollups are queried
  derived_table: {
    sql:
      WITH v1 AS (
        SELECT
          {{ _sdt_i.i_category._sql }} AS i_category,
          {{ _sdt_i.i_brand._sql }} AS i_brand,
          {{ _sdt_s.s_store_name._sql }} AS s_store_name,
          {{ _sdt_s.s_company_name._sql }} AS s_company_name,
          {{ _sdt_d.d_year_num._sql }} AS d_year,
          {{ _sdt_d.d_moy._sql }} AS d_moy,
          SUM({{ _sdt_ss.ss_sales_price._sql }}) AS sum_sales,
          AVG(SUM({{ _sdt_ss.ss_sales_price._sql }})) OVER (
            PARTITION BY
              {{ _sdt_i.i_category._sql }},
              {{ _sdt_i.i_brand._sql }},
              {{ _sdt_s.s_store_name._sql }},
              {{ _sdt_s.s_company_name._sql }},
              {{ _sdt_d.d_year_num._sql }}
          ) AS avg_monthly_sales,
          RANK() OVER (
            PARTITION BY
              {{ _sdt_i.i_category._sql }},
              {{ _sdt_i.i_brand._sql }},
              {{ _sdt_s.s_store_name._sql }},
              {{ _sdt_s.s_company_name._sql }}
            ORDER BY
              {{ _sdt_d.d_year_num._sql }},
              {{ _sdt_d.d_moy._sql }}
          ) AS rn
        FROM ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_ss._name }}
        INNER JOIN ${item.SQL_TABLE_NAME} AS {{ _sdt_i._name }}
          ON {{ _sdt_ss.ss_item_sk._sql }} = {{ _sdt_i.i_item_sk._sql }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_d._name }}
          ON {{ _sdt_ss.ss_sold_date_sk._sql }} = {{ _sdt_d.d_date_sk._sql }}
        INNER JOIN ${store.SQL_TABLE_NAME} AS {{ _sdt_s._name }}
          ON {{ _sdt_ss.ss_store_sk._sql }} = {{ _sdt_s.s_store_sk._sql }}
        WHERE (
          {{ _sdt_d.d_year_num._sql }} = {% parameter target_year %}
          OR ({{ _sdt_d.d_year_num._sql }} = {% parameter target_year %} - 1 AND {{ _sdt_d.d_moy._sql }} = 12)
          OR ({{ _sdt_d.d_year_num._sql }} = {% parameter target_year %} + 1 AND {{ _sdt_d.d_moy._sql }} = 1)
        )
        GROUP BY
          {{ _sdt_i.i_category._sql }},
          {{ _sdt_i.i_brand._sql }},
          {{ _sdt_s.s_store_name._sql }},
          {{ _sdt_s.s_company_name._sql }},
          {{ _sdt_d.d_year_num._sql }},
          {{ _sdt_d.d_moy._sql }}
      ),
      v2 AS (
        SELECT
          v1.i_category AS i_category,
          v1.i_brand AS i_brand,
          v1.s_store_name AS s_store_name,
          v1.s_company_name AS s_company_name,
          v1.d_year AS d_year,
          v1.d_moy AS d_moy,
          v1.avg_monthly_sales AS avg_monthly_sales,
          v1.sum_sales AS sum_sales,
          v1_lag.sum_sales AS psum,
          v1_lead.sum_sales AS nsum
        FROM v1
        INNER JOIN v1 AS v1_lag
          ON v1.i_category = v1_lag.i_category
          AND v1.i_brand = v1_lag.i_brand
          AND v1.s_store_name = v1_lag.s_store_name
          AND v1.s_company_name = v1_lag.s_company_name
          AND v1.rn = v1_lag.rn + 1
        INNER JOIN v1 AS v1_lead
          ON v1.i_category = v1_lead.i_category
          AND v1.i_brand = v1_lead.i_brand
          AND v1.s_store_name = v1_lead.s_store_name
          AND v1.s_company_name = v1_lead.s_company_name
          AND v1.rn = v1_lead.rn - 1
      )
      SELECT * FROM v2 ;;
  }

  parameter: target_year {
    type: number
    default_value: "1999"
    label: "Target Year"
    description: "Target calendar year for monthly sales lag and lead comparison (includes Dec of target_year - 1 and Jan of target_year + 1 in the rank window)."
  }

  dimension: pk {
    primary_key: yes
    type: string
    order_by_field: sales_vs_avg_diff
    label: "Category Brand Store Month Key"
    description: "Composite primary key combining item category, brand, store name, company name, year, and month of year (ordered by monthly sales minus annual monthly average)."
    sql: CONCAT(${i_category}, '|', ${i_brand}, '|', ${s_store_name}, '|', ${s_company_name}, '|', CAST(${d_year} AS STRING), '|', CAST(${d_moy} AS STRING)) ;;
  }

  dimension: i_category {
    type: string
    label: "Item Category"
    description: "Item category name (i_category)."
    synonyms: ["category"]
    sql: ${TABLE}.i_category ;;
  }

  dimension: i_brand {
    type: string
    label: "Item Brand"
    description: "Item brand name (i_brand)."
    synonyms: ["brand"]
    sql: ${TABLE}.i_brand ;;
  }

  dimension: s_store_name {
    type: string
    label: "Store Name"
    description: "Store name (s_store_name)."
    sql: ${TABLE}.s_store_name ;;
  }

  dimension: s_company_name {
    type: string
    label: "Company Name"
    description: "Store company name (s_company_name)."
    sql: ${TABLE}.s_company_name ;;
  }

  dimension: d_year {
    type: number
    label: "Calendar Year Number"
    description: "Four-digit calendar year integer (d_year)."
    synonyms: ["year"]
    sql: ${TABLE}.d_year ;;
  }

  dimension: d_moy {
    type: number
    label: "Month of Year"
    description: "Calendar month of year integer 1-12 (d_moy)."
    synonyms: ["month of year"]
    sql: ${TABLE}.d_moy ;;
  }

  dimension: avg_monthly_sales {
    type: number
    value_format_name: decimal_4
    label: "Avg Monthly Sales"
    description: "Annual average of monthly store sales price for the category, brand, store, and company (avg_monthly_sales)."
    sql: ${TABLE}.avg_monthly_sales ;;
  }

  dimension: sum_sales {
    type: number
    value_format_name: usd
    label: "Monthly Sales"
    description: "Total monthly store sales price for the category, brand, store, and company (sum_sales)."
    sql: ${TABLE}.sum_sales ;;
  }

  dimension: psum {
    type: number
    value_format_name: usd
    label: "Prior Month Sales"
    description: "Immediately preceding ranked month store sales price for the same category, brand, store, and company (psum)."
    synonyms: ["previous month sales", "lag monthly sales"]
    sql: ${TABLE}.psum ;;
  }

  dimension: nsum {
    type: number
    value_format_name: usd
    label: "Next Month Sales"
    description: "Immediately following ranked month store sales price for the same category, brand, store, and company (nsum)."
    synonyms: ["following month sales", "lead monthly sales"]
    sql: ${TABLE}.nsum ;;
  }

  dimension: sales_vs_avg_diff {
    type: number
    value_format_name: usd
    label: "Sales vs Monthly Avg Diff"
    description: "Signed difference between current month sales and the annual monthly average (sum_sales - avg_monthly_sales)."
    sql: ${sum_sales} - ${avg_monthly_sales} ;;
  }

  dimension: is_above_10pct_deviation {
    type: yesno
    label: "Above 10% Monthly Avg Deviation"
    description: "True when annual average monthly sales is positive and current month sales deviates by more than 10% from the annual monthly average."
    sql: ${avg_monthly_sales} > 0 AND ABS(${sum_sales} - ${avg_monthly_sales}) > 0.1 * ${avg_monthly_sales} ;;
  }

  measure: count {
    type: count
    description: "Count of store-brand-category monthly lag and lead sales rows."
  }
}
