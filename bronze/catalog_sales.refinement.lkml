include: "catalog_sales.view.lkml"

view: +catalog_sales {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${cs_item_sk} AS STRING), '_', CAST(${cs_order_number} AS STRING)) ;;
  }

  dimension: cs_sold_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.cs_sold_date_sk ;;
  }

  dimension: cs_ship_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.cs_ship_date_sk ;;
  }

  dimension: cs_item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.cs_item_sk ;;
  }

  dimension: cs_bill_customer_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.cs_bill_customer_sk ;;
  }

  dimension: cs_bill_cdemo_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.cs_bill_cdemo_sk ;;
  }

  dimension: cs_ship_addr_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.cs_ship_addr_sk ;;
  }

  dimension: cs_call_center_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.cs_call_center_sk ;;
  }

  dimension: cs_warehouse_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.cs_warehouse_sk ;;
  }

  dimension: cs_order_number {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.cs_order_number ;;
  }

  measure: count {
    description: "Count of catalog sales records."
  }

  measure: order_count {
    type: count_distinct
    sql: ${cs_order_number} ;;
    tags: ["non_additive"]
    description: "Distinct count of catalog order numbers (cs_order_number)."
  }

  measure: distinct_warehouse_count {
    type: count_distinct
    sql: ${cs_warehouse_sk} ;;
    tags: ["non_additive"]
    description: "Distinct count of fulfillment warehouses (cs_warehouse_sk)."
  }

  measure: total_ext_sales_price {
    type: sum
    sql: ${cs_ext_sales_price} ;;
    value_format_name: usd
    description: "Sum of extended catalog sales price (cs_ext_sales_price)."
  }

  measure: total_sales_price {
    type: sum
    sql: ${cs_sales_price} ;;
    value_format_name: usd
    description: "Sum of catalog item sales price (cs_sales_price)."
  }

  measure: total_shipping_cost {
    type: sum
    sql: ${cs_ext_ship_cost} ;;
    value_format_name: usd
    description: "Sum of extended shipping cost (cs_ext_ship_cost)."
    synonyms: ["total_ext_ship_cost"]
  }

  measure: total_net_profit {
    type: sum
    sql: ${cs_net_profit} ;;
    value_format_name: usd
    description: "Sum of catalog sales net profit (cs_net_profit)."
  }

  measure: average_quantity {
    type: average
    sql: ${cs_quantity} ;;
    value_format_name: decimal_2
    tags: ["non_additive"]
    description: "Average quantity per catalog sales line item (AVG(cs_quantity))."
  }

  measure: average_list_price {
    type: average
    sql: ${cs_list_price} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Average list price per catalog sales line item (AVG(cs_list_price))."
  }

  measure: average_coupon_amount {
    type: average
    sql: ${cs_coupon_amt} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Average coupon discount amount per catalog sales line item (AVG(cs_coupon_amt))."
  }

  measure: average_sales_price {
    type: average
    sql: ${cs_sales_price} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Average sales price per catalog sales line item (AVG(cs_sales_price))."
  }

  measure: average_net_profit {
    type: average
    sql: ${cs_net_profit} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Average net profit per catalog sales line item (AVG(cs_net_profit))."
  }
}
