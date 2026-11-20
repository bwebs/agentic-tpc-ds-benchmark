include: "time_dim.view.lkml"

view: +time_dim {
  dimension: t_time_id {
    primary_key: no
  }

  dimension: t_time_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.t_time_sk ;;
  }

  measure: count {
    description: "Count of time dimension rows."
  }
}
