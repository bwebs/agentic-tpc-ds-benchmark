include: "/bronze/explores/web_sales_base.explore.lkml"

view: web_order_warehouse_facts {
  derived_table: {
    explore_source: web_sales_base {
      column: ws_order_number { field: web_sales.ws_order_number }
      column: distinct_warehouse_count { field: web_sales.distinct_warehouse_count }
      filters: [web_sales.ws_order_number: "NOT NULL"]
    }
  }

  dimension: ws_order_number {
    primary_key: yes
    type: number
    value_format_name: id
    description: "Web order number."
  }

  dimension: distinct_warehouse_count {
    type: number
    description: "Number of distinct fulfillment warehouses for this web order."
  }

  dimension: is_multi_warehouse_order {
    type: yesno
    sql: ${distinct_warehouse_count} > 1 ;;
    description: "Whether the web order shipped from more than one warehouse."
  }

  measure: count {
    type: count
    filters: [ws_order_number: "NOT NULL"]
    description: "Count of distinct web orders."
  }
}
