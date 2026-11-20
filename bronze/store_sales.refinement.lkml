include: "store_sales.view.lkml"

view: +store_sales {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${ss_item_sk} AS STRING), '_', CAST(${ss_ticket_number} AS STRING)) ;;
  }

  dimension: ss_sold_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ss_sold_date_sk ;;
  }

  dimension: ss_item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ss_item_sk ;;
  }

  dimension: ss_customer_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ss_customer_sk ;;
  }

  dimension: ss_cdemo_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ss_cdemo_sk ;;
  }

  dimension: ss_promo_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ss_promo_sk ;;
  }

  measure: count {
    description: "Count of store sales line items."
  }

  measure: total_extended_discount_amount {
    type: sum
    sql: ${ss_ext_discount_amt} ;;
    value_format_name: usd
    description: "Sum of extended discount amount across store sales (ss_ext_discount_amt)."
    synonyms: ["sum_agg", "extended discount amount"]
  }

  measure: average_quantity {
    type: average
    sql: ${ss_quantity} ;;
    value_format_name: decimal_2
    tags: ["non_additive"]
    description: "Average quantity per store sales line item (AVG(ss_quantity))."
  }

  measure: average_list_price {
    type: average
    sql: ${ss_list_price} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Average list price per store sales line item (AVG(ss_list_price))."
  }

  measure: average_coupon_amount {
    type: average
    sql: ${ss_coupon_amt} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Average coupon discount amount per store sales line item (AVG(ss_coupon_amt))."
  }

  measure: average_sales_price {
    type: average
    sql: ${ss_sales_price} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Average sales price per store sales line item (AVG(ss_sales_price))."
  }
}
