include: "/silver/weekly_web_catalog_sales_facts.view.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

explore: weekly_web_catalog_sales_facts {
  hidden: no
  label: "Weekly Web & Catalog Sales"
  view_name: weekly_web_catalog_sales_facts

  join: date_dim {
    type: left_outer
    relationship: one_to_many
    sql_on: ${weekly_web_catalog_sales_facts.d_week_seq} = ${date_dim.d_week_seq} ;;
  }
}
