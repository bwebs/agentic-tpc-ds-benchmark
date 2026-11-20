include: "../../silver/explores/weekly_web_catalog_sales_facts.explore.lkml"

test: weekly_web_catalog_sales_facts_w5115_metrics {
  explore_source: weekly_web_catalog_sales_facts {
    column: total_sun_sales { field: weekly_web_catalog_sales_facts.total_sun_sales }
    column: week_count { field: weekly_web_catalog_sales_facts.count }
    column: date_count { field: date_dim.count }
    filters: {
      field: weekly_web_catalog_sales_facts.d_week_seq
      value: "5115"
    }
    filters: {
      field: date_dim.d_year_num
      value: "1998"
    }
  }
  assert: symmetric_sunday_sales_matches {
    expression: round(${weekly_web_catalog_sales_facts.total_sun_sales}, 2) = 1607061.17 ;;
  }
  assert: week_count_matches {
    expression: ${weekly_web_catalog_sales_facts.count} = 1 ;;
  }
  assert: date_fanout_count_matches {
    expression: ${date_dim.count} = 7 ;;
  }
}
