include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/promotion.view.lkml"
include: "/bronze/promotion.refinement.lkml"

view: catalog_sales_promotion_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${catalog_sales.pk} ;;
  }

  measure: no_promo_count {
    type: count
    label: "No Promo Count"
    description: "Count of catalog sales line items without a matching promotion (promotion.p_promo_sk IS NULL)."
    synonyms: ["no_promo"]
    filters: [promotion.p_promo_sk: "NULL"]
  }

  measure: promo_count {
    type: count
    label: "Promo Count"
    description: "Count of catalog sales line items with a matching promotion (promotion.p_promo_sk IS NOT NULL)."
    synonyms: ["promo"]
    filters: [promotion.p_promo_sk: "NOT NULL"]
  }
}
