include: "/silver/all_channel_sales.view.lkml"
include: "/silver/all_channel_sales_customer_date_dim_fields.view.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"

explore: all_channel_sales {
  hidden: no
  label: "All Channel Sales"
  view_name: all_channel_sales

  join: customer {
    type: left_outer
    relationship: many_to_one
    sql_on: ${all_channel_sales.customer_sk} = ${customer.c_customer_sk} ;;
  }

  join: customer_address {
    type: left_outer
    relationship: many_to_one
    sql_on: ${all_channel_sales.addr_sk} = ${customer_address.ca_address_sk} ;;
  }

  join: date_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${all_channel_sales.sold_date_sk} = ${date_dim.d_date_sk} ;;
  }

  join: item {
    type: left_outer
    relationship: many_to_one
    sql_on: ${all_channel_sales.item_sk} = ${item.i_item_sk} ;;
  }

  join: all_channel_sales_customer_date_dim_fields {
    sql: ;;
    relationship: one_to_one
  }

  join: _sdt_store_sales {
    from: store_sales
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_catalog_sales {
    from: catalog_sales
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_web_sales {
    from: web_sales
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  query: balanced_channel_item_revenue_week_5330 {
    description: "Items with store, catalog, and web revenue within +/- 10% of each other during week sequence 5330 (week of 2002-02-25)."
    dimensions: [item.i_item_id]
    measures: [
      all_channel_sales.ss_item_rev,
      all_channel_sales.ss_dev,
      all_channel_sales.cs_item_rev,
      all_channel_sales.cs_dev,
      all_channel_sales.ws_item_rev,
      all_channel_sales.ws_dev,
      all_channel_sales.average_channel_rev
    ]
    filters: [
      date_dim.d_week_seq: "5330",
      item.i_item_sk: "NOT NULL",
      all_channel_sales.is_balanced_across_channels: "yes"
    ]
    sorts: [item.i_item_id: asc, all_channel_sales.ss_item_rev: asc]
    limit: 100
  }
}
