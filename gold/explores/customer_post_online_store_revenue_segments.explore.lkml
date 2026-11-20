include: "/gold/customer_post_online_store_revenue_segments.view.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"
include: "/bronze/store.view.lkml"
include: "/bronze/store.refinement.lkml"

explore: customer_post_online_store_revenue_segments {
  view_name: customer_post_online_store_revenue_segments
  label: "Customer Post-Online Store Revenue Segments"
  tags: ["gold"]

  always_filter: {
    filters: [
      customer_post_online_store_revenue_segments.cohort_year_filter: "2000",
      customer_post_online_store_revenue_segments.cohort_month_filter: "5",
      customer_post_online_store_revenue_segments.category_filter: "Sports",
      customer_post_online_store_revenue_segments.class_filter: "fitness"
    ]
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

  join: _sdt_item {
    from: item
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_date_dim {
    from: date_dim
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_customer {
    from: customer
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_store_sales {
    from: store_sales
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_customer_address {
    from: customer_address
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_store {
    from: store
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  query: may_2000_sports_fitness_post_online_revenue_segments {
    description: "Customer count and segment base by $50 local-store 3-month revenue segment following May 2000 online/catalog Sports fitness purchases"
    dimensions: [
      customer_post_online_store_revenue_segments.segment,
      customer_post_online_store_revenue_segments.segment_base
    ]
    measures: [
      customer_post_online_store_revenue_segments.num_customers
    ]
    filters: [
      customer_post_online_store_revenue_segments.cohort_year_filter: "2000",
      customer_post_online_store_revenue_segments.cohort_month_filter: "5",
      customer_post_online_store_revenue_segments.category_filter: "Sports",
      customer_post_online_store_revenue_segments.class_filter: "fitness"
    ]
    sorts: [
      customer_post_online_store_revenue_segments.segment: asc,
      customer_post_online_store_revenue_segments.num_customers: asc
    ]
    limit: 100
  }
}
