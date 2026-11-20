include: "/silver/explores/store_sales.explore.lkml"

view: store_item_revenue_vs_store_avg {
  derived_table: {
    explore_source: store_sales {
      bind_filters: {
        from_field: store_item_revenue_vs_store_avg.month_seq_filter
        to_field: date_dim.d_month_seq
      }
      column: ss_store_sk { field: store_sales.ss_store_sk }
      column: ss_item_sk { field: store_sales.ss_item_sk }
      column: revenue { field: store_sales.total_sales_price }
      derived_column: store_avg_item_revenue {
        sql: AVG(revenue) OVER (PARTITION BY ss_store_sk) ;;
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
        field: store_sales.ss_sales_price
        value: "NOT NULL"
      }
    }
  }

  filter: month_seq_filter {
    type: number
    label: "Month Sequence Filter"
    description: "Filters inner store sales aggregation by date_dim.d_month_seq."
  }

  dimension: pk {
    primary_key: yes
    type: string
    label: "Store Item Key"
    description: "Composite primary key combining store SK and item SK."
    sql: CONCAT(COALESCE(CAST(${ss_store_sk} AS STRING), 'NULL'), '_', COALESCE(CAST(${ss_item_sk} AS STRING), 'NULL')) ;;
  }

  dimension: ss_store_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    label: "Store SK"
    description: "Store surrogate key (ss_store_sk)."
    sql: ${TABLE}.ss_store_sk ;;
  }

  dimension: ss_item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    label: "Item SK"
    description: "Item surrogate key (ss_item_sk)."
    sql: ${TABLE}.ss_item_sk ;;
  }

  dimension: revenue {
    type: number
    value_format_name: usd
    label: "Store Item Revenue"
    description: "Total store sales price for the store and item in the selected month sequence window (SUM(ss_sales_price))."
    sql: ${TABLE}.revenue ;;
  }

  dimension: store_avg_item_revenue {
    type: number
    value_format_name: usd
    label: "Store Average Item Revenue"
    synonyms: ["ave"]
    description: "Average per-item store sales revenue across all items sold in the store during the selected month sequence window."
    sql: ${TABLE}.store_avg_item_revenue ;;
  }

  dimension: is_below_10pct_store_avg {
    type: yesno
    label: "Below 10% of Store Average Revenue"
    description: "Whether the item's store sales revenue is less than or equal to 10% of the store's average per-item revenue."
    sql: ${revenue} <= 0.1 * ${store_avg_item_revenue} ;;
  }

  measure: count {
    type: count
    description: "Count of store-item revenue rows."
  }

  measure: total_revenue {
    type: sum
    value_format_name: usd
    label: "Total Revenue"
    description: "Sum of store-item sales revenue across selected store-item pairs."
    sql: ${revenue} ;;
  }
}
