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
}
