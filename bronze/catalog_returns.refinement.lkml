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

  measure: count {
    description: "Count of catalog return records."
  }
}
