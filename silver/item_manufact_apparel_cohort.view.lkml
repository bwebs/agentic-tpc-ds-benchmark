include: "/bronze/explores/item.explore.lkml"

view: item_manufact_apparel_cohort {
  derived_table: {
    explore_source: item {
      column: i_manufact { field: item.i_manufact }
      filters: {
        field: item.is_apparel_spec_match
        value: "yes"
      }
      filters: {
        field: item.i_manufact
        value: "-NULL"
      }
    }
  }

  dimension: i_manufact {
    primary_key: yes
    type: string
    sql: ${TABLE}.i_manufact ;;
    description: "Manufacturer name producing at least one qualifying apparel-spec item."
  }

  dimension: has_apparel_spec_match {
    type: yesno
    label: "Has Apparel Spec Match"
    sql: ${i_manufact} IS NOT NULL ;;
    description: "Whether the manufacturer produces at least one item matching the 8 Men/Women apparel specifications."
  }

  measure: count {
    type: count
    filters: [i_manufact: "-NULL"]
    description: "Count of distinct manufacturers with at least one apparel-spec item."
  }
}
