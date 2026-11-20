include: "/silver/explores/catalog_sales.explore.lkml"
include: "/gold/catalog_item_avg_discount.view.lkml"
include: "/gold/catalog_item_avg_discount_catalog_sales_fields.view.lkml"

explore: catalog_sales_excess_discount {
  extends: [catalog_sales]
  hidden: no
  label: "Catalog Sales Excess Discount"
  view_name: catalog_sales
  tags: ["gold"]

  always_filter: {
    filters: [date_dim.d_date: "2001-03-04 to 2001-06-04"]
  }

  join: catalog_item_avg_discount {
    type: left_outer
    relationship: many_to_one
    sql_on: ${catalog_sales.cs_item_sk} = ${catalog_item_avg_discount.cs_item_sk} ;;
  }

  join: catalog_item_avg_discount_catalog_sales_fields {
    sql: ;;
    relationship: one_to_one
  }

  query: excess_discount_amount_manufact_610_spring_2001 {
    description: "Total excess catalog discount amount (>130% of item average discount) for manufacturer 610 from 2001-03-04 through 2001-06-03"
    measures: [catalog_sales.total_ext_discount_amt]
    filters: [
      item.i_manufact_id: "610",
      date_dim.d_date: "2001-03-04 to 2001-06-04",
      catalog_item_avg_discount_catalog_sales_fields.is_excess_discount: "Yes",
      catalog_sales.cs_item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      catalog_sales.cs_sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL"
    ]
    limit: 100
  }
}
