include: "/silver/explores/all_channel_item_sales.explore.lkml"

view: cross_channel_item_taxonomy_facts {
  derived_table: {
    explore_source: all_channel_item_sales {
      column: i_brand_id { field: item.i_brand_id }
      column: i_class_id { field: item.i_class_id }
      column: i_category_id { field: item.i_category_id }
      column: distinct_channel_count { field: all_channel_item_sales.distinct_channel_count }
      filters: [
        all_channel_item_sales.item_sk: "NOT NULL",
        item.i_item_sk: "NOT NULL",
        item.i_brand_id: "NOT NULL",
        item.i_class_id: "NOT NULL",
        item.i_category_id: "NOT NULL",
        all_channel_item_sales.sold_date_sk: "NOT NULL",
        date_dim.d_date_sk: "NOT NULL",
        date_dim.d_year_num: "[1999, 2001]"
      ]
    }
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${i_brand_id} AS STRING), '_', CAST(${i_class_id} AS STRING), '_', CAST(${i_category_id} AS STRING)) ;;
  }

  dimension: i_brand_id {
    type: number
    value_format_name: id
    sql: ${TABLE}.i_brand_id ;;
  }

  dimension: i_class_id {
    type: number
    value_format_name: id
    sql: ${TABLE}.i_class_id ;;
  }

  dimension: i_category_id {
    type: number
    value_format_name: id
    sql: ${TABLE}.i_category_id ;;
  }

  dimension: distinct_channel_count {
    type: number
    description: "Number of distinct sales channels ('store', 'catalog', 'web') selling this brand/class/category between 1999 and 2001."
    sql: ${TABLE}.distinct_channel_count ;;
  }

  dimension: is_cross_channel_item {
    type: yesno
    label: "Sold in All 3 Channels (1999-2001)"
    description: "True when the item taxonomy (brand_id, class_id, category_id) had sales in store, catalog, and web during 1999-2001."
    sql: ${distinct_channel_count} = 3 ;;
  }

  measure: count {
    type: count
    filters: [i_brand_id: "NOT NULL"]
    description: "Count of item taxonomy (brand, class, category) tuples active in 1999-2001."
  }
}
