include: "../../gold/explores/store_return_catalog_repurchase.explore.lkml"

test: store_return_catalog_repurchase_2000_dispersion_metrics {
  explore_source: store_return_catalog_repurchase {
    column: count { field: store_return_catalog_repurchase.count }
    column: store_sales_quantity_count { field: store_return_catalog_repurchase.store_sales_quantity_count }
    column: average_store_sales_quantity { field: store_return_catalog_repurchase.average_store_sales_quantity }
    column: stddev_store_sales_quantity { field: store_return_catalog_repurchase.stddev_store_sales_quantity }
    column: cov_store_sales_quantity { field: store_return_catalog_repurchase.cov_store_sales_quantity }
    column: store_returns_quantity_count { field: store_return_catalog_repurchase.store_returns_quantity_count }
    column: average_store_returns_quantity { field: store_return_catalog_repurchase.average_store_returns_quantity }
    column: stddev_store_returns_quantity { field: store_return_catalog_repurchase.stddev_store_returns_quantity }
    column: cov_store_returns_quantity { field: store_return_catalog_repurchase.cov_store_returns_quantity }
    column: catalog_sales_quantity_count { field: store_return_catalog_repurchase.catalog_sales_quantity_count }
    column: average_catalog_sales_quantity { field: store_return_catalog_repurchase.average_catalog_sales_quantity }
    column: stddev_catalog_sales_quantity { field: store_return_catalog_repurchase.stddev_catalog_sales_quantity }
    column: cov_catalog_sales_quantity { field: store_return_catalog_repurchase.cov_catalog_sales_quantity }
    filters: {
      field: d1.d_year_num
      value: "2000"
    }
    filters: {
      field: store.s_store_sk
      value: "NOT NULL"
    }
    filters: {
      field: item.i_item_sk
      value: "NOT NULL"
    }
  }
  assert: pair_count_matches {
    expression: ${store_return_catalog_repurchase.count} = 42 ;;
  }
  assert: store_sales_dispersion_matches {
    expression: ${store_return_catalog_repurchase.store_sales_quantity_count} = 42
      AND round(${store_return_catalog_repurchase.average_store_sales_quantity}, 4) = 50.2857
      AND round(${store_return_catalog_repurchase.stddev_store_sales_quantity}, 4) = 28.3069
      AND round(${store_return_catalog_repurchase.cov_store_sales_quantity}, 4) = 0.5629 ;;
  }
  assert: store_returns_dispersion_matches {
    expression: ${store_return_catalog_repurchase.store_returns_quantity_count} = 41
      AND round(${store_return_catalog_repurchase.average_store_returns_quantity}, 4) = 22.8537
      AND round(${store_return_catalog_repurchase.stddev_store_returns_quantity}, 4) = 20.6465
      AND round(${store_return_catalog_repurchase.cov_store_returns_quantity}, 4) = 0.9034 ;;
  }
  assert: catalog_sales_dispersion_matches {
    expression: ${store_return_catalog_repurchase.catalog_sales_quantity_count} = 42
      AND round(${store_return_catalog_repurchase.average_catalog_sales_quantity}, 4) = 52.0238
      AND round(${store_return_catalog_repurchase.stddev_catalog_sales_quantity}, 4) = 29.0126
      AND round(${store_return_catalog_repurchase.cov_catalog_sales_quantity}, 4) = 0.5577 ;;
  }
}
