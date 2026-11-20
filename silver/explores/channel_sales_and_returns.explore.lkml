include: "/silver/channel_sales_and_returns.view.lkml"
include: "/silver/catalog_page_channel_sales_and_returns_store_web_site_fields.view.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/store.view.lkml"
include: "/bronze/store.refinement.lkml"
include: "/bronze/catalog_page.view.lkml"
include: "/bronze/catalog_page.refinement.lkml"
include: "/bronze/web_site.view.lkml"
include: "/bronze/web_site.refinement.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/store_returns.view.lkml"
include: "/bronze/store_returns.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/catalog_returns.view.lkml"
include: "/bronze/catalog_returns.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/web_returns.view.lkml"
include: "/bronze/web_returns.refinement.lkml"

explore: channel_sales_and_returns {
  hidden: no
  label: "Channel Sales and Returns"
  view_name: channel_sales_and_returns

  join: date_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${channel_sales_and_returns.date_sk} = ${date_dim.d_date_sk} ;;
  }

  join: store {
    type: left_outer
    relationship: many_to_one
    sql_on: ${channel_sales_and_returns.store_sk} = ${store.s_store_sk} ;;
  }

  join: catalog_page {
    type: left_outer
    relationship: many_to_one
    sql_on: ${channel_sales_and_returns.catalog_page_sk} = ${catalog_page.cp_catalog_page_sk} ;;
  }

  join: web_site {
    type: left_outer
    relationship: many_to_one
    sql_on: ${channel_sales_and_returns.web_site_sk} = ${web_site.web_site_sk} ;;
  }

  join: catalog_page_channel_sales_and_returns_store_web_site_fields {
    sql: ;;
    relationship: one_to_one
  }

  join: _sdt_store_sales {
    from: store_sales
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_store_returns {
    from: store_returns
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

  join: _sdt_catalog_returns {
    from: catalog_returns
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

  join: _sdt_web_returns {
    from: web_returns
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  query: channel_sales_returns_aug_sep_2002 {
    description: "Sales, returns, and net profit by channel and channel entity ID from 2002-08-22 through 2002-09-05"
    dimensions: [
      channel_sales_and_returns.channel,
      catalog_page_channel_sales_and_returns_store_web_site_fields.channel_entity_id
    ]
    measures: [
      channel_sales_and_returns.total_sales,
      channel_sales_and_returns.total_returns,
      channel_sales_and_returns.total_net_profit
    ]
    filters: [
      date_dim.d_date: "2002-08-22 to 2002-09-06",
      catalog_page_channel_sales_and_returns_store_web_site_fields.channel_entity_id: "-NULL"
    ]
    sorts: [
      channel_sales_and_returns.channel: asc,
      catalog_page_channel_sales_and_returns_store_web_site_fields.channel_entity_id: asc
    ]
    limit: 100
  }
}
