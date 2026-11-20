include: "../../silver/explores/weekly_web_catalog_sales_facts.explore.lkml"

test: weekly_web_catalog_sales_facts_w5115_metrics {
  explore_source: weekly_web_catalog_sales_facts {
    column: total_sun_sales { field: weekly_web_catalog_sales_facts.total_sun_sales }
    column: total_sat_sales { field: weekly_web_catalog_sales_facts.total_sat_sales }
    column: count { field: weekly_web_catalog_sales_facts.count }
    filters: {
      field: weekly_web_catalog_sales_facts.d_week_seq
      value: "5115"
    }
  }
  assert: total_sun_sales_matches {
    expression: round(${weekly_web_catalog_sales_facts.total_sun_sales}, 2) = 1607061.17 ;;
  }
  assert: total_sat_sales_matches {
    expression: round(${weekly_web_catalog_sales_facts.total_sat_sales}, 2) = 2139368.98 ;;
  }
  assert: week_row_count_matches {
    expression: ${weekly_web_catalog_sales_facts.count} = 1 ;;
  }
}
