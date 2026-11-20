include: "/gold/inventory_monthly_dispersion_pair.view.lkml"
include: "/bronze/inventory.view.lkml"
include: "/bronze/inventory.refinement.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/warehouse.view.lkml"
include: "/bronze/warehouse.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

explore: inventory_monthly_dispersion_pair {
  view_name: inventory_monthly_dispersion_pair
  label: "Inventory Monthly Dispersion Pair"
  tags: ["gold"]

  join: warehouse {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory_monthly_dispersion_pair.w_warehouse_sk} = ${warehouse.w_warehouse_sk} ;;
  }

  join: item {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory_monthly_dispersion_pair.i_item_sk} = ${item.i_item_sk} ;;
  }

  join: _sdt_inv {
    from: inventory
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_i {
    from: item
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_w {
    from: warehouse
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: _sdt_d {
    from: date_dim
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  query: jan_feb_2002_high_dispersion_inventory_pairs {
    description: "Warehouse-item pairs in January and February 2002 where monthly inventory quantity on hand coefficient of variation exceeds 1 in both consecutive months"
    dimensions: [
      inventory_monthly_dispersion_pair.w_warehouse_sk,
      inventory_monthly_dispersion_pair.i_item_sk,
      inventory_monthly_dispersion_pair.d_moy,
      inventory_monthly_dispersion_pair.mean,
      inventory_monthly_dispersion_pair.cov,
      inventory_monthly_dispersion_pair.d_moy_2,
      inventory_monthly_dispersion_pair.mean_2,
      inventory_monthly_dispersion_pair.cov_2
    ]
    filters: [
      inventory_monthly_dispersion_pair.d_year: "2002",
      inventory_monthly_dispersion_pair.d_moy: "1"
    ]
    sorts: [
      inventory_monthly_dispersion_pair.w_warehouse_sk: asc,
      inventory_monthly_dispersion_pair.i_item_sk: asc,
      inventory_monthly_dispersion_pair.d_moy: asc,
      inventory_monthly_dispersion_pair.mean: asc,
      inventory_monthly_dispersion_pair.cov: asc,
      inventory_monthly_dispersion_pair.d_moy_2: asc,
      inventory_monthly_dispersion_pair.mean_2: asc,
      inventory_monthly_dispersion_pair.cov_2: asc
    ]
    limit: 500
  }
}
