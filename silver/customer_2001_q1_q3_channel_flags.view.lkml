include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

view: customer_2001_q1_q3_channel_flags {
  # ponytail: compact 2001 Q1-Q3 UNION ALL customer channel flags SDT mirroring customer_2002_apr_jul_channel_flags; promote to parameterized Gold NDT if arbitrary date windows are requested
  derived_table: {
    sql:
      SELECT
        customer_sk,
        MAX(is_store) AS _has_store,
        MAX(is_web_or_cat_ship) AS _has_web_or_cat_ship
      FROM (
        SELECT
          {{ _sdt_store_sales.ss_customer_sk._sql }} AS customer_sk,
          1 AS is_store,
          0 AS is_web_or_cat_ship
        FROM ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_store_sales._name }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_date_dim._name }}
          ON {{ _sdt_store_sales.ss_sold_date_sk._sql }} = {{ _sdt_date_dim.d_date_sk._sql }}
        WHERE {{ _sdt_date_dim.d_year_num._sql }} = 2001
          AND {{ _sdt_date_dim.d_qoy._sql }} < 4
          AND {{ _sdt_store_sales.ss_customer_sk._sql }} IS NOT NULL
        UNION ALL
        SELECT
          {{ _sdt_web_sales.ws_bill_customer_sk._sql }} AS customer_sk,
          0 AS is_store,
          1 AS is_web_or_cat_ship
        FROM ${web_sales.SQL_TABLE_NAME} AS {{ _sdt_web_sales._name }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_date_dim._name }}
          ON {{ _sdt_web_sales.ws_sold_date_sk._sql }} = {{ _sdt_date_dim.d_date_sk._sql }}
        WHERE {{ _sdt_date_dim.d_year_num._sql }} = 2001
          AND {{ _sdt_date_dim.d_qoy._sql }} < 4
          AND {{ _sdt_web_sales.ws_bill_customer_sk._sql }} IS NOT NULL
        UNION ALL
        SELECT
          {{ _sdt_catalog_sales.cs_ship_customer_sk._sql }} AS customer_sk,
          0 AS is_store,
          1 AS is_web_or_cat_ship
        FROM ${catalog_sales.SQL_TABLE_NAME} AS {{ _sdt_catalog_sales._name }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_date_dim._name }}
          ON {{ _sdt_catalog_sales.cs_sold_date_sk._sql }} = {{ _sdt_date_dim.d_date_sk._sql }}
        WHERE {{ _sdt_date_dim.d_year_num._sql }} = 2001
          AND {{ _sdt_date_dim.d_qoy._sql }} < 4
          AND {{ _sdt_catalog_sales.cs_ship_customer_sk._sql }} IS NOT NULL
      )
      GROUP BY customer_sk ;;
  }

  dimension: customer_sk {
    primary_key: yes
    type: number
    value_format_name: id
    description: "Customer surrogate key with 2001 Q1-Q3 channel activity."
    sql: ${TABLE}.customer_sk ;;
  }

  dimension: has_store_sales {
    type: yesno
    label: "Has 2001 Q1-Q3 Store Sales"
    description: "True when the customer has at least one store sale in Q1-Q3 2001 (d_year = 2001 AND d_qoy < 4)."
    sql: ${TABLE}._has_store = 1 ;;
  }

  dimension: has_web_or_catalog_ship_sales {
    type: yesno
    label: "Has 2001 Q1-Q3 Web or Catalog Ship Sales"
    description: "True when the customer has at least one web sale (bill customer) or catalog sale (ship customer) in Q1-Q3 2001 (d_year = 2001 AND d_qoy < 4)."
    sql: ${TABLE}._has_web_or_cat_ship = 1 ;;
  }

  measure: count {
    type: count
    filters: [customer_sk: "NOT NULL"]
    description: "Count of customers with 2001 Q1-Q3 channel activity."
  }
}
