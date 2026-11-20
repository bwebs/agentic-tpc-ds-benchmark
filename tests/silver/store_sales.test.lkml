include: "../../silver/explores/store_sales.explore.lkml"

test: store_sales_2001_nov_manufact_427_join_metrics {
  explore_source: store_sales {
    column: total_extended_discount_amount { field: store_sales.total_extended_discount_amount }
    column: count { field: store_sales.count }
    filters: {
      field: date_dim.d_year_num
      value: "2001"
    }
    filters: {
      field: date_dim.d_moy
      value: "11"
    }
    filters: {
      field: item.i_manufact_id
      value: "427"
    }
  }
  assert: total_extended_discount_amount_matches {
    expression: round(${store_sales.total_extended_discount_amount}, 2) = 30650.66 ;;
  }
  assert: store_sales_count_matches {
    expression: ${store_sales.count} = 114 ;;
  }
}

test: store_sales_july_1998_high_price_metrics {
  explore_source: store_sales {
    column: store_sales_count { field: store_sales.count }
    column: category_count { field: item_category_price_facts.count }
    filters: {
      field: date_dim.d_year_num
      value: "1998"
    }
    filters: {
      field: date_dim.d_moy
      value: "7"
    }
    filters: {
      field: item_item_category_price_facts_fields.is_above_120pct_category_avg_price
      value: "Yes"
    }
    filters: {
      field: customer_address.ca_address_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer.c_customer_sk
      value: "NOT NULL"
    }
    filters: {
      field: item.i_item_sk
      value: "NOT NULL"
    }
    filters: {
      field: date_dim.d_date_sk
      value: "NOT NULL"
    }
  }
  assert: store_sales_count_matches {
    expression: ${store_sales.count} = 2807 ;;
  }
  assert: category_count_matches {
    expression: ${item_category_price_facts.count} = 10 ;;
  }
}

test: store_sales_1998_cdemo_promo_channel_averages {
  explore_source: store_sales {
    column: i_item_id { field: item.i_item_id }
    column: average_quantity { field: store_sales.average_quantity }
    column: average_list_price { field: store_sales.average_list_price }
    column: average_coupon_amount { field: store_sales.average_coupon_amount }
    column: average_sales_price { field: store_sales.average_sales_price }
    column: count { field: store_sales.count }
    filters: {
      field: date_dim.d_year_num
      value: "1998"
    }
    filters: {
      field: item.i_item_id
      value: "AAAAAAAAAAAEAAAA"
    }
    filters: {
      field: customer_demographics.cd_gender
      value: "F"
    }
    filters: {
      field: customer_demographics.cd_marital_status
      value: "W"
    }
    filters: {
      field: customer_demographics.cd_education_status
      value: "2 yr Degree"
    }
    filters: {
      field: promotion.is_non_email_or_non_event_channel
      value: "Yes"
    }
    filters: {
      field: store_sales.ss_sold_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: date_dim.d_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_item_sk
      value: "NOT NULL"
    }
    filters: {
      field: item.i_item_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_cdemo_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer_demographics.cd_demo_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_promo_sk
      value: "NOT NULL"
    }
    filters: {
      field: promotion.p_promo_sk
      value: "NOT NULL"
    }
  }
  assert: average_quantity_matches {
    expression: round(${store_sales.average_quantity}, 2) = 57 ;;
  }
  assert: average_list_price_matches {
    expression: round(${store_sales.average_list_price}, 2) = 76.8 ;;
  }
  assert: average_coupon_amount_matches {
    expression: round(${store_sales.average_coupon_amount}, 2) = 1694.95 ;;
  }
  assert: average_sales_price_matches {
    expression: round(${store_sales.average_sales_price}, 2) = 58.94 ;;
  }
  assert: count_matches {
    expression: ${store_sales.count} = 3 ;;
  }
}

test: store_sales_q2_2000_store_join_net_profit_metrics {
  explore_source: store_sales {
    column: total_net_profit { field: store_sales.total_net_profit }
    column: count { field: store_sales.count }
    filters: {
      field: date_dim.d_year_num
      value: "2000"
    }
    filters: {
      field: date_dim.d_qoy
      value: "2"
    }
    filters: {
      field: store.s_store_name
      value: "able"
    }
    filters: {
      field: store_sales.ss_store_sk
      value: "NOT NULL"
    }
    filters: {
      field: store.s_store_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_sold_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: date_dim.d_date_sk
      value: "NOT NULL"
    }
  }
  assert: total_net_profit_matches {
    expression: round(${store_sales.total_net_profit}, 2) = -10355108.96 ;;
  }
  assert: store_sales_count_matches {
    expression: ${store_sales.count} = 12700 ;;
  }
}

