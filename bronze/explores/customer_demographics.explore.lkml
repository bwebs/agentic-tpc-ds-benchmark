include: "/bronze/customer_demographics.view.lkml"
include: "/bronze/customer_demographics.refinement.lkml"

explore: customer_demographics {
  hidden: no
  label: "Customer Demographics"
  view_name: customer_demographics
}
