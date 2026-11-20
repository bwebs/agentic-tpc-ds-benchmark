include: "/silver/explores/all_channel_sales.explore.lkml"

view: all_channel_customer_daily_overlap {
  # ponytail: direct d_month_seq grain column in NDT avoids bind_filters/Liquid since d_date -> d_month_seq is functional 1:1
  derived_table: {
    explore_source: all_channel_sales {
      column: c_last_name { field: customer.c_last_name }
      column: c_first_name { field: customer.c_first_name }
      column: d_date { field: date_dim.d_raw }
      column: d_month_seq { field: date_dim.d_month_seq }
      column: distinct_channel_count { field: all_channel_sales.distinct_channel_count }
      filters: [
        all_channel_sales.sold_date_sk: "NOT NULL",
        date_dim.d_date_sk: "NOT NULL",
        all_channel_sales.customer_sk: "NOT NULL",
        customer.c_customer_sk: "NOT NULL"
      ]
    }
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(COALESCE(${c_last_name}, ''), '_', COALESCE(${c_first_name}, ''), '_', COALESCE(CAST(${d_raw} AS STRING), '')) ;;
  }

  dimension: c_last_name {
    type: string
    description: "Customer last name."
    sql: ${TABLE}.c_last_name ;;
  }

  dimension: c_first_name {
    type: string
    description: "Customer first name."
    sql: ${TABLE}.c_first_name ;;
  }

  dimension_group: d {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    description: "Calendar sale date."
    sql: ${TABLE}.d_date ;;
  }

  dimension: d_month_seq {
    type: number
    description: "Sequential calendar month identifier from date_dim."
    sql: ${TABLE}.d_month_seq ;;
  }

  dimension: distinct_channel_count {
    type: number
    description: "Number of distinct sales channels ('s' store, 'c' catalog, 'w' web) with activity for this customer name and date."
    sql: ${TABLE}.distinct_channel_count ;;
  }

  measure: count {
    type: count
    description: "Count of distinct (customer last name, customer first name, date) tuples."
  }
}
