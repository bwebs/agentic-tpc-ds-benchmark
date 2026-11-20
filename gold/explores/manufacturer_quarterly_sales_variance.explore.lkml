include: "/gold/manufacturer_quarterly_sales_variance.view.lkml"

explore: manufacturer_quarterly_sales_variance {
  view_name: manufacturer_quarterly_sales_variance
  label: "Manufacturer Quarterly Sales Variance"
  tags: ["gold"]

  always_filter: {
    filters: [
      manufacturer_quarterly_sales_variance.month_seq_filter: "[1199, 1210]",
      manufacturer_quarterly_sales_variance.featured_brand_cohort_filter: "Yes"
    ]
  }

  query: manufacturer_quarterly_sales_outliers_m1199_1210 {
    description: "Manufacturer quarterly store sales exceeding 10% deviation from the manufacturer's average quarterly sales across months 1199-1210 for featured brand cohorts"
    dimensions: [
      manufacturer_quarterly_sales_variance.i_manufact_id,
      manufacturer_quarterly_sales_variance.sum_sales,
      manufacturer_quarterly_sales_variance.avg_quarterly_sales,
      manufacturer_quarterly_sales_variance.pk
    ]
    filters: [
      manufacturer_quarterly_sales_variance.month_seq_filter: "[1199, 1210]",
      manufacturer_quarterly_sales_variance.featured_brand_cohort_filter: "Yes",
      manufacturer_quarterly_sales_variance.is_above_10pct_quarterly_deviation: "Yes"
    ]
    sorts: [
      manufacturer_quarterly_sales_variance.avg_quarterly_sales: asc,
      manufacturer_quarterly_sales_variance.sum_sales: asc,
      manufacturer_quarterly_sales_variance.i_manufact_id: asc
    ]
    limit: 100
  }
}
