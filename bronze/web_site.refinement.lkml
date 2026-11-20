include: "web_site.view.lkml"

view: +web_site {
  dimension: web_site_id {
    primary_key: no
  }

  dimension: web_site_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.web_site_sk ;;
  }
}
