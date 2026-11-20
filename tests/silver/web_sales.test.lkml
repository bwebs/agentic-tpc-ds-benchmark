include: "../../silver/explores/web_sales.explore.lkml"

test: web_sales_may_jun_2000_home_join_metrics {
  explore_source: web_sales {
    column: total_ext_sales_price { field: web_sales.total_ext_sales_price }
    column: count { field: web_sales.count }
    filters: {
      field: date_dim.d_date
      value: "2000-05-11 to 2000-06-12"
    }
    filters: {
      field: item.i_category
      value: "Home"
    }
    filters: {
      field: web_sales.ws_item_sk
      value: "NOT NULL"
    }
    filters: {
      field: item.i_item_sk
      value: "NOT NULL"
    }
    filters: {
      field: web_sales.ws_sold_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: date_dim.d_date_sk
      value: "NOT NULL"
    }
  }
  assert: total_ext_sales_price_matches {
    expression: round(${web_sales.total_ext_sales_price}, 2) = 1917832.64 ;;
  }
  assert: web_sales_count_matches {
    expression: ${web_sales.count} = 716 ;;
  }
}

test: web_sales_q1_2000_prime_sk_item_customer_address_metrics {
  explore_source: web_sales {
    column: total_sales_price { field: web_sales.total_sales_price }
    column: count { field: web_sales.count }
    filters: {
      field: date_dim.d_year_num
      value: "2000"
    }
    filters: {
      field: date_dim.d_qoy
      value: "1"
    }
    filters: {
      field: customer.c_customer_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer_address.ca_address_sk
      value: "NOT NULL"
    }
    filters: {
      field: item.i_item_sk
      value: "NOT NULL"
    }
    filters: {
      field: prime_sk_item_ids.is_prime_sk_item
      value: "Yes"
    }
  }
  assert: total_sales_price_matches {
    expression: round(${web_sales.total_sales_price}, 2) = 475.56 ;;
  }
  assert: web_sales_count_matches {
    expression: ${web_sales.count} = 14 ;;
  }
}

test: web_sales_month_seq_1222_1233_ship_aging_joins {
  explore_source: web_sales {
    column: w_warehouse_name_20 { field: warehouse.w_warehouse_name_20 }
    column: sm_type { field: ship_mode.sm_type }
    column: web_name { field: web_site.web_name }
    column: days_30 { field: web_sales.days_30 }
    column: days_31_60 { field: web_sales.days_31_60 }
    column: days_61_90 { field: web_sales.days_61_90 }
    column: days_91_120 { field: web_sales.days_91_120 }
    column: days_over_120 { field: web_sales.days_over_120 }
    filters: {
      field: ship_date.d_month_seq
      value: "[1222, 1233]"
    }
    filters: {
      field: warehouse.w_warehouse_sk
      value: "NOT NULL"
    }
    filters: {
      field: ship_mode.sm_ship_mode_sk
      value: "NOT NULL"
    }
    filters: {
      field: web_site.web_site_sk
      value: "NOT NULL"
    }
    sorts: [warehouse.w_warehouse_name_20: asc, ship_mode.sm_type: asc, web_site.web_name: asc]
    limit: 5
  }
  assert: first_row_ship_aging_matches {
    expression: index(${ship_mode.sm_type}, 1) = "EXPRESS" AND index(${web_site.web_name}, 1) = "site_0" AND index(${web_sales.days_30}, 1) = 286 AND index(${web_sales.days_31_60}, 1) = 307 AND index(${web_sales.days_61_90}, 1) = 314 AND index(${web_sales.days_91_120}, 1) = 289 AND index(${web_sales.days_over_120}, 1) = 0 ;;
  }
}

test: web_sales_2001_web_returns_reason_demographics_joins {
  explore_source: web_sales {
    column: r_reason_desc_20 { field: reason.r_reason_desc_20 }
    column: average_quantity { field: web_sales.average_quantity }
    column: average_refunded_cash { field: web_returns.average_refunded_cash }
    column: average_fee { field: web_returns.average_fee }
    column: count { field: web_sales.count }
    filters: {
      field: date_dim.d_year_num
      value: "2001"
    }
    filters: {
      field: refunded_address.ca_country
      value: "United States"
    }
    filters: {
      field: web_page.wp_web_page_sk
      value: "NOT NULL"
    }
    filters: {
      field: web_returns.wr_item_sk
      value: "NOT NULL"
    }
    filters: {
      field: date_dim.d_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: cd1.cd_demo_sk
      value: "NOT NULL"
    }
    filters: {
      field: cd2.cd_demo_sk
      value: "NOT NULL"
    }
    filters: {
      field: refunded_address.ca_address_sk
      value: "NOT NULL"
    }
    filters: {
      field: reason.r_reason_sk
      value: "NOT NULL"
    }
    sorts: [reason.r_reason_desc_20: asc]
    limit: 5
  }
  assert: first_row_reason_returns_matches {
    expression: index(${reason.r_reason_desc_20}, 1) = "Did not fit" AND round(index(${web_sales.average_quantity}, 1), 2) = 51.76 AND round(index(${web_returns.average_refunded_cash}, 1), 2) = 667.13 AND round(index(${web_returns.average_fee}, 1), 2) = 50.72 AND index(${web_sales.count}, 1) = 385 ;;
  }
}

test: web_sales_q90_2000_am_pm_sales_ratio_metrics {
  explore_source: web_sales {
    column: hour_12_13_sales_count { field: time_dim_web_sales_fields.hour_12_13_sales_count }
    column: hour_20_21_sales_count { field: time_dim_web_sales_fields.hour_20_21_sales_count }
    column: am_pm_sales_ratio { field: time_dim_web_sales_fields.am_pm_sales_ratio }
    filters: {
      field: date_dim.d_year_num
      value: "2000"
    }
    filters: {
      field: ship_household_demographics.hd_dep_count
      value: "8"
    }
    filters: {
      field: web_page.wp_char_count
      value: "[5000, 5200]"
    }
    filters: {
      field: time_dim.t_hour
      value: "[12, 13], [20, 21]"
    }
    filters: {
      field: date_dim.d_date_sk
      value: "NOT NULL"
    }
  }
  assert: hour_12_13_sales_count_matches {
    expression: ${time_dim_web_sales_fields.hour_12_13_sales_count} = 56 ;;
  }
  assert: hour_20_21_sales_count_matches {
    expression: ${time_dim_web_sales_fields.hour_20_21_sales_count} = 63 ;;
  }
  assert: am_pm_sales_ratio_matches {
    expression: round(${time_dim_web_sales_fields.am_pm_sales_ratio}, 4) = 0.8889 ;;
  }
}
