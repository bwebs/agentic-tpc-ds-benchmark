include: "/silver/explores/all_channel_sales.explore.lkml"
include: "/gold/manufacturer_category_cohort.view.lkml"

explore: all_channel_manufacturer_category_sales {
  extends: [all_channel_sales]
  hidden: no
  label: "All Channel Manufacturer Category Sales"
  view_name: all_channel_sales
  tags: ["gold"]

  always_filter: {
    filters: [manufacturer_category_cohort.manufacturer_category_filter: "Books"]
  }

  join: manufacturer_category_cohort {
    type: left_outer
    relationship: many_to_one
    sql_on: ${item.i_manufact_id} = ${manufacturer_category_cohort.i_manufact_id} ;;
  }

  query: march_1999_books_manufacturer_sales_gmt_minus_5 {
    description: "March 1999 total extended sales price across store, catalog, and web channels in GMT-5 addresses for manufacturers producing Books items"
    dimensions: [item.i_manufact_id]
    measures: [all_channel_sales.total_ext_sales_price]
    filters: [
      manufacturer_category_cohort.manufacturer_category_filter: "Books",
      manufacturer_category_cohort.is_in_category_cohort: "Yes",
      date_dim.d_year_num: "1999",
      date_dim.d_moy: "3",
      customer_address.ca_gmt_offset: "-5",
      all_channel_sales.item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      all_channel_sales.sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      all_channel_sales.addr_sk: "NOT NULL",
      customer_address.ca_address_sk: "NOT NULL"
    ]
    sorts: [all_channel_sales.total_ext_sales_price: asc]
    limit: 100
  }
}
