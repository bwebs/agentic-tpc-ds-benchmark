include: "/gold/store_return_net_paid.view.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/store_returns.view.lkml"
include: "/bronze/store_returns.refinement.lkml"
include: "/bronze/store.view.lkml"
include: "/bronze/store.refinement.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"

explore: store_return_net_paid {
  view_name: store_return_net_paid
  label: "Store Return Net Paid Benchmark"
  tags: ["gold"]

  always_filter: {
    filters: [
      store_return_net_paid.market_id_filter: "6"
    ]
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

  join: _sdt_s {
    from: store
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_i {
    from: item
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_c {
    from: customer
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_ca {
    from: customer_address
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  query: market_6_papaya_net_paid_above_5pct_avg {
    description: "Customer net paid by store in market 6 for papaya items exceeding 5% of the market 6 ssales cohort average net paid"
    dimensions: [
      store_return_net_paid.c_last_name,
      store_return_net_paid.c_first_name,
      store_return_net_paid.s_store_name
    ]
    measures: [
      store_return_net_paid.paid
    ]
    filters: [
      store_return_net_paid.market_id_filter: "6",
      store_return_net_paid.i_color: "papaya",
      store_return_net_paid.is_above_5pct_avg_netpaid: "Yes"
    ]
    limit: 500
  }
}
