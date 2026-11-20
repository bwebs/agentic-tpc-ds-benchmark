include: "household_demographics.view.lkml"

view: +household_demographics {
  dimension: hd_demo_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.hd_demo_sk ;;
    description: "Household demographics surrogate primary key."
  }

  dimension: hd_income_band_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.hd_income_band_sk ;;
    description: "Foreign key to income_band."
  }

  dimension: hd_dep_count {
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.hd_dep_count ;;
    description: "Household dependent count."
  }

  dimension: is_dep_to_vehicle_ratio_over_1_2 {
    type: yesno
    label: "Dependent-to-Vehicle Ratio Over 1.2"
    description: "True when household vehicle count > 0 and dependent-to-vehicle ratio (hd_dep_count / hd_vehicle_count) exceeds 1.2."
    sql: ${hd_vehicle_count} > 0 AND ${hd_dep_count} > 1.2 * ${hd_vehicle_count} ;;
  }

  measure: count {
    description: "Count of household demographic records."
  }
}
