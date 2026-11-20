include: "/silver/explores/all_channel_sales.explore.lkml"
include: "/gold/item_category_cohort.view.lkml"

explore: all_channel_item_category_sales {
  extends: [all_channel_sales]
  hidden: no
  label: "All Channel Item Category Sales"
  view_name: all_channel_sales
  tags: ["gold"]

  always_filter: {
    filters: [item_category_cohort.item_category_filter: "Jewelry"]
  }

  join: item_category_cohort {
    type: left_outer
    relationship: many_to_one
    sql_on: ${item.i_item_id} = ${item_category_cohort.i_item_id} ;;
  }

  query: august_1999_jewelry_item_sales_gmt_minus_6 {
    description: "August 1999 total extended sales price across store, catalog, and web channels in GMT-6 addresses for items with at least one Jewelry category version"
    dimensions: [item.i_item_id]
    measures: [all_channel_sales.total_sales]
    filters: [
      item_category_cohort.item_category_filter: "Jewelry",
      item_category_cohort.is_in_category_cohort: "Yes",
      date_dim.d_year_num: "1999",
      date_dim.d_moy: "8",
      customer_address.ca_gmt_offset: "-6",
      all_channel_sales.item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      all_channel_sales.sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      all_channel_sales.addr_sk: "NOT NULL",
      customer_address.ca_address_sk: "NOT NULL"
    ]
    sorts: [item.i_item_id: asc, all_channel_sales.total_sales: asc]
    limit: 100
  }
}
