view: customer_address_store_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${customer_address.ca_address_sk} AS STRING), '_', CAST(${store.s_store_sk} AS STRING)) ;;
  }

  dimension: is_different_zip_5 {
    type: yesno
    label: "Different 5-Digit Zip Code"
    description: "True when customer address 5-digit postal code differs from store 5-digit postal code (SUBSTR(ca_zip, 1, 5) <> SUBSTR(s_zip, 1, 5))."
    sql: ${customer_address.ca_zip_5} <> ${store.s_zip_5} ;;
  }
}
