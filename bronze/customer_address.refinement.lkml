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

  dimension: ca_zip_5 {
    type: string
    label: "Zip Code (5-Digit)"
    description: "First 5 characters of customer address postal code (SUBSTR(ca_zip, 1, 5))."
    sql: SUBSTR(${ca_zip}, 1, 5) ;;
  }

  dimension: ca_zip_prefix_2 {
    type: string
    label: "Zip Prefix (2-Digit)"
    description: "First 2 characters of customer address postal code (SUBSTR(ca_zip, 1, 2))."
    sql: SUBSTR(${ca_zip}, 1, 2) ;;
  }

  measure: count {
    description: "Count of customer addresses."
  }
}
