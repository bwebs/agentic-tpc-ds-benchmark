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
}
