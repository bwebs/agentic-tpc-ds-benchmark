include: "/silver/explores/all_channel_item_sales.explore.lkml"
include: "/silver/cross_channel_item_taxonomy_facts.view.lkml"
include: "/silver/all_channel_1999_2001_avg_sales.view.lkml"
include: "/silver/all_channel_1999_2001_avg_sales_all_channel_item_sales_fields.view.lkml"

explore: cross_channel_item_sales {
  extends: [all_channel_item_sales]
  hidden: no
  label: "Cross Channel Item Sales"
  view_name: all_channel_item_sales
  tags: ["gold"]

  join: cross_channel_item_taxonomy_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${item.i_brand_id} = ${cross_channel_item_taxonomy_facts.i_brand_id}
      AND ${item.i_class_id} = ${cross_channel_item_taxonomy_facts.i_class_id}
      AND ${item.i_category_id} = ${cross_channel_item_taxonomy_facts.i_category_id} ;;
  }

  join: all_channel_1999_2001_avg_sales {
    type: left_outer
    relationship: many_to_one
    sql_on: 1 = ${all_channel_1999_2001_avg_sales.pk} ;;
  }

  join: all_channel_1999_2001_avg_sales_all_channel_item_sales_fields {
    sql: ;;
    relationship: one_to_one
  }

  query: nov_2001_cross_channel_sales_above_3yr_avg {
    description: "November 2001 channel sales and sale count for brand/class/category tuples sold in all 3 channels (1999-2001) exceeding 1999-2001 average line sales"
    dimensions: [
      all_channel_item_sales.channel,
      item.i_brand_id,
      item.i_class_id,
      item.i_category_id
    ]
    measures: [
      all_channel_item_sales.total_gross_list_sales,
      all_channel_item_sales.count
    ]
    filters: [
      date_dim.d_year_num: "2001",
      date_dim.d_moy: "11",
      all_channel_item_sales.item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      all_channel_item_sales.sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      cross_channel_item_taxonomy_facts.is_cross_channel_item: "Yes",
      all_channel_1999_2001_avg_sales_all_channel_item_sales_fields.is_above_3yr_avg_sales: "Yes"
    ]
    sorts: [
      all_channel_item_sales.channel: asc,
      item.i_brand_id: asc,
      item.i_class_id: asc,
      item.i_category_id: asc
    ]
    limit: 100
  }
}
