include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/store_returns.view.lkml"
include: "/bronze/store_returns.refinement.lkml"
include: "/bronze/store.view.lkml"
include: "/bronze/store.refinement.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"

view: store_return_net_paid {
  # ponytail: single Gold SDT carrying AVG(netpaid) OVER () across the market-filtered ssales cohort before outer item color filtering; split into separate cohort NDTs if reused independently
  derived_table: {
    sql:
      WITH ssales AS (
        SELECT
          {{ _sdt_c.c_last_name._sql }} AS c_last_name,
          {{ _sdt_c.c_first_name._sql }} AS c_first_name,
          {{ _sdt_s.s_store_name._sql }} AS s_store_name,
          {{ _sdt_ca.ca_state._sql }} AS ca_state,
          {{ _sdt_s.s_state._sql }} AS s_state,
          {{ _sdt_i.i_color._sql }} AS i_color,
          {{ _sdt_i.i_current_price._sql }} AS i_current_price,
          {{ _sdt_i.i_manager_id._sql }} AS i_manager_id,
          {{ _sdt_i.i_units._sql }} AS i_units,
          {{ _sdt_i.i_size._sql }} AS i_size,
          SUM({{ _sdt_ss.ss_net_profit._sql }}) AS netpaid
        FROM ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_ss._name }}
        INNER JOIN ${store_returns.SQL_TABLE_NAME} AS {{ _sdt_sr._name }}
          ON {{ _sdt_ss.ss_ticket_number._sql }} = {{ _sdt_sr.sr_ticket_number._sql }}
          AND {{ _sdt_ss.ss_item_sk._sql }} = {{ _sdt_sr.sr_item_sk._sql }}
        INNER JOIN ${customer.SQL_TABLE_NAME} AS {{ _sdt_c._name }}
          ON {{ _sdt_ss.ss_customer_sk._sql }} = {{ _sdt_c.c_customer_sk._sql }}
        INNER JOIN ${item.SQL_TABLE_NAME} AS {{ _sdt_i._name }}
          ON {{ _sdt_ss.ss_item_sk._sql }} = {{ _sdt_i.i_item_sk._sql }}
        INNER JOIN ${store.SQL_TABLE_NAME} AS {{ _sdt_s._name }}
          ON {{ _sdt_ss.ss_store_sk._sql }} = {{ _sdt_s.s_store_sk._sql }}
        INNER JOIN ${customer_address.SQL_TABLE_NAME} AS {{ _sdt_ca._name }}
          ON {{ _sdt_c.c_birth_country._sql }} = UPPER({{ _sdt_ca.ca_country._sql }})
          AND {{ _sdt_s.s_zip._sql }} = {{ _sdt_ca.ca_zip._sql }}
        WHERE {% condition market_id_filter %} {{ _sdt_s.s_market_id._sql }} {% endcondition %}
        GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
      )
      SELECT
        c_last_name,
        c_first_name,
        s_store_name,
        ca_state,
        s_state,
        i_color,
        i_current_price,
        i_manager_id,
        i_units,
        i_size,
        netpaid,
        AVG(netpaid) OVER () AS avg_ssales_netpaid
      FROM ssales ;;
  }

  filter: market_id_filter {
    type: number
    label: "Store Market ID Filter"
    description: "Store market ID filter applied to the inner ssales cohort before computing the 5% average net paid benchmark."
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(
      COALESCE(${c_last_name}, ''), '|',
      COALESCE(${c_first_name}, ''), '|',
      COALESCE(${s_store_name}, ''), '|',
      COALESCE(${ca_state}, ''), '|',
      COALESCE(${s_state}, ''), '|',
      COALESCE(${i_color}, ''), '|',
      COALESCE(CAST(${i_current_price} AS STRING), ''), '|',
      COALESCE(CAST(${i_manager_id} AS STRING), ''), '|',
      COALESCE(${i_units}, ''), '|',
      COALESCE(${i_size}, '')
    ) ;;
  }

  dimension: c_last_name {
    type: string
    label: "Customer Last Name"
    description: "Customer last name (c_last_name)."
    sql: ${TABLE}.c_last_name ;;
  }

  dimension: c_first_name {
    type: string
    label: "Customer First Name"
    description: "Customer first name (c_first_name)."
    sql: ${TABLE}.c_first_name ;;
  }

  dimension: s_store_name {
    type: string
    label: "Store Name"
    description: "Store name (s_store_name)."
    sql: ${TABLE}.s_store_name ;;
  }

  dimension: ca_state {
    type: string
    label: "Customer Address State"
    description: "Customer address state matched by zip and birth country (ca_state)."
    sql: ${TABLE}.ca_state ;;
  }

  dimension: s_state {
    type: string
    label: "Store State"
    description: "Store state (s_state)."
    sql: ${TABLE}.s_state ;;
  }

  dimension: i_color {
    type: string
    label: "Item Color"
    description: "Item color (i_color)."
    sql: ${TABLE}.i_color ;;
  }

  dimension: i_current_price {
    type: number
    value_format_name: usd
    label: "Item Current Price"
    description: "Item current retail price (i_current_price)."
    sql: ${TABLE}.i_current_price ;;
  }

  dimension: i_manager_id {
    type: number
    value_format_name: id
    label: "Item Manager ID"
    description: "Item manager identifier (i_manager_id)."
    sql: ${TABLE}.i_manager_id ;;
  }

  dimension: i_units {
    type: string
    label: "Item Units"
    description: "Item unit of measure (i_units)."
    sql: ${TABLE}.i_units ;;
  }

  dimension: i_size {
    type: string
    label: "Item Size"
    description: "Item size label (i_size)."
    sql: ${TABLE}.i_size ;;
  }

  dimension: netpaid {
    type: number
    value_format_name: usd
    description: "Stage-1 sum of store sales net profit for the 10-column customer-store-item group (SUM(ss_net_profit))."
    sql: ${TABLE}.netpaid ;;
  }

  dimension: avg_ssales_netpaid {
    hidden: yes
    type: number
    sql: ${TABLE}.avg_ssales_netpaid ;;
  }

  measure: count {
    type: count
    description: "Count of grouped customer-store-item return net paid rows in ssales."
  }

  measure: paid {
    type: sum
    sql: ${netpaid} ;;
    value_format_name: usd
    description: "Total net paid across grouped ssales rows (SUM(netpaid))."
    synonyms: ["total net paid", "net paid"]
  }

  measure: _max_avg_ssales_netpaid {
    hidden: yes
    type: max
    sql: ${avg_ssales_netpaid} ;;
  }

  measure: is_above_5pct_avg_netpaid {
    type: yesno
    label: "Above 5% of Cohort Avg Net Paid"
    tags: ["non_additive"]
    description: "True when SUM(netpaid) exceeds 5% of the unfiltered ssales cohort average net paid (SUM(netpaid) > 0.05 * AVG(netpaid))."
    sql: ${paid} > 0.05 * ${_max_avg_ssales_netpaid} ;;
  }
}
