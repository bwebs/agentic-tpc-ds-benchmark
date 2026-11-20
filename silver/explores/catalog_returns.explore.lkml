include: "/bronze/explores/catalog_returns_base.explore.lkml"
include: "/bronze/call_center.view.lkml"
include: "/bronze/call_center.refinement.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"
include: "/bronze/customer_demographics.view.lkml"
include: "/bronze/customer_demographics.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/household_demographics.view.lkml"
include: "/bronze/household_demographics.refinement.lkml"

explore: catalog_returns {
  extends: [catalog_returns_base]
  hidden: no
  label: "Catalog Returns"
  view_name: catalog_returns

  join: call_center {
    type: left_outer
    relationship: many_to_one
    sql_on: ${catalog_returns.cr_call_center_sk} = ${call_center.cc_call_center_sk} ;;
  }

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

  join: customer_address {
    view_label: "Customer Current Address"
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_current_addr_sk} = ${customer_address.ca_address_sk} ;;
  }

  join: customer_demographics {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_current_cdemo_sk} = ${customer_demographics.cd_demo_sk} ;;
  }

  join: household_demographics {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_current_hdemo_sk} = ${household_demographics.hd_demo_sk} ;;
  }

  query: call_center_returns_loss_dec_1999 {
    description: "Catalog returns net loss by call center and manager in December 1999 for GMT-7 customers with unknown household buy potential and married/unknown or widowed/advanced-degree demographics"
    dimensions: [
      call_center.cc_call_center_id,
      call_center.cc_name,
      call_center.cc_manager,
      customer_demographics.marital_education_group_id
    ]
    measures: [catalog_returns.total_net_loss]
    filters: [
      call_center.cc_call_center_sk: "NOT NULL",
      date_dim.d_year_num: "1999",
      date_dim.d_moy: "12",
      customer_demographics.marital_education_group_id: "M: Unknown,W: Advanced Degree",
      household_demographics.hd_buy_potential: "Unknown%",
      customer_address.ca_gmt_offset: "-7"
    ]
    sorts: [catalog_returns.total_net_loss: desc]
  }
}
