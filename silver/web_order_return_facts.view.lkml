include: "/silver/explores/web_returns.explore.lkml"

view: web_order_return_facts {
  derived_table: {
    explore_source: web_returns {
      column: wr_order_number { field: web_returns.wr_order_number }
      column: return_line_count { field: web_returns.count }
      filters: [web_returns.wr_order_number: "NOT NULL"]
    }
  }

  dimension: wr_order_number {
    primary_key: yes
    type: number
    value_format_name: id
    description: "Returned web order number (NULL when left-joined order has no returns)."
  }

  dimension: return_line_count {
    type: number
    description: "Count of return line items recorded for this web order."
  }

  measure: count {
    type: count
    filters: [wr_order_number: "NOT NULL"]
    description: "Count of returned web orders."
  }
}
