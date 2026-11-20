include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"

view: all_channel_item_sales {
  # ponytail: sibling UNION ALL SDT for item-level quantity * list_price across store, catalog, and web so existing all_channel_sales remains untouched
  derived_table: {
    sql:
      SELECT
        IF({{ _sdt_store_sales.ss_item_sk._sql }} IS NOT NULL, 'store', 'store') AS channel,
        {{ _sdt_store_sales.ss_item_sk._sql }} AS item_sk,
        {{ _sdt_store_sales.ss_ticket_number._sql }} AS order_number,
        {{ _sdt_store_sales.ss_sold_date_sk._sql }} AS sold_date_sk,
        {{ _sdt_store_sales.ss_quantity._sql }} AS quantity,
        {{ _sdt_store_sales.ss_list_price._sql }} AS list_price
      FROM ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_store_sales._name }}
      UNION ALL
      SELECT
        IF({{ _sdt_catalog_sales.cs_item_sk._sql }} IS NOT NULL, 'catalog', 'catalog') AS channel,
        {{ _sdt_catalog_sales.cs_item_sk._sql }} AS item_sk,
        {{ _sdt_catalog_sales.cs_order_number._sql }} AS order_number,
        {{ _sdt_catalog_sales.cs_sold_date_sk._sql }} AS sold_date_sk,
        {{ _sdt_catalog_sales.cs_quantity._sql }} AS quantity,
        {{ _sdt_catalog_sales.cs_list_price._sql }} AS list_price
      FROM ${catalog_sales.SQL_TABLE_NAME} AS {{ _sdt_catalog_sales._name }}
      UNION ALL
      SELECT
        IF({{ _sdt_web_sales.ws_item_sk._sql }} IS NOT NULL, 'web', 'web') AS channel,
        {{ _sdt_web_sales.ws_item_sk._sql }} AS item_sk,
        {{ _sdt_web_sales.ws_order_number._sql }} AS order_number,
        {{ _sdt_web_sales.ws_sold_date_sk._sql }} AS sold_date_sk,
        {{ _sdt_web_sales.ws_quantity._sql }} AS quantity,
        {{ _sdt_web_sales.ws_list_price._sql }} AS list_price
      FROM ${web_sales.SQL_TABLE_NAME} AS {{ _sdt_web_sales._name }} ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${channel}, '_', CAST(${item_sk} AS STRING), '_', CAST(${order_number} AS STRING)) ;;
  }

  dimension: channel {
    type: string
    description: "Sales channel name ('store', 'catalog', 'web')."
    sql: ${TABLE}.channel ;;
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

  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: list_price {
    type: number
    value_format_name: usd
    sql: ${TABLE}.list_price ;;
  }

  dimension: gross_list_sales {
    type: number
    value_format_name: usd
    description: "Line-item gross list sales (quantity * list_price)."
    sql: ${quantity} * ${list_price} ;;
  }

  measure: count {
    type: count
    synonyms: ["number_sales"]
    description: "Count of sales line items across channels."
  }

  measure: total_gross_list_sales {
    type: sum
    sql: ${gross_list_sales} ;;
    value_format_name: usd
    synonyms: ["sales"]
    description: "Sum of (quantity * list_price) across store, catalog, and web channels."
  }

  measure: average_gross_list_sales {
    type: average
    sql: ${gross_list_sales} ;;
    value_format_name: usd
    tags: ["non_additive"]
    synonyms: ["average_sales"]
    description: "Average line-item (quantity * list_price) across store, catalog, and web channels."
  }

  measure: distinct_channel_count {
    type: count_distinct
    sql: ${channel} ;;
    tags: ["non_additive"]
    description: "Count of distinct sales channels ('store', 'catalog', 'web') with sales."
  }
}
