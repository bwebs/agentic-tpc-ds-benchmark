include: "../../gold/explores/web_sales_excess_discount.explore.lkml"

test: web_sales_excess_discount_manufact_718_spring_2002_metrics {
  explore_source: web_sales_excess_discount {
    column: total_ext_discount_amt { field: web_sales.total_ext_discount_amt }
    column: count { field: web_sales.count }
    filters: [
      item.i_manufact_id: "718",
      date_dim.d_date: "2002-03-29 to 2002-06-29",
      web_item_avg_discount_web_sales_fields.is_excess_discount: "Yes",
      web_sales.ws_item_sk: "NOT NULL",
      item.i_item_sk: "NOT NULL",
      web_sales.ws_sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL"
    ]
  }
  assert: total_ext_discount_amt_matches {
    expression: round(${web_sales.total_ext_discount_amt}, 2) = 13924.27 ;;
  }
  assert: count_matches {
    expression: ${web_sales.count} = 2 ;;
  }
}
