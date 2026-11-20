include: "customer_demographics.view.lkml"

view: +customer_demographics {
  dimension: cd_demo_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.cd_demo_sk ;;
  }

  dimension: marital_education_group_id {
    type: string
    label: "Marital & Education Group ID"
    description: "Combined marital status and education status grain key (CONCAT(cd_marital_status, ': ', cd_education_status))."
    sql: CONCAT(${cd_marital_status}, ': ', ${cd_education_status}) ;;
  }

  measure: count {
    description: "Count of customer demographic profiles."
  }

  # --- Dependent Count Metrics ---
  measure: _cd_dep_count_count {
    hidden: yes
    type: count
    filters: [cd_dep_count: "NOT NULL"]
  }

  measure: _cd_dep_count_sum {
    hidden: yes
    type: sum
    sql: ${cd_dep_count} ;;
  }

  measure: _cd_dep_count_sum_of_squares {
    hidden: yes
    type: sum
    sql: POWER(${cd_dep_count}, 2) ;;
  }

  measure: average_dependent_count {
    type: average
    sql: ${cd_dep_count} ;;
    value_format_name: decimal_2
    tags: ["non_additive"]
    description: "Average number of dependents (AVG(cd_dep_count))."
  }

  measure: max_dependent_count {
    type: max
    sql: ${cd_dep_count} ;;
    tags: ["non_additive"]
    description: "Maximum number of dependents (MAX(cd_dep_count))."
  }

  measure: stddev_dependent_count {
    type: number
    sql: SQRT(GREATEST(${_cd_dep_count_sum_of_squares} - (POWER(${_cd_dep_count_sum}, 2) / NULLIF(${_cd_dep_count_count}, 0)), 0) / NULLIF(${_cd_dep_count_count} - 1, 0)) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Sample standard deviation of dependent count (STDDEV_SAMP(cd_dep_count))."
  }

  # --- Employed Dependent Count Metrics ---
  measure: _cd_dep_employed_count_count {
    hidden: yes
    type: count
    filters: [cd_dep_employed_count: "NOT NULL"]
  }

  measure: _cd_dep_employed_count_sum {
    hidden: yes
    type: sum
    sql: ${cd_dep_employed_count} ;;
  }

  measure: _cd_dep_employed_count_sum_of_squares {
    hidden: yes
    type: sum
    sql: POWER(${cd_dep_employed_count}, 2) ;;
  }

  measure: average_employed_dependent_count {
    type: average
    sql: ${cd_dep_employed_count} ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Average number of employed dependents (AVG(cd_dep_employed_count))."
  }

  measure: max_employed_dependent_count {
    type: max
    sql: ${cd_dep_employed_count} ;;
    tags: ["non_additive"]
    description: "Maximum number of employed dependents (MAX(cd_dep_employed_count))."
  }

  measure: stddev_employed_dependent_count {
    type: number
    sql: SQRT(GREATEST(${_cd_dep_employed_count_sum_of_squares} - (POWER(${_cd_dep_employed_count_sum}, 2) / NULLIF(${_cd_dep_employed_count_count}, 0)), 0) / NULLIF(${_cd_dep_employed_count_count} - 1, 0)) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Sample standard deviation of employed dependent count (STDDEV_SAMP(cd_dep_employed_count))."
  }

  # --- College Dependent Count Metrics ---
  measure: _cd_dep_college_count_count {
    hidden: yes
    type: count
    filters: [cd_dep_college_count: "NOT NULL"]
  }

  measure: _cd_dep_college_count_sum {
    hidden: yes
    type: sum
    sql: ${cd_dep_college_count} ;;
  }

  measure: _cd_dep_college_count_sum_of_squares {
    hidden: yes
    type: sum
    sql: POWER(${cd_dep_college_count}, 2) ;;
  }

  measure: average_college_dependent_count {
    type: average
    sql: ${cd_dep_college_count} ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Average number of college dependents (AVG(cd_dep_college_count))."
  }

  measure: max_college_dependent_count {
    type: max
    sql: ${cd_dep_college_count} ;;
    tags: ["non_additive"]
    description: "Maximum number of college dependents (MAX(cd_dep_college_count))."
  }

  measure: stddev_college_dependent_count {
    type: number
    sql: SQRT(GREATEST(${_cd_dep_college_count_sum_of_squares} - (POWER(${_cd_dep_college_count_sum}, 2) / NULLIF(${_cd_dep_college_count_count}, 0)), 0) / NULLIF(${_cd_dep_college_count_count} - 1, 0)) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Sample standard deviation of college dependent count (STDDEV_SAMP(cd_dep_college_count))."
  }
}
