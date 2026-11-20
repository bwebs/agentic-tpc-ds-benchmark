include: "/silver/explores/all_channel_sales.explore.lkml"

view: customer_channel_yoy_facts {
  derived_table: {
    explore_source: all_channel_sales {
      column: c_customer_id { field: customer.c_customer_id }
      column: store_2001_year_total { field: all_channel_sales_customer_date_dim_fields.store_2001_year_total }
      column: store_2002_year_total { field: all_channel_sales_customer_date_dim_fields.store_2002_year_total }
      column: catalog_2001_year_total { field: all_channel_sales_customer_date_dim_fields.catalog_2001_year_total }
      column: catalog_2002_year_total { field: all_channel_sales_customer_date_dim_fields.catalog_2002_year_total }
      column: web_2001_year_total { field: all_channel_sales_customer_date_dim_fields.web_2001_year_total }
      column: web_2002_year_total { field: all_channel_sales_customer_date_dim_fields.web_2002_year_total }
      filters: [
        customer.c_customer_sk: "NOT NULL",
        customer.c_customer_id: "-NULL",
        date_dim.d_year_num: "2001, 2002"
      ]
    }
  }

  dimension: c_customer_id {
    primary_key: yes
    type: string
    synonyms: ["customer_id"]
    description: "Customer business identifier (c_customer_id)."
    sql: ${TABLE}.c_customer_id ;;
  }

  dimension: store_2001_year_total {
    type: number
    value_format_name: usd
    sql: ${TABLE}.store_2001_year_total ;;
  }

  dimension: store_2002_year_total {
    type: number
    value_format_name: usd
    sql: ${TABLE}.store_2002_year_total ;;
  }

  dimension: catalog_2001_year_total {
    type: number
    value_format_name: usd
    sql: ${TABLE}.catalog_2001_year_total ;;
  }

  dimension: catalog_2002_year_total {
    type: number
    value_format_name: usd
    sql: ${TABLE}.catalog_2002_year_total ;;
  }

  dimension: web_2001_year_total {
    type: number
    value_format_name: usd
    sql: ${TABLE}.web_2001_year_total ;;
  }

  dimension: web_2002_year_total {
    type: number
    value_format_name: usd
    sql: ${TABLE}.web_2002_year_total ;;
  }

  dimension: has_positive_2001_all_channels {
    type: yesno
    label: "Has Positive 2001 Spend in All Channels"
    description: "Yes when 2001 year_total is strictly positive across store, catalog, and web channels."
    sql: ${store_2001_year_total} > 0
      AND ${catalog_2001_year_total} > 0
      AND ${web_2001_year_total} > 0 ;;
  }

  dimension: is_catalog_yoy_outpacing_store_and_web {
    type: yesno
    label: "Catalog YoY Growth Outpaces Store and Web"
    description: "Yes when 2001 spend is positive in all three channels and 2002/2001 catalog year_total ratio exceeds both store and web 2002/2001 ratios."
    sql: ${store_2001_year_total} > 0
      AND ${catalog_2001_year_total} > 0
      AND ${web_2001_year_total} > 0
      AND CASE WHEN ${catalog_2001_year_total} > 0 THEN ${catalog_2002_year_total} / ${catalog_2001_year_total} ELSE NULL END
        > CASE WHEN ${store_2001_year_total} > 0 THEN ${store_2002_year_total} / ${store_2001_year_total} ELSE NULL END
      AND CASE WHEN ${catalog_2001_year_total} > 0 THEN ${catalog_2002_year_total} / ${catalog_2001_year_total} ELSE NULL END
        > CASE WHEN ${web_2001_year_total} > 0 THEN ${web_2002_year_total} / ${web_2001_year_total} ELSE NULL END ;;
  }

  measure: count {
    type: count
  }

  measure: total_store_2001_year_total {
    type: sum
    sql: ${store_2001_year_total} ;;
    value_format_name: usd
  }

  measure: total_store_2002_year_total {
    type: sum
    sql: ${store_2002_year_total} ;;
    value_format_name: usd
  }

  measure: total_catalog_2001_year_total {
    type: sum
    sql: ${catalog_2001_year_total} ;;
    value_format_name: usd
  }

  measure: total_catalog_2002_year_total {
    type: sum
    sql: ${catalog_2002_year_total} ;;
    value_format_name: usd
  }

  measure: total_web_2001_year_total {
    type: sum
    sql: ${web_2001_year_total} ;;
    value_format_name: usd
  }

  measure: total_web_2002_year_total {
    type: sum
    sql: ${web_2002_year_total} ;;
    value_format_name: usd
  }

  measure: store_yoy_ratio {
    type: number
    sql: 1.0 * ${total_store_2002_year_total} / NULLIF(${total_store_2001_year_total}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
  }

  measure: catalog_yoy_ratio {
    type: number
    sql: 1.0 * ${total_catalog_2002_year_total} / NULLIF(${total_catalog_2001_year_total}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
  }

  measure: web_yoy_ratio {
    type: number
    sql: 1.0 * ${total_web_2002_year_total} / NULLIF(${total_web_2001_year_total}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
  }
}
