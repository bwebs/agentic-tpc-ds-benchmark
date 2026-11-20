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
