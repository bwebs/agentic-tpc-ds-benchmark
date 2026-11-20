include: "date_dim.view.lkml"

view: +date_dim {
  dimension: d_date_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.d_date_sk ;;
  }

  dimension: d_year_num {
    label: "Calendar Year Number"
    description: "Four-digit calendar year integer from date_dim (d_year)."
    synonyms: ["d_year"]
  }
}
