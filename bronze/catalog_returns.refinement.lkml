include: "catalog_returns.view.lkml"

view: +catalog_returns {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${cr_item_sk} AS STRING), '_', CAST(${cr_order_number} AS STRING)) ;;
  }

  dimension: cr_catalog_page_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.cr_catalog_page_sk ;;
  }

  dimension: cr_returned_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.cr_returned_date_sk ;;
  }

  dimension: cr_order_number {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.cr_order_number ;;
  }

  dimension: cr_returning_customer_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.cr_returning_customer_sk ;;
  }

  dimension: cr_returning_addr_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.cr_returning_addr_sk ;;
  }

  measure: count {
    description: "Count of catalog return records."
  }

  measure: total_return_amt_inc_tax {
    type: sum
    sql: ${cr_return_amt_inc_tax} ;;
    value_format_name: usd
    description: "Sum of catalog return amount including tax (cr_return_amt_inc_tax)."
    synonyms: ["ctr_total_return", "total return including tax"]
  }
}
