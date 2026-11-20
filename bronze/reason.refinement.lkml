include: "reason.view.lkml"

view: +reason {
  dimension: r_reason_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.r_reason_sk ;;
    description: "Surrogate primary key for return reason."
  }

  dimension: r_reason_id {
    primary_key: no
    type: string
    sql: ${TABLE}.r_reason_id ;;
    description: "Business identifier for return reason."
  }

  measure: count {
    description: "Count of return reasons."
  }
}