test: store_sales_2001_demographic_address_profit_tier_metrics {
  explore_source: store_sales {
    column: average_quantity { field: store_sales.average_quantity }
    column: average_ext_sales_price { field: store_sales.average_ext_sales_price }
    column: average_ext_wholesale_cost { field: store_sales.average_ext_wholesale_cost }
    column: total_ext_wholesale_cost { field: store_sales.total_ext_wholesale_cost }
    column: count { field: store_sales.count }
    filters: {
      field: date_dim.d_year_num
      value: "2001"
    }
    filters: {
      field: customer_demographics_household_demographics_store_sales_fields.is_qualifying_demographic_sales_price_tier
      value: "Yes"
    }
    filters: {
      field: sales_customer_address_store_sales_fields.is_qualifying_us_state_net_profit_tier
      value: "Yes"
    }
    filters: {
      field: store_sales.ss_store_sk
      value: "NOT NULL"
    }
    filters: {
      field: store.s_store_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_sold_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: date_dim.d_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_hdemo_sk
      value: "NOT NULL"
    }
    filters: {
      field: household_demographics.hd_demo_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_cdemo_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer_demographics.cd_demo_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_addr_sk
      value: "NOT NULL"
    }
    filters: {
      field: sales_customer_address.ca_address_sk
      value: "NOT NULL"
    }
  }
  assert: average_quantity_matches {
    expression: round(${store_sales.average_quantity}, 2) = 19.22 ;;
  }
  assert: average_ext_sales_price_matches {
    expression: round(${store_sales.average_ext_sales_price}, 2) = 1329.69 ;;
  }
  assert: average_ext_wholesale_cost_matches {
    expression: round(${store_sales.average_ext_wholesale_cost}, 2) = 1179.58 ;;
  }
  assert: total_ext_wholesale_cost_matches {
    expression: round(${store_sales.total_ext_wholesale_cost}, 2) = 10616.24 ;;
  }
  assert: store_sales_count_matches {
    expression: ${store_sales.count} = 9 ;;
  }
}

test: store_sales_dec_1998_out_of_zip_manager_38_metrics {
  explore_source: store_sales {
    column: total_ext_sales_price { field: store_sales.total_ext_sales_price }
    column: count { field: store_sales.count }
    filters: {
      field: item.i_manager_id
      value: "38"
    }
    filters: {
      field: date_dim.d_moy
      value: "12"
    }
    filters: {
      field: date_dim.d_year_num
      value: "1998"
    }
    filters: {
      field: customer_address_store_fields.is_different_zip_5
      value: "Yes"
    }
    filters: {
      field: store_sales.ss_sold_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: date_dim.d_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_item_sk
      value: "NOT NULL"
    }
    filters: {
      field: item.i_item_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_customer_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer.c_customer_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer.c_current_addr_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer_address.ca_address_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_store_sk
      value: "NOT NULL"
    }
    filters: {
      field: store.s_store_sk
      value: "NOT NULL"
    }
  }
  assert: total_ext_sales_price_matches {
    expression: round(${store_sales.total_ext_sales_price}, 2) = 1583499.98 ;;
  }
  assert: store_sales_count_matches {
    expression: ${store_sales.count} = 740 ;;
  }
}

test: store_sales_2000_tn_male_divorced_college_averages {
  explore_source: store_sales {
    column: count { field: store_sales.count }
    column: average_quantity { field: store_sales.average_quantity }
    column: average_list_price { field: store_sales.average_list_price }
    column: average_coupon_amount { field: store_sales.average_coupon_amount }
    column: average_sales_price { field: store_sales.average_sales_price }
    filters: {
      field: date_dim.d_year_num
      value: "2000"
    }
    filters: {
      field: customer_demographics.cd_gender
      value: "M"
    }
    filters: {
      field: customer_demographics.cd_marital_status
      value: "D"
    }
    filters: {
      field: customer_demographics.cd_education_status
      value: "College"
    }
    filters: {
      field: store.s_state
      value: "TN"
    }
    filters: {
      field: store_sales.ss_sold_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: date_dim.d_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_item_sk
      value: "NOT NULL"
    }
    filters: {
      field: item.i_item_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_store_sk
      value: "NOT NULL"
    }
    filters: {
      field: store.s_store_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_cdemo_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer_demographics.cd_demo_sk
      value: "NOT NULL"
    }
  }
  assert: store_sales_count_matches {
    expression: ${store_sales.count} = 7806 ;;
  }
  assert: average_quantity_matches {
    expression: round(${store_sales.average_quantity}, 2) = 50.55 ;;
  }
  assert: average_list_price_matches {
    expression: round(${store_sales.average_list_price}, 2) = 75.73 ;;
  }
  assert: average_coupon_amount_matches {
    expression: round(${store_sales.average_coupon_amount}, 2) = 186.13 ;;
  }
  assert: average_sales_price_matches {
    expression: round(${store_sales.average_sales_price}, 2) = 38.01 ;;
  }
}

