include: "catalog_page.view.lkml"

view: +catalog_page {
  dimension: cp_catalog_page_id {
    primary_key: no
  }

  dimension: cp_catalog_page_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.cp_catalog_page_sk ;;
  }
}
