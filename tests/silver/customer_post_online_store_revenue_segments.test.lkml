include: "../../gold/explores/customer_post_online_store_revenue_segments.explore.lkml"

test: customer_post_online_store_revenue_segments_oct_1998_children_toddlers_metrics {
  explore_source: customer_post_online_store_revenue_segments {
    column: segment { field: customer_post_online_store_revenue_segments.segment }
    column: segment_base { field: customer_post_online_store_revenue_segments.segment_base }
    column: num_customers { field: customer_post_online_store_revenue_segments.num_customers }
    filters: {
      field: customer_post_online_store_revenue_segments.cohort_year_filter
      value: "1998"
    }
    filters: {
      field: customer_post_online_store_revenue_segments.cohort_month_filter
      value: "10"
    }
    filters: {
      field: customer_post_online_store_revenue_segments.category_filter
      value: "Children"
    }
    filters: {
      field: customer_post_online_store_revenue_segments.class_filter
      value: "toddlers"
    }
    sorts: [customer_post_online_store_revenue_segments.segment: asc]
  }
  assert: row_1_segment_matches {
    expression: index(${customer_post_online_store_revenue_segments.segment}, 1) = 5381 AND index(${customer_post_online_store_revenue_segments.segment_base}, 1) = 269050 AND index(${customer_post_online_store_revenue_segments.num_customers}, 1) = 1 ;;
  }
  assert: row_2_segment_matches {
    expression: index(${customer_post_online_store_revenue_segments.segment}, 2) = 5682 AND index(${customer_post_online_store_revenue_segments.segment_base}, 2) = 284100 AND index(${customer_post_online_store_revenue_segments.num_customers}, 2) = 1 ;;
  }
}
