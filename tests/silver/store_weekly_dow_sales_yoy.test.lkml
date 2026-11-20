include: "../../gold/explores/store_weekly_dow_sales_yoy.explore.lkml"

test: store_weekly_dow_sales_yoy_able_5202_metrics {
  explore_source: store_weekly_dow_sales_yoy {
    column: s_store_name1 { field: store_weekly_dow_sales_yoy.s_store_name1 }
    column: s_store_id1 { field: store_weekly_dow_sales_yoy.s_store_id1 }
    column: d_week_seq1 { field: store_weekly_dow_sales_yoy.d_week_seq1 }
    column: sun_sales_ratio { field: store_weekly_dow_sales_yoy.sun_sales_ratio }
    column: mon_sales_ratio { field: store_weekly_dow_sales_yoy.mon_sales_ratio }
    column: tue_sales_ratio { field: store_weekly_dow_sales_yoy.tue_sales_ratio }
    column: wed_sales_ratio { field: store_weekly_dow_sales_yoy.wed_sales_ratio }
    column: thu_sales_ratio { field: store_weekly_dow_sales_yoy.thu_sales_ratio }
    column: fri_sales_ratio { field: store_weekly_dow_sales_yoy.fri_sales_ratio }
    column: sat_sales_ratio { field: store_weekly_dow_sales_yoy.sat_sales_ratio }
    column: count { field: store_weekly_dow_sales_yoy.count }
    filters: {
      field: store_weekly_dow_sales_yoy.start_month_seq
      value: "1196"
    }
    filters: {
      field: store_weekly_dow_sales_yoy.s_store_id1
      value: "AAAAAAAACAAAAAAA"
    }
    filters: {
      field: store_weekly_dow_sales_yoy.d_week_seq1
      value: "5202"
    }
  }
  assert: able_week_5202_yoy_ratios_and_49_day_multiplicity_match {
    expression: ${store_weekly_dow_sales_yoy.s_store_name1} = "able"
      AND ${store_weekly_dow_sales_yoy.count} = 49
      AND round(${store_weekly_dow_sales_yoy.sun_sales_ratio}, 4) = 1.3913
      AND round(${store_weekly_dow_sales_yoy.mon_sales_ratio}, 4) = 0.7987
      AND round(${store_weekly_dow_sales_yoy.tue_sales_ratio}, 4) = 1.0769
      AND round(${store_weekly_dow_sales_yoy.wed_sales_ratio}, 4) = 1.2795
      AND round(${store_weekly_dow_sales_yoy.thu_sales_ratio}, 4) = 1.2145
      AND round(${store_weekly_dow_sales_yoy.fri_sales_ratio}, 4) = 0.8921
      AND round(${store_weekly_dow_sales_yoy.sat_sales_ratio}, 4) = 0.9623 ;;
  }
}
