include: "../../silver/explores/inventory.explore.lkml"

test: inventory_apr_jun_2000_price_band_join_metrics {
  explore_source: inventory {
    column: count { field: inventory.count }
    column: inv_before { field: date_dim_inventory_fields.inv_before }
    column: inv_after { field: date_dim_inventory_fields.inv_after }
    column: inv_after_to_before_ratio { field: date_dim_inventory_fields.inv_after_to_before_ratio }
    filters: {
      field: item.i_current_price
      value: "[0.99, 1.49]"
    }
    filters: {
      field: date_dim.d_date
      value: "2000-04-13 to 2000-06-14"
    }
    filters: {
      field: inventory.inv_item_sk
      value: "NOT NULL"
    }
    filters: {
      field: item.i_item_sk
      value: "NOT NULL"
    }
    filters: {
      field: inventory.inv_warehouse_sk
      value: "NOT NULL"
    }
    filters: {
      field: warehouse.w_warehouse_sk
      value: "NOT NULL"
    }
    filters: {
      field: inventory.inv_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: date_dim.d_date_sk
      value: "NOT NULL"
    }
  }
  assert: inventory_join_count_matches {
    expression: ${inventory.count} = 25155 ;;
  }
  assert: inv_before_matches {
    expression: ${date_dim_inventory_fields.inv_before} = 6574026 ;;
  }
  assert: inv_after_matches {
    expression: ${date_dim_inventory_fields.inv_after} = 5255661 ;;
  }
  assert: inv_after_to_before_ratio_matches {
    expression: round(${date_dim_inventory_fields.inv_after_to_before_ratio}, 4) = 0.7995 ;;
  }
}
