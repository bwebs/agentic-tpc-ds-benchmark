include: "web_sales.view.lkml"

view: +web_sales {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${ws_item_sk} AS STRING), '_', CAST(${ws_order_number} AS STRING)) ;;
  }

  dimension: ws_item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ws_item_sk ;;
  }

  dimension: ws_sold_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ws_sold_date_sk ;;
  }

  dimension: ws_ship_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ws_ship_date_sk ;;
  }

  dimension: ws_bill_customer_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ws_bill_customer_sk ;;
  }

  dimension: ws_warehouse_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ws_warehouse_sk ;;
  }

  dimension: ws_ship_mode_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ws_ship_mode_sk ;;
  }

  dimension: ws_web_site_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ws_web_site_sk ;;
  }

  dimension: ws_web_page_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ws_web_page_sk ;;
  }

  dimension: ws_sold_time_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ws_sold_time_sk ;;
  }

  dimension: ws_ship_hdemo_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ws_ship_hdemo_sk ;;
  }

  dimension: days_to_ship {
    type: number
    sql: ${ws_ship_date_sk} - ${ws_sold_date_sk} ;;
    description: "Days elapsed between sold date surrogate key and ship date surrogate key."
  }

  measure: count {
    description: "Count of web sales line items."
  }

  measure: total_sales_price {
    type: sum
    sql: ${ws_sales_price} ;;
    value_format_name: usd
    description: "Sum of web sales unit sales price (ws_sales_price)."
  }

  measure: total_ext_sales_price {
    type: sum
    sql: ${ws_ext_sales_price} ;;
    value_format_name: usd
    synonyms: ["itemrevenue"]
    description: "Sum of extended web sales price (ws_ext_sales_price)."
  }

  measure: days_30 {
    type: count
    filters: [days_to_ship: "<=30"]
    description: "Web sales line items shipped within 30 days of sale."
  }

  measure: days_31_60 {
    type: count
    filters: [days_to_ship: "(30, 60]"]
    description: "Web sales line items shipped 31 to 60 days after sale."
  }

  measure: days_61_90 {
    type: count
    filters: [days_to_ship: "(60, 90]"]
    description: "Web sales line items shipped 61 to 90 days after sale."
  }

  measure: days_91_120 {
    type: count
    filters: [days_to_ship: "(90, 120]"]
    description: "Web sales line items shipped 91 to 120 days after sale."
  }

  measure: days_over_120 {
    type: count
    filters: [days_to_ship: ">120"]
    description: "Web sales line items shipped more than 120 days after sale."
  }

  measure: average_quantity {
    type: average
    sql: ${ws_quantity} ;;
    value_format_name: decimal_2
    tags: ["non_additive"]
    description: "Average web sales item quantity (AVG(ws_quantity))."
  }

  measure: total_net_paid {
    type: sum
    sql: ${ws_net_paid} ;;
    value_format_name: usd
    synonyms: ["total_sum"]
    description: "Sum of web sales net paid amount (SUM(ws_net_paid))."
  }
}
