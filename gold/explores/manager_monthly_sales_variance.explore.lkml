include: "/gold/manager_monthly_sales_variance.view.lkml"

explore: manager_monthly_sales_variance {
  view_name: manager_monthly_sales_variance
  label: "Manager Monthly Sales Variance"
  tags: ["gold"]

  always_filter: {
    filters: [
      manager_monthly_sales_variance.month_seq_filter: "[1200, 1211]",
      manager_monthly_sales_variance.featured_brand_cohort_filter: "Yes"
    ]
  }

  query: manager_monthly_sales_outliers_m1200_1211 {
    description: "Manager monthly store sales exceeding 10% deviation from the manager's average monthly sales across months 1200-1211 for featured brand cohorts"
    dimensions: [
      manager_monthly_sales_variance.i_manager_id,
      manager_monthly_sales_variance.sum_sales,
      manager_monthly_sales_variance.avg_monthly_sales,
      manager_monthly_sales_variance.pk
    ]
    filters: [
      manager_monthly_sales_variance.month_seq_filter: "[1200, 1211]",
      manager_monthly_sales_variance.featured_brand_cohort_filter: "Yes",
      manager_monthly_sales_variance.is_above_10pct_monthly_deviation: "Yes"
    ]
    sorts: [
      manager_monthly_sales_variance.i_manager_id: asc,
      manager_monthly_sales_variance.avg_monthly_sales: asc,
      manager_monthly_sales_variance.sum_sales: asc
    ]
    limit: 100
  }
}