test: store_sales_dec_2000_manager_1_join_metrics {
  explore_source: store_sales {
    column: total_ext_sales_price { field: store_sales.total_ext_sales_price }
    column: count { field: store_sales.count }
    filters: {
      field: item.i_manager_id
      value: "1"
    }
    filters: {
      field: date_dim.d_moy
      value: "12"
    }
    filters: {
      field: date_dim.d_year_num
      value: "2000"
    }
    filters: {
      field: store_sales.ss_sold_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: date_dim.d_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_item_sk
      value: "NOT NULL"
    }
    filters: {
      field: item.i_item_sk
      value: "NOT NULL"
    }
  }
  assert: total_ext_sales_price_matches {
    expression: round(${store_sales.total_ext_sales_price}, 2) = 2942395.13 ;;
  }
  assert: store_sales_count_matches {
    expression: ${store_sales.count} = 1579 ;;
  }
}

test: store_sales_jan_2002_gmt_minus_5_dow_sales_metrics {
  explore_source: store_sales {
    column: sun_sales { field: date_dim_store_sales_fields.sun_sales }
    column: mon_sales { field: date_dim_store_sales_fields.mon_sales }
    column: tue_sales { field: date_dim_store_sales_fields.tue_sales }
    column: wed_sales { field: date_dim_store_sales_fields.wed_sales }
    column: thu_sales { field: date_dim_store_sales_fields.thu_sales }
    column: fri_sales { field: date_dim_store_sales_fields.fri_sales }
    column: sat_sales { field: date_dim_store_sales_fields.sat_sales }
    column: count { field: store_sales.count }
    filters: {
      field: store.s_gmt_offset
      value: "-5"
    }
    filters: {
      field: date_dim.d_year_num
      value: "2002"
    }
    filters: {
      field: date_dim.d_moy
      value: "1"
    }
    filters: {
      field: store_sales.ss_sold_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: date_dim.d_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_store_sk
      value: "NOT NULL"
    }
    filters: {
      field: store.s_store_sk
      value: "NOT NULL"
    }
  }
  assert: sun_sales_matches {
    expression: round(${date_dim_store_sales_fields.sun_sales}, 2) = 120839.86 ;;
  }
  assert: mon_sales_matches {
    expression: round(${date_dim_store_sales_fields.mon_sales}, 2) = 126240.76 ;;
  }
  assert: tue_sales_matches {
    expression: round(${date_dim_store_sales_fields.tue_sales}, 2) = 265947.00 ;;
  }
  assert: wed_sales_matches {
    expression: round(${date_dim_store_sales_fields.wed_sales}, 2) = 274714.09 ;;
  }
  assert: thu_sales_matches {
    expression: round(${date_dim_store_sales_fields.thu_sales}, 2) = 166388.35 ;;
  }
  assert: fri_sales_matches {
    expression: round(${date_dim_store_sales_fields.fri_sales}, 2) = 136739.38 ;;
  }
  assert: sat_sales_matches {
    expression: round(${date_dim_store_sales_fields.sat_sales}, 2) = 125172.19 ;;
  }
  assert: count_matches {
    expression: ${store_sales.count} = 32412 ;;
  }
}

test: store_sales_2000_weekend_midway_fairview_address_join_metrics {
  explore_source: store_sales {
    column: total_coupon_amt { field: store_sales.total_coupon_amt }
    column: total_net_profit { field: store_sales.total_net_profit }
    column: count { field: store_sales.count }
    filters: {
      field: store.s_city
      value: "Midway,Fairview"
    }
    filters: {
      field: date_dim.d_dow
      value: "0, 6"
    }
    filters: {
      field: date_dim.d_year_num
      value: "2000"
    }
    filters: {
      field: store_sales.ss_sold_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: date_dim.d_date_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_store_sk
      value: "NOT NULL"
    }
    filters: {
      field: store.s_store_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_hdemo_sk
      value: "NOT NULL"
    }
    filters: {
      field: household_demographics.hd_demo_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_addr_sk
      value: "NOT NULL"
    }
    filters: {
      field: sales_customer_address.ca_address_sk
      value: "NOT NULL"
    }
    filters: {
      field: store_sales.ss_customer_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer.c_customer_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer.c_current_addr_sk
      value: "NOT NULL"
    }
    filters: {
      field: customer_address.ca_address_sk
      value: "NOT NULL"
    }
  }
  assert: total_coupon_amt_matches {
    expression: round(${store_sales.total_coupon_amt}, 2) = 29995097.04 ;;
  }
  assert: total_net_profit_matches {
    expression: round(${store_sales.total_net_profit}, 2) = -129155554.65 ;;
  }
  assert: store_sales_count_matches {
    expression: ${store_sales.count} = 156841 ;;
  }
}
