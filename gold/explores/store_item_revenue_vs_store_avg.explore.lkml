include: "/gold/store_item_revenue_vs_store_avg.view.lkml"
include: "/bronze/store.view.lkml"
include: "/bronze/store.refinement.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"

explore: store_item_revenue_vs_store_avg {
  view_name: store_item_revenue_vs_store_avg
  label: "Store Item Revenue vs Store Average"
  tags: ["gold"]

  always_filter: {
    filters: [
      store_item_revenue_vs_store_avg.month_seq_filter: "[1199, 1210]"
    ]
  }

  join: store {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_item_revenue_vs_store_avg.ss_store_sk} = ${store.s_store_sk} ;;
  }

  join: item {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_item_revenue_vs_store_avg.ss_item_sk} = ${item.i_item_sk} ;;
  }

  query: low_revenue_store_items_month_seq_1199_1210 {
    description: "Store items whose 12-month store sales revenue (d_month_seq 1199..1210) is at or below 10% of their store's average item revenue"
    dimensions: [
      store.s_store_name,
      item.i_item_desc,
      store_item_revenue_vs_store_avg.revenue,
      item.i_current_price,
      item.i_wholesale_cost,
      item.i_brand,
      store_item_revenue_vs_store_avg.pk
    ]
    filters: [
      store_item_revenue_vs_store_avg.month_seq_filter: "[1199, 1210]",
      store_item_revenue_vs_store_avg.is_below_10pct_store_avg: "yes",
      store.s_store_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL"
    ]
    sorts: [
      store.s_store_name: asc,
      item.i_item_desc: asc
    ]
    limit: 100
  }
}
