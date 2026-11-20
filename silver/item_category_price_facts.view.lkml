include: "/bronze/explores/item.explore.lkml"

view: item_category_price_facts {
  derived_table: {
    explore_source: item {
      column: i_category { field: item.i_category }
      column: avg_current_price { field: item.average_current_price }
      filters: [item.i_category: "-NULL"]
    }
  }

  dimension: i_category {
    primary_key: yes
    type: string
    sql: ${TABLE}.i_category ;;
    description: "Item category key for category-level price benchmarks."
  }

  dimension: avg_current_price {
    type: number
    value_format_name: usd
    sql: ${TABLE}.avg_current_price ;;
    description: "Average current item price within the item category."
  }

  measure: count {
    type: count
    filters: [i_category: "-NULL"]
    description: "Count of distinct item categories with price facts."
  }
}
