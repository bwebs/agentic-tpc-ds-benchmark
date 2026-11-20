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
