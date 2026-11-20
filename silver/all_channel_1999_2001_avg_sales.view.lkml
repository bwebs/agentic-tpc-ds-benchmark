include: "/silver/explores/all_channel_item_sales.explore.lkml"

view: all_channel_1999_2001_avg_sales {
  derived_table: {
    explore_source: all_channel_item_sales {
      column: average_sales { field: all_channel_item_sales.average_gross_list_sales }
      filters: [
        all_channel_item_sales.sold_date_sk: "NOT NULL",
        date_dim.d_date_sk: "NOT NULL",
        date_dim.d_year_num: "[1999, 2001]"
      ]
    }
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: 1 ;;
  }

  dimension: average_sales {
    type: number
    value_format_name: usd
    description: "Overall 3-channel average line-item gross list sales (quantity * list_price) across 1999-2001."
    sql: ${TABLE}.average_sales ;;
  }

  measure: benchmark_average_sales {
    type: max
    sql: ${average_sales} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Scalar 3-channel 1999-2001 average line-item gross list sales benchmark."
  }
}
