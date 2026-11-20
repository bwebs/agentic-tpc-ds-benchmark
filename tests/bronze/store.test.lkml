include: "../../silver/explores/store_sales.explore.lkml"

test: store_zip_5_prefix_slice {
  explore_source: store_sales {
    column: s_zip_5 { field: store.s_zip_5 }
    column: count { field: store.count }
    filters: {
      field: store.s_store_sk
      value: "<=10"
    }
    sorts: [store.s_zip_5: asc]
  }
  assert: first_store_zip_5_matches {
    expression: index(${store.s_zip_5}, 1) = "31904" AND index(${store.count}, 1) = 5 ;;
  }
}
