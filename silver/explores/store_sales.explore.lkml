include: "/bronze/explores/store_sales_base.explore.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"

explore: store_sales {
  extends: [store_sales_base]
  hidden: no
  label: "Store Sales"
  view_name: store_sales

  join: date_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_sales.ss_sold_date_sk} = ${date_dim.d_date_sk} ;;
  }

  join: item {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_sales.ss_item_sk} = ${item.i_item_sk} ;;
  }

  query: november_manufacturer_427_brand_discounts {
    description: "November extended discount amount by calendar year and item brand for manufacturer 427"
    dimensions: [date_dim.d_year_num, item.i_brand_id, item.i_brand]
    measures: [store_sales.total_extended_discount_amount]
    filters: [item.i_manufact_id: "427", date_dim.d_moy: "11"]
    sorts: [date_dim.d_year_num: asc, store_sales.total_extended_discount_amount: desc, item.i_brand_id: asc]
    limit: 100
  }
}
