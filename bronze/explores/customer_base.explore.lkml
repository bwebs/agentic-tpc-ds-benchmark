include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"

explore: customer_base {
  hidden: yes
  view_name: customer
}
