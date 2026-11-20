include: "/silver/web_catalog_sales.view.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

view: date_dim_web_catalog_sales_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${web_catalog_sales.pk} ;;
  }

  measure: _sun_sales_sum {
    hidden: yes
    type: sum
    sql: ${web_catalog_sales.sales_price} ;;
    filters: [date_dim.d_day_name: "Sunday", date_dim.d_date_sk: "NOT NULL"]
  }
  measure: _sun_priced_count {
    hidden: yes
    type: sum
    sql: ${web_catalog_sales.has_dated_sales_price} ;;
    filters: [date_dim.d_day_name: "Sunday", date_dim.d_date_sk: "NOT NULL"]
  }
  measure: sun_sales {
    type: number
    sql: IF(${_sun_priced_count} > 0, ${_sun_sales_sum}, NULL) ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Sunday extended sales across web and catalog channels (NULL when no priced Sunday rows exist)."
  }

  measure: _mon_sales_sum {
    hidden: yes
    type: sum
    sql: ${web_catalog_sales.sales_price} ;;
    filters: [date_dim.d_day_name: "Monday", date_dim.d_date_sk: "NOT NULL"]
  }
  measure: _mon_priced_count {
    hidden: yes
    type: sum
    sql: ${web_catalog_sales.has_dated_sales_price} ;;
    filters: [date_dim.d_day_name: "Monday", date_dim.d_date_sk: "NOT NULL"]
  }
  measure: mon_sales {
    type: number
    sql: IF(${_mon_priced_count} > 0, ${_mon_sales_sum}, NULL) ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Monday extended sales across web and catalog channels (NULL when no priced Monday rows exist)."
  }

  measure: _tue_sales_sum {
    hidden: yes
    type: sum
    sql: ${web_catalog_sales.sales_price} ;;
    filters: [date_dim.d_day_name: "Tuesday", date_dim.d_date_sk: "NOT NULL"]
  }
  measure: _tue_priced_count {
    hidden: yes
    type: sum
    sql: ${web_catalog_sales.has_dated_sales_price} ;;
    filters: [date_dim.d_day_name: "Tuesday", date_dim.d_date_sk: "NOT NULL"]
  }
  measure: tue_sales {
    type: number
    sql: IF(${_tue_priced_count} > 0, ${_tue_sales_sum}, NULL) ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Tuesday extended sales across web and catalog channels (NULL when no priced Tuesday rows exist)."
  }

  measure: _wed_sales_sum {
    hidden: yes
    type: sum
    sql: ${web_catalog_sales.sales_price} ;;
    filters: [date_dim.d_day_name: "Wednesday", date_dim.d_date_sk: "NOT NULL"]
  }
  measure: _wed_priced_count {
    hidden: yes
    type: sum
    sql: ${web_catalog_sales.has_dated_sales_price} ;;
    filters: [date_dim.d_day_name: "Wednesday", date_dim.d_date_sk: "NOT NULL"]
  }
  measure: wed_sales {
    type: number
    sql: IF(${_wed_priced_count} > 0, ${_wed_sales_sum}, NULL) ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Wednesday extended sales across web and catalog channels (NULL when no priced Wednesday rows exist)."
  }

  measure: _thu_sales_sum {
    hidden: yes
    type: sum
    sql: ${web_catalog_sales.sales_price} ;;
    filters: [date_dim.d_day_name: "Thursday", date_dim.d_date_sk: "NOT NULL"]
  }
  measure: _thu_priced_count {
    hidden: yes
    type: sum
    sql: ${web_catalog_sales.has_dated_sales_price} ;;
    filters: [date_dim.d_day_name: "Thursday", date_dim.d_date_sk: "NOT NULL"]
  }
  measure: thu_sales {
    type: number
    sql: IF(${_thu_priced_count} > 0, ${_thu_sales_sum}, NULL) ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Thursday extended sales across web and catalog channels (NULL when no priced Thursday rows exist)."
  }

  measure: _fri_sales_sum {
    hidden: yes
    type: sum
    sql: ${web_catalog_sales.sales_price} ;;
    filters: [date_dim.d_day_name: "Friday", date_dim.d_date_sk: "NOT NULL"]
  }
  measure: _fri_priced_count {
    hidden: yes
    type: sum
    sql: ${web_catalog_sales.has_dated_sales_price} ;;
    filters: [date_dim.d_day_name: "Friday", date_dim.d_date_sk: "NOT NULL"]
  }
  measure: fri_sales {
    type: number
    sql: IF(${_fri_priced_count} > 0, ${_fri_sales_sum}, NULL) ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Friday extended sales across web and catalog channels (NULL when no priced Friday rows exist)."
  }

  measure: _sat_sales_sum {
    hidden: yes
    type: sum
    sql: ${web_catalog_sales.sales_price} ;;
    filters: [date_dim.d_day_name: "Saturday", date_dim.d_date_sk: "NOT NULL"]
  }
  measure: _sat_priced_count {
    hidden: yes
    type: sum
    sql: ${web_catalog_sales.has_dated_sales_price} ;;
    filters: [date_dim.d_day_name: "Saturday", date_dim.d_date_sk: "NOT NULL"]
  }
  measure: sat_sales {
    type: number
    sql: IF(${_sat_priced_count} > 0, ${_sat_sales_sum}, NULL) ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Saturday extended sales across web and catalog channels (NULL when no priced Saturday rows exist)."
  }
}
