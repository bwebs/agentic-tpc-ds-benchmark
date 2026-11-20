include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"

view: web_catalog_sales {
  derived_table: {
    sql:
      SELECT
        'web' AS channel,
        {{ _sdt_web_sales.ws_item_sk._sql }} AS item_sk,
        {{ _sdt_web_sales.ws_order_number._sql }} AS order_number,
        {{ _sdt_web_sales.ws_sold_date_sk._sql }} AS sold_date_sk,
        {{ _sdt_web_sales.ws_ext_sales_price._sql }} AS sales_price
      FROM ${web_sales.SQL_TABLE_NAME} AS {{ _sdt_web_sales._name }}
      UNION ALL
      SELECT
        'catalog' AS channel,
        {{ _sdt_catalog_sales.cs_item_sk._sql }} AS item_sk,
        {{ _sdt_catalog_sales.cs_order_number._sql }} AS order_number,
        {{ _sdt_catalog_sales.cs_sold_date_sk._sql }} AS sold_date_sk,
        {{ _sdt_catalog_sales.cs_ext_sales_price._sql }} AS sales_price
      FROM ${catalog_sales.SQL_TABLE_NAME} AS {{ _sdt_catalog_sales._name }} ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${channel}, '_', CAST(${item_sk} AS STRING), '_', CAST(${order_number} AS STRING)) ;;
  }

  dimension: channel {
    type: string
    description: "Sales channel source ('web' or 'catalog')."
    sql: ${TABLE}.channel ;;
  }

  dimension: item_sk {
    type: number
    value_format_name: id
    sql: ${TABLE}.item_sk ;;
  }

  dimension: order_number {
    type: number
    value_format_name: id
    sql: ${TABLE}.order_number ;;
  }

  dimension: sold_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.sold_date_sk ;;
  }

  dimension: sales_price {
    type: number
    value_format_name: usd
    description: "Extended sales price across web and catalog line items."
    sql: ${TABLE}.sales_price ;;
  }

  dimension: has_dated_sales_price {
    hidden: yes
    type: number
    sql: IF(${sales_price} IS NOT NULL AND ${sold_date_sk} IS NOT NULL, 1, 0) ;;
  }

  measure: count {
    type: count
  }

  measure: total_sales_price {
    type: sum
    sql: ${sales_price} ;;
    value_format_name: usd
    description: "Combined extended sales price across web and catalog channels."
  }
}
