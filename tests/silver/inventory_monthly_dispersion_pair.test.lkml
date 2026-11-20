include: "../../gold/explores/inventory_monthly_dispersion_pair.explore.lkml"

test: inventory_monthly_dispersion_pair_2002_m1_metrics {
  explore_source: inventory_monthly_dispersion_pair {
    column: count { field: inventory_monthly_dispersion_pair.count }
    filters: {
      field: inventory_monthly_dispersion_pair.d_year
      value: "2002"
    }
    filters: {
      field: inventory_monthly_dispersion_pair.d_moy
      value: "1"
    }
  }
  assert: jan_feb_2002_pair_count_matches {
    expression: ${inventory_monthly_dispersion_pair.count} = 140 ;;
  }
}

test: inventory_monthly_dispersion_pair_2002_m1_w1_i709 {
  explore_source: inventory_monthly_dispersion_pair {
    column: d_moy_2 { field: inventory_monthly_dispersion_pair.d_moy_2 }
    column: mean { field: inventory_monthly_dispersion_pair.mean }
    column: cov { field: inventory_monthly_dispersion_pair.cov }
    column: mean_2 { field: inventory_monthly_dispersion_pair.mean_2 }
    column: cov_2 { field: inventory_monthly_dispersion_pair.cov_2 }
    column: count { field: inventory_monthly_dispersion_pair.count }
    filters: {
      field: inventory_monthly_dispersion_pair.d_year
      value: "2002"
    }
    filters: {
      field: inventory_monthly_dispersion_pair.d_moy
      value: "1"
    }
    filters: {
      field: inventory_monthly_dispersion_pair.w_warehouse_sk
      value: "1"
    }
    filters: {
      field: inventory_monthly_dispersion_pair.i_item_sk
      value: "709"
    }
  }
  assert: consecutive_month_dispersion_values_match {
    expression: ${inventory_monthly_dispersion_pair.count} = 1
      AND ${inventory_monthly_dispersion_pair.d_moy_2} = 2
      AND round(${inventory_monthly_dispersion_pair.mean}, 2) = 319.60
      AND round(${inventory_monthly_dispersion_pair.cov}, 4) = 1.1268
      AND round(${inventory_monthly_dispersion_pair.mean_2}, 2) = 218.50
      AND round(${inventory_monthly_dispersion_pair.cov_2}, 4) = 1.1371 ;;
  }
}
