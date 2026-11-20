include: "web_returns.view.lkml"

view: +web_returns {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${wr_item_sk} AS STRING), '_', CAST(${wr_order_number} AS STRING)) ;;
  }

  dimension: wr_item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.wr_item_sk ;;
  }

  dimension: wr_order_number {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.wr_order_number ;;
  }

  dimension: wr_returned_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.wr_returned_date_sk ;;
  }

  dimension: wr_returning_customer_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.wr_returning_customer_sk ;;
  }

  dimension: wr_returning_addr_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.wr_returning_addr_sk ;;
  }

  dimension: wr_refunded_cdemo_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.wr_refunded_cdemo_sk ;;
  }

  dimension: wr_returning_cdemo_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.wr_returning_cdemo_sk ;;
  }

  dimension: wr_refunded_addr_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.wr_refunded_addr_sk ;;
  }

  dimension: wr_reason_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.wr_reason_sk ;;
  }

  measure: count {
    description: "Count of web return line items."
  }

  measure: total_return_amount {
    type: sum
    sql: ${wr_return_amt} ;;
    value_format_name: usd
    description: "Sum of web return amount (wr_return_amt)."
    synonyms: ["ctr_total_return", "total return"]
  }

  measure: average_refunded_cash {
    type: average
    sql: ${wr_refunded_cash} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Average web return refunded cash (AVG(wr_refunded_cash))."
  }

  measure: average_fee {
    type: average
    sql: ${wr_fee} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Average web return fee (AVG(wr_fee))."
  }
}
