include: "../../gold/explores/store_item_profit_rank_pairs.explore.lkml"

test: store_item_profit_rank_pairs_store_4_top_10_metrics {
  explore_source: store_item_profit_rank_pairs {
    column: rnk { field: store_item_profit_rank_pairs.rnk }
    column: best_performing { field: best_item.i_product_name }
    column: worst_performing { field: worst_item.i_product_name }
    column: count { field: store_item_profit_rank_pairs.count }
    filters: {
      field: store_item_profit_rank_pairs.store_sk_filter
      value: "4"
    }
    filters: {
      field: store_item_profit_rank_pairs.rnk
      value: "<11"
    }
    sorts: [store_item_profit_rank_pairs.rnk: asc]
  }
  assert: rank_1_pair_matches {
    expression: index(${store_item_profit_rank_pairs.rnk}, 1) = 1 AND index(${best_item.i_product_name}, 1) = "n stcallyn stantiought" AND index(${worst_item.i_product_name}, 1) = "callyeingbarcallyought" ;;
  }
  assert: rank_10_pair_matches {
    expression: index(${store_item_profit_rank_pairs.rnk}, 10) = 10 AND index(${best_item.i_product_name}, 10) = "barantiationought" AND index(${worst_item.i_product_name}, 10) = "barcallyableought" ;;
  }
}
