include: "/bronze/explores/item.explore.lkml"

view: item_color_cohort {
  derived_table: {
    explore_source: item {
      bind_filters: {
        from_field: item_color_cohort.item_color_filter
        to_field: item.i_color
      }
      column: i_item_id { field: item.i_item_id }
      filters: {
        field: item.i_item_id
        value: "-NULL"
      }
    }
  }

  filter: item_color_filter {
    type: string
    label: "Item Color Cohort Filter"
    description: "Filters to item IDs that have at least one version in the specified colors (i_item_id IN (SELECT i_item_id FROM item WHERE i_color IN (...)))."
    suggest_explore: item
    suggest_dimension: item.i_color
  }

  dimension: i_item_id {
    primary_key: yes
    type: string
    description: "Item ID having at least one item record in the selected color cohort."
    sql: ${TABLE}.i_item_id ;;
  }

  dimension: is_in_color_cohort {
    type: yesno
    description: "Whether the item's i_item_id has at least one item record matching item_color_filter."
    sql: ${i_item_id} IS NOT NULL ;;
  }
}
