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

  dimension: w_warehouse_name_20 {
    type: string
    sql: SUBSTR(${w_warehouse_name}, 1, 20) ;;
    description: "First 20 characters of the warehouse name."
  }

  measure: max_warehouse_sq_ft {
    hidden: yes
    type: max
    sql: ${w_warehouse_sq_ft} ;;
    tags: ["non_additive"]
    description: "Maximum warehouse square footage (used for sales-per-sq-ft ratios at warehouse grain)."
  }

  measure: count {
    description: "Count of warehouses."
  }
}
