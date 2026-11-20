include: "customer_address.view.lkml"

view: +customer_address {
  dimension: ca_address_id {
    primary_key: no
  }

  dimension: ca_address_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.ca_address_sk ;;
  }

  dimension: ca_state {
    type: string
    sql: ${TABLE}.ca_state ;;
    synonyms: ["state"]
  }

  measure: count {
    description: "Count of customer addresses."
  }
}
