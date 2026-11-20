include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"

explore: catalog_sales_base {
  hidden: yes
  view_name: catalog_sales
}
