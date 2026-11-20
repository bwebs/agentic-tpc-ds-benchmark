include: "../../gold/explores/catalog_sales_excess_discount.explore.lkml"

test: catalog_sales_excess_discount_manufact_610_spring_2001_metrics {
  explore_source: catalog_sales_excess_discount {
    column: total_ext_discount_amt { field: catalog_sales.total_ext_discount_amt }
    column: count { field: catalog_sales.count }
    filters: [
      item.i_manufact_id: "610",
      date_dim.d_date: "2001-03-04 to 2001-06-04",
      catalog_item_avg_discount_catalog_sales_fields.is_excess_discount: "Yes",
      catalog_sales.cs_item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      catalog_sales.cs_sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL"
    ]
  }
  assert: total_ext_discount_amt_matches {
    expression: round(${catalog_sales.total_ext_discount_amt}, 2) = 88535.2 ;;
  }
  assert: count_matches {
    expression: ${catalog_sales.count} = 15 ;;
  }
}
