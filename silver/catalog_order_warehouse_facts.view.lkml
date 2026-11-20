include: "/bronze/explores/catalog_sales_base.explore.lkml"

view: catalog_order_warehouse_facts {
  derived_table: {
    explore_source: catalog_sales_base {
      column: cs_order_number { field: catalog_sales.cs_order_number }
      column: distinct_warehouse_count { field: catalog_sales.distinct_warehouse_count }
      filters: [catalog_sales.cs_order_number: "NOT NULL"]
    }
  }

  dimension: cs_order_number {
    primary_key: yes
    type: number
    value_format_name: id
    description: "Catalog order number."
  }

  dimension: distinct_warehouse_count {
    type: number
    description: "Number of distinct fulfillment warehouses for this catalog order."
  }

  dimension: is_multi_warehouse_order {
    type: yesno
    sql: ${distinct_warehouse_count} > 1 ;;
    description: "Whether the catalog order shipped from more than one warehouse."
  }

  measure: count {
    type: count
    filters: [cs_order_number: "NOT NULL"]
    description: "Count of distinct catalog orders."
  }
}
