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
      column: store_2001_list_net_total { field: all_channel_sales_customer_date_dim_fields.store_2001_list_net_total }
      column: store_2002_list_net_total { field: all_channel_sales_customer_date_dim_fields.store_2002_list_net_total }
      column: web_2001_list_net_total { field: all_channel_sales_customer_date_dim_fields.web_2001_list_net_total }
      column: web_2002_list_net_total { field: all_channel_sales_customer_date_dim_fields.web_2002_list_net_total }
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

  dimension: store_2001_list_net_total {
    type: number
    value_format_name: usd
    sql: ${TABLE}.store_2001_list_net_total ;;
  }

  dimension: store_2002_list_net_total {
    type: number
    value_format_name: usd
    sql: ${TABLE}.store_2002_list_net_total ;;
  }

  dimension: web_2001_list_net_total {
    type: number
    value_format_name: usd
    sql: ${TABLE}.web_2001_list_net_total ;;
  }

  dimension: web_2002_list_net_total {
    type: number
    value_format_name: usd
    sql: ${TABLE}.web_2002_list_net_total ;;
  }

  dimension: _has_store_2002 {
    hidden: yes
    type: number
    sql: IF(${store_2002_year_total} IS NOT NULL, 1, 0) ;;
  }

  dimension: _has_catalog_2002 {
    hidden: yes
    type: number
    sql: IF(${catalog_2002_year_total} IS NOT NULL, 1, 0) ;;
  }

  dimension: _has_web_2002 {
    hidden: yes
    type: number
    sql: IF(${web_2002_year_total} IS NOT NULL, 1, 0) ;;
  }

  dimension: _has_store_2002_list_net {
    hidden: yes
    type: number
    sql: IF(${store_2002_list_net_total} IS NOT NULL, 1, 0) ;;
  }

  dimension: _has_web_2002_list_net {
    hidden: yes
    type: number
    sql: IF(${web_2002_list_net_total} IS NOT NULL, 1, 0) ;;
  }

  measure: count {
    type: count
  }

  measure: _store_2002_count {
    hidden: yes
    type: sum
    sql: ${_has_store_2002} ;;
  }

  measure: _catalog_2002_count {
    hidden: yes
    type: sum
    sql: ${_has_catalog_2002} ;;
  }

  measure: _web_2002_count {
    hidden: yes
    type: sum
    sql: ${_has_web_2002} ;;
  }

  measure: _store_2002_list_net_count {
    hidden: yes
    type: sum
    sql: ${_has_store_2002_list_net} ;;
  }

  measure: _web_2002_list_net_count {
    hidden: yes
    type: sum
    sql: ${_has_web_2002_list_net} ;;
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

  measure: total_store_2001_list_net_total {
    type: sum
    sql: ${store_2001_list_net_total} ;;
    value_format_name: usd
  }

  measure: total_store_2002_list_net_total {
    type: sum
    sql: ${store_2002_list_net_total} ;;
    value_format_name: usd
  }

  measure: total_web_2001_list_net_total {
    type: sum
    sql: ${web_2001_list_net_total} ;;
    value_format_name: usd
  }

  measure: total_web_2002_list_net_total {
    type: sum
    sql: ${web_2002_list_net_total} ;;
    value_format_name: usd
  }

  measure: store_yoy_ratio {
    type: number
    sql: IF(${_store_2002_count} > 0 AND ${total_store_2001_year_total} > 0, 1.0 * ${total_store_2002_year_total} / NULLIF(${total_store_2001_year_total}, 0), NULL) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
  }

  measure: catalog_yoy_ratio {
    type: number
    sql: IF(${_catalog_2002_count} > 0 AND ${total_catalog_2001_year_total} > 0, 1.0 * ${total_catalog_2002_year_total} / NULLIF(${total_catalog_2001_year_total}, 0), NULL) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
  }

  measure: web_yoy_ratio {
    type: number
    sql: IF(${_web_2002_count} > 0 AND ${total_web_2001_year_total} > 0, 1.0 * ${total_web_2002_year_total} / NULLIF(${total_web_2001_year_total}, 0), NULL) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
  }

  measure: store_list_net_yoy_ratio {
    type: number
    sql: IF(${_store_2002_list_net_count} > 0 AND ${total_store_2001_list_net_total} > 0, 1.0 * ${total_store_2002_list_net_total} / NULLIF(${total_store_2001_list_net_total}, 0), NULL) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Store 2002/2001 (ext_list_price - ext_discount_amt) growth ratio."
  }

  measure: web_list_net_yoy_ratio {
    type: number
    sql: IF(${_web_2002_list_net_count} > 0 AND ${total_web_2001_list_net_total} > 0, 1.0 * ${total_web_2002_list_net_total} / NULLIF(${total_web_2001_list_net_total}, 0), NULL) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Web 2002/2001 (ext_list_price - ext_discount_amt) growth ratio."
  }

  measure: is_catalog_yoy_outpacing_store_and_web {
    type: yesno
    label: "Catalog YoY Growth Outpaces Store and Web"
    tags: ["non_additive"]
    description: "Yes when 2001 spend is positive in all three channels and 2002/2001 catalog year_total ratio exceeds both store and web 2002/2001 ratios."
    sql: ${total_store_2001_year_total} > 0
      AND ${total_catalog_2001_year_total} > 0
      AND ${total_web_2001_year_total} > 0
      AND ${catalog_yoy_ratio} > ${store_yoy_ratio}
      AND ${catalog_yoy_ratio} > ${web_yoy_ratio} ;;
  }

  measure: is_web_yoy_outpacing_store_list_net_2001_2002 {
    type: yesno
    label: "Web YoY List Net Growth Outpaces Store (2001-2002)"
    tags: ["non_additive"]
    description: "Yes when 2001 (ext_list_price - ext_discount_amt) spend is positive in both store and web channels and the 2002/2001 web ratio exceeds the store ratio."
    sql: ${total_store_2001_list_net_total} > 0
      AND ${total_web_2001_list_net_total} > 0
      AND ${web_list_net_yoy_ratio} > ${store_list_net_yoy_ratio} ;;
  }
}
