include: "customer_demographics.view.lkml"

view: +customer_demographics {
  dimension: cd_demo_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.cd_demo_sk ;;
  }
}
