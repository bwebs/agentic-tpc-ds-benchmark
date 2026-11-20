include: "/gold/channel_item_return_rankings.view.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/web_returns.view.lkml"
include: "/bronze/web_returns.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/catalog_returns.view.lkml"
include: "/bronze/catalog_returns.refinement.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/store_returns.view.lkml"
include: "/bronze/store_returns.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

explore: channel_item_return_rankings {
  view_name: channel_item_return_rankings
  label: "Channel Item Return Rankings"
  tags: ["gold"]

  always_filter: {
    filters: [
      channel_item_return_rankings.year_filter: "1999",
      channel_item_return_rankings.month_filter: "12"
    ]
  }

  join: item {
    type: left_outer
    relationship: many_to_one
    sql_on: ${channel_item_return_rankings.item_sk} = ${item.i_item_sk} ;;
  }

  join: _sdt_ws {
    from: web_sales
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_wr {
    from: web_returns
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_cs {
    from: catalog_sales
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_cr {
    from: catalog_returns
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_ss {
    from: store_sales
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_sr {
    from: store_returns
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_d {
    from: date_dim
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  query: dec_1999_channel_item_return_rankings {
    description: "Items ranked by ascending quantity return ratio and currency return ratio across web, catalog, and store channels in December 1999"
    dimensions: [
      channel_item_return_rankings.channel,
      channel_item_return_rankings.item_sk,
      channel_item_return_rankings.return_ratio,
      channel_item_return_rankings.return_rank,
      channel_item_return_rankings.currency_rank
    ]
    filters: [
      channel_item_return_rankings.year_filter: "1999",
      channel_item_return_rankings.month_filter: "12"
    ]
    sorts: [
      channel_item_return_rankings.channel: asc,
      channel_item_return_rankings.return_rank: asc,
      channel_item_return_rankings.currency_rank: asc
    ]
    limit: 100
  }
}
