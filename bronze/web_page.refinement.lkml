include: "web_page.view.lkml"

view: +web_page {
  dimension: wp_web_page_id {
    primary_key: no
  }

  dimension: wp_web_page_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.wp_web_page_sk ;;
    description: "Surrogate primary key for web page."
  }

  measure: count {
    description: "Count of web pages."
  }
}
