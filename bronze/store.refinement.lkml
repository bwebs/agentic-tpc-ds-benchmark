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
}
