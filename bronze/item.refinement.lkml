include: "item.view.lkml"

view: +item {
  dimension: i_item_id {
    primary_key: no
  }

  dimension: i_item_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.i_item_sk ;;
  }

  dimension: i_brand_id {
    type: number
    value_format_name: id
    sql: ${TABLE}.i_brand_id ;;
    synonyms: ["brand_id"]
  }

  dimension: i_class_id {
    type: number
    value_format_name: id
    sql: ${TABLE}.i_class_id ;;
    synonyms: ["class_id"]
  }

  dimension: i_category_id {
    type: number
    value_format_name: id
    sql: ${TABLE}.i_category_id ;;
    synonyms: ["category_id"]
  }

  dimension: i_brand {
    type: string
    sql: ${TABLE}.i_brand ;;
    synonyms: ["brand"]
  }

  dimension: i_manufact_id {
    type: number
    value_format_name: id
    sql: ${TABLE}.i_manufact_id ;;
  }

  dimension: is_apparel_spec_match {
    type: yesno
    label: "Apparel Spec Match"
    description: "Whether the item matches one of the 8 Men/Women apparel color, unit, and size specification combinations."
    sql: (${i_category} = 'Women' AND ${i_color} IN ('dim', 'green') AND ${i_units} IN ('Gross', 'Dozen') AND ${i_size} IN ('economy', 'petite'))
      OR (${i_category} = 'Women' AND ${i_color} IN ('navajo', 'aquamarine') AND ${i_units} IN ('Case', 'Unknown') AND ${i_size} IN ('large', 'N/A'))
      OR (${i_category} = 'Men' AND ${i_color} IN ('indian', 'dark') AND ${i_units} IN ('Oz', 'Lb') AND ${i_size} IN ('extra large', 'small'))
      OR (${i_category} = 'Men' AND ${i_color} IN ('peach', 'purple') AND ${i_units} IN ('Tbl', 'Bunch') AND ${i_size} IN ('economy', 'petite'))
      OR (${i_category} = 'Women' AND ${i_color} IN ('orchid', 'peru') AND ${i_units} IN ('Carton', 'Cup') AND ${i_size} IN ('economy', 'petite'))
      OR (${i_category} = 'Women' AND ${i_color} IN ('violet', 'papaya') AND ${i_units} IN ('Ounce', 'Box') AND ${i_size} IN ('large', 'N/A'))
      OR (${i_category} = 'Men' AND ${i_color} IN ('drab', 'grey') AND ${i_units} IN ('Each', 'N/A') AND ${i_size} IN ('extra large', 'small'))
      OR (${i_category} = 'Men' AND ${i_color} IN ('chocolate', 'antique') AND ${i_units} IN ('Dram', 'Gram') AND ${i_size} IN ('economy', 'petite')) ;;
  }

  dimension: is_q53_featured_brand_cohort {
    type: yesno
    label: "Featured Brand Cohort (Q53)"
    description: "Whether the item belongs to one of the two featured category, class, and brand cohorts (Books/Children/Electronics or Women/Music/Men)."
    sql: (${i_category} IN ('Books', 'Children', 'Electronics')
        AND ${i_class} IN ('personal', 'portable', 'reference', 'self-help')
        AND ${i_brand} IN ('scholaramalgamalg #14', 'scholaramalgamalg #7', 'exportiunivamalg #9', 'scholaramalgamalg #9'))
      OR (${i_category} IN ('Women', 'Music', 'Men')
        AND ${i_class} IN ('accessories', 'classical', 'fragrances', 'pants')
        AND ${i_brand} IN ('amalgimporto #1', 'edu packscholar #1', 'exportiimporto #1', 'importoamalg #1')) ;;
  }

  measure: count {
    description: "Count of items."
  }

  measure: average_current_price {
    type: average
    sql: ${i_current_price} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Average current retail price across items (i_current_price)."
  }
}
