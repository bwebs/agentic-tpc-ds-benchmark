include: "../../gold/explores/manufacturer_quarterly_sales_variance.explore.lkml"

test: manufacturer_quarterly_sales_variance_m1199_1210_m545_metrics {
  explore_source: manufacturer_quarterly_sales_variance {
    column: d_qoy { field: manufacturer_quarterly_sales_variance.d_qoy }
    column: sum_sales { field: manufacturer_quarterly_sales_variance.sum_sales }
    column: avg_quarterly_sales { field: manufacturer_quarterly_sales_variance.avg_quarterly_sales }
    column: count { field: manufacturer_quarterly_sales_variance.count }
    filters: {
      field: manufacturer_quarterly_sales_variance.month_seq_filter
      value: "[1199, 1210]"
    }
    filters: {
      field: manufacturer_quarterly_sales_variance.featured_brand_cohort_filter
      value: "Yes"
    }
    filters: {
      field: manufacturer_quarterly_sales_variance.is_above_10pct_quarterly_deviation
      value: "Yes"
    }
    filters: {
      field: manufacturer_quarterly_sales_variance.i_manufact_id
      value: "545"
    }
    sorts: [manufacturer_quarterly_sales_variance.d_qoy: asc]
  }
  assert: manufacturer_545_quarterly_variance_matches {
    expression: index(${manufacturer_quarterly_sales_variance.d_qoy}, 1) = 1
      AND round(index(${manufacturer_quarterly_sales_variance.sum_sales}, 1), 2) = 0
      AND round(index(${manufacturer_quarterly_sales_variance.avg_quarterly_sales}, 1), 4) = 89.935
      AND index(${manufacturer_quarterly_sales_variance.d_qoy}, 2) = 4
      AND round(index(${manufacturer_quarterly_sales_variance.sum_sales}, 2), 2) = 179.87
      AND round(index(${manufacturer_quarterly_sales_variance.avg_quarterly_sales}, 2), 4) = 89.935 ;;
  }
}
