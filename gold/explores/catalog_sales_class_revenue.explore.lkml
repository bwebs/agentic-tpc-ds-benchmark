include: "/silver/explores/catalog_sales.explore.lkml"
include: "/gold/catalog_class_revenue.view.lkml"
include: "/gold/catalog_class_revenue_catalog_sales_fields.view.lkml"

explore: catalog_sales_class_revenue {
  extends: [catalog_sales]
  hidden: no
  label: "Catalog Sales Class Revenue"
  view_name: catalog_sales
  tags: ["gold"]

  always_filter: {
    filters: [date_dim.d_date: "2001-02-03 to 2001-03-04"]
  }

  join: catalog_class_revenue {
    type: left_outer
    relationship: many_to_one
    sql_on: COALESCE(${item.i_class}, '__NULL__') = ${catalog_class_revenue.pk} ;;
  }

  join: catalog_class_revenue_catalog_sales_fields {
    sql: ;;
    relationship: one_to_one
  }

  query: item_revenue_and_class_share_feb_mar_2001 {
    description: "Catalog sales item revenue and share of class revenue for Children, Women, and Electronics categories from 2001-02-03 through 2001-03-03"
    dimensions: [
      item.i_item_id,
      item.i_item_desc,
      item.i_category,
      item.i_class,
      item.i_current_price
    ]
    measures: [
      catalog_sales.total_ext_sales_price,
      catalog_class_revenue_catalog_sales_fields.revenue_ratio
    ]
    filters: [
      item.i_category: "Children,Women,Electronics",
      date_dim.d_date: "2001-02-03 to 2001-03-04",
      catalog_sales.cs_item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      catalog_sales.cs_sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL"
    ]
    sorts: [
      item.i_category: asc,
      item.i_class: asc,
      item.i_item_id: asc,
      item.i_item_desc: asc,
      catalog_class_revenue_catalog_sales_fields.revenue_ratio: asc
    ]
    limit: 100
  }
}
