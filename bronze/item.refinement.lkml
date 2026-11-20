include: "item.view.lkml"

view: +item {
  dimension: i_item_id {
    primary_key: no
    type: string
    sql: ${TABLE}.i_item_id ;;
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
    description: "Brand identifier for the item (i_brand_id)."
    synonyms: ["brand_id"]
    sql: ${TABLE}.i_brand_id ;;
  }

  dimension: i_brand {
    type: string
    description: "Brand name for the item (i_brand)."
    synonyms: ["brand"]
    sql: ${TABLE}.i_brand ;;
  }

  dimension: i_manufact_id {
    type: number
    value_format_name: id
    description: "Manufacturer identifier for the item (i_manufact_id)."
    sql: ${TABLE}.i_manufact_id ;;
  }
}
