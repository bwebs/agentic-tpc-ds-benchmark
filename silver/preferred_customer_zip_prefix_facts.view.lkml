include: "/silver/explores/preferred_customer_common_zip_facts_base.explore.lkml"

view: preferred_customer_zip_prefix_facts {
  derived_table: {
    explore_source: preferred_customer_common_zip_facts_base {
      column: ca_zip_prefix_2 { field: preferred_customer_common_zip_facts.ca_zip_prefix_2 }
      column: qualifying_zip5_count { field: preferred_customer_common_zip_facts.count }
      filters: [preferred_customer_common_zip_facts.ca_zip_prefix_2: "-NULL"]
    }
  }

  dimension: ca_zip_prefix_2 {
    primary_key: yes
    type: string
    sql: ${TABLE}.ca_zip_prefix_2 ;;
    description: "2-digit postal code prefix aggregated across qualifying preferred-customer common 5-digit ZIP codes."
  }

  dimension: qualifying_zip5_count {
    type: number
    sql: ${TABLE}.qualifying_zip5_count ;;
    description: "Number of qualifying common 5-digit ZIP codes (>10 preferred customers each) sharing this 2-digit prefix."
  }

  measure: count {
    type: count
    filters: [ca_zip_prefix_2: "-NULL"]
    description: "Count of distinct 2-digit ZIP prefixes with qualifying preferred-customer common ZIP codes."
  }

  measure: total_qualifying_zip5_codes {
    type: sum
    sql: ${qualifying_zip5_count} ;;
    description: "Total qualifying 5-digit common ZIP codes across selected 2-digit prefixes."
  }
}
