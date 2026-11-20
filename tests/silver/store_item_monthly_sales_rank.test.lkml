include: "../../gold/explores/store_item_monthly_sales_rank.explore.lkml"

test: store_item_monthly_sales_rank_m1181_1192_books_arts_rk1 {
  explore_source: store_item_monthly_sales_rank {
    column: i_product_name { field: store_item_monthly_sales_rank.i_product_name }
    column: d_year { field: store_item_monthly_sales_rank.d_year }
    column: d_moy { field: store_item_monthly_sales_rank.d_moy }
    column: s_store_id { field: store_item_monthly_sales_rank.s_store_id }
    column: sumsales { field: store_item_monthly_sales_rank.sumsales }
    column: rk { field: store_item_monthly_sales_rank.rk }
    column: count { field: store_item_monthly_sales_rank.count }
    filters: {
      field: store_item_monthly_sales_rank.month_seq_filter
      value: "[1181, 1192]"
    }
    filters: {
      field: store_item_monthly_sales_rank.i_category
      value: "Books"
    }
    filters: {
      field: store_item_monthly_sales_rank.i_class
      value: "arts"
    }
    filters: {
      field: store_item_monthly_sales_rank.i_brand
      value: "amalgmaxi #11"
    }
    filters: {
      field: store_item_monthly_sales_rank.rk
      value: "1"
    }
    sorts: [store_item_monthly_sales_rank.i_product_name: asc]
  }
  assert: books_arts_amalgmaxi11_rk1_matches {
    expression: index(${store_item_monthly_sales_rank.i_product_name}, 1) = "ableableantipriought"
      AND index(${store_item_monthly_sales_rank.d_year}, 1) = 1998
      AND index(${store_item_monthly_sales_rank.d_moy}, 1) = 10
      AND index(${store_item_monthly_sales_rank.s_store_id}, 1) = "AAAAAAAAKAAAAAAA"
      AND round(index(${store_item_monthly_sales_rank.sumsales}, 1), 2) = 15444.96
      AND index(${store_item_monthly_sales_rank.rk}, 1) = 1 ;;
  }
}
