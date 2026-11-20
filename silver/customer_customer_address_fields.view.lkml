view: customer_customer_address_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${customer.c_customer_sk} ;;
  }

  dimension: has_current_address_match {
    type: yesno
    label: "Has Current Address Match"
    description: "True when customer c_current_addr_sk matches customer_address ca_address_sk."
    sql: ${customer.c_current_addr_sk} = ${customer_address.ca_address_sk} ;;
  }
}
