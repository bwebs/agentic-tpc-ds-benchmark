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

test: inventory_month_seq_1205_1216_join_metrics {
  explore_source: inventory {
    column: count { field: inventory.count }
    column: average_quantity_on_hand { field: inventory.average_quantity_on_hand }
    filters: {
      field: date_dim.d_month_seq
      value: "[1205, 1216]"
    }
    filters: {
      field: inventory.inv_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: date_dim.d_date_sk
      value: "NOT NULL"
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
  }
  assert: inventory_join_count_matches {
    expression: ${inventory.count} = 2385000 ;;
  }
  assert: average_quantity_on_hand_matches {
    expression: round(${inventory.average_quantity_on_hand}, 2) = 500.27 ;;
  }
}

test: inventory_mar_may_1999_catalog_sold_join_metrics {
  explore_source: inventory {
    column: count { field: inventory.count }
    column: total_quantity_on_hand { field: inventory.total_quantity_on_hand }
    filters: {
      field: date_dim.d_date
      value: "1999-03-06 to 1999-05-07"
    }
    filters: {
      field: item.i_current_price
      value: "[20, 50]"
    }
    filters: {
      field: inventory.inv_quantity_on_hand
      value: "[100, 500]"
    }
    filters: {
      field: catalog_sold_items.has_catalog_sales
      value: "Yes"
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
      field: inventory.inv_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: date_dim.d_date_sk
      value: "NOT NULL"
    }
  }
  assert: inventory_catalog_sold_count_matches {
    expression: ${inventory.count} = 5296 ;;
  }
  assert: total_quantity_on_hand_matches {
    expression: ${inventory.total_quantity_on_hand} = 1578236 ;;
  }
}
