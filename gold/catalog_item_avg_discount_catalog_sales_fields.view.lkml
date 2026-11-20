view: catalog_item_avg_discount_catalog_sales_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${catalog_sales.pk} ;;
  }

  dimension: is_excess_discount {
    type: yesno
    label: "Excess Discount (>130% Item Average)"
    description: "Yes when catalog sales extended discount amount exceeds 130% of the item's average extended discount amount over the filtered sold-date window."
    sql: ${catalog_sales.cs_ext_discount_amt} > 1.3 * ${catalog_item_avg_discount.avg_ext_discount_amt} ;;
  }
}
