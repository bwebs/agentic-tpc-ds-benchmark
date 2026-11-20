include: "customer.view.lkml"

view: +customer {
  dimension: c_customer_id {
    primary_key: no
    synonyms: ["customer_id"]
  }

  dimension: c_customer_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.c_customer_sk ;;
  }

  measure: count {
    description: "Count of customer records."
  }
}
