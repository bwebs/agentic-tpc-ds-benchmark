view: item_item_category_price_facts_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${item.i_item_sk} ;;
  }

  dimension: is_above_120pct_category_avg_price {
    type: yesno
    label: "Above 120% Category Avg Price"
    description: "True when item current price strictly exceeds 1.2x the average current price of its item category."
    sql: ${item.i_current_price} > 1.2 * ${item_category_price_facts.avg_current_price} ;;
  }
}
