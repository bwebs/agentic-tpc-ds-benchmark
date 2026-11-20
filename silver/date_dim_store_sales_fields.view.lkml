view: date_dim_store_sales_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${store_sales.pk} ;;
  }

  measure: sun_sales {
    type: sum
    label: "Sunday Sales"
    description: "Total store sales price on Sundays."
    sql: ${store_sales.ss_sales_price} ;;
    filters: [date_dim.d_day_name: "Sunday"]
    value_format_name: usd
  }

  measure: mon_sales {
    type: sum
    label: "Monday Sales"
    description: "Total store sales price on Mondays."
    sql: ${store_sales.ss_sales_price} ;;
    filters: [date_dim.d_day_name: "Monday"]
    value_format_name: usd
  }

  measure: tue_sales {
    type: sum
    label: "Tuesday Sales"
    description: "Total store sales price on Tuesdays."
    sql: ${store_sales.ss_sales_price} ;;
    filters: [date_dim.d_day_name: "Tuesday"]
    value_format_name: usd
  }

  measure: wed_sales {
    type: sum
    label: "Wednesday Sales"
    description: "Total store sales price on Wednesdays."
    sql: ${store_sales.ss_sales_price} ;;
    filters: [date_dim.d_day_name: "Wednesday"]
    value_format_name: usd
  }

  measure: thu_sales {
    type: sum
    label: "Thursday Sales"
    description: "Total store sales price on Thursdays."
    sql: ${store_sales.ss_sales_price} ;;
    filters: [date_dim.d_day_name: "Thursday"]
    value_format_name: usd
  }

  measure: fri_sales {
    type: sum
    label: "Friday Sales"
    description: "Total store sales price on Fridays."
    sql: ${store_sales.ss_sales_price} ;;
    filters: [date_dim.d_day_name: "Friday"]
    value_format_name: usd
  }

  measure: sat_sales {
    type: sum
    label: "Saturday Sales"
    description: "Total store sales price on Saturdays."
    sql: ${store_sales.ss_sales_price} ;;
    filters: [date_dim.d_day_name: "Saturday"]
    value_format_name: usd
  }
}
