include: "/silver/explores/store_sales.explore.lkml"

view: manager_monthly_sales_variance {
  # ponytail: Liquid-free Gold NDT over store_sales with bind_filters + derived_column AVG() OVER (PARTITION BY i_manager_id) instead of a multi-CTE SQL derived table
  derived_table: {
    explore_source: store_sales {
      bind_filters: {
        from_field: manager_monthly_sales_variance.month_seq_filter
        to_field: date_dim.d_month_seq
      }
      bind_filters: {
        from_field: manager_monthly_sales_variance.featured_brand_cohort_filter
        to_field: item.is_q53_featured_brand_cohort
      }
      column: i_manager_id { field: item.i_manager_id }
      column: d_moy { field: date_dim.d_moy }
      column: sum_sales { field: store_sales.total_sales_price }
      derived_column: avg_monthly_sales {
        sql: AVG(sum_sales) OVER (PARTITION BY i_manager_id) ;;
      }
      filters: {
        field: store_sales.ss_item_sk
        value: "NOT NULL"
      }
      filters: {
        field: item.i_item_sk
        value: "NOT NULL"
      }
      filters: {
        field: store_sales.ss_sold_date_sk
        value: "NOT NULL"
      }
      filters: {
        field: date_dim.d_date_sk
        value: "NOT NULL"
      }
      filters: {
        field: store_sales.ss_store_sk
        value: "NOT NULL"
      }
      filters: {
        field: store.s_store_sk
        value: "NOT NULL"
      }
    }
  }

  filter: month_seq_filter {
    type: number
    label: "Month Sequence Filter"
    description: "Filters inner store sales aggregation by date_dim.d_month_seq."
  }

  filter: featured_brand_cohort_filter {
    type: yesno
    label: "Featured Brand Cohort Filter"
    description: "Filters inner store sales aggregation by item.is_q53_featured_brand_cohort."
  }

  dimension: pk {
    primary_key: yes
    hidden: no
    type: string
    label: "Manager Month Key"
    description: "Composite primary key combining manager ID and month of year."
    sql: CONCAT(CAST(${i_manager_id} AS STRING), '_', CAST(${d_moy} AS STRING)) ;;
  }

  dimension: i_manager_id {
    type: number
    value_format_name: id
    label: "Manager ID"
    description: "Item manager identifier (i_manager_id)."
    sql: ${TABLE}.i_manager_id ;;
  }

  dimension: d_moy {
    type: number
    label: "Month of Year"
    description: "Calendar month of year integer 1-12 (d_moy)."
    sql: ${TABLE}.d_moy ;;
  }

  dimension: sum_sales {
    type: number
    value_format_name: usd
    label: "Monthly Store Sales"
    description: "Total store sales price for the manager and month of year (sum_sales)."
    sql: ${TABLE}.sum_sales ;;
  }

  dimension: avg_monthly_sales {
    type: number
    value_format_name: decimal_4
    label: "Avg Monthly Store Sales"
    description: "Average monthly store sales price across months for the manager (avg_monthly_sales)."
    sql: ${TABLE}.avg_monthly_sales ;;
  }

  dimension: is_above_10pct_monthly_deviation {
    type: yesno
    label: "Above 10% Monthly Avg Deviation"
    description: "True when average monthly sales is positive and monthly store sales deviates by more than 10% from the manager's average monthly sales."
    sql: ${avg_monthly_sales} > 0 AND ABS(${sum_sales} - ${avg_monthly_sales}) > 0.1 * ${avg_monthly_sales} ;;
  }

  measure: count {
    type: count
    description: "Count of manager-month store sales variance rows."
  }
}
