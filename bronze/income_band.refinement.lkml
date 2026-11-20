include: "income_band.view.lkml"

view: +income_band {
  dimension: ib_income_band_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.ib_income_band_sk ;;
  }

  measure: count {
    description: "Count of income bands."
  }
}
