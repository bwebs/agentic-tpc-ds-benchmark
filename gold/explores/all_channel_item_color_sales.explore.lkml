include: "/silver/explores/all_channel_sales.explore.lkml"
include: "/gold/item_color_cohort.view.lkml"

explore: all_channel_item_color_sales {
  extends: [all_channel_sales]
  hidden: no
  label: "All Channel Item Color Sales"
  view_name: all_channel_sales
  tags: ["gold"]

  always_filter: {
    filters: [item_color_cohort.item_color_filter: "firebrick,rosy,white"]
  }

  join: item_color_cohort {
    type: left_outer
    relationship: many_to_one
    sql_on: ${item.i_item_id} = ${item_color_cohort.i_item_id} ;;
  }

  query: march_1998_item_color_sales_gmt_minus_6 {
    description: "March 1998 total extended sales price across store, catalog, and web channels in GMT-6 addresses for items with firebrick, rosy, or white color versions"
    dimensions: [item.i_item_id]
    measures: [all_channel_sales.total_sales]
    filters: [
      item_color_cohort.item_color_filter: "firebrick,rosy,white",
      item_color_cohort.is_in_color_cohort: "Yes",
      date_dim.d_year_num: "1998",
      date_dim.d_moy: "3",
      customer_address.ca_gmt_offset: "-6",
      all_channel_sales.item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      all_channel_sales.sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      all_channel_sales.addr_sk: "NOT NULL",
      customer_address.ca_address_sk: "NOT NULL"
    ]
    sorts: [all_channel_sales.total_sales: asc]
    limit: 100
  }
}
