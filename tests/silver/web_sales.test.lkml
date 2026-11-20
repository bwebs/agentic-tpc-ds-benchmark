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
