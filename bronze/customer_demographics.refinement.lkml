include: "customer_demographics.view.lkml"

view: +customer_demographics {
  dimension: cd_demo_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.cd_demo_sk ;;
  }

  measure: count {
    description: "Count of customer demographic profiles."
  }

  measure: average_dependent_count {
    type: average
    sql: ${cd_dep_count} ;;
    value_format_name: decimal_2
    tags: ["non_additive"]
    description: "Average number of dependents (AVG(cd_dep_count))."
  }
}
