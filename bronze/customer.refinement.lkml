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

  dimension: c_current_addr_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.c_current_addr_sk ;;
  }

  dimension: c_current_cdemo_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.c_current_cdemo_sk ;;
  }

  dimension: is_preferred_customer {
    type: yesno
    label: "Preferred Customer"
    description: "True when customer preferred flag (c_preferred_cust_flag) is Y."
    sql: ${c_preferred_cust_flag} = 'Y' ;;
  }

  measure: count {
    description: "Count of customer records."
  }

  measure: preferred_customer_count {
    type: count
    filters: [is_preferred_customer: "Yes"]
    description: "Count of preferred customer records (c_preferred_cust_flag = Y)."
  }
}
