include: "../../silver/explores/inventory.explore.lkml"

test: inventory_date_sk_2450815_metrics {
  explore_source: inventory {
    column: count { field: inventory.count }
    column: total_quantity_on_hand { field: inventory.total_quantity_on_hand }
    filters: {
      field: inventory.inv_date_sk
      value: "2450815"
    }
  }
  assert: inventory_count_matches {
    expression: ${inventory.count} = 45000 ;;
  }
  assert: total_quantity_on_hand_matches {
    expression: ${inventory.total_quantity_on_hand} = 21419217 ;;
  }
}

test: inventory_date_sk_2450815_average_qoh {
  explore_source: inventory {
    column: average_quantity_on_hand { field: inventory.average_quantity_on_hand }
    filters: {
      field: inventory.inv_date_sk
      value: "2450815"
    }
  }
  assert: average_quantity_on_hand_matches {
    expression: round(${inventory.average_quantity_on_hand}, 2) = 500.15 ;;
  }
}
