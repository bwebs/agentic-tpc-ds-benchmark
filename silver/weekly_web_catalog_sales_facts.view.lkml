include: "/silver/explores/web_catalog_sales.explore.lkml"

view: weekly_web_catalog_sales_facts {
  derived_table: {
    explore_source: web_catalog_sales {
      column: d_week_seq { field: date_dim.d_week_seq }
      column: sun_sales { field: date_dim_web_catalog_sales_fields.sun_sales }
      column: _sun_cnt { field: date_dim_web_catalog_sales_fields._sun_priced_count }
      column: mon_sales { field: date_dim_web_catalog_sales_fields.mon_sales }
      column: _mon_cnt { field: date_dim_web_catalog_sales_fields._mon_priced_count }
      column: tue_sales { field: date_dim_web_catalog_sales_fields.tue_sales }
      column: _tue_cnt { field: date_dim_web_catalog_sales_fields._tue_priced_count }
      column: wed_sales { field: date_dim_web_catalog_sales_fields.wed_sales }
      column: _wed_cnt { field: date_dim_web_catalog_sales_fields._wed_priced_count }
      column: thu_sales { field: date_dim_web_catalog_sales_fields.thu_sales }
      column: _thu_cnt { field: date_dim_web_catalog_sales_fields._thu_priced_count }
      column: fri_sales { field: date_dim_web_catalog_sales_fields.fri_sales }
      column: _fri_cnt { field: date_dim_web_catalog_sales_fields._fri_priced_count }
      column: sat_sales { field: date_dim_web_catalog_sales_fields.sat_sales }
      column: _sat_cnt { field: date_dim_web_catalog_sales_fields._sat_priced_count }
      filters: [date_dim.d_date_sk: "NOT NULL"]
    }
  }

  dimension: d_week_seq {
    primary_key: yes
    type: number
    value_format_name: id
    description: "Sequential week number from date_dim."
    synonyms: ["d_week_seq1", "d_week_seq2"]
    sql: ${TABLE}.d_week_seq ;;
  }

  measure: count {
    type: count
    filters: [d_week_seq: "NOT NULL"]
  }

  dimension: sun_sales {
    type: number
    label: "Weekly Sunday Sales"
    description: "Weekly Sunday web and catalog sales price (NULL when no priced Sunday sales occurred)."
    value_format_name: usd
    sql: IF(${TABLE}._sun_cnt > 0, ${TABLE}.sun_sales, NULL) ;;
  }

  dimension: mon_sales {
    type: number
    label: "Weekly Monday Sales"
    description: "Weekly Monday web and catalog sales price (NULL when no priced Monday sales occurred)."
    value_format_name: usd
    sql: IF(${TABLE}._mon_cnt > 0, ${TABLE}.mon_sales, NULL) ;;
  }

  dimension: tue_sales {
    type: number
    label: "Weekly Tuesday Sales"
    description: "Weekly Tuesday web and catalog sales price (NULL when no priced Tuesday sales occurred)."
    value_format_name: usd
    sql: IF(${TABLE}._tue_cnt > 0, ${TABLE}.tue_sales, NULL) ;;
  }

  dimension: wed_sales {
    type: number
    label: "Weekly Wednesday Sales"
    description: "Weekly Wednesday web and catalog sales price (NULL when no priced Wednesday sales occurred)."
    value_format_name: usd
    sql: IF(${TABLE}._wed_cnt > 0, ${TABLE}.wed_sales, NULL) ;;
  }

  dimension: thu_sales {
    type: number
    label: "Weekly Thursday Sales"
    description: "Weekly Thursday web and catalog sales price (NULL when no priced Thursday sales occurred)."
    value_format_name: usd
    sql: IF(${TABLE}._thu_cnt > 0, ${TABLE}.thu_sales, NULL) ;;
  }

  dimension: fri_sales {
    type: number
    label: "Weekly Friday Sales"
    description: "Weekly Friday web and catalog sales price (NULL when no priced Friday sales occurred)."
    value_format_name: usd
    sql: IF(${TABLE}._fri_cnt > 0, ${TABLE}.fri_sales, NULL) ;;
  }

  dimension: sat_sales {
    type: number
    label: "Weekly Saturday Sales"
    description: "Weekly Saturday web and catalog sales price (NULL when no priced Saturday sales occurred)."
    value_format_name: usd
    sql: IF(${TABLE}._sat_cnt > 0, ${TABLE}.sat_sales, NULL) ;;
  }

  measure: total_sun_sales {
    type: sum
    label: "Total Sunday Sales"
    description: "Sum of weekly Sunday web and catalog sales."
    value_format_name: usd
    sql: ${sun_sales} ;;
  }

  measure: total_mon_sales {
    type: sum
    label: "Total Monday Sales"
    description: "Sum of weekly Monday web and catalog sales."
    value_format_name: usd
    sql: ${mon_sales} ;;
  }

  measure: total_tue_sales {
    type: sum
    label: "Total Tuesday Sales"
    description: "Sum of weekly Tuesday web and catalog sales."
    value_format_name: usd
    sql: ${tue_sales} ;;
  }

  measure: total_wed_sales {
    type: sum
    label: "Total Wednesday Sales"
    description: "Sum of weekly Wednesday web and catalog sales."
    value_format_name: usd
    sql: ${wed_sales} ;;
  }

  measure: total_thu_sales {
    type: sum
    label: "Total Thursday Sales"
    description: "Sum of weekly Thursday web and catalog sales."
    value_format_name: usd
    sql: ${thu_sales} ;;
  }

  measure: total_fri_sales {
    type: sum
    label: "Total Friday Sales"
    description: "Sum of weekly Friday web and catalog sales."
    value_format_name: usd
    sql: ${fri_sales} ;;
  }

  measure: total_sat_sales {
    type: sum
    label: "Total Saturday Sales"
    description: "Sum of weekly Saturday web and catalog sales."
    value_format_name: usd
    sql: ${sat_sales} ;;
  }
}
