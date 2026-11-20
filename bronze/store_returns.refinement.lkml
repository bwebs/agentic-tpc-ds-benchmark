include: "store_returns.view.lkml"

view: +store_returns {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${sr_item_sk} AS STRING), '_', CAST(${sr_ticket_number} AS STRING)) ;;
  }

  dimension: sr_customer_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.sr_customer_sk ;;
  }

  dimension: sr_store_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.sr_store_sk ;;
  }

  dimension: sr_returned_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.sr_returned_date_sk ;;
  }

  measure: total_return_amount {
    type: sum
    sql: ${sr_return_amt} ;;
    value_format_name: usd
    description: "Sum of store return amount (sr_return_amt)."
    synonyms: ["ctr_total_return", "total return"]
  }
}
