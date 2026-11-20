view: common_helpers {
  dimension: no_group {
    primary_key: yes
    hidden: yes
    type: number
    sql: 1 ;;
  }

  dimension_group: current_timestamp {
    hidden: yes
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CURRENT_TIMESTAMP() ;;
  }
}
