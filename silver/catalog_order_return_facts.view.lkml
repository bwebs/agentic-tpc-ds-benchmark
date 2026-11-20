include: "/silver/explores/catalog_returns.explore.lkml"

view: catalog_order_return_facts {
  derived_table: {
    explore_source: catalog_returns {
      column: cr_order_number { field: catalog_returns.cr_order_number }
      column: return_line_count { field: catalog_returns.count }
      filters: [catalog_returns.cr_order_number: "NOT NULL"]
    }
  }

  dimension: cr_order_number {
    primary_key: yes
    type: number
    value_format_name: id
    description: "Returned catalog order number (NULL when left-joined order has no returns)."
  }

  dimension: return_line_count {
    type: number
    description: "Count of return line items recorded for this catalog order."
  }

  measure: count {
    type: count
    filters: [cr_order_number: "NOT NULL"]
    description: "Count of returned catalog orders."
  }
}
