include: "ship_mode.view.lkml"

view: +ship_mode {
  dimension: sm_ship_mode_id {
    primary_key: no
  }

  dimension: sm_ship_mode_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.sm_ship_mode_sk ;;
  }

  measure: count {
    description: "Count of ship modes."
  }
}
