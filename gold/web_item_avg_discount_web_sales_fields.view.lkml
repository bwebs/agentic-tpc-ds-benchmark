view: web_item_avg_discount_web_sales_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${web_sales.pk} ;;
  }

  dimension: is_excess_discount {
    type: yesno
    label: "Excess Discount (>130% Item Average)"
    description: "Yes when web sales extended discount amount exceeds 130% of the item's average extended discount amount over the filtered sold-date window."
    sql: ${web_sales.ws_ext_discount_amt} > 1.3 * ${web_item_avg_discount.avg_ext_discount_amt} ;;
  }
}
