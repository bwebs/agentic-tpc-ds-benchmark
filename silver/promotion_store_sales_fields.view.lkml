include: "/bronze/promotion.view.lkml"
include: "/bronze/promotion.refinement.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"

view: promotion_store_sales_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${store_sales.pk} ;;
  }

  measure: promotional_ext_sales_price {
    label: "Promotional Extended Sales Price"
    description: "Sum of extended sales price across store sales on direct mail, email, or TV promotions (SUM(ss_ext_sales_price) filtered by p_channel_dmail = 'Y' OR p_channel_email = 'Y' OR p_channel_tv = 'Y')."
    type: sum
    sql: ${store_sales.ss_ext_sales_price} ;;
    filters: [
      promotion.p_promo_sk: "NOT NULL",
      promotion.is_dmail_email_or_tv_channel: "yes"
    ]
    value_format_name: usd
  }

  measure: promotional_sales_pct {
    label: "Promotional Sales Percentage"
    description: "Percentage of extended store sales price attributable to direct mail, email, or TV promotions (promotional_ext_sales_price / NULLIF(total_ext_sales_price, 0) * 100.0)."
    type: number
    tags: ["non_additive"]
    sql: ${promotional_ext_sales_price} / NULLIF(${store_sales.total_ext_sales_price}, 0) * 100.0 ;;
    value_format_name: decimal_2
  }
}
