include: "call_center.view.lkml"

view: +call_center {
  dimension: cc_call_center_id {
    primary_key: no
  }

  dimension: cc_call_center_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.cc_call_center_sk ;;
  }

  measure: count {
    description: "Count of call centers."
  }
}
