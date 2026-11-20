include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"

explore: web_sales_base {
  hidden: yes
  view_name: web_sales
}
