include: "/bronze/explores/item.explore.lkml"

view: manufacturer_category_cohort {
  derived_table: {
    explore_source: item {
      bind_filters: {
        from_field: manufacturer_category_cohort.manufacturer_category_filter
        to_field: item.i_category
      }
      column: i_manufact_id { field: item.i_manufact_id }
      filters: {
        field: item.i_manufact_id
        value: "NOT NULL"
      }
    }
  }

  filter: manufacturer_category_filter {
    type: string
    label: "Manufacturer Category Cohort Filter"
    description: "Filters to manufacturers producing at least one item in the specified category (i_manufact_id IN (SELECT i_manufact_id FROM item WHERE i_category = ...))."
    suggest_explore: item
    suggest_dimension: item.i_category
  }

  dimension: i_manufact_id {
    primary_key: yes
    type: number
    value_format_name: id
    description: "Manufacturer ID producing at least one item in the selected category cohort."
    sql: ${TABLE}.i_manufact_id ;;
  }

  dimension: is_in_category_cohort {
    type: yesno
    description: "Whether the item's manufacturer produces at least one item in the selected manufacturer_category_filter."
    sql: ${i_manufact_id} IS NOT NULL ;;
  }
}
