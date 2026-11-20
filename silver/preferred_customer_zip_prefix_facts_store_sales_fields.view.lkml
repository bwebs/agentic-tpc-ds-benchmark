view: preferred_customer_zip_prefix_facts_store_sales_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${store_sales.pk} ;;
  }

  dimension: _zip_weighted_net_profit {
    hidden: yes
    type: number
    sql: ${store_sales.ss_net_profit} * ${preferred_customer_zip_prefix_facts.qualifying_zip5_count} ;;
  }

  measure: total_common_zip_net_profit {
    type: sum
    sql: ${_zip_weighted_net_profit} ;;
    value_format_name: usd
    description: "Sum of store sales net profit weighted by qualifying preferred-customer common 5-digit ZIP count sharing the store's 2-digit ZIP prefix."
    synonyms: ["common zip net profit"]
  }
}
