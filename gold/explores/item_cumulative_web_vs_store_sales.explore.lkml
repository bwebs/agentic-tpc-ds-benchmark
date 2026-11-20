include: "/gold/item_cumulative_web_vs_store_sales.view.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

explore: item_cumulative_web_vs_store_sales {
  view_name: item_cumulative_web_vs_store_sales
  label: "Item Cumulative Web vs Store Sales"
  tags: ["gold"]

  always_filter: {
    filters: [
      item_cumulative_web_vs_store_sales.month_seq_filter: "[1192, 1203]"
    ]
  }

  join: item {
    type: left_outer
    relationship: many_to_one
    sql_on: ${item_cumulative_web_vs_store_sales.item_sk} = ${item.i_item_sk} ;;
  }

  join: _sdt_ws {
    from: web_sales
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

  join: _sdt_d {
    from: date_dim
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  query: web_exceeding_store_cumulative_sales_m1192_1203 {
    description: "Item-date rows in month sequence 1192..1203 where cumulative web sales exceed cumulative store sales"
    dimensions: [
      item_cumulative_web_vs_store_sales.item_sk,
      item_cumulative_web_vs_store_sales.d_date,
      item_cumulative_web_vs_store_sales.web_sales,
      item_cumulative_web_vs_store_sales.store_sales,
      item_cumulative_web_vs_store_sales.web_cumulative,
      item_cumulative_web_vs_store_sales.store_cumulative
    ]
    filters: [
      item_cumulative_web_vs_store_sales.month_seq_filter: "[1192, 1203]",
      item_cumulative_web_vs_store_sales.is_web_exceeding_store_cumulative: "Yes"
    ]
    sorts: [
      item_cumulative_web_vs_store_sales.item_sk: asc,
      item_cumulative_web_vs_store_sales.d_date: asc
    ]
    limit: 100
  }
}
