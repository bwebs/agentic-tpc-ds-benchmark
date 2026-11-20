include: "/silver/all_channel_sales.view.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

view: all_channel_sales_customer_date_dim_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${all_channel_sales.pk} ;;
  }

  measure: _store_2001_sum {
    hidden: yes
    type: sum
    sql: ${all_channel_sales.year_net_amount} ;;
    filters: [all_channel_sales.sale_type: "s", date_dim.d_year_num: "2001", date_dim.d_date_sk: "NOT NULL", customer.c_customer_sk: "NOT NULL"]
  }
  measure: _store_2001_priced_count {
    hidden: yes
    type: sum
    sql: ${all_channel_sales.has_dated_year_net_amount} ;;
    filters: [all_channel_sales.sale_type: "s", date_dim.d_year_num: "2001", date_dim.d_date_sk: "NOT NULL", customer.c_customer_sk: "NOT NULL"]
  }
  measure: store_2001_year_total {
    type: number
    sql: IF(${_store_2001_priced_count} > 0, ${_store_2001_sum}, NULL) ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Store channel year_total in 2001 (NULL when no priced rows exist)."
  }

  measure: _store_2002_sum {
    hidden: yes
    type: sum
    sql: ${all_channel_sales.year_net_amount} ;;
    filters: [all_channel_sales.sale_type: "s", date_dim.d_year_num: "2002", date_dim.d_date_sk: "NOT NULL", customer.c_customer_sk: "NOT NULL"]
  }
  measure: _store_2002_priced_count {
    hidden: yes
    type: sum
    sql: ${all_channel_sales.has_dated_year_net_amount} ;;
    filters: [all_channel_sales.sale_type: "s", date_dim.d_year_num: "2002", date_dim.d_date_sk: "NOT NULL", customer.c_customer_sk: "NOT NULL"]
  }
  measure: store_2002_year_total {
    type: number
    sql: IF(${_store_2002_priced_count} > 0, ${_store_2002_sum}, NULL) ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Store channel year_total in 2002 (NULL when no priced rows exist)."
  }

  measure: _catalog_2001_sum {
    hidden: yes
    type: sum
    sql: ${all_channel_sales.year_net_amount} ;;
    filters: [all_channel_sales.sale_type: "c", date_dim.d_year_num: "2001", date_dim.d_date_sk: "NOT NULL", customer.c_customer_sk: "NOT NULL"]
  }
  measure: _catalog_2001_priced_count {
    hidden: yes
    type: sum
    sql: ${all_channel_sales.has_dated_year_net_amount} ;;
    filters: [all_channel_sales.sale_type: "c", date_dim.d_year_num: "2001", date_dim.d_date_sk: "NOT NULL", customer.c_customer_sk: "NOT NULL"]
  }
  measure: catalog_2001_year_total {
    type: number
    sql: IF(${_catalog_2001_priced_count} > 0, ${_catalog_2001_sum}, NULL) ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Catalog channel year_total in 2001 (NULL when no priced rows exist)."
  }

  measure: _catalog_2002_sum {
    hidden: yes
    type: sum
    sql: ${all_channel_sales.year_net_amount} ;;
    filters: [all_channel_sales.sale_type: "c", date_dim.d_year_num: "2002", date_dim.d_date_sk: "NOT NULL", customer.c_customer_sk: "NOT NULL"]
  }
  measure: _catalog_2002_priced_count {
    hidden: yes
    type: sum
    sql: ${all_channel_sales.has_dated_year_net_amount} ;;
    filters: [all_channel_sales.sale_type: "c", date_dim.d_year_num: "2002", date_dim.d_date_sk: "NOT NULL", customer.c_customer_sk: "NOT NULL"]
  }
  measure: catalog_2002_year_total {
    type: number
    sql: IF(${_catalog_2002_priced_count} > 0, ${_catalog_2002_sum}, NULL) ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Catalog channel year_total in 2002 (NULL when no priced rows exist)."
  }

  measure: _web_2001_sum {
    hidden: yes
    type: sum
    sql: ${all_channel_sales.year_net_amount} ;;
    filters: [all_channel_sales.sale_type: "w", date_dim.d_year_num: "2001", date_dim.d_date_sk: "NOT NULL", customer.c_customer_sk: "NOT NULL"]
  }
  measure: _web_2001_priced_count {
    hidden: yes
    type: sum
    sql: ${all_channel_sales.has_dated_year_net_amount} ;;
    filters: [all_channel_sales.sale_type: "w", date_dim.d_year_num: "2001", date_dim.d_date_sk: "NOT NULL", customer.c_customer_sk: "NOT NULL"]
  }
  measure: web_2001_year_total {
    type: number
    sql: IF(${_web_2001_priced_count} > 0, ${_web_2001_sum}, NULL) ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Web channel year_total in 2001 (NULL when no priced rows exist)."
  }

  measure: _web_2002_sum {
    hidden: yes
    type: sum
    sql: ${all_channel_sales.year_net_amount} ;;
    filters: [all_channel_sales.sale_type: "w", date_dim.d_year_num: "2002", date_dim.d_date_sk: "NOT NULL", customer.c_customer_sk: "NOT NULL"]
  }
  measure: _web_2002_priced_count {
    hidden: yes
    type: sum
    sql: ${all_channel_sales.has_dated_year_net_amount} ;;
    filters: [all_channel_sales.sale_type: "w", date_dim.d_year_num: "2002", date_dim.d_date_sk: "NOT NULL", customer.c_customer_sk: "NOT NULL"]
  }
  measure: web_2002_year_total {
    type: number
    sql: IF(${_web_2002_priced_count} > 0, ${_web_2002_sum}, NULL) ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Web channel year_total in 2002 (NULL when no priced rows exist)."
  }
}
