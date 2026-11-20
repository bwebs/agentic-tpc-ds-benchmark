include: "/gold/frequent_item_best_customer_sales.view.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"

explore: frequent_item_best_customer_sales {
  view_name: frequent_item_best_customer_sales
  label: "Frequent Item Best Customer Sales"
  tags: ["gold"]

  always_filter: {
    filters: [
      frequent_item_best_customer_sales.store_cohort_year_filter: "1998,1999,2000,2001"
    ]
  }

  join: date_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${frequent_item_best_customer_sales.sold_date_sk} = ${date_dim.d_date_sk} ;;
  }

  join: item {
    type: left_outer
    relationship: many_to_one
    sql_on: ${frequent_item_best_customer_sales.item_sk} = ${item.i_item_sk} ;;
  }

  join: customer {
    type: left_outer
    relationship: many_to_one
    sql_on: ${frequent_item_best_customer_sales.bill_customer_sk} = ${customer.c_customer_sk} ;;
  }

  join: _sdt_store_sales {
    from: store_sales
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

  join: _sdt_item {
    from: item
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

  query: jun_1998_frequent_item_best_customer_sales {
    description: "Total catalog and web list sales in June 1998 for items sold >4 times on a single store day (1998-2001) to top-5%-threshold store customers"
    measures: [
      frequent_item_best_customer_sales.sum_sales
    ]
    filters: [
      frequent_item_best_customer_sales.store_cohort_year_filter: "1998,1999,2000,2001",
      date_dim.d_year_num: "1998",
      date_dim.d_moy: "6"
    ]
    limit: 100
  }
}
