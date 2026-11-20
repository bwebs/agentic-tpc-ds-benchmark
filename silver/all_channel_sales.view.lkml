include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"

view: all_channel_sales {
  derived_table: {
    sql:
      SELECT
        IF({{ _sdt_store_sales.ss_item_sk._sql }} IS NOT NULL, 's', 's') AS sale_type,
        {{ _sdt_store_sales.ss_item_sk._sql }} AS item_sk,
        {{ _sdt_store_sales.ss_ticket_number._sql }} AS order_number,
        {{ _sdt_store_sales.ss_customer_sk._sql }} AS customer_sk,
        {{ _sdt_store_sales.ss_addr_sk._sql }} AS addr_sk,
        {{ _sdt_store_sales.ss_sold_date_sk._sql }} AS sold_date_sk,
        {{ _sdt_store_sales.ss_ext_list_price._sql }} AS ext_list_price,
        {{ _sdt_store_sales.ss_ext_wholesale_cost._sql }} AS ext_wholesale_cost,
        {{ _sdt_store_sales.ss_ext_discount_amt._sql }} AS ext_discount_amt,
        {{ _sdt_store_sales.ss_ext_sales_price._sql }} AS ext_sales_price
      FROM ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_store_sales._name }}
      UNION ALL
      SELECT
        IF({{ _sdt_catalog_sales.cs_item_sk._sql }} IS NOT NULL, 'c', 'c') AS sale_type,
        {{ _sdt_catalog_sales.cs_item_sk._sql }} AS item_sk,
        {{ _sdt_catalog_sales.cs_order_number._sql }} AS order_number,
        {{ _sdt_catalog_sales.cs_bill_customer_sk._sql }} AS customer_sk,
        {{ _sdt_catalog_sales.cs_bill_addr_sk._sql }} AS addr_sk,
        {{ _sdt_catalog_sales.cs_sold_date_sk._sql }} AS sold_date_sk,
        {{ _sdt_catalog_sales.cs_ext_list_price._sql }} AS ext_list_price,
        {{ _sdt_catalog_sales.cs_ext_wholesale_cost._sql }} AS ext_wholesale_cost,
        {{ _sdt_catalog_sales.cs_ext_discount_amt._sql }} AS ext_discount_amt,
        {{ _sdt_catalog_sales.cs_ext_sales_price._sql }} AS ext_sales_price
      FROM ${catalog_sales.SQL_TABLE_NAME} AS {{ _sdt_catalog_sales._name }}
      UNION ALL
      SELECT
        IF({{ _sdt_web_sales.ws_item_sk._sql }} IS NOT NULL, 'w', 'w') AS sale_type,
        {{ _sdt_web_sales.ws_item_sk._sql }} AS item_sk,
        {{ _sdt_web_sales.ws_order_number._sql }} AS order_number,
        {{ _sdt_web_sales.ws_bill_customer_sk._sql }} AS customer_sk,
        {{ _sdt_web_sales.ws_bill_addr_sk._sql }} AS addr_sk,
        {{ _sdt_web_sales.ws_sold_date_sk._sql }} AS sold_date_sk,
        {{ _sdt_web_sales.ws_ext_list_price._sql }} AS ext_list_price,
        {{ _sdt_web_sales.ws_ext_wholesale_cost._sql }} AS ext_wholesale_cost,
        {{ _sdt_web_sales.ws_ext_discount_amt._sql }} AS ext_discount_amt,
        {{ _sdt_web_sales.ws_ext_sales_price._sql }} AS ext_sales_price
      FROM ${web_sales.SQL_TABLE_NAME} AS {{ _sdt_web_sales._name }} ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${sale_type}, '_', CAST(${item_sk} AS STRING), '_', CAST(${order_number} AS STRING)) ;;
  }

  dimension: sale_type {
    type: string
    description: "Sales channel identifier ('s' store, 'c' catalog, 'w' web)."
    sql: ${TABLE}.sale_type ;;
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

  dimension: customer_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.customer_sk ;;
  }

  dimension: addr_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    description: "Transaction or billing customer address surrogate key (ss_addr_sk, cs_bill_addr_sk, ws_bill_addr_sk)."
    sql: ${TABLE}.addr_sk ;;
  }

  dimension: sold_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.sold_date_sk ;;
  }

  dimension: ext_list_price {
    type: number
    value_format_name: usd
    sql: ${TABLE}.ext_list_price ;;
  }

  dimension: ext_wholesale_cost {
    type: number
    value_format_name: usd
    sql: ${TABLE}.ext_wholesale_cost ;;
  }

  dimension: ext_discount_amt {
    type: number
    value_format_name: usd
    sql: ${TABLE}.ext_discount_amt ;;
  }

  dimension: ext_sales_price {
    type: number
    value_format_name: usd
    sql: ${TABLE}.ext_sales_price ;;
  }

  dimension: year_net_amount {
    type: number
    value_format_name: usd
    description: "Half of net margin plus extended sales price (((ext_list_price - ext_wholesale_cost - ext_discount_amt) + ext_sales_price) / 2)."
    sql: (((${ext_list_price} - ${ext_wholesale_cost} - ${ext_discount_amt}) + ${ext_sales_price}) / 2) ;;
  }

  dimension: has_dated_year_net_amount {
    hidden: yes
    type: number
    sql: IF(${year_net_amount} IS NOT NULL AND ${customer_sk} IS NOT NULL AND ${sold_date_sk} IS NOT NULL, 1, 0) ;;
  }

  dimension: ext_list_minus_discount {
    type: number
    value_format_name: usd
    description: "Extended list price minus extended discount amount (ext_list_price - ext_discount_amt)."
    sql: ${ext_list_price} - ${ext_discount_amt} ;;
  }

  dimension: has_dated_ext_list_minus_discount {
    hidden: yes
    type: number
    sql: IF(${ext_list_minus_discount} IS NOT NULL AND ${customer_sk} IS NOT NULL AND ${sold_date_sk} IS NOT NULL, 1, 0) ;;
  }

  measure: count {
    type: count
  }

  measure: total_year_net_amount {
    type: sum
    sql: ${year_net_amount} ;;
    value_format_name: usd
    synonyms: ["year_total"]
    description: "Sum of (((ext_list_price - ext_wholesale_cost - ext_discount_amt) + ext_sales_price) / 2) across store, catalog, and web channels."
  }

  measure: total_ext_sales_price {
    type: sum
    sql: ${ext_sales_price} ;;
    value_format_name: usd
    description: "Sum of extended sales price across store, catalog, and web channels."
  }

  dimension: has_ext_sales_price {
    hidden: yes
    type: number
    sql: IF(${ext_sales_price} IS NOT NULL, 1, 0) ;;
  }

  measure: _ext_sales_price_nonnull_count {
    hidden: yes
    type: sum
    sql: ${has_ext_sales_price} ;;
  }

  measure: total_sales {
    type: number
    sql: IF(${_ext_sales_price_nonnull_count} > 0, ${total_ext_sales_price}, NULL) ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Sum of extended sales price across store, catalog, and web channels (NULL when all rows have NULL ext_sales_price)."
  }

  measure: total_ext_list_minus_discount {
    type: sum
    sql: ${ext_list_minus_discount} ;;
    value_format_name: usd
    description: "Sum of (ext_list_price - ext_discount_amt) across store, catalog, and web channels."
  }

  measure: distinct_channel_count {
    type: count_distinct
    sql: ${sale_type} ;;
    tags: ["non_additive"]
    description: "Count of distinct sales channels ('s' store, 'c' catalog, 'w' web) with activity."
  }
}
