include: "/bronze/explores/catalog_returns_base.explore.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

explore: catalog_returns {
  extends: [catalog_returns_base]
  hidden: no
  label: "Catalog Returns"
  view_name: catalog_returns

  join: date_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${catalog_returns.cr_returned_date_sk} = ${date_dim.d_date_sk} ;;
  }

  join: returning_address {
    from: customer_address
    view_label: "Returning Address"
    type: left_outer
    relationship: many_to_one
    sql_on: ${catalog_returns.cr_returning_addr_sk} = ${returning_address.ca_address_sk} ;;
  }

  join: customer {
    type: left_outer
    relationship: many_to_one
    sql_on: ${catalog_returns.cr_returning_customer_sk} = ${customer.c_customer_sk} ;;
  }
}
