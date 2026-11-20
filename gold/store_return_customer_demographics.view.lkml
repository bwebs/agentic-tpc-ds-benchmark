include: "/bronze/store_returns.view.lkml"
include: "/bronze/store_returns.refinement.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"

view: store_return_customer_demographics {
  # ponytail: flat Gold SDT bridging M:M store_returns.sr_cdemo_sk = customer.c_current_cdemo_sk so all downstream entity joins stay many_to_one without fan_trap warnings
  derived_table: {
    sql:
      SELECT
        {{ _sdt_sr.sr_item_sk._sql }} AS sr_item_sk,
        {{ _sdt_sr.sr_ticket_number._sql }} AS sr_ticket_number,
        {{ _sdt_sr.sr_cdemo_sk._sql }} AS sr_cdemo_sk,
        {{ _sdt_c.c_customer_sk._sql }} AS c_customer_sk
      FROM ${store_returns.SQL_TABLE_NAME} AS {{ _sdt_sr._name }}
      INNER JOIN ${customer.SQL_TABLE_NAME} AS {{ _sdt_c._name }}
        ON {{ _sdt_sr.sr_cdemo_sk._sql }} = {{ _sdt_c.c_current_cdemo_sk._sql }} ;;
  }

  dimension: pk {
    primary_key: yes
    type: string
    label: "Store Return Customer Demographics Key"
    description: "Composite row grain key combining store return item, ticket number, and customer surrogate key."
    sql: CONCAT(CAST(${sr_item_sk} AS STRING), '_', CAST(${sr_ticket_number} AS STRING), '_', CAST(${c_customer_sk} AS STRING)) ;;
  }

  dimension: sr_item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    description: "Returned item surrogate key (sr_item_sk)."
    sql: ${TABLE}.sr_item_sk ;;
  }

  dimension: sr_ticket_number {
    type: number
    value_format_name: id
    description: "Store return ticket number (sr_ticket_number)."
    sql: ${TABLE}.sr_ticket_number ;;
  }

  dimension: sr_cdemo_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    description: "Shared customer demographics surrogate key matching sr_cdemo_sk = c_current_cdemo_sk."
    sql: ${TABLE}.sr_cdemo_sk ;;
  }

  dimension: c_customer_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    description: "Matched customer surrogate key (c_customer_sk)."
    sql: ${TABLE}.c_customer_sk ;;
  }

  measure: count {
    type: count
    description: "Count of store return to customer demographic match rows."
  }
}
