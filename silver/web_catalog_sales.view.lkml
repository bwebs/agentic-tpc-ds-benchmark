include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"

view: web_catalog_sales {
  extends: [catalog_sales, web_sales]

  derived_table: {
    sql:
      SELECT
        'web' AS sales_channel,
        {{ ws_item_sk._sql }} AS item_sk,
        {{ ws_order_number._sql }} AS order_number,
        {{ ws_sold_date_sk._sql }} AS sold_date_sk,
        {{ ws_ext_sales_price._sql }} AS sales_price
      FROM ${web_sales.SQL_TABLE_NAME} AS {{ _table }}
      UNION ALL
      SELECT
        'catalog' AS sales_channel,
        {{ cs_item_sk._sql }} AS item_sk,
        {{ cs_order_number._sql }} AS order_number,
        {{ cs_sold_date_sk._sql }} AS sold_date_sk,
        {{ cs_ext_sales_price._sql }} AS sales_price
      FROM ${catalog_sales.SQL_TABLE_NAME} AS {{ _table }} ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${sales_channel}, '_', CAST(${item_sk} AS STRING), '_', CAST(${order_number} AS STRING)) ;;
  }

  dimension: sales_channel {
    type: string
    description: "Sales channel source ('web' or 'catalog')."
    sql: ${TABLE}.sales_channel ;;
  }

  dimension: item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
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
    description: "Extended sales price across web and catalog sales."
    sql: ${TABLE}.sales_price ;;
  }

  measure: total_sales_price {
    type: sum
    sql: ${sales_price} ;;
    value_format_name: usd
    description: "Total extended sales price across web and catalog channels."
  }
}
