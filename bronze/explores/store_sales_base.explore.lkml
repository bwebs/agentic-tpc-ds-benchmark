include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"

explore: store_sales_base {
  hidden: yes
  view_name: store_sales
}
