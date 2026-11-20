include: "/silver/all_channel_returns.view.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/store_returns.view.lkml"
include: "/bronze/store_returns.refinement.lkml"
include: "/bronze/catalog_returns.view.lkml"
include: "/bronze/catalog_returns.refinement.lkml"
include: "/bronze/web_returns.view.lkml"
include: "/bronze/web_returns.refinement.lkml"

explore: all_channel_returns {
  hidden: no
  label: "All Channel Returns"
  view_name: all_channel_returns

  join: date_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${all_channel_returns.returned_date_sk} = ${date_dim.d_date_sk} ;;
  }

  join: item {
    type: left_outer
    relationship: many_to_one
    sql_on: ${all_channel_returns.item_sk} = ${item.i_item_sk} ;;
  }

  join: _sdt_store_returns {
    from: store_returns
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_catalog_returns {
    from: catalog_returns
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_web_returns {
    from: web_returns
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  query: cross_channel_item_returns_weeks_5192_5200_5212 {
    description: "Items returned across all three channels (store, catalog, web) during week sequences 5192, 5200, and 5212 (weeks containing 1999-06-30, 1999-08-28, and 1999-11-18)."
    dimensions: [item.i_item_id]
    measures: [
      all_channel_returns.sr_item_qty,
      all_channel_returns.sr_dev,
      all_channel_returns.cr_item_qty,
      all_channel_returns.cr_dev,
      all_channel_returns.wr_item_qty,
      all_channel_returns.wr_dev,
      all_channel_returns.average_channel_qty
    ]
    filters: [
      date_dim.d_week_seq: "5192, 5200, 5212",
      item.i_item_sk: "NOT NULL",
      all_channel_returns.distinct_channel_count: "3"
    ]
    sorts: [item.i_item_id: asc, all_channel_returns.sr_item_qty: asc]
    limit: 100
  }
}
