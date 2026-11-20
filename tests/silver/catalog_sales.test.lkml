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
