include: "/gold/store_return_catalog_repurchase.view.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/store.view.lkml"
include: "/bronze/store.refinement.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/store_returns.view.lkml"
include: "/bronze/store_returns.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"

explore: store_return_catalog_repurchase {
  view_name: store_return_catalog_repurchase
  label: "Store Return and Catalog Repurchase Dispersion"
  tags: ["gold"]

  join: d1 {
    from: date_dim
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_return_catalog_repurchase.ss_sold_date_sk} = ${d1.d_date_sk} ;;
  }

  join: d2 {
    from: date_dim
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_return_catalog_repurchase.sr_returned_date_sk} = ${d2.d_date_sk} ;;
  }

  join: d3 {
    from: date_dim
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_return_catalog_repurchase.cs_sold_date_sk} = ${d3.d_date_sk} ;;
  }

  join: store {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_return_catalog_repurchase.ss_store_sk} = ${store.s_store_sk} ;;
  }

  join: item {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_return_catalog_repurchase.ss_item_sk} = ${item.i_item_sk} ;;
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

  join: _sdt_cs {
    from: catalog_sales
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  query: q1_1999_store_return_catalog_quantity_dispersion {
    description: "Store sales, store returns, and catalog repurchase quantity count, average, sample standard deviation, and coefficient of variation by item and state for 1999Q1 store sales returned and repurchased in 1999Q1-1999Q3"
    dimensions: [
      item.i_item_id,
      item.i_item_desc,
      store.s_state
    ]
    measures: [
      store_return_catalog_repurchase.store_sales_quantity_count,
      store_return_catalog_repurchase.average_store_sales_quantity,
      store_return_catalog_repurchase.stddev_store_sales_quantity,
      store_return_catalog_repurchase.cov_store_sales_quantity,
      store_return_catalog_repurchase.store_returns_quantity_count,
      store_return_catalog_repurchase.average_store_returns_quantity,
      store_return_catalog_repurchase.stddev_store_returns_quantity,
      store_return_catalog_repurchase.cov_store_returns_quantity,
      store_return_catalog_repurchase.catalog_sales_quantity_count,
      store_return_catalog_repurchase.average_catalog_sales_quantity,
      store_return_catalog_repurchase.cov_catalog_sales_quantity
    ]
    filters: [
      d1.d_quarter_name: "1999Q1",
      d2.d_quarter_name: "1999Q1,1999Q2,1999Q3",
      d3.d_quarter_name: "1999Q1,1999Q2,1999Q3",
      store.s_store_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL"
    ]
    sorts: [
      item.i_item_id: asc,
      item.i_item_desc: asc,
      store.s_state: asc
    ]
    limit: 100
  }

  query: apr_2001_store_return_catalog_max_profit_loss {
    description: "Maximum store sales profit, store returns loss, and catalog sales profit by item and store for April 2001 store sales returned and repurchased in April-October 2001"
    dimensions: [
      item.i_item_id,
      item.i_item_desc,
      store.s_store_id,
      store.s_store_name
    ]
    measures: [
      store_return_catalog_repurchase.max_store_sales_profit,
      store_return_catalog_repurchase.max_store_returns_loss,
      store_return_catalog_repurchase.max_catalog_sales_profit
    ]
    filters: [
      d1.d_moy: "4",
      d1.d_year_num: "2001",
      d2.d_moy: "[4, 10]",
      d2.d_year_num: "2001",
      d3.d_moy: "[4, 10]",
      d3.d_year_num: "2001",
      store.s_store_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL"
    ]
    sorts: [
      item.i_item_id: asc,
      item.i_item_desc: asc,
      store.s_store_id: asc,
      store.s_store_name: asc
    ]
    limit: 100
  }
}
