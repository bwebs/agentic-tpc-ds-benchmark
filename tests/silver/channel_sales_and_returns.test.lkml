include: "../../silver/explores/channel_sales_and_returns.explore.lkml"

test: channel_sales_and_returns_aug_sep_2002_metrics {
  explore_source: channel_sales_and_returns {
    column: channel { field: channel_sales_and_returns.channel }
    column: total_sales { field: channel_sales_and_returns.total_sales }
    column: total_returns { field: channel_sales_and_returns.total_returns }
    column: total_net_profit { field: channel_sales_and_returns.total_net_profit }
    column: count { field: channel_sales_and_returns.count }
    filters: {
      field: date_dim.d_date
      value: "2002-08-22 to 2002-09-06"
    }
    filters: {
      field: catalog_page_channel_sales_and_returns_store_web_site_fields.channel_entity_id
      value: "-NULL"
    }
    sorts: [channel_sales_and_returns.channel: asc]
  }
  assert: catalog_channel_metrics_match {
    expression: index(${channel_sales_and_returns.channel}, 1) = "catalog channel"
      AND round(index(${channel_sales_and_returns.total_sales}, 1), 2) = 39228064.07
      AND round(index(${channel_sales_and_returns.total_returns}, 1), 2) = 997711.81
      AND round(index(${channel_sales_and_returns.total_net_profit}, 1), 2) = -4497777.04
      AND index(${channel_sales_and_returns.count}, 1) = 16023 ;;
  }
  assert: store_channel_metrics_match {
    expression: index(${channel_sales_and_returns.channel}, 2) = "store channel"
      AND round(index(${channel_sales_and_returns.total_sales}, 2), 2) = 54608295.87
      AND round(index(${channel_sales_and_returns.total_returns}, 2), 2) = 1445772.63
      AND round(index(${channel_sales_and_returns.total_net_profit}, 2), 2) = -23949425.61
      AND index(${channel_sales_and_returns.count}, 2) = 30368 ;;
  }
  assert: web_channel_metrics_match {
    expression: index(${channel_sales_and_returns.channel}, 3) = "web channel"
      AND round(index(${channel_sales_and_returns.total_sales}, 3), 2) = 19425054.50
      AND round(index(${channel_sales_and_returns.total_returns}, 3), 2) = 594011.14
      AND round(index(${channel_sales_and_returns.total_net_profit}, 3), 2) = -2222153.30
      AND index(${channel_sales_and_returns.count}, 3) = 8075 ;;
  }
}
