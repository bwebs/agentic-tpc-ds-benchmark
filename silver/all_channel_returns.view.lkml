include: "/bronze/store_returns.view.lkml"
include: "/bronze/store_returns.refinement.lkml"
include: "/bronze/catalog_returns.view.lkml"
include: "/bronze/catalog_returns.refinement.lkml"
include: "/bronze/web_returns.view.lkml"
include: "/bronze/web_returns.refinement.lkml"

view: all_channel_returns {
  derived_table: {
    sql:
      SELECT
        IF({{ _sdt_store_returns.pk._sql }} IS NOT NULL, 's', 's') AS return_channel,
        {{ _sdt_store_returns.sr_item_sk._sql }} AS item_sk,
        {{ _sdt_store_returns.sr_ticket_number._sql }} AS order_number,
        {{ _sdt_store_returns.sr_returned_date_sk._sql }} AS returned_date_sk,
        {{ _sdt_store_returns.sr_return_quantity._sql }} AS return_quantity
      FROM ${store_returns.SQL_TABLE_NAME} AS {{ _sdt_store_returns._name }}
      UNION ALL
      SELECT
        IF({{ _sdt_catalog_returns.pk._sql }} IS NOT NULL, 'c', 'c') AS return_channel,
        {{ _sdt_catalog_returns.cr_item_sk._sql }} AS item_sk,
        {{ _sdt_catalog_returns.cr_order_number._sql }} AS order_number,
        {{ _sdt_catalog_returns.cr_returned_date_sk._sql }} AS returned_date_sk,
        {{ _sdt_catalog_returns.cr_return_quantity._sql }} AS return_quantity
      FROM ${catalog_returns.SQL_TABLE_NAME} AS {{ _sdt_catalog_returns._name }}
      UNION ALL
      SELECT
        IF({{ _sdt_web_returns.pk._sql }} IS NOT NULL, 'w', 'w') AS return_channel,
        {{ _sdt_web_returns.wr_item_sk._sql }} AS item_sk,
        {{ _sdt_web_returns.wr_order_number._sql }} AS order_number,
        {{ _sdt_web_returns.wr_returned_date_sk._sql }} AS returned_date_sk,
        {{ _sdt_web_returns.wr_return_quantity._sql }} AS return_quantity
      FROM ${web_returns.SQL_TABLE_NAME} AS {{ _sdt_web_returns._name }} ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${return_channel}, '_', CAST(${item_sk} AS STRING), '_', CAST(${order_number} AS STRING)) ;;
  }

  dimension: return_channel {
    type: string
    description: "Return channel identifier ('s' store, 'c' catalog, 'w' web)."
    sql: ${TABLE}.return_channel ;;
  }

  dimension: item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.item_sk ;;
  }

  dimension: order_number {
    type: number
    value_format_name: id
    sql: ${TABLE}.order_number ;;
  }

  dimension: returned_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.returned_date_sk ;;
  }

  dimension: return_quantity {
    type: number
    sql: ${TABLE}.return_quantity ;;
  }

  dimension: has_return_quantity {
    hidden: yes
    type: number
    sql: IF(${return_quantity} IS NOT NULL, 1, 0) ;;
  }

  measure: count {
    type: count
  }

  measure: distinct_channel_count {
    type: count_distinct
    sql: ${return_channel} ;;
    tags: ["non_additive"]
    description: "Count of distinct return channels ('s' store, 'c' catalog, 'w' web) with return rows."
  }

  measure: _sr_qty_sum {
    hidden: yes
    type: sum
    sql: ${return_quantity} ;;
    filters: [return_channel: "s"]
  }

  measure: _sr_qty_nonnull_count {
    hidden: yes
    type: sum
    sql: ${has_return_quantity} ;;
    filters: [return_channel: "s"]
  }

  measure: sr_item_qty {
    type: number
    sql: IF(${_sr_qty_nonnull_count} > 0, ${_sr_qty_sum}, NULL) ;;
    value_format_name: decimal_0
    tags: ["non_additive"]
    description: "Sum of returned item quantity for store returns (return_channel = 's'; NULL when all store return rows have NULL return_quantity)."
  }

  measure: _cr_qty_sum {
    hidden: yes
    type: sum
    sql: ${return_quantity} ;;
    filters: [return_channel: "c"]
  }

  measure: _cr_qty_nonnull_count {
    hidden: yes
    type: sum
    sql: ${has_return_quantity} ;;
    filters: [return_channel: "c"]
  }

  measure: cr_item_qty {
    type: number
    sql: IF(${_cr_qty_nonnull_count} > 0, ${_cr_qty_sum}, NULL) ;;
    value_format_name: decimal_0
    tags: ["non_additive"]
    description: "Sum of returned item quantity for catalog returns (return_channel = 'c'; NULL when all catalog return rows have NULL return_quantity)."
  }

  measure: _wr_qty_sum {
    hidden: yes
    type: sum
    sql: ${return_quantity} ;;
    filters: [return_channel: "w"]
  }

  measure: _wr_qty_nonnull_count {
    hidden: yes
    type: sum
    sql: ${has_return_quantity} ;;
    filters: [return_channel: "w"]
  }

  measure: wr_item_qty {
    type: number
    sql: IF(${_wr_qty_nonnull_count} > 0, ${_wr_qty_sum}, NULL) ;;
    value_format_name: decimal_0
    tags: ["non_additive"]
    description: "Sum of returned item quantity for web returns (return_channel = 'w'; NULL when all web return rows have NULL return_quantity)."
  }

  measure: sr_dev {
    type: number
    sql: ${sr_item_qty} / NULLIF(${sr_item_qty} + ${cr_item_qty} + ${wr_item_qty}, 0) / 3.0 * 100 ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Store channel return quantity share divided by 3, scaled by 100 (sr_item_qty / (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100)."
  }

  measure: cr_dev {
    type: number
    sql: ${cr_item_qty} / NULLIF(${sr_item_qty} + ${cr_item_qty} + ${wr_item_qty}, 0) / 3.0 * 100 ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Catalog channel return quantity share divided by 3, scaled by 100 (cr_item_qty / (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100)."
  }

  measure: wr_dev {
    type: number
    sql: ${wr_item_qty} / NULLIF(${sr_item_qty} + ${cr_item_qty} + ${wr_item_qty}, 0) / 3.0 * 100 ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Web channel return quantity share divided by 3, scaled by 100 (wr_item_qty / (sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100)."
  }

  measure: average_channel_qty {
    type: number
    sql: (${sr_item_qty} + ${cr_item_qty} + ${wr_item_qty}) / 3.0 ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    synonyms: ["average"]
    description: "Average returned item quantity across store, catalog, and web channels ((sr_item_qty + cr_item_qty + wr_item_qty) / 3.0)."
  }
}
