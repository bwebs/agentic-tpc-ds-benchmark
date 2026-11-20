include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

view: customer_2004_mar_may_channel_flags {
  # ponytail: compact 2004 Mar-May UNION ALL customer channel flags SDT mirroring customer_2001_q1_q3_channel_flags; promote to parameterized Gold NDT if arbitrary date windows are requested
  derived_table: {
    sql:
      SELECT
        customer_sk,
        MAX(has_store) AS has_store,
        MAX(has_web) AS has_web,
        MAX(has_catalog) AS has_catalog
      FROM (
        SELECT
          {{ _sdt_store_sales.ss_customer_sk._sql }} AS customer_sk,
          1 AS has_store,
          0 AS has_web,
          0 AS has_catalog
        FROM ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_store_sales._name }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_date_dim._name }}
          ON {{ _sdt_store_sales.ss_sold_date_sk._sql }} = {{ _sdt_date_dim.d_date_sk._sql }}
        WHERE {{ _sdt_date_dim.d_year_num._sql }} = 2004
          AND {{ _sdt_date_dim.d_moy._sql }} BETWEEN 3 AND 5
          AND {{ _sdt_store_sales.ss_customer_sk._sql }} IS NOT NULL
        UNION ALL
        SELECT
          {{ _sdt_web_sales.ws_bill_customer_sk._sql }} AS customer_sk,
          0 AS has_store,
          1 AS has_web,
          0 AS has_catalog
        FROM ${web_sales.SQL_TABLE_NAME} AS {{ _sdt_web_sales._name }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_date_dim._name }}
          ON {{ _sdt_web_sales.ws_sold_date_sk._sql }} = {{ _sdt_date_dim.d_date_sk._sql }}
        WHERE {{ _sdt_date_dim.d_year_num._sql }} = 2004
          AND {{ _sdt_date_dim.d_moy._sql }} BETWEEN 3 AND 5
          AND {{ _sdt_web_sales.ws_bill_customer_sk._sql }} IS NOT NULL
        UNION ALL
        SELECT
          {{ _sdt_catalog_sales.cs_ship_customer_sk._sql }} AS customer_sk,
          0 AS has_store,
          0 AS has_web,
          1 AS has_catalog
        FROM ${catalog_sales.SQL_TABLE_NAME} AS {{ _sdt_catalog_sales._name }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_date_dim._name }}
          ON {{ _sdt_catalog_sales.cs_sold_date_sk._sql }} = {{ _sdt_date_dim.d_date_sk._sql }}
        WHERE {{ _sdt_date_dim.d_year_num._sql }} = 2004
          AND {{ _sdt_date_dim.d_moy._sql }} BETWEEN 3 AND 5
          AND {{ _sdt_catalog_sales.cs_ship_customer_sk._sql }} IS NOT NULL
      )
      GROUP BY customer_sk ;;
  }

  dimension: customer_sk {
    primary_key: yes
    type: number
    value_format_name: id
    description: "Customer surrogate key with 2004 Mar-May channel activity."
    sql: ${TABLE}.customer_sk ;;
  }

  dimension: is_store_only_mar_may_2004 {
    type: yesno
    label: "Store-Only Active in Mar-May 2004"
    description: "True when the customer has at least one store sale and zero web (bill customer) or catalog (ship customer) sales in March-May 2004."
    sql: ${TABLE}.has_store = 1 AND ${TABLE}.has_web = 0 AND ${TABLE}.has_catalog = 0 ;;
  }

  measure: count {
    type: count
    filters: [customer_sk: "NOT NULL"]
    description: "Count of customers with 2004 Mar-May channel activity."
  }
}
