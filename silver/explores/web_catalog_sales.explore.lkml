include: "/silver/web_catalog_sales.view.lkml"
include: "/silver/date_dim_web_catalog_sales_fields.view.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

explore: web_catalog_sales {
  hidden: no
  label: "Web and Catalog Sales"
  view_name: web_catalog_sales

  join: date_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_catalog_sales.sold_date_sk} = ${date_dim.d_date_sk} ;;
  }

  join: date_dim_web_catalog_sales_fields {
    sql: ;;
    relationship: one_to_one
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
}
