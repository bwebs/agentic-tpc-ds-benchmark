view: catalog_class_revenue_catalog_sales_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${catalog_sales.pk} ;;
  }

  measure: revenue_ratio {
    type: number
    value_format_name: percent_2
    label: "Class Revenue Share"
    synonyms: ["revenueratio"]
    tags: ["non_additive"]
    description: "Share of item catalog sales revenue within its item class (total_ext_sales_price / total_class_revenue)."
    sql: ${catalog_sales.total_ext_sales_price} / NULLIF(${catalog_class_revenue.total_class_revenue}, 0) ;;
  }
}
