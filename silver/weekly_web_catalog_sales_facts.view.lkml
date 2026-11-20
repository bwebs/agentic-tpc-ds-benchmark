include: "/silver/explores/web_catalog_sales.explore.lkml"

view: weekly_web_catalog_sales_facts {
  derived_table: {
    explore_source: web_catalog_sales {
      column: d_week_seq { field: date_dim.d_week_seq }
      column: sun_sales { field: date_dim_web_catalog_sales_fields.sun_sales }
      column: mon_sales { field: date_dim_web_catalog_sales_fields.mon_sales }
      column: tue_sales { field: date_dim_web_catalog_sales_fields.tue_sales }
      column: wed_sales { field: date_dim_web_catalog_sales_fields.wed_sales }
      column: thu_sales { field: date_dim_web_catalog_sales_fields.thu_sales }
      column: fri_sales { field: date_dim_web_catalog_sales_fields.fri_sales }
      column: sat_sales { field: date_dim_web_catalog_sales_fields.sat_sales }
      filters: [date_dim.d_week_seq: "NOT NULL"]
    }
  }

  dimension: d_week_seq {
    primary_key: yes
    type: number
    description: "Sequential week identifier from date_dim (d_week_seq)."
    sql: ${TABLE}.d_week_seq ;;
  }

  measure: count {
    type: count
    filters: [d_week_seq: "NOT NULL"]
  }

  dimension: sun_sales {
    type: number
    value_format_name: usd
    description: "Weekly Sunday web and catalog extended sales."
    sql: ${TABLE}.sun_sales ;;
  }
  measure: total_sun_sales {
    type: sum
    sql: ${sun_sales} ;;
    value_format_name: usd
    description: "Sum of weekly Sunday web and catalog extended sales."
  }

  dimension: mon_sales {
    type: number
    value_format_name: usd
    description: "Weekly Monday web and catalog extended sales."
    sql: ${TABLE}.mon_sales ;;
  }
  measure: total_mon_sales {
    type: sum
    sql: ${mon_sales} ;;
    value_format_name: usd
    description: "Sum of weekly Monday web and catalog extended sales."
  }

  dimension: tue_sales {
    type: number
    value_format_name: usd
    description: "Weekly Tuesday web and catalog extended sales."
    sql: ${TABLE}.tue_sales ;;
  }
  measure: total_tue_sales {
    type: sum
    sql: ${tue_sales} ;;
    value_format_name: usd
    description: "Sum of weekly Tuesday web and catalog extended sales."
  }

  dimension: wed_sales {
    type: number
    value_format_name: usd
    description: "Weekly Wednesday web and catalog extended sales."
    sql: ${TABLE}.wed_sales ;;
  }
  measure: total_wed_sales {
    type: sum
    sql: ${wed_sales} ;;
    value_format_name: usd
    description: "Sum of weekly Wednesday web and catalog extended sales."
  }

  dimension: thu_sales {
    type: number
    value_format_name: usd
    description: "Weekly Thursday web and catalog extended sales."
    sql: ${TABLE}.thu_sales ;;
  }
  measure: total_thu_sales {
    type: sum
    sql: ${thu_sales} ;;
    value_format_name: usd
    description: "Sum of weekly Thursday web and catalog extended sales."
  }

  dimension: fri_sales {
    type: number
    value_format_name: usd
    description: "Weekly Friday web and catalog extended sales."
    sql: ${TABLE}.fri_sales ;;
  }
  measure: total_fri_sales {
    type: sum
    sql: ${fri_sales} ;;
    value_format_name: usd
    description: "Sum of weekly Friday web and catalog extended sales."
  }

  dimension: sat_sales {
    type: number
    value_format_name: usd
    description: "Weekly Saturday web and catalog extended sales."
    sql: ${TABLE}.sat_sales ;;
  }
  measure: total_sat_sales {
    type: sum
    sql: ${sat_sales} ;;
    value_format_name: usd
    description: "Sum of weekly Saturday web and catalog extended sales."
  }
}
