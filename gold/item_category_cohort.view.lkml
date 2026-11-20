include: "/bronze/explores/item.explore.lkml"

view: item_category_cohort {
  derived_table: {
    explore_source: item {
      bind_filters: {
        from_field: item_category_cohort.item_category_filter
        to_field: item.i_category
      }
      column: i_item_id { field: item.i_item_id }
      filters: {
        field: item.i_item_id
        value: "-NULL"
      }
    }
  }

  filter: item_category_filter {
    type: string
    label: "Item Category Cohort Filter"
    description: "Filters to item IDs that have at least one version in the specified categories (i_item_id IN (SELECT i_item_id FROM item WHERE i_category IN (...)))."
    suggest_explore: item
    suggest_dimension: item.i_category
  }

  dimension: i_item_id {
    primary_key: yes
    type: string
    description: "Item ID having at least one item record in the selected category cohort."
    sql: ${TABLE}.i_item_id ;;
  }

  dimension: is_in_category_cohort {
    type: yesno
    description: "Whether the item's i_item_id has at least one item record matching item_category_filter."
    sql: ${i_item_id} IS NOT NULL ;;
  }
}
