include: "/silver/web_catalog_sales.view.lkml"
include: "/silver/date_dim_web_catalog_sales_fields.view.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

explore: web_catalog_sales {
  hidden: no
  label: "Web & Catalog Sales"
  view_name: web_catalog_sales
  fields: [
    ALL_FIELDS*,
    -web_catalog_sales.cs_bill_addr_sk,
    -web_catalog_sales.cs_bill_cdemo_sk,
    -web_catalog_sales.cs_bill_customer_sk,
    -web_catalog_sales.cs_bill_hdemo_sk,
    -web_catalog_sales.cs_call_center_sk,
    -web_catalog_sales.cs_catalog_page_sk,
    -web_catalog_sales.cs_coupon_amt,
    -web_catalog_sales.cs_ext_discount_amt,
    -web_catalog_sales.cs_ext_list_price,
    -web_catalog_sales.cs_ext_sales_price,
    -web_catalog_sales.cs_ext_ship_cost,
    -web_catalog_sales.cs_ext_tax,
    -web_catalog_sales.cs_ext_wholesale_cost,
    -web_catalog_sales.cs_item_sk,
    -web_catalog_sales.cs_list_price,
    -web_catalog_sales.cs_net_paid,
    -web_catalog_sales.cs_net_paid_inc_ship,
    -web_catalog_sales.cs_net_paid_inc_ship_tax,
    -web_catalog_sales.cs_net_paid_inc_tax,
    -web_catalog_sales.cs_net_profit,
    -web_catalog_sales.cs_order_number,
    -web_catalog_sales.cs_promo_sk,
    -web_catalog_sales.cs_quantity,
    -web_catalog_sales.cs_sales_price,
    -web_catalog_sales.cs_ship_addr_sk,
    -web_catalog_sales.cs_ship_cdemo_sk,
    -web_catalog_sales.cs_ship_customer_sk,
    -web_catalog_sales.cs_ship_date_sk,
    -web_catalog_sales.cs_ship_hdemo_sk,
    -web_catalog_sales.cs_ship_mode_sk,
    -web_catalog_sales.cs_sold_date_sk,
    -web_catalog_sales.cs_sold_time_sk,
    -web_catalog_sales.cs_warehouse_sk,
    -web_catalog_sales.cs_wholesale_cost,
    -web_catalog_sales.ws_bill_addr_sk,
    -web_catalog_sales.ws_bill_cdemo_sk,
    -web_catalog_sales.ws_bill_customer_sk,
    -web_catalog_sales.ws_bill_hdemo_sk,
    -web_catalog_sales.ws_coupon_amt,
    -web_catalog_sales.ws_ext_discount_amt,
    -web_catalog_sales.ws_ext_list_price,
    -web_catalog_sales.ws_ext_sales_price,
    -web_catalog_sales.ws_ext_ship_cost,
    -web_catalog_sales.ws_ext_tax,
    -web_catalog_sales.ws_ext_wholesale_cost,
    -web_catalog_sales.ws_item_sk,
    -web_catalog_sales.ws_list_price,
    -web_catalog_sales.ws_net_paid,
    -web_catalog_sales.ws_net_paid_inc_ship,
    -web_catalog_sales.ws_net_paid_inc_ship_tax,
    -web_catalog_sales.ws_net_paid_inc_tax,
    -web_catalog_sales.ws_net_profit,
    -web_catalog_sales.ws_order_number,
    -web_catalog_sales.ws_promo_sk,
    -web_catalog_sales.ws_quantity,
    -web_catalog_sales.ws_sales_price,
    -web_catalog_sales.ws_ship_addr_sk,
    -web_catalog_sales.ws_ship_cdemo_sk,
    -web_catalog_sales.ws_ship_customer_sk,
    -web_catalog_sales.ws_ship_date_sk,
    -web_catalog_sales.ws_ship_hdemo_sk,
    -web_catalog_sales.ws_ship_mode_sk,
    -web_catalog_sales.ws_sold_date_sk,
    -web_catalog_sales.ws_sold_time_sk,
    -web_catalog_sales.ws_warehouse_sk,
    -web_catalog_sales.ws_web_page_sk,
    -web_catalog_sales.ws_web_site_sk,
    -web_catalog_sales.ws_wholesale_cost
  ]

  join: date_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_catalog_sales.sold_date_sk} = ${date_dim.d_date_sk} ;;
  }

  join: date_dim_web_catalog_sales_fields {
    view_label: "Day-of-Week Sales"
    sql: ;;
    relationship: one_to_one
  }
}
