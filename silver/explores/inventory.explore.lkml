include: "/bronze/explores/inventory_base.explore.lkml"
include: "/bronze/warehouse.view.lkml"
include: "/bronze/warehouse.refinement.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/silver/catalog_sold_items.view.lkml"
include: "/silver/date_dim_inventory_fields.view.lkml"

explore: inventory {
  extends: [inventory_base]
  hidden: no
  label: "Inventory"
  view_name: inventory

  join: warehouse {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory.inv_warehouse_sk} = ${warehouse.w_warehouse_sk} ;;
  }

  join: item {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory.inv_item_sk} = ${item.i_item_sk} ;;
  }

  join: date_dim {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory.inv_date_sk} = ${date_dim.d_date_sk} ;;
  }

  join: catalog_sold_items {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory.inv_item_sk} = ${catalog_sold_items.cs_item_sk} ;;
  }

  join: date_dim_inventory_fields {
    sql: ;;
    relationship: one_to_one
  }

  query: catalog_sold_items_mar_may_1999_by_item {
    description: "Catalog-sold items priced $20-$50 from manufacturers 843, 815, 850, and 840 with inventory quantity on hand 100-500 between 1999-03-06 and 1999-05-06"
    dimensions: [
      item.i_item_id,
      item.i_item_desc,
      item.i_current_price
    ]
    filters: [
      item.i_current_price: "[20, 50]",
      date_dim.d_date: "1999-03-06 to 1999-05-07",
      item.i_manufact_id: "843, 815, 850, 840",
      inventory.inv_quantity_on_hand: "[100, 500]",
      catalog_sold_items.has_catalog_sales: "Yes",
      inventory.inv_item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      inventory.inv_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL"
    ]
    sorts: [item.i_item_id: asc]
    limit: 100
  }

  query: inventory_before_after_2000_05_13_by_warehouse_and_item {
    description: "Inventory quantity before and on/after 2000-05-13 (2000-04-13 through 2000-06-13) by warehouse name and item ID for items priced $0.99-$1.49 with after/before ratio between 2/3 and 3/2"
    dimensions: [
      warehouse.w_warehouse_name,
      item.i_item_id
    ]
    measures: [
      date_dim_inventory_fields.inv_before,
      date_dim_inventory_fields.inv_after
    ]
    filters: [
      item.i_current_price: "[0.99, 1.49]",
      date_dim.d_date: "2000-04-13 to 2000-06-14",
      date_dim_inventory_fields.is_inv_ratio_within_two_thirds_to_three_halves: "Yes",
      inventory.inv_item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      inventory.inv_warehouse_sk: "NOT NULL",
      warehouse.w_warehouse_sk: "NOT NULL",
      inventory.inv_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL"
    ]
    sorts: [
      warehouse.w_warehouse_name: asc,
      item.i_item_id: asc
    ]
    limit: 100
  }

  query: average_qoh_by_item_hierarchy_month_seq_1205_1216 {
    description: "Average quantity on hand by item product name, brand, class, and category for month sequence 1205 through 1216"
    dimensions: [
      item.i_product_name,
      item.i_brand,
      item.i_class,
      item.i_category
    ]
    measures: [
      inventory.average_quantity_on_hand
    ]
    filters: [
      date_dim.d_month_seq: "[1205, 1216]",
      inventory.inv_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      inventory.inv_item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      inventory.inv_warehouse_sk: "NOT NULL",
      warehouse.w_warehouse_sk: "NOT NULL"
    ]
    sorts: [
      inventory.average_quantity_on_hand: asc,
      item.i_product_name: asc,
      item.i_brand: asc,
      item.i_class: asc,
      item.i_category: asc
    ]
    limit: 100
  }
}
