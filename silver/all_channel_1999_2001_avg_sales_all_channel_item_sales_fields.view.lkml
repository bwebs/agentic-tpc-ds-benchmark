view: all_channel_1999_2001_avg_sales_all_channel_item_sales_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${all_channel_item_sales.pk} ;;
  }

  measure: is_above_3yr_avg_sales {
    type: yesno
    label: "Above 1999-2001 Avg Line Sales"
    tags: ["non_additive"]
    description: "True when total gross list sales strictly exceeds the 1999-2001 3-channel average line-item gross list sales."
    sql: ${all_channel_item_sales.total_gross_list_sales} > ${all_channel_1999_2001_avg_sales.benchmark_average_sales} ;;
  }
}
