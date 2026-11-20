include: "store_sales.view.lkml"

view: +store_sales {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${ss_item_sk} AS STRING), '_', CAST(${ss_ticket_number} AS STRING)) ;;
  }

  dimension: ss_sold_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ss_sold_date_sk ;;
  }

  dimension: ss_item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ss_item_sk ;;
  }

  dimension: ss_customer_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ss_customer_sk ;;
  }

  dimension: ss_cdemo_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ss_cdemo_sk ;;
  }

  dimension: ss_promo_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ss_promo_sk ;;
  }

  dimension: ss_store_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ss_store_sk ;;
  }

  dimension: ss_hdemo_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ss_hdemo_sk ;;
  }

  dimension: ss_addr_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ss_addr_sk ;;
  }

  measure: count {
    description: "Count of store sales line items."
  }

  measure: average_ext_sales_price {
    type: average
    sql: ${ss_ext_sales_price} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Average extended sales price per store sales line item (AVG(ss_ext_sales_price))."
  }

  measure: total_ext_sales_price {
    type: sum
    sql: ${ss_ext_sales_price} ;;
    value_format_name: usd
    description: "Sum of extended sales price across store sales line items (SUM(ss_ext_sales_price))."
    synonyms: ["ext_price", "extended sales price"]
  }

  measure: average_ext_wholesale_cost {
    type: average
    sql: ${ss_ext_wholesale_cost} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Average extended wholesale cost per store sales line item (AVG(ss_ext_wholesale_cost))."
  }

  measure: total_ext_wholesale_cost {
    type: sum
    sql: ${ss_ext_wholesale_cost} ;;
    value_format_name: usd
    description: "Sum of extended wholesale cost across store sales line items (SUM(ss_ext_wholesale_cost))."
  }

  measure: total_net_profit {
    type: sum
    sql: ${ss_net_profit} ;;
    value_format_name: usd
    description: "Sum of net profit across store sales line items (SUM(ss_net_profit))."
    synonyms: ["net profit"]
  }

  measure: total_extended_discount_amount {
    type: sum
    sql: ${ss_ext_discount_amt} ;;
    value_format_name: usd
    description: "Sum of extended discount amount across store sales (ss_ext_discount_amt)."
    synonyms: ["sum_agg", "extended discount amount"]
  }

  measure: average_quantity {
    type: average
    sql: ${ss_quantity} ;;
    value_format_name: decimal_2
    tags: ["non_additive"]
    description: "Average quantity per store sales line item (AVG(ss_quantity))."
  }

  measure: average_list_price {
    type: average
    sql: ${ss_list_price} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Average list price per store sales line item (AVG(ss_list_price))."
  }

  measure: average_coupon_amount {
    type: average
    sql: ${ss_coupon_amt} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Average coupon discount amount per store sales line item (AVG(ss_coupon_amt))."
  }

  measure: average_sales_price {
    type: average
    sql: ${ss_sales_price} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Average sales price per store sales line item (AVG(ss_sales_price))."
  }

  measure: qty_1_20_count {
    type: count
    filters: [ss_quantity: "[1, 20]"]
    group_label: "Quantity Bucket Metrics"
    description: "Count of store sales line items with quantity between 1 and 20."
  }

  measure: qty_1_20_avg_ext_list_price {
    type: average
    sql: ${ss_ext_list_price} ;;
    filters: [ss_quantity: "[1, 20]"]
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Bucket Metrics"
    description: "Average extended list price for store sales line items with quantity between 1 and 20."
  }

  measure: qty_1_20_avg_net_profit {
    type: average
    sql: ${ss_net_profit} ;;
    filters: [ss_quantity: "[1, 20]"]
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Bucket Metrics"
    description: "Average net profit for store sales line items with quantity between 1 and 20."
  }

  measure: bucket1 {
    type: number
    sql: CASE WHEN ${qty_1_20_count} > 3672 THEN ${qty_1_20_avg_ext_list_price} ELSE ${qty_1_20_avg_net_profit} END ;;
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Bucket Metrics"
    description: "Conditional metric for quantity 1-20: average extended list price when count > 3,672, else average net profit."
  }

  measure: qty_21_40_count {
    type: count
    filters: [ss_quantity: "[21, 40]"]
    group_label: "Quantity Bucket Metrics"
    description: "Count of store sales line items with quantity between 21 and 40."
  }

  measure: qty_21_40_avg_ext_list_price {
    type: average
    sql: ${ss_ext_list_price} ;;
    filters: [ss_quantity: "[21, 40]"]
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Bucket Metrics"
    description: "Average extended list price for store sales line items with quantity between 21 and 40."
  }

  measure: qty_21_40_avg_net_profit {
    type: average
    sql: ${ss_net_profit} ;;
    filters: [ss_quantity: "[21, 40]"]
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Bucket Metrics"
    description: "Average net profit for store sales line items with quantity between 21 and 40."
  }

  measure: bucket2 {
    type: number
    sql: CASE WHEN ${qty_21_40_count} > 3392 THEN ${qty_21_40_avg_ext_list_price} ELSE ${qty_21_40_avg_net_profit} END ;;
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Bucket Metrics"
    description: "Conditional metric for quantity 21-40: average extended list price when count > 3,392, else average net profit."
  }

  measure: qty_41_60_count {
    type: count
    filters: [ss_quantity: "[41, 60]"]
    group_label: "Quantity Bucket Metrics"
    description: "Count of store sales line items with quantity between 41 and 60."
  }

  measure: qty_41_60_avg_ext_list_price {
    type: average
    sql: ${ss_ext_list_price} ;;
    filters: [ss_quantity: "[41, 60]"]
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Bucket Metrics"
    description: "Average extended list price for store sales line items with quantity between 41 and 60."
  }

  measure: qty_41_60_avg_net_profit {
    type: average
    sql: ${ss_net_profit} ;;
    filters: [ss_quantity: "[41, 60]"]
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Bucket Metrics"
    description: "Average net profit for store sales line items with quantity between 41 and 60."
  }

  measure: bucket3 {
    type: number
    sql: CASE WHEN ${qty_41_60_count} > 32784 THEN ${qty_41_60_avg_ext_list_price} ELSE ${qty_41_60_avg_net_profit} END ;;
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Bucket Metrics"
    description: "Conditional metric for quantity 41-60: average extended list price when count > 32,784, else average net profit."
  }

  measure: qty_61_80_count {
    type: count
    filters: [ss_quantity: "[61, 80]"]
    group_label: "Quantity Bucket Metrics"
    description: "Count of store sales line items with quantity between 61 and 80."
  }

  measure: qty_61_80_avg_ext_list_price {
    type: average
    sql: ${ss_ext_list_price} ;;
    filters: [ss_quantity: "[61, 80]"]
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Bucket Metrics"
    description: "Average extended list price for store sales line items with quantity between 61 and 80."
  }

  measure: qty_61_80_avg_net_profit {
    type: average
    sql: ${ss_net_profit} ;;
    filters: [ss_quantity: "[61, 80]"]
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Bucket Metrics"
    description: "Average net profit for store sales line items with quantity between 61 and 80."
  }

  measure: bucket4 {
    type: number
    sql: CASE WHEN ${qty_61_80_count} > 26032 THEN ${qty_61_80_avg_ext_list_price} ELSE ${qty_61_80_avg_net_profit} END ;;
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Bucket Metrics"
    description: "Conditional metric for quantity 61-80: average extended list price when count > 26,032, else average net profit."
  }

  measure: qty_81_100_count {
    type: count
    filters: [ss_quantity: "[81, 100]"]
    group_label: "Quantity Bucket Metrics"
    description: "Count of store sales line items with quantity between 81 and 100."
  }

  measure: qty_81_100_avg_ext_list_price {
    type: average
    sql: ${ss_ext_list_price} ;;
    filters: [ss_quantity: "[81, 100]"]
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Bucket Metrics"
    description: "Average extended list price for store sales line items with quantity between 81 and 100."
  }

  measure: qty_81_100_avg_net_profit {
    type: average
    sql: ${ss_net_profit} ;;
    filters: [ss_quantity: "[81, 100]"]
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Bucket Metrics"
    description: "Average net profit for store sales line items with quantity between 81 and 100."
  }

  measure: bucket5 {
    type: number
    sql: CASE WHEN ${qty_81_100_count} > 23982 THEN ${qty_81_100_avg_ext_list_price} ELSE ${qty_81_100_avg_net_profit} END ;;
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Bucket Metrics"
    description: "Conditional metric for quantity 81-100: average extended list price when count > 23,982, else average net profit."
  }
}
