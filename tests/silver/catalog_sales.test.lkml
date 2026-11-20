include: "../../silver/explores/catalog_sales.explore.lkml"

test: catalog_sales_q1_1998_ca_target_filter_metrics {
  explore_source: catalog_sales {
    column: total_sales_price { field: catalog_sales.total_sales_price }
    column: count { field: catalog_sales.count }
    filters: {
      field: date_dim.d_year_num
      value: "1998"
    }
    filters: {
      field: date_dim.d_qoy
      value: "1"
    }
    filters: {
      field: customer_address.ca_state
      value: "CA"
    }
    filters: {
      field: catalog_sales_customer_address_fields.is_target_zip_state_or_high_price
      value: "Yes"
    }
    filters: {
      field: catalog_sales.cs_bill_customer_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer.c_customer_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer.c_current_addr_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer_address.ca_address_sk
      value: "NOT NULL"
    }
    filters: {
      field: catalog_sales.cs_sold_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: date_dim.d_date_sk
      value: "NOT NULL"
    }
  }
  assert: total_sales_price_matches {
    expression: round(${catalog_sales.total_sales_price}, 2) = 43293.61 ;;
  }
  assert: catalog_sales_count_matches {
    expression: ${catalog_sales.count} = 812 ;;
  }
}

test: catalog_sales_multi_warehouse_unreturned_2002_metrics {
  explore_source: catalog_sales {
    column: order_count { field: catalog_sales.order_count }
    column: total_shipping_cost { field: catalog_sales.total_shipping_cost }
    column: total_net_profit { field: catalog_sales.total_net_profit }
    filters: [
      ship_date_dim.d_date: "2002-03-01 to 2002-05-02",
      ship_customer_address.ca_state: "IA",
      call_center.cc_county: "Williamson County",
      catalog_sales.cs_warehouse_sk: "NOT NULL",
      catalog_order_warehouse_facts.is_multi_warehouse_order: "Yes",
      catalog_order_return_facts.cr_order_number: "NULL"
    ]
  }
  assert: order_count_matches {
    expression: ${catalog_sales.order_count} = 114 ;;
  }
  assert: total_shipping_cost_matches {
    expression: round(${catalog_sales.total_shipping_cost}, 2) = 443596.18 ;;
  }
  assert: total_net_profit_matches {
    expression: round(${catalog_sales.total_net_profit}, 2) = -116138.96 ;;
  }
}
