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
