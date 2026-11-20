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

  dimension: ws_bill_customer_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ws_bill_customer_sk ;;
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
}
