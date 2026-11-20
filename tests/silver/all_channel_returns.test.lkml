include: "../../silver/explores/all_channel_returns.explore.lkml"

test: all_channel_returns_weeks_5192_5200_5212_metrics {
  explore_source: all_channel_returns {
    column: count { field: all_channel_returns.count }
    column: distinct_channel_count { field: all_channel_returns.distinct_channel_count }
    column: sr_item_qty { field: all_channel_returns.sr_item_qty }
    column: cr_item_qty { field: all_channel_returns.cr_item_qty }
    column: wr_item_qty { field: all_channel_returns.wr_item_qty }
    column: sr_dev { field: all_channel_returns.sr_dev }
    column: cr_dev { field: all_channel_returns.cr_dev }
    column: wr_dev { field: all_channel_returns.wr_dev }
    column: average_channel_qty { field: all_channel_returns.average_channel_qty }
    filters: {
      field: date_dim.d_week_seq
      value: "5192, 5200, 5212"
    }
    filters: {
      field: item.i_item_sk
      value: "NOT NULL"
    }
  }
  assert: row_count_matches {
    expression: ${all_channel_returns.count} = 4451 ;;
  }
  assert: distinct_channel_count_matches {
    expression: ${all_channel_returns.distinct_channel_count} = 3 ;;
  }
  assert: sr_item_qty_matches {
    expression: ${all_channel_returns.sr_item_qty} = 60719 ;;
  }
  assert: cr_item_qty_matches {
    expression: ${all_channel_returns.cr_item_qty} = 34567 ;;
  }
  assert: wr_item_qty_matches {
    expression: ${all_channel_returns.wr_item_qty} = 17903 ;;
  }
  assert: sr_dev_matches {
    expression: round(${all_channel_returns.sr_dev}, 4) = 17.8813 ;;
  }
  assert: cr_dev_matches {
    expression: round(${all_channel_returns.cr_dev}, 4) = 10.1797 ;;
  }
  assert: wr_dev_matches {
    expression: round(${all_channel_returns.wr_dev}, 4) = 5.2723 ;;
  }
  assert: average_channel_qty_matches {
    expression: round(${all_channel_returns.average_channel_qty}, 4) = 37729.6667 ;;
  }
}
