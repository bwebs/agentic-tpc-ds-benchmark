include: "/gold/store_item_profit_rank_pairs.view.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"

explore: store_item_profit_rank_pairs {
  view_name: store_item_profit_rank_pairs
  label: "Store Item Profit Rank Pairs"
  tags: ["gold"]

  always_filter: {
    filters: [
      store_item_profit_rank_pairs.store_sk_filter: "4"
    ]
  }

  join: best_item {
    from: item
    view_label: "Best Performing Item (Ascending Profit Rank)"
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_item_profit_rank_pairs.ascending_item_sk} = ${best_item.i_item_sk} ;;
  }

  join: worst_item {
    from: item
    view_label: "Worst Performing Item (Descending Profit Rank)"
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_item_profit_rank_pairs.descending_item_sk} = ${worst_item.i_item_sk} ;;
  }

  join: _sdt_ss {
    from: store_sales
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  query: store_4_top_10_profit_rank_item_pairs {
    description: "Top 10 paired ascending and descending average net profit items in store 4 exceeding 90% of the store's null-customer-demographics average net profit"
    dimensions: [
      store_item_profit_rank_pairs.rnk,
      best_item.i_product_name,
      worst_item.i_product_name
    ]
    filters: [
      store_item_profit_rank_pairs.store_sk_filter: "4",
      store_item_profit_rank_pairs.rnk: "<11"
    ]
    sorts: [
      store_item_profit_rank_pairs.rnk: asc
    ]
    limit: 100
  }
}
