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

  dimension: quantity_price_bucket {
    type: string
    sql: CASE
      WHEN ${ss_quantity} BETWEEN 0 AND 5 AND (${ss_list_price} BETWEEN 18 AND 28 OR ${ss_coupon_amt} BETWEEN 1939 AND 2939 OR ${ss_wholesale_cost} BETWEEN 34 AND 54) THEN 'B1'
      WHEN ${ss_quantity} BETWEEN 6 AND 10 AND (${ss_list_price} BETWEEN 1 AND 11 OR ${ss_coupon_amt} BETWEEN 35 AND 1035 OR ${ss_wholesale_cost} BETWEEN 50 AND 70) THEN 'B2'
      WHEN ${ss_quantity} BETWEEN 11 AND 15 AND (${ss_list_price} BETWEEN 91 AND 101 OR ${ss_coupon_amt} BETWEEN 1412 AND 2412 OR ${ss_wholesale_cost} BETWEEN 17 AND 37) THEN 'B3'
      WHEN ${ss_quantity} BETWEEN 16 AND 20 AND (${ss_list_price} BETWEEN 9 AND 19 OR ${ss_coupon_amt} BETWEEN 5270 AND 6270 OR ${ss_wholesale_cost} BETWEEN 29 AND 49) THEN 'B4'
      WHEN ${ss_quantity} BETWEEN 21 AND 25 AND (${ss_list_price} BETWEEN 45 AND 55 OR ${ss_coupon_amt} BETWEEN 826 AND 1826 OR ${ss_wholesale_cost} BETWEEN 5 AND 25) THEN 'B5'
      WHEN ${ss_quantity} BETWEEN 26 AND 30 AND (${ss_list_price} BETWEEN 174 AND 184 OR ${ss_coupon_amt} BETWEEN 5548 AND 6548 OR ${ss_wholesale_cost} BETWEEN 42 AND 62) THEN 'B6'
    END ;;
    description: "Mutually exclusive quantity (0-30 in 5-unit bands) and price/coupon/wholesale qualifying bucket (B1..B6)."
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

  measure: total_sales_price {
    type: sum
    sql: ${ss_sales_price} ;;
    value_format_name: usd
    description: "Sum of sales price across store sales line items (SUM(ss_sales_price))."
    synonyms: ["sum_sales", "sales price"]
  }

  measure: total_sales_price_x_quantity {
    type: sum
    sql: COALESCE(${ss_sales_price} * ${ss_quantity}, 0) ;;
    value_format_name: usd
    description: "Sum of sales price times quantity across store sales line items (SUM(COALESCE(ss_sales_price * ss_quantity, 0)))."
    synonyms: ["sumsales"]
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

  measure: total_coupon_amt {
    type: sum
    sql: ${ss_coupon_amt} ;;
    value_format_name: usd
    description: "Sum of coupon discount amount across store sales line items (SUM(ss_coupon_amt))."
    synonyms: ["coupon amount", "total coupon amount"]
  }

  measure: gross_margin {
    type: number
    sql: ${total_net_profit} / NULLIF(${total_ext_sales_price}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Store sales gross margin ratio (SUM(ss_net_profit) / SUM(ss_ext_sales_price))."
  }

  measure: total_extended_discount_amount {
    type: sum
    sql: ${ss_ext_discount_amt} ;;
    value_format_name: usd
    description: "Sum of extended discount amount across store sales (ss_ext_discount_amt)."
    synonyms: ["sum_agg", "extended discount amount"]
  }

  measure: total_quantity {
    type: sum
    sql: ${ss_quantity} ;;
    value_format_name: decimal_0
    description: "Sum of quantity across store sales line items (SUM(ss_quantity))."
    synonyms: ["quantity", "sum quantity"]
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

  measure: b1_lp {
    type: average
    sql: ${ss_list_price} ;;
    filters: [quantity_price_bucket: "B1"]
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Price Bucket Metrics"
    description: "Average list price for store sales in qualifying bucket B1 (quantity 0-5)."
  }

  measure: b1_cnt {
    type: count
    filters: [quantity_price_bucket: "B1", ss_list_price: "NOT NULL"]
    group_label: "Quantity Price Bucket Metrics"
    description: "Count of store sales with non-null list price in qualifying bucket B1 (quantity 0-5)."
  }

  measure: b1_cntd {
    type: count_distinct
    sql: ${ss_list_price} ;;
    filters: [quantity_price_bucket: "B1"]
    tags: ["non_additive"]
    group_label: "Quantity Price Bucket Metrics"
    description: "Distinct list price count for store sales in qualifying bucket B1 (quantity 0-5)."
  }

  measure: b2_lp {
    type: average
    sql: ${ss_list_price} ;;
    filters: [quantity_price_bucket: "B2"]
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Price Bucket Metrics"
    description: "Average list price for store sales in qualifying bucket B2 (quantity 6-10)."
  }

  measure: b2_cnt {
    type: count
    filters: [quantity_price_bucket: "B2", ss_list_price: "NOT NULL"]
    group_label: "Quantity Price Bucket Metrics"
    description: "Count of store sales with non-null list price in qualifying bucket B2 (quantity 6-10)."
  }

  measure: b2_cntd {
    type: count_distinct
    sql: ${ss_list_price} ;;
    filters: [quantity_price_bucket: "B2"]
    tags: ["non_additive"]
    group_label: "Quantity Price Bucket Metrics"
    description: "Distinct list price count for store sales in qualifying bucket B2 (quantity 6-10)."
  }

  measure: b3_lp {
    type: average
    sql: ${ss_list_price} ;;
    filters: [quantity_price_bucket: "B3"]
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Price Bucket Metrics"
    description: "Average list price for store sales in qualifying bucket B3 (quantity 11-15)."
  }

  measure: b3_cnt {
    type: count
    filters: [quantity_price_bucket: "B3", ss_list_price: "NOT NULL"]
    group_label: "Quantity Price Bucket Metrics"
    description: "Count of store sales with non-null list price in qualifying bucket B3 (quantity 11-15)."
  }

  measure: b3_cntd {
    type: count_distinct
    sql: ${ss_list_price} ;;
    filters: [quantity_price_bucket: "B3"]
    tags: ["non_additive"]
    group_label: "Quantity Price Bucket Metrics"
    description: "Distinct list price count for store sales in qualifying bucket B3 (quantity 11-15)."
  }

  measure: b4_lp {
    type: average
    sql: ${ss_list_price} ;;
    filters: [quantity_price_bucket: "B4"]
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Price Bucket Metrics"
    description: "Average list price for store sales in qualifying bucket B4 (quantity 16-20)."
  }

  measure: b4_cnt {
    type: count
    filters: [quantity_price_bucket: "B4", ss_list_price: "NOT NULL"]
    group_label: "Quantity Price Bucket Metrics"
    description: "Count of store sales with non-null list price in qualifying bucket B4 (quantity 16-20)."
  }

  measure: b4_cntd {
    type: count_distinct
    sql: ${ss_list_price} ;;
    filters: [quantity_price_bucket: "B4"]
    tags: ["non_additive"]
    group_label: "Quantity Price Bucket Metrics"
    description: "Distinct list price count for store sales in qualifying bucket B4 (quantity 16-20)."
  }

  measure: b5_lp {
    type: average
    sql: ${ss_list_price} ;;
    filters: [quantity_price_bucket: "B5"]
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Price Bucket Metrics"
    description: "Average list price for store sales in qualifying bucket B5 (quantity 21-25)."
  }

  measure: b5_cnt {
    type: count
    filters: [quantity_price_bucket: "B5", ss_list_price: "NOT NULL"]
    group_label: "Quantity Price Bucket Metrics"
    description: "Count of store sales with non-null list price in qualifying bucket B5 (quantity 21-25)."
  }

  measure: b5_cntd {
    type: count_distinct
    sql: ${ss_list_price} ;;
    filters: [quantity_price_bucket: "B5"]
    tags: ["non_additive"]
    group_label: "Quantity Price Bucket Metrics"
    description: "Distinct list price count for store sales in qualifying bucket B5 (quantity 21-25)."
  }

  measure: b6_lp {
    type: average
    sql: ${ss_list_price} ;;
    filters: [quantity_price_bucket: "B6"]
    value_format_name: usd
    tags: ["non_additive"]
    group_label: "Quantity Price Bucket Metrics"
    description: "Average list price for store sales in qualifying bucket B6 (quantity 26-30)."
  }

  measure: b6_cnt {
    type: count
    filters: [quantity_price_bucket: "B6", ss_list_price: "NOT NULL"]
    group_label: "Quantity Price Bucket Metrics"
    description: "Count of store sales with non-null list price in qualifying bucket B6 (quantity 26-30)."
  }

  measure: b6_cntd {
    type: count_distinct
    sql: ${ss_list_price} ;;
    filters: [quantity_price_bucket: "B6"]
    tags: ["non_additive"]
    group_label: "Quantity Price Bucket Metrics"
    description: "Distinct list price count for store sales in qualifying bucket B6 (quantity 26-30)."
  }
}
