include: "../../silver/explores/store_sales.explore.lkml"

test: store_sales_2001_nov_manufact_427_join_metrics {
  explore_source: store_sales {
    column: total_extended_discount_amount { field: store_sales.total_extended_discount_amount }
    column: count { field: store_sales.count }
    filters: {
      field: date_dim.d_year_num
      value: "2001"
    }
    filters: {
      field: date_dim.d_moy
      value: "11"
    }
    filters: {
      field: item.i_manufact_id
      value: "427"
    }
  }
  assert: total_extended_discount_amount_matches {
    expression: round(${store_sales.total_extended_discount_amount}, 2) = 30650.66 ;;
  }
  assert: store_sales_count_matches {
    expression: ${store_sales.count} = 114 ;;
  }
}

test: store_sales_july_1998_high_price_metrics {
  explore_source: store_sales {
    column: store_sales_count { field: store_sales.count }
    column: category_count { field: item_category_price_facts.count }
    filters: {
      field: date_dim.d_year_num
      value: "1998"
    }
    filters: {
      field: date_dim.d_moy
      value: "7"
    }
    filters: {
      field: item_item_category_price_facts_fields.is_above_120pct_category_avg_price
      value: "Yes"
    }
    filters: {
      field: customer_address.ca_address_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer.c_customer_sk
      value: "NOT NULL"
    }
    filters: {
      field: item.i_item_sk
      value: "NOT NULL"
    }
    filters: {
      field: date_dim.d_date_sk
      value: "NOT NULL"
    }
  }
  assert: store_sales_count_matches {
    expression: ${store_sales.count} = 2807 ;;
  }
  assert: category_count_matches {
    expression: ${item_category_price_facts.count} = 10 ;;
  }
}
