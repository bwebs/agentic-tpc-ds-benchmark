include: "../../silver/explores/web_catalog_sales.explore.lkml"

test: web_catalog_sales_1998_w5115_metrics {
  explore_source: web_catalog_sales {
    column: total_sales_price { field: web_catalog_sales.total_sales_price }
    column: count { field: web_catalog_sales.count }
    column: sun_sales { field: date_dim_web_catalog_sales_fields.sun_sales }
    column: sat_sales { field: date_dim_web_catalog_sales_fields.sat_sales }
    filters: {
      field: date_dim.d_year_num
      value: "1998"
    }
    filters: {
      field: date_dim.d_week_seq
      value: "5115"
    }
  }
  assert: total_sales_price_matches {
    expression: round(${web_catalog_sales.total_sales_price}, 2) = 12911822.7 ;;
  }
  assert: row_count_matches {
    expression: ${web_catalog_sales.count} = 4920 ;;
  }
  assert: sun_sales_matches {
    expression: round(${date_dim_web_catalog_sales_fields.sun_sales}, 2) = 1607061.17 ;;
  }
  assert: sat_sales_matches {
    expression: round(${date_dim_web_catalog_sales_fields.sat_sales}, 2) = 2139368.98 ;;
  }
}
