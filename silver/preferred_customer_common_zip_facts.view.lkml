include: "/silver/explores/customer.explore.lkml"

view: preferred_customer_common_zip_facts {
  derived_table: {
    explore_source: customer {
      column: ca_zip_5 { field: customer_address.ca_zip_5 }
      column: ca_zip_prefix_2 { field: customer_address.ca_zip_prefix_2 }
      column: has_current_address_match { field: customer_customer_address_fields.has_current_address_match }
      column: preferred_customer_count { field: customer.preferred_customer_count }
      column: customer_record_count { field: customer.count }
      filters: [
        customer.is_preferred_customer: "Yes",
        customer_customer_address_fields.has_current_address_match: "Yes",
        customer_address.ca_zip_5: "-NULL",
        customer.preferred_customer_count: ">10"
      ]
    }
  }

  dimension: ca_zip_5 {
    primary_key: yes
    type: string
    sql: ${TABLE}.ca_zip_5 ;;
    description: "5-digit postal code with strictly more than 10 preferred customers."
  }

  dimension: ca_zip_prefix_2 {
    type: string
    sql: ${TABLE}.ca_zip_prefix_2 ;;
    description: "2-digit postal code prefix of a qualifying common 5-digit ZIP."
  }

  dimension: has_current_address_match {
    hidden: yes
    type: yesno
    sql: ${TABLE}.has_current_address_match ;;
  }

  dimension: preferred_customer_count {
    type: number
    sql: ${TABLE}.preferred_customer_count ;;
    description: "Count of preferred customers residing in this 5-digit postal code."
  }

  dimension: customer_record_count {
    hidden: yes
    type: number
    sql: ${TABLE}.customer_record_count ;;
  }

  measure: count {
    type: count
    filters: [ca_zip_5: "-NULL", has_current_address_match: "Yes", preferred_customer_count: ">10", customer_record_count: ">10"]
    description: "Count of qualifying 5-digit postal codes with >10 preferred customers."
  }
}
