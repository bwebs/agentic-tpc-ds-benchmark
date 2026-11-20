view: date_dim_web_catalog_sales_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${web_catalog_sales.pk} ;;
  }

  measure: sun_sales {
    type: sum
    label: "Sunday Sales"
    description: "Total web and catalog extended sales price on Sundays."
    sql: ${web_catalog_sales.sales_price} ;;
    filters: [date_dim.d_day_name: "Sunday"]
    value_format_name: usd
  }

  measure: _sun_priced_count {
    hidden: yes
    type: count
    filters: [date_dim.d_day_name: "Sunday", web_catalog_sales.sales_price: "NOT NULL"]
  }

  measure: mon_sales {
    type: sum
    label: "Monday Sales"
    description: "Total web and catalog extended sales price on Mondays."
    sql: ${web_catalog_sales.sales_price} ;;
    filters: [date_dim.d_day_name: "Monday"]
    value_format_name: usd
  }

  measure: _mon_priced_count {
    hidden: yes
    type: count
    filters: [date_dim.d_day_name: "Monday", web_catalog_sales.sales_price: "NOT NULL"]
  }

  measure: tue_sales {
    type: sum
    label: "Tuesday Sales"
    description: "Total web and catalog extended sales price on Tuesdays."
    sql: ${web_catalog_sales.sales_price} ;;
    filters: [date_dim.d_day_name: "Tuesday"]
    value_format_name: usd
  }

  measure: _tue_priced_count {
    hidden: yes
    type: count
    filters: [date_dim.d_day_name: "Tuesday", web_catalog_sales.sales_price: "NOT NULL"]
  }

  measure: wed_sales {
    type: sum
    label: "Wednesday Sales"
    description: "Total web and catalog extended sales price on Wednesdays."
    sql: ${web_catalog_sales.sales_price} ;;
    filters: [date_dim.d_day_name: "Wednesday"]
    value_format_name: usd
  }

  measure: _wed_priced_count {
    hidden: yes
    type: count
    filters: [date_dim.d_day_name: "Wednesday", web_catalog_sales.sales_price: "NOT NULL"]
  }

  measure: thu_sales {
    type: sum
    label: "Thursday Sales"
    description: "Total web and catalog extended sales price on Thursdays."
    sql: ${web_catalog_sales.sales_price} ;;
    filters: [date_dim.d_day_name: "Thursday"]
    value_format_name: usd
  }

  measure: _thu_priced_count {
    hidden: yes
    type: count
    filters: [date_dim.d_day_name: "Thursday", web_catalog_sales.sales_price: "NOT NULL"]
  }

  measure: fri_sales {
    type: sum
    label: "Friday Sales"
    description: "Total web and catalog extended sales price on Fridays."
    sql: ${web_catalog_sales.sales_price} ;;
    filters: [date_dim.d_day_name: "Friday"]
    value_format_name: usd
  }

  measure: _fri_priced_count {
    hidden: yes
    type: count
    filters: [date_dim.d_day_name: "Friday", web_catalog_sales.sales_price: "NOT NULL"]
  }

  measure: sat_sales {
    type: sum
    label: "Saturday Sales"
    description: "Total web and catalog extended sales price on Saturdays."
    sql: ${web_catalog_sales.sales_price} ;;
    filters: [date_dim.d_day_name: "Saturday"]
    value_format_name: usd
  }

  measure: _sat_priced_count {
    hidden: yes
    type: count
    filters: [date_dim.d_day_name: "Saturday", web_catalog_sales.sales_price: "NOT NULL"]
  }
}
