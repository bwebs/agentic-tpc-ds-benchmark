include: "/silver/explores/catalog_returns.explore.lkml"

view: catalog_customer_total_return {
  derived_table: {
    explore_source: catalog_returns {
      bind_filters: {
        from_field: catalog_customer_total_return.return_year_filter
        to_field: date_dim.d_year_num
      }
      filters: [
        catalog_returns.cr_returned_date_sk: "NOT NULL",
        date_dim.d_date_sk: "NOT NULL",
        catalog_returns.cr_returning_addr_sk: "NOT NULL",
        returning_address.ca_address_sk: "NOT NULL"
      ]
      column: ctr_customer_sk { field: catalog_returns.cr_returning_customer_sk }
      column: ctr_state { field: returning_address.ca_state }
      column: ctr_total_return { field: catalog_returns.total_return_amt_inc_tax }
      derived_column: state_avg_return {
        sql: AVG(ctr_total_return) OVER (PARTITION BY ctr_state) ;;
      }
    }
  }

  filter: return_year_filter {
    label: "Return Year"
    type: number
    description: "Filters the inner catalog return aggregation by date_dim.d_year_num."
  }

  dimension: pk {
    primary_key: yes
    type: string
    sql: CONCAT(COALESCE(CAST(${ctr_customer_sk} AS STRING), 'NULL'), '_', COALESCE(${ctr_state}, 'NULL')) ;;
  }

  dimension: ctr_customer_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ctr_customer_sk ;;
  }

  dimension: ctr_state {
    type: string
    description: "Returning address state (returning_address.ca_state) for the catalog return."
    sql: ${TABLE}.ctr_state ;;
  }

  dimension: ctr_total_return {
    type: number
    value_format_name: usd
    description: "Customer total catalog return amount including tax in this returning state for the filtered return year."
    synonyms: ["customer_total_return"]
    sql: ${TABLE}.ctr_total_return ;;
  }

  dimension: state_avg_return {
    type: number
    value_format_name: usd
    description: "Average customer total catalog return including tax across all returning customers in the same returning state."
    sql: ${TABLE}.state_avg_return ;;
  }

  dimension: state_return_limit {
    type: number
    value_format_name: usd
    description: "120% of the returning state's average customer total catalog return including tax (1.2 * state_avg_return)."
    synonyms: ["hr_limit", "return_limit"]
    sql: ${state_avg_return} * 1.2 ;;
  }

  dimension: is_above_state_return_limit {
    type: yesno
    label: "Above State Return Limit"
    description: "Yes when ctr_total_return exceeds 120% of the returning state's average customer catalog return including tax."
    sql: ${ctr_total_return} > ${state_return_limit} ;;
  }

  measure: count {
    type: count
    description: "Count of customer-by-returning-state catalog return summary rows."
  }

  measure: total_customer_return {
    type: sum
    sql: ${ctr_total_return} ;;
    value_format_name: usd
    description: "Sum of customer total catalog return amount including tax across summary rows."
  }
}
