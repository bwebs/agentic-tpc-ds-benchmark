include: "../../silver/explores/store_sales.explore.lkml"

test: store_sales_2000_m11_mfg427_join_metrics {
  explore_source: store_sales {
    column: d_year_num { field: date_dim.d_year_num }
    column: i_brand_id { field: item.i_brand_id }
    column: total_extended_discount_amount { field: store_sales.total_extended_discount_amount }
    column: count { field: store_sales.count }
    filters: {
      field: date_dim.d_year_num
      value: "2000"
    }
    filters: {
      field: date_dim.d_moy
      value: "11"
    }
    filters: {
      field: item.i_manufact_id
      value: "427"
    }
    sorts: [store_sales.total_extended_discount_amount: desc, item.i_brand_id: asc]
  }
  assert: top_brand_id_matches {
    expression: index(${item.i_brand_id}, 1) = 3003001 ;;
  }
  assert: top_brand_discount_matches {
    expression: round(index(${store_sales.total_extended_discount_amount}, 1), 2) = 2574.76 ;;
  }
  assert: top_brand_count_matches {
    expression: index(${store_sales.count}, 1) = 6 ;;
  }
}
