include: "../../gold/explores/channel_item_return_rankings.explore.lkml"

test: channel_item_return_rankings_dec_1999_rank_1_metrics {
  explore_source: channel_item_return_rankings {
    column: channel { field: channel_item_return_rankings.channel }
    column: item_sk { field: channel_item_return_rankings.item_sk }
    column: return_ratio { field: channel_item_return_rankings.return_ratio }
    column: currency_ratio { field: channel_item_return_rankings.currency_ratio }
    column: return_rank { field: channel_item_return_rankings.return_rank }
    column: currency_rank { field: channel_item_return_rankings.currency_rank }
    column: count { field: channel_item_return_rankings.count }
    filters: {
      field: channel_item_return_rankings.year_filter
      value: "1999"
    }
    filters: {
      field: channel_item_return_rankings.month_filter
      value: "12"
    }
    filters: {
      field: channel_item_return_rankings.return_rank
      value: "1"
    }
    sorts: [
      channel_item_return_rankings.channel: asc,
      channel_item_return_rankings.item_sk: asc
    ]
  }
  assert: catalog_rank_1_matches {
    expression: index(${channel_item_return_rankings.channel}, 1) = "catalog" AND index(${channel_item_return_rankings.item_sk}, 1) = 9778 AND round(index(${channel_item_return_rankings.return_ratio}, 1), 4) = 0.56 AND index(${channel_item_return_rankings.currency_rank}, 1) = 1 ;;
  }
  assert: store_rank_1_matches {
    expression: index(${channel_item_return_rankings.channel}, 2) = "store" AND index(${channel_item_return_rankings.item_sk}, 2) = 8588 AND round(index(${channel_item_return_rankings.return_ratio}, 2), 4) = 0.7374 AND index(${channel_item_return_rankings.currency_rank}, 2) = 1 ;;
  }
  assert: web_rank_1_matches {
    expression: index(${channel_item_return_rankings.channel}, 3) = "web" AND index(${channel_item_return_rankings.item_sk}, 3) = 11656 AND round(index(${channel_item_return_rankings.return_ratio}, 3), 4) = 0.5294 AND index(${channel_item_return_rankings.currency_rank}, 3) = 32 ;;
  }
}
