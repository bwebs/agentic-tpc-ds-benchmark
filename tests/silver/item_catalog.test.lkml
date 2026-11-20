include: "../../silver/explores/item_catalog.explore.lkml"

test: item_catalog_manufact_700_900_cohort_metrics {
  explore_source: item_catalog {
    column: has_apparel_spec_match { field: item_manufact_apparel_cohort.has_apparel_spec_match }
    column: item_count { field: item.count }
    column: cohort_manufact_count { field: item_manufact_apparel_cohort.count }
    filters: {
      field: item.i_manufact_id
      value: "[700, 900]"
    }
    sorts: [item_manufact_apparel_cohort.has_apparel_spec_match: asc]
  }
  assert: non_cohort_slice_matches {
    expression: index(${item_manufact_apparel_cohort.has_apparel_spec_match}, 1) = no AND index(${item.count}, 1) = 1135 AND index(${item_manufact_apparel_cohort.count}, 1) = 0 ;;
  }
  assert: cohort_slice_matches {
    expression: index(${item_manufact_apparel_cohort.has_apparel_spec_match}, 2) = yes AND index(${item.count}, 2) = 2 AND index(${item_manufact_apparel_cohort.count}, 2) = 1 ;;
  }
}
