include: "/silver/explores/store_returns.explore.lkml"

view: customer_store_return_facts {
  derived_table: {
    explore_source: store_returns {
      bind_filters: {
        from_field: customer_store_return_facts.return_year_filter
        to_field: date_dim.d_year_num
      }
      column: sr_customer_sk { field: store_returns.sr_customer_sk }
      column: sr_store_sk { field: store_returns.sr_store_sk }
      column: customer_total_return { field: store_returns.total_return_amount }
      derived_column: store_avg_return {
        sql: AVG(customer_total_return) OVER (PARTITION BY sr_store_sk) ;;
      }
    }
  }

  filter: return_year_filter {
    label: "Return Year"
    type: number
    description: "Filters the inner store return aggregation by date_dim.d_year_num."
  }

  dimension: pk {
    primary_key: yes
    type: string
    sql: CONCAT(CAST(${sr_customer_sk} AS STRING), '_', CAST(${sr_store_sk} AS STRING)) ;;
  }

  dimension: sr_customer_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.sr_customer_sk ;;
  }

  dimension: sr_store_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.sr_store_sk ;;
  }

  dimension: customer_total_return {
    type: number
    value_format_name: usd
    description: "Customer total return amount at this store for the filtered return year."
    sql: ${TABLE}.customer_total_return ;;
  }

  dimension: store_avg_return {
    type: number
    value_format_name: usd
    description: "Average customer total return across all returning customers at this store."
    sql: ${TABLE}.store_avg_return ;;
  }

  dimension: store_return_limit {
    type: number
    value_format_name: usd
    description: "120% of the store's average customer total return (1.2 * store_avg_return)."
    synonyms: ["return_limit"]
    sql: ${store_avg_return} * 1.2 ;;
  }

  dimension: is_above_store_return_limit {
    type: yesno
    label: "Above Store Return Limit"
    description: "Yes when customer_total_return exceeds 120% of the store's average customer return."
    sql: ${customer_total_return} > ${store_return_limit} ;;
  }

  measure: count {
    type: count
  }

  measure: total_customer_return {
    type: sum
    sql: ${customer_total_return} ;;
    value_format_name: usd
  }
}
