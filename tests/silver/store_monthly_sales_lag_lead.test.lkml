include: "../../gold/explores/store_monthly_sales_lag_lead.explore.lkml"

test: store_monthly_sales_lag_lead_1999_m3_men_ese_metrics {
  explore_source: store_monthly_sales_lag_lead {
    column: i_brand { field: store_monthly_sales_lag_lead.i_brand }
    column: avg_monthly_sales { field: store_monthly_sales_lag_lead.avg_monthly_sales }
    column: sum_sales { field: store_monthly_sales_lag_lead.sum_sales }
    column: psum { field: store_monthly_sales_lag_lead.psum }
    column: nsum { field: store_monthly_sales_lag_lead.nsum }
    column: sales_vs_avg_diff { field: store_monthly_sales_lag_lead.sales_vs_avg_diff }
    column: count { field: store_monthly_sales_lag_lead.count }
    filters: {
      field: store_monthly_sales_lag_lead.target_year
      value: "1999"
    }
    filters: {
      field: store_monthly_sales_lag_lead.d_year
      value: "1999"
    }
    filters: {
      field: store_monthly_sales_lag_lead.d_moy
      value: "3"
    }
    filters: {
      field: store_monthly_sales_lag_lead.i_category
      value: "Men"
    }
    filters: {
      field: store_monthly_sales_lag_lead.s_store_name
      value: "ese"
    }
    filters: {
      field: store_monthly_sales_lag_lead.s_company_name
      value: "Unknown"
    }
    filters: {
      field: store_monthly_sales_lag_lead.is_above_10pct_deviation
      value: "Yes"
    }
    sorts: [store_monthly_sales_lag_lead.sales_vs_avg_diff: asc]
  }
  assert: top_negative_deviation_row_matches {
    expression: ${store_monthly_sales_lag_lead.count} >= 1
      AND index(${store_monthly_sales_lag_lead.i_brand}, 1) = "importoimporto #1"
      AND round(index(${store_monthly_sales_lag_lead.avg_monthly_sales}, 1), 4) = 5492.8175
      AND round(index(${store_monthly_sales_lag_lead.sum_sales}, 1), 2) = 2070.65
      AND round(index(${store_monthly_sales_lag_lead.psum}, 1), 2) = 3307.78
      AND round(index(${store_monthly_sales_lag_lead.nsum}, 1), 2) = 2784.11
      AND round(index(${store_monthly_sales_lag_lead.sales_vs_avg_diff}, 1), 4) = -3422.1675 ;;
  }
}
