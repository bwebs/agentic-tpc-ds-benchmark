include: "/bronze/store_returns.view.lkml"
include: "/bronze/store_returns.refinement.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"

view: store_returns_store_sales_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${store_sales.pk} ;;
  }

  dimension: days_to_return {
    type: number
    sql: ${store_returns.sr_returned_date_sk} - ${store_sales.ss_sold_date_sk} ;;
    description: "Elapsed days from store sale date to store return date (sr_returned_date_sk - ss_sold_date_sk)."
  }

  measure: days_30 {
    type: count
    filters: [days_to_return: "<=30"]
    group_label: "Return Window Metrics"
    description: "Count of returned store sales line items returned within 30 days of sale."
  }

  measure: days_31_60 {
    type: count
    filters: [days_to_return: "(30, 60]"]
    group_label: "Return Window Metrics"
    description: "Count of returned store sales line items returned 31 to 60 days after sale."
  }

  measure: days_61_90 {
    type: count
    filters: [days_to_return: "(60, 90]"]
    group_label: "Return Window Metrics"
    description: "Count of returned store sales line items returned 61 to 90 days after sale."
  }

  measure: days_91_120 {
    type: count
    filters: [days_to_return: "(90, 120]"]
    group_label: "Return Window Metrics"
    description: "Count of returned store sales line items returned 91 to 120 days after sale."
  }

  measure: days_over_120 {
    type: count
    filters: [days_to_return: ">120"]
    group_label: "Return Window Metrics"
    description: "Count of returned store sales line items returned more than 120 days after sale."
  }
}
