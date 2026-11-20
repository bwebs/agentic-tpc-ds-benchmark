include: "../../gold/explores/manager_monthly_sales_variance.explore.lkml"

test: manager_monthly_sales_variance_m1200_1211_mgr1_metrics {
  explore_source: manager_monthly_sales_variance {
    column: d_moy { field: manager_monthly_sales_variance.d_moy }
    column: sum_sales { field: manager_monthly_sales_variance.sum_sales }
    column: avg_monthly_sales { field: manager_monthly_sales_variance.avg_monthly_sales }
    column: count { field: manager_monthly_sales_variance.count }
    filters: {
      field: manager_monthly_sales_variance.month_seq_filter
      value: "[1200, 1211]"
    }
    filters: {
      field: manager_monthly_sales_variance.featured_brand_cohort_filter
      value: "Yes"
    }
    filters: {
      field: manager_monthly_sales_variance.is_above_10pct_monthly_deviation
      value: "Yes"
    }
    filters: {
      field: manager_monthly_sales_variance.i_manager_id
      value: "1"
    }
    sorts: [manager_monthly_sales_variance.d_moy: asc]
  }
  assert: manager_1_monthly_variance_matches {
    expression: index(${manager_monthly_sales_variance.d_moy}, 1) = 1
      AND round(index(${manager_monthly_sales_variance.sum_sales}, 1), 2) = 430.03
      AND round(index(${manager_monthly_sales_variance.avg_monthly_sales}, 1), 4) = 531.9192
      AND index(${manager_monthly_sales_variance.d_moy}, 2) = 2
      AND round(index(${manager_monthly_sales_variance.sum_sales}, 2), 2) = 189.04
      AND round(index(${manager_monthly_sales_variance.avg_monthly_sales}, 2), 4) = 531.9192 ;;
  }
}
