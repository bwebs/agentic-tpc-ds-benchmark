include: "/bronze/explores/customer_base.explore.lkml"
include: "/silver/customer_channel_yoy_facts.view.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

explore: customer {
  extends: [customer_base]
  hidden: no
  label: "Customer"
  view_name: customer

  join: customer_channel_yoy_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_customer_id} = ${customer_channel_yoy_facts.c_customer_id} ;;
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

  join: _sdt_date_dim {
    from: date_dim
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  query: catalog_yoy_outpacing_store_and_web_2001_2002 {
    description: "Customers with positive 2001 spend in store, catalog, and web whose 2002/2001 catalog growth ratio exceeds both store and web"
    dimensions: [customer.c_customer_id, customer.c_first_name, customer.c_last_name, customer.c_preferred_cust_flag]
    filters: [
      customer_channel_yoy_facts.is_catalog_yoy_outpacing_store_and_web: "Yes",
      customer_channel_yoy_facts.c_customer_id: "-NULL"
    ]
    sorts: [customer.c_customer_id: asc]
    limit: 100
  }
}
