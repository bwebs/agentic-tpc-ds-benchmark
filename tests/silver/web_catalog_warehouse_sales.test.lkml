include: "../../gold/explores/web_catalog_warehouse_sales.explore.lkml"

test: web_catalog_warehouse_sales_1998_w1_zouros_zhou_metrics {
  explore_source: web_catalog_warehouse_sales {
    column: jan_sales { field: web_catalog_warehouse_sales.jan_sales }
    column: jan_sales_per_sq_foot { field: web_catalog_warehouse_sales.jan_sales_per_sq_foot }
    column: jan_net { field: web_catalog_warehouse_sales.jan_net }
    column: dec_sales { field: web_catalog_warehouse_sales.dec_sales }
    column: dec_net { field: web_catalog_warehouse_sales.dec_net }
    column: count { field: web_catalog_warehouse_sales.count }
    filters: {
      field: date_dim.d_year_num
      value: "1998"
    }
    filters: {
      field: time_dim.t_time
      value: "[7249, 36049]"
    }
    filters: {
      field: ship_mode.sm_carrier
      value: "ZOUROS,ZHOU"
    }
    filters: {
      field: warehouse.w_warehouse_sk
      value: "1"
    }
  }
  assert: jan_sales_matches {
    expression: round(${web_catalog_warehouse_sales.jan_sales}, 2) = 19999839.24 ;;
  }
  assert: jan_sales_per_sq_foot_matches {
    expression: round(${web_catalog_warehouse_sales.jan_sales_per_sq_foot}, 4) = 20.4542 ;;
  }
  assert: jan_net_matches {
    expression: round(${web_catalog_warehouse_sales.jan_net}, 2) = 21857524.94 ;;
  }
  assert: dec_sales_matches {
    expression: round(${web_catalog_warehouse_sales.dec_sales}, 2) = 64427886.38 ;;
  }
  assert: dec_net_matches {
    expression: round(${web_catalog_warehouse_sales.dec_net}, 2) = 73221304.77 ;;
  }
  assert: row_count_matches {
    expression: ${web_catalog_warehouse_sales.count} = 2156 ;;
  }
}
