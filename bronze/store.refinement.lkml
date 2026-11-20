include: "store.view.lkml"

view: +store {
  dimension: s_store_id {
    primary_key: no
  }

  dimension: s_store_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.s_store_sk ;;
  }

  dimension: s_zip_prefix_2 {
    type: string
    label: "Store Zip Prefix (2-Digit)"
    description: "First 2 characters of store postal code (SUBSTR(s_zip, 1, 2))."
    sql: SUBSTR(${s_zip}, 1, 2) ;;
  }
}
