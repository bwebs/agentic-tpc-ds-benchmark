include: "/bronze/explores/web_sales_base.explore.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

explore: web_sales {
  extends: [web_sales_base]
  hidden: no
  label: "Web Sales"
  view_name: web_sales

  join: item {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_sales.ws_item_sk} = ${item.i_item_sk} ;;
  }

  join: date_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_sales.ws_sold_date_sk} = ${date_dim.d_date_sk} ;;
  }
}
