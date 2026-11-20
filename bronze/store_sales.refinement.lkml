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
}
