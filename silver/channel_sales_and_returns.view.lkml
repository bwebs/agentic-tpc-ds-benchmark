include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/store_returns.view.lkml"
include: "/bronze/store_returns.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/catalog_returns.view.lkml"
include: "/bronze/catalog_returns.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/web_returns.view.lkml"
include: "/bronze/web_returns.refinement.lkml"

view: channel_sales_and_returns {
  derived_table: {
    sql:
      SELECT
        'store channel' AS channel,
        'sale' AS record_type,
        {{ _sdt_store_sales.ss_item_sk._sql }} AS item_sk,
        {{ _sdt_store_sales.ss_ticket_number._sql }} AS order_number,
        {{ _sdt_store_sales.ss_store_sk._sql }} AS store_sk,
        CAST(NULL AS INT64) AS catalog_page_sk,
        CAST(NULL AS INT64) AS web_site_sk,
        {{ _sdt_store_sales.ss_sold_date_sk._sql }} AS date_sk,
        {{ _sdt_store_sales.ss_ext_sales_price._sql }} AS sales_price,
        0 AS return_amt,
        {{ _sdt_store_sales.ss_net_profit._sql }} AS profit,
        0 AS net_loss
      FROM ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_store_sales._name }}
      UNION ALL
      SELECT
        'store channel' AS channel,
        'return' AS record_type,
        {{ _sdt_store_returns.sr_item_sk._sql }} AS item_sk,
        {{ _sdt_store_returns.sr_ticket_number._sql }} AS order_number,
        {{ _sdt_store_returns.sr_store_sk._sql }} AS store_sk,
        CAST(NULL AS INT64) AS catalog_page_sk,
        CAST(NULL AS INT64) AS web_site_sk,
        {{ _sdt_store_returns.sr_returned_date_sk._sql }} AS date_sk,
        0 AS sales_price,
        {{ _sdt_store_returns.sr_return_amt._sql }} AS return_amt,
        0 AS profit,
        {{ _sdt_store_returns.sr_net_loss._sql }} AS net_loss
      FROM ${store_returns.SQL_TABLE_NAME} AS {{ _sdt_store_returns._name }}
      UNION ALL
      SELECT
        'catalog channel' AS channel,
        'sale' AS record_type,
        {{ _sdt_catalog_sales.cs_item_sk._sql }} AS item_sk,
        {{ _sdt_catalog_sales.cs_order_number._sql }} AS order_number,
        CAST(NULL AS INT64) AS store_sk,
        {{ _sdt_catalog_sales.cs_catalog_page_sk._sql }} AS catalog_page_sk,
        CAST(NULL AS INT64) AS web_site_sk,
        {{ _sdt_catalog_sales.cs_sold_date_sk._sql }} AS date_sk,
        {{ _sdt_catalog_sales.cs_ext_sales_price._sql }} AS sales_price,
        0 AS return_amt,
        {{ _sdt_catalog_sales.cs_net_profit._sql }} AS profit,
        0 AS net_loss
      FROM ${catalog_sales.SQL_TABLE_NAME} AS {{ _sdt_catalog_sales._name }}
      UNION ALL
      SELECT
        'catalog channel' AS channel,
        'return' AS record_type,
        {{ _sdt_catalog_returns.cr_item_sk._sql }} AS item_sk,
        {{ _sdt_catalog_returns.cr_order_number._sql }} AS order_number,
        CAST(NULL AS INT64) AS store_sk,
        {{ _sdt_catalog_returns.cr_catalog_page_sk._sql }} AS catalog_page_sk,
        CAST(NULL AS INT64) AS web_site_sk,
        {{ _sdt_catalog_returns.cr_returned_date_sk._sql }} AS date_sk,
        0 AS sales_price,
        {{ _sdt_catalog_returns.cr_return_amount._sql }} AS return_amt,
        0 AS profit,
        {{ _sdt_catalog_returns.cr_net_loss._sql }} AS net_loss
      FROM ${catalog_returns.SQL_TABLE_NAME} AS {{ _sdt_catalog_returns._name }}
      UNION ALL
      SELECT
        'web channel' AS channel,
        'sale' AS record_type,
        {{ _sdt_web_sales.ws_item_sk._sql }} AS item_sk,
        {{ _sdt_web_sales.ws_order_number._sql }} AS order_number,
        CAST(NULL AS INT64) AS store_sk,
        CAST(NULL AS INT64) AS catalog_page_sk,
        {{ _sdt_web_sales.ws_web_site_sk._sql }} AS web_site_sk,
        {{ _sdt_web_sales.ws_sold_date_sk._sql }} AS date_sk,
        {{ _sdt_web_sales.ws_ext_sales_price._sql }} AS sales_price,
        0 AS return_amt,
        {{ _sdt_web_sales.ws_net_profit._sql }} AS profit,
        0 AS net_loss
      FROM ${web_sales.SQL_TABLE_NAME} AS {{ _sdt_web_sales._name }}
      UNION ALL
      SELECT
        'web channel' AS channel,
        'return' AS record_type,
        {{ _sdt_web_returns.wr_item_sk._sql }} AS item_sk,
        {{ _sdt_web_returns.wr_order_number._sql }} AS order_number,
        CAST(NULL AS INT64) AS store_sk,
        CAST(NULL AS INT64) AS catalog_page_sk,
        {{ _sdt_web_sales.ws_web_site_sk._sql }} AS web_site_sk,
        {{ _sdt_web_returns.wr_returned_date_sk._sql }} AS date_sk,
        0 AS sales_price,
        {{ _sdt_web_returns.wr_return_amt._sql }} AS return_amt,
        0 AS profit,
        {{ _sdt_web_returns.wr_net_loss._sql }} AS net_loss
      FROM ${web_returns.SQL_TABLE_NAME} AS {{ _sdt_web_returns._name }}
      LEFT OUTER JOIN ${web_sales.SQL_TABLE_NAME} AS {{ _sdt_web_sales._name }}
        ON {{ _sdt_web_returns.wr_item_sk._sql }} = {{ _sdt_web_sales.ws_item_sk._sql }}
        AND {{ _sdt_web_returns.wr_order_number._sql }} = {{ _sdt_web_sales.ws_order_number._sql }} ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${channel}, '_', ${record_type}, '_', CAST(${item_sk} AS STRING), '_', CAST(${order_number} AS STRING)) ;;
  }

  dimension: channel {
    type: string
    description: "Retail channel label ('store channel', 'catalog channel', or 'web channel')."
    sql: ${TABLE}.channel ;;
  }

  dimension: record_type {
    type: string
    description: "Transaction line type ('sale' or 'return')."
    sql: ${TABLE}.record_type ;;
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

  dimension: store_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.store_sk ;;
  }

  dimension: catalog_page_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.catalog_page_sk ;;
  }

  dimension: web_site_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.web_site_sk ;;
  }

  dimension: date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.date_sk ;;
  }

  dimension: sales_price {
    type: number
    value_format_name: usd
    description: "Extended sales price on sales rows (0 on return rows)."
    sql: ${TABLE}.sales_price ;;
  }

  dimension: return_amt {
    type: number
    value_format_name: usd
    description: "Return amount on return rows (0 on sales rows)."
    sql: ${TABLE}.return_amt ;;
  }

  dimension: profit {
    type: number
    value_format_name: usd
    description: "Net profit on sales rows (0 on return rows)."
    sql: ${TABLE}.profit ;;
  }

  dimension: net_loss {
    type: number
    value_format_name: usd
    description: "Net loss on return rows (0 on sales rows)."
    sql: ${TABLE}.net_loss ;;
  }

  dimension: has_sales_price {
    hidden: yes
    type: number
    sql: IF(${sales_price} IS NOT NULL, 1, 0) ;;
  }

  dimension: has_return_amt {
    hidden: yes
    type: number
    sql: IF(${return_amt} IS NOT NULL, 1, 0) ;;
  }

  dimension: has_profit {
    hidden: yes
    type: number
    sql: IF(${profit} IS NOT NULL, 1, 0) ;;
  }

  dimension: has_net_loss {
    hidden: yes
    type: number
    sql: IF(${net_loss} IS NOT NULL, 1, 0) ;;
  }

  measure: count {
    type: count
    description: "Count of unified channel sales and return line items."
  }

  measure: _sales_sum {
    hidden: yes
    type: sum
    sql: ${sales_price} ;;
  }

  measure: _sales_nonnull_count {
    hidden: yes
    type: sum
    sql: ${has_sales_price} ;;
  }

  measure: total_sales {
    type: number
    sql: IF(${_sales_nonnull_count} > 0, ${_sales_sum}, NULL) ;;
    value_format_name: usd
    tags: ["non_additive"]
    synonyms: ["sales"]
    description: "Total extended sales price across store, catalog, and web channels (NULL when all rows have NULL sales_price)."
  }

  measure: _returns_sum {
    hidden: yes
    type: sum
    sql: ${return_amt} ;;
  }

  measure: _returns_nonnull_count {
    hidden: yes
    type: sum
    sql: ${has_return_amt} ;;
  }

  measure: total_returns {
    type: number
    sql: IF(${_returns_nonnull_count} > 0, ${_returns_sum}, NULL) ;;
    value_format_name: usd
    tags: ["non_additive"]
    synonyms: ["returns1", "returns"]
    description: "Total return amount across store, catalog, and web channels (NULL when all rows have NULL return_amt)."
  }

  measure: _profit_sum {
    hidden: yes
    type: sum
    sql: ${profit} ;;
  }

  measure: _profit_nonnull_count {
    hidden: yes
    type: sum
    sql: ${has_profit} ;;
  }

  measure: _net_loss_sum {
    hidden: yes
    type: sum
    sql: ${net_loss} ;;
  }

  measure: _net_loss_nonnull_count {
    hidden: yes
    type: sum
    sql: ${has_net_loss} ;;
  }

  measure: total_net_profit {
    type: number
    sql: IF(${_profit_nonnull_count} > 0 AND ${_net_loss_nonnull_count} > 0, ${_profit_sum} - ${_net_loss_sum}, NULL) ;;
    value_format_name: usd
    tags: ["non_additive"]
    synonyms: ["profit"]
    description: "Total net profit after subtracting return net losses across store, catalog, and web channels."
  }
}
