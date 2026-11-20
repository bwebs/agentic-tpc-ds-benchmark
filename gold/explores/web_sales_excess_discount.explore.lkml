include: "/silver/explores/web_sales.explore.lkml"
include: "/gold/web_item_avg_discount.view.lkml"
include: "/gold/web_item_avg_discount_web_sales_fields.view.lkml"

explore: web_sales_excess_discount {
  extends: [web_sales]
  hidden: no
  label: "Web Sales Excess Discount"
  view_name: web_sales
  tags: ["gold"]

  always_filter: {
    filters: [date_dim.d_date: "2002-03-29 to 2002-06-29"]
  }

  join: web_item_avg_discount {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_sales.ws_item_sk} = ${web_item_avg_discount.ws_item_sk} ;;
  }

  join: web_item_avg_discount_web_sales_fields {
    sql: ;;
    relationship: one_to_one
  }

  query: excess_discount_amount_manufact_718_spring_2002 {
    description: "Total excess web sales discount amount (>130% of item average discount) for manufacturer 718 from 2002-03-29 through 2002-06-28"
    measures: [web_sales.total_ext_discount_amt]
    filters: [
      item.i_manufact_id: "718",
      date_dim.d_date: "2002-03-29 to 2002-06-29",
      web_item_avg_discount_web_sales_fields.is_excess_discount: "Yes",
      web_sales.ws_item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      web_sales.ws_sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL"
    ]
    sorts: [web_sales.total_ext_discount_amt: asc]
    limit: 100
  }
}
