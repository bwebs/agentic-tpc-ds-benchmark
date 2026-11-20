include: "/bronze/explores/item.explore.lkml"

view: prime_sk_item_ids {
  derived_table: {
    explore_source: item {
      column: i_item_id { field: item.i_item_id }
      filters: {
        field: item.i_item_sk
        value: "2, 3, 5, 7, 11, 13, 17, 19, 23, 29"
      }
    }
  }

  dimension: i_item_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.i_item_id ;;
    description: "Distinct item business identifier (i_item_id) appearing on prime surrogate keys (2, 3, 5, 7, 11, 13, 17, 19, 23, 29)."
  }

  dimension: is_prime_sk_item {
    type: yesno
    label: "Prime SK Item"
    sql: ${i_item_id} IS NOT NULL ;;
    description: "Whether the item's business ID matches an item with surrogate key in (2, 3, 5, 7, 11, 13, 17, 19, 23, 29)."
  }
}
