include: "/silver/explores/store_sales.explore.lkml"

view: manufacturer_quarterly_sales_variance {
  # ponytail: Liquid-free Gold NDT over store_sales with bind_filters + derived_column AVG() OVER (PARTITION BY i_manufact_id) instead of a multi-CTE SQL derived table
  derived_table: {
    explore_source: store_sales {
      bind_filters: {
        from_field: manufacturer_quarterly_sales_variance.month_seq_filter
        to_field: date_dim.d_month_seq
      }
      bind_filters: {
        from_field: manufacturer_quarterly_sales_variance.featured_brand_cohort_filter
        to_field: item.is_q53_featured_brand_cohort
      }
      column: i_manufact_id { field: item.i_manufact_id }
      column: d_qoy { field: date_dim.d_qoy }
      column: sum_sales { field: store_sales.total_sales_price }
      derived_column: avg_quarterly_sales {
        sql: AVG(sum_sales) OVER (PARTITION BY i_manufact_id) ;;
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
    label: "Manufacturer Quarter Key"
    description: "Composite primary key combining manufacturer ID and quarter of year."
    sql: CONCAT(CAST(${i_manufact_id} AS STRING), '_', CAST(${d_qoy} AS STRING)) ;;
  }

  dimension: i_manufact_id {
    type: number
    value_format_name: id
    label: "Manufacturer ID"
    description: "Item manufacturer identifier (i_manufact_id)."
    sql: ${TABLE}.i_manufact_id ;;
  }

  dimension: d_qoy {
    type: number
    label: "Quarter of Year"
    description: "Calendar quarter of year integer 1-4 (d_qoy)."
    sql: ${TABLE}.d_qoy ;;
  }

  dimension: sum_sales {
    type: number
    value_format_name: usd
    label: "Quarterly Store Sales"
    description: "Total store sales price for the manufacturer and quarter of year (sum_sales)."
    sql: ${TABLE}.sum_sales ;;
  }

  dimension: avg_quarterly_sales {
    type: number
    value_format_name: decimal_4
    label: "Avg Quarterly Store Sales"
    description: "Average quarterly store sales price across quarters for the manufacturer (avg_quarterly_sales)."
    sql: ${TABLE}.avg_quarterly_sales ;;
  }

  dimension: is_above_10pct_quarterly_deviation {
    type: yesno
    label: "Above 10% Quarterly Avg Deviation"
    description: "True when average quarterly sales is positive and quarterly store sales deviates by more than 10% from the manufacturer's average quarterly sales."
    sql: ${avg_quarterly_sales} > 0 AND ABS(${sum_sales} - ${avg_quarterly_sales}) > 0.1 * ${avg_quarterly_sales} ;;
  }

  measure: count {
    type: count
    description: "Count of manufacturer-quarter store sales variance rows."
  }
}
