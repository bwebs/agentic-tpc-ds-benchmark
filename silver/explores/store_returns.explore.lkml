include: "/bronze/explores/store_returns_base.explore.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/store.view.lkml"
include: "/bronze/store.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

explore: store_returns {
  extends: [store_returns_base]
  hidden: no
  label: "Store Returns"
  view_name: store_returns

  join: date_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_returns.sr_returned_date_sk} = ${date_dim.d_date_sk} ;;
  }

  join: store {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_returns.sr_store_sk} = ${store.s_store_sk} ;;
  }

  join: customer {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store_returns.sr_customer_sk} = ${customer.c_customer_sk} ;;
  }
}
