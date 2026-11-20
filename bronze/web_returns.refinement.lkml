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
}
