include: "warehouse.view.lkml"

view: +warehouse {
  dimension: w_warehouse_id {
    primary_key: no
  }

  dimension: w_warehouse_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.w_warehouse_sk ;;
  }

  measure: count {
    description: "Count of warehouses."
  }
}
