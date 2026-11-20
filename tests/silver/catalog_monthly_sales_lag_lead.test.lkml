include: "../../gold/explores/catalog_monthly_sales_lag_lead.explore.lkml"

test: catalog_monthly_sales_lag_lead_2000_m2_music_north_midwest_metrics {
  explore_source: catalog_monthly_sales_lag_lead {
    column: i_brand { field: catalog_monthly_sales_lag_lead.i_brand }
    column: avg_monthly_sales { field: catalog_monthly_sales_lag_lead.avg_monthly_sales }
    column: sum_sales { field: catalog_monthly_sales_lag_lead.sum_sales }
    column: psum { field: catalog_monthly_sales_lag_lead.psum }
    column: nsum { field: catalog_monthly_sales_lag_lead.nsum }
    column: sales_vs_avg_diff { field: catalog_monthly_sales_lag_lead.sales_vs_avg_diff }
    column: count { field: catalog_monthly_sales_lag_lead.count }
    filters: {
      field: catalog_monthly_sales_lag_lead.target_year
      value: "2000"
    }
    filters: {
      field: catalog_monthly_sales_lag_lead.d_year
      value: "2000"
    }
    filters: {
      field: catalog_monthly_sales_lag_lead.d_moy
      value: "2"
    }
    filters: {
      field: catalog_monthly_sales_lag_lead.i_category
      value: "Music"
    }
    filters: {
      field: catalog_monthly_sales_lag_lead.cc_name
      value: "North Midwest"
    }
    filters: {
      field: catalog_monthly_sales_lag_lead.is_above_10pct_deviation
      value: "Yes"
    }
    sorts: [catalog_monthly_sales_lag_lead.sales_vs_avg_diff: asc]
  }
  assert: top_negative_deviation_row_matches {
    expression: ${catalog_monthly_sales_lag_lead.count} >= 1
      AND index(${catalog_monthly_sales_lag_lead.i_brand}, 1) = "exportischolar #2"
      AND round(index(${catalog_monthly_sales_lag_lead.avg_monthly_sales}, 1), 4) = 7201.0933
      AND round(index(${catalog_monthly_sales_lag_lead.sum_sales}, 1), 2) = 2787.29
      AND round(index(${catalog_monthly_sales_lag_lead.psum}, 1), 2) = 3877.25
      AND round(index(${catalog_monthly_sales_lag_lead.nsum}, 1), 2) = 4135.16
      AND round(index(${catalog_monthly_sales_lag_lead.sales_vs_avg_diff}, 1), 4) = -4413.8033 ;;
  }
}
