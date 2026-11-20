include: "inventory.view.lkml"

view: +inventory {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${inv_date_sk} AS STRING), '|', CAST(${inv_item_sk} AS STRING), '|', CAST(${inv_warehouse_sk} AS STRING)) ;;
  }

  dimension: inv_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.inv_date_sk ;;
  }

  dimension: inv_item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.inv_item_sk ;;
  }

  dimension: inv_warehouse_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.inv_warehouse_sk ;;
  }

  measure: count {
    description: "Count of inventory snapshot rows."
  }

  measure: total_quantity_on_hand {
    type: sum
    sql: ${inv_quantity_on_hand} ;;
    value_format_name: decimal_0
    description: "Total quantity on hand across inventory snapshots (SUM(inv_quantity_on_hand))."
  }
}
