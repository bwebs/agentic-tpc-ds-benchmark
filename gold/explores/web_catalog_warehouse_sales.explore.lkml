include: "/gold/web_catalog_warehouse_sales.view.lkml"
include: "/bronze/warehouse.view.lkml"
include: "/bronze/warehouse.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/time_dim.view.lkml"
include: "/bronze/time_dim.refinement.lkml"
include: "/bronze/ship_mode.view.lkml"
include: "/bronze/ship_mode.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"

explore: web_catalog_warehouse_sales {
  view_name: web_catalog_warehouse_sales
  label: "Web and Catalog Warehouse Monthly Sales"
  tags: ["gold"]

  join: warehouse {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_catalog_warehouse_sales.warehouse_sk} = ${warehouse.w_warehouse_sk} ;;
  }

  join: date_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_catalog_warehouse_sales.sold_date_sk} = ${date_dim.d_date_sk} ;;
  }

  join: time_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_catalog_warehouse_sales.sold_time_sk} = ${time_dim.t_time_sk} ;;
  }

  join: ship_mode {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_catalog_warehouse_sales.ship_mode_sk} = ${ship_mode.sm_ship_mode_sk} ;;
  }

  join: _sdt_web_sales {
    from: web_sales
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

  query: warehouse_monthly_sales_1998_zouros_zhou {
    description: "Monthly sales, sales per square foot, and net paid by warehouse for 1998 morning/midday shipments via ZOUROS and ZHOU"
    dimensions: [warehouse.w_warehouse_name, warehouse.w_warehouse_sq_ft, warehouse.w_city, warehouse.w_county, warehouse.w_state, warehouse.w_country, date_dim.d_year_num]
    measures: [web_catalog_warehouse_sales.jan_sales, web_catalog_warehouse_sales.feb_sales, web_catalog_warehouse_sales.mar_sales, web_catalog_warehouse_sales.apr_sales, web_catalog_warehouse_sales.may_sales, web_catalog_warehouse_sales.jun_sales, web_catalog_warehouse_sales.jul_sales, web_catalog_warehouse_sales.aug_sales, web_catalog_warehouse_sales.sep_sales, web_catalog_warehouse_sales.oct_sales, web_catalog_warehouse_sales.nov_sales, web_catalog_warehouse_sales.dec_sales, web_catalog_warehouse_sales.jan_sales_per_sq_foot, web_catalog_warehouse_sales.feb_sales_per_sq_foot, web_catalog_warehouse_sales.mar_sales_per_sq_foot, web_catalog_warehouse_sales.apr_sales_per_sq_foot, web_catalog_warehouse_sales.may_sales_per_sq_foot, web_catalog_warehouse_sales.jun_sales_per_sq_foot, web_catalog_warehouse_sales.jul_sales_per_sq_foot, web_catalog_warehouse_sales.aug_sales_per_sq_foot, web_catalog_warehouse_sales.sep_sales_per_sq_foot, web_catalog_warehouse_sales.oct_sales_per_sq_foot, web_catalog_warehouse_sales.nov_sales_per_sq_foot, web_catalog_warehouse_sales.dec_sales_per_sq_foot, web_catalog_warehouse_sales.jan_net, web_catalog_warehouse_sales.feb_net, web_catalog_warehouse_sales.mar_net, web_catalog_warehouse_sales.apr_net, web_catalog_warehouse_sales.may_net, web_catalog_warehouse_sales.jun_net, web_catalog_warehouse_sales.jul_net, web_catalog_warehouse_sales.aug_net, web_catalog_warehouse_sales.sep_net, web_catalog_warehouse_sales.oct_net, web_catalog_warehouse_sales.nov_net, web_catalog_warehouse_sales.dec_net]
    filters: [
      date_dim.d_year_num: "1998",
      time_dim.t_time: "[7249, 36049]",
      ship_mode.sm_carrier: "ZOUROS,ZHOU",
      warehouse.w_warehouse_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      time_dim.t_time_sk: "NOT NULL",
      ship_mode.sm_ship_mode_sk: "NOT NULL"
    ]
    sorts: [warehouse.w_warehouse_name: asc]
    limit: 100
  }
}
