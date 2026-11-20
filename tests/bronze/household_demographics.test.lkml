include: "../../silver/explores/store_sales.explore.lkml"

test: household_demographics_dep_to_vehicle_ratio_jan_2000_slice {
  explore_source: store_sales {
    column: is_dep_to_vehicle_ratio_over_1_2 { field: household_demographics.is_dep_to_vehicle_ratio_over_1_2 }
    column: count { field: store_sales.count }
    filters: {
      field: date_dim.d_year_num
      value: "2000"
    }
    filters: {
      field: date_dim.d_moy
      value: "1"
    }
    filters: {
      field: store_sales.ss_sold_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: date_dim.d_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_hdemo_sk
      value: "NOT NULL"
    }
    filters: {
      field: household_demographics.hd_demo_sk
      value: "NOT NULL"
    }
    sorts: [household_demographics.is_dep_to_vehicle_ratio_over_1_2: asc]
  }
  assert: ratio_over_1_2_counts_match {
    expression: index(${household_demographics.is_dep_to_vehicle_ratio_over_1_2}, 1) = no AND index(${store_sales.count}, 1) = 17725 AND index(${household_demographics.is_dep_to_vehicle_ratio_over_1_2}, 2) = yes AND index(${store_sales.count}, 2) = 13467 ;;
  }
}
