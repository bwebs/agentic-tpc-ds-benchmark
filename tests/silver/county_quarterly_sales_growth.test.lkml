include: "../../gold/explores/county_quarterly_sales_growth.explore.lkml"

test: county_quarterly_sales_growth_2001_adair_county_metrics {
  explore_source: county_quarterly_sales_growth {
    column: count { field: county_quarterly_sales_growth.count }
    column: store_sales_q1 { field: county_quarterly_sales_growth.store_sales_q1 }
    column: store_sales_q2 { field: county_quarterly_sales_growth.store_sales_q2 }
    column: store_sales_q3 { field: county_quarterly_sales_growth.store_sales_q3 }
    column: web_sales_q1 { field: county_quarterly_sales_growth.web_sales_q1 }
    column: web_sales_q2 { field: county_quarterly_sales_growth.web_sales_q2 }
    column: web_sales_q3 { field: county_quarterly_sales_growth.web_sales_q3 }
    column: web_q1_q2_increase { field: county_quarterly_sales_growth.web_q1_q2_increase }
    column: store_q1_q2_increase { field: county_quarterly_sales_growth.store_q1_q2_increase }
    column: web_q2_q3_increase { field: county_quarterly_sales_growth.web_q2_q3_increase }
    column: store_q2_q3_increase { field: county_quarterly_sales_growth.store_q2_q3_increase }
    column: is_web_outgrowing_store_q1_to_q3 { field: county_quarterly_sales_growth.is_web_outgrowing_store_q1_to_q3 }
    filters: {
      field: county_quarterly_sales_growth.d_year
      value: "2001"
    }
    filters: {
      field: county_quarterly_sales_growth.ca_county
      value: "Adair County"
    }
  }
  assert: row_count_matches {
    expression: ${county_quarterly_sales_growth.count} = 1 ;;
  }
  assert: quarterly_sales_totals_match {
    expression: round(${county_quarterly_sales_growth.store_sales_q1}, 2) = 219316.84
      AND round(${county_quarterly_sales_growth.store_sales_q2}, 2) = 183992.63
      AND round(${county_quarterly_sales_growth.store_sales_q3}, 2) = 193025.34
      AND round(${county_quarterly_sales_growth.web_sales_q1}, 2) = 41486.77
      AND round(${county_quarterly_sales_growth.web_sales_q2}, 2) = 150595.61
      AND round(${county_quarterly_sales_growth.web_sales_q3}, 2) = 220447.80 ;;
  }
  assert: growth_ratios_and_flag_match {
    expression: round(${county_quarterly_sales_growth.web_q1_q2_increase}, 4) = 3.6300
      AND round(${county_quarterly_sales_growth.store_q1_q2_increase}, 4) = 0.8389
      AND round(${county_quarterly_sales_growth.web_q2_q3_increase}, 4) = 1.4638
      AND round(${county_quarterly_sales_growth.store_q2_q3_increase}, 4) = 1.0491
      AND ${county_quarterly_sales_growth.is_web_outgrowing_store_q1_to_q3} = yes ;;
  }
}
