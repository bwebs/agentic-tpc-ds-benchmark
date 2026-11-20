include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/store_returns.view.lkml"
include: "/bronze/store_returns.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"

view: store_return_catalog_repurchase {
  derived_table: {
    sql:
      SELECT
        {{ _sdt_ss.ss_item_sk._sql }} AS ss_item_sk,
        {{ _sdt_ss.ss_ticket_number._sql }} AS ss_ticket_number,
        {{ _sdt_ss.ss_customer_sk._sql }} AS ss_customer_sk,
        {{ _sdt_ss.ss_store_sk._sql }} AS ss_store_sk,
        {{ _sdt_ss.ss_sold_date_sk._sql }} AS ss_sold_date_sk,
        {{ _sdt_ss.ss_quantity._sql }} AS ss_quantity,
        {{ _sdt_ss.ss_net_profit._sql }} AS ss_net_profit,
        {{ _sdt_sr.sr_returned_date_sk._sql }} AS sr_returned_date_sk,
        {{ _sdt_sr.sr_return_quantity._sql }} AS sr_return_quantity,
        {{ _sdt_sr.sr_net_loss._sql }} AS sr_net_loss,
        {{ _sdt_cs.cs_order_number._sql }} AS cs_order_number,
        {{ _sdt_cs.cs_sold_date_sk._sql }} AS cs_sold_date_sk,
        {{ _sdt_cs.cs_quantity._sql }} AS cs_quantity,
        {{ _sdt_cs.cs_net_profit._sql }} AS cs_net_profit
      FROM ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_ss._name }}
      INNER JOIN ${store_returns.SQL_TABLE_NAME} AS {{ _sdt_sr._name }}
        ON {{ _sdt_ss.ss_customer_sk._sql }} = {{ _sdt_sr.sr_customer_sk._sql }}
        AND {{ _sdt_ss.ss_item_sk._sql }} = {{ _sdt_sr.sr_item_sk._sql }}
        AND {{ _sdt_ss.ss_ticket_number._sql }} = {{ _sdt_sr.sr_ticket_number._sql }}
      INNER JOIN ${catalog_sales.SQL_TABLE_NAME} AS {{ _sdt_cs._name }}
        ON {{ _sdt_sr.sr_customer_sk._sql }} = {{ _sdt_cs.cs_bill_customer_sk._sql }}
        AND {{ _sdt_sr.sr_item_sk._sql }} = {{ _sdt_cs.cs_item_sk._sql }} ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${ss_item_sk} AS STRING), '_', CAST(${ss_ticket_number} AS STRING), '_', CAST(${cs_order_number} AS STRING)) ;;
  }

  dimension: ss_item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ss_item_sk ;;
  }

  dimension: ss_ticket_number {
    type: number
    value_format_name: id
    sql: ${TABLE}.ss_ticket_number ;;
  }

  dimension: ss_customer_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ss_customer_sk ;;
  }

  dimension: ss_store_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ss_store_sk ;;
  }

  dimension: ss_sold_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ss_sold_date_sk ;;
  }

  dimension: ss_quantity {
    type: number
    description: "Store sales line item quantity on matched return-and-catalog-repurchase pairs."
    sql: ${TABLE}.ss_quantity ;;
  }

  dimension: sr_returned_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.sr_returned_date_sk ;;
  }

  dimension: sr_return_quantity {
    type: number
    description: "Store return quantity on matched return-and-catalog-repurchase pairs."
    sql: ${TABLE}.sr_return_quantity ;;
  }

  dimension: cs_order_number {
    type: number
    value_format_name: id
    sql: ${TABLE}.cs_order_number ;;
  }

  dimension: cs_sold_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.cs_sold_date_sk ;;
  }

  dimension: cs_quantity {
    type: number
    description: "Subsequent catalog sales order quantity on matched return-and-catalog-repurchase pairs."
    sql: ${TABLE}.cs_quantity ;;
  }

  dimension: ss_net_profit {
    type: number
    value_format_name: usd
    description: "Store sales net profit on matched return-and-catalog-repurchase pairs."
    sql: ${TABLE}.ss_net_profit ;;
  }

  dimension: sr_net_loss {
    type: number
    value_format_name: usd
    description: "Store return net loss on matched return-and-catalog-repurchase pairs."
    sql: ${TABLE}.sr_net_loss ;;
  }

  dimension: cs_net_profit {
    type: number
    value_format_name: usd
    description: "Subsequent catalog sales net profit on matched return-and-catalog-repurchase pairs."
    sql: ${TABLE}.cs_net_profit ;;
  }

  measure: count {
    type: count
    description: "Count of matched store-sale, store-return, and catalog-repurchase pairs."
  }

  # --- Store Sales Quantity Dispersion ---
  measure: store_sales_quantity_count {
    type: count
    filters: [ss_quantity: "NOT NULL"]
    description: "Non-null count of store sales quantity across matched pairs (COUNT(ss_quantity))."
    synonyms: ["store_sales_quantitycount"]
  }

  measure: average_store_sales_quantity {
    type: average
    sql: ${ss_quantity} ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Average store sales quantity across matched pairs (AVG(ss_quantity))."
    synonyms: ["store_sales_quantityave"]
  }

  measure: _ss_quantity_sum {
    hidden: yes
    type: sum
    sql: ${ss_quantity} ;;
  }

  measure: _ss_quantity_sum_of_squares {
    hidden: yes
    type: sum
    sql: POWER(${ss_quantity}, 2) ;;
  }

  measure: stddev_store_sales_quantity {
    type: number
    sql: SQRT(GREATEST(${_ss_quantity_sum_of_squares} - (POWER(${_ss_quantity_sum}, 2) / NULLIF(${store_sales_quantity_count}, 0)), 0) / NULLIF(${store_sales_quantity_count} - 1, 0)) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Sample standard deviation of store sales quantity across matched pairs (STDDEV_SAMP(ss_quantity))."
    synonyms: ["store_sales_quantitystdev"]
  }

  measure: cov_store_sales_quantity {
    type: number
    sql: 1.0 * ${stddev_store_sales_quantity} / NULLIF(${average_store_sales_quantity}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Coefficient of variation of store sales quantity (STDDEV_SAMP(ss_quantity) / AVG(ss_quantity))."
    synonyms: ["store_sales_quantitycov"]
  }

  # --- Store Returns Quantity Dispersion ---
  measure: store_returns_quantity_count {
    type: count
    filters: [sr_return_quantity: "NOT NULL"]
    description: "Non-null count of store return quantity across matched pairs (COUNT(sr_return_quantity))."
    synonyms: ["store_returns_quantitycount"]
  }

  measure: average_store_returns_quantity {
    type: average
    sql: ${sr_return_quantity} ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Average store return quantity across matched pairs (AVG(sr_return_quantity))."
    synonyms: ["store_returns_quantityave"]
  }

  measure: _sr_return_quantity_sum {
    hidden: yes
    type: sum
    sql: ${sr_return_quantity} ;;
  }

  measure: _sr_return_quantity_sum_of_squares {
    hidden: yes
    type: sum
    sql: POWER(${sr_return_quantity}, 2) ;;
  }

  measure: stddev_store_returns_quantity {
    type: number
    sql: SQRT(GREATEST(${_sr_return_quantity_sum_of_squares} - (POWER(${_sr_return_quantity_sum}, 2) / NULLIF(${store_returns_quantity_count}, 0)), 0) / NULLIF(${store_returns_quantity_count} - 1, 0)) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Sample standard deviation of store return quantity across matched pairs (STDDEV_SAMP(sr_return_quantity))."
    synonyms: ["store_returns_quantitystdev"]
  }

  measure: cov_store_returns_quantity {
    type: number
    sql: 1.0 * ${stddev_store_returns_quantity} / NULLIF(${average_store_returns_quantity}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Coefficient of variation of store return quantity (STDDEV_SAMP(sr_return_quantity) / AVG(sr_return_quantity))."
    synonyms: ["store_returns_quantitycov"]
  }

  # --- Catalog Sales Quantity Dispersion ---
  measure: catalog_sales_quantity_count {
    type: count
    filters: [cs_quantity: "NOT NULL"]
    description: "Non-null count of catalog sales quantity across matched pairs (COUNT(cs_quantity))."
    synonyms: ["catalog_sales_quantitycount"]
  }

  measure: average_catalog_sales_quantity {
    type: average
    sql: ${cs_quantity} ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Average catalog sales quantity across matched pairs (AVG(cs_quantity))."
    synonyms: ["catalog_sales_quantityave"]
  }

  measure: _cs_quantity_sum {
    hidden: yes
    type: sum
    sql: ${cs_quantity} ;;
  }

  measure: _cs_quantity_sum_of_squares {
    hidden: yes
    type: sum
    sql: POWER(${cs_quantity}, 2) ;;
  }

  measure: stddev_catalog_sales_quantity {
    type: number
    sql: SQRT(GREATEST(${_cs_quantity_sum_of_squares} - (POWER(${_cs_quantity_sum}, 2) / NULLIF(${catalog_sales_quantity_count}, 0)), 0) / NULLIF(${catalog_sales_quantity_count} - 1, 0)) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Sample standard deviation of catalog sales quantity across matched pairs (STDDEV_SAMP(cs_quantity))."
  }

  measure: cov_catalog_sales_quantity {
    type: number
    sql: 1.0 * ${stddev_catalog_sales_quantity} / NULLIF(${average_catalog_sales_quantity}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Coefficient of variation of catalog sales quantity (STDDEV_SAMP(cs_quantity) / AVG(cs_quantity))."
    synonyms: ["catalog_sales_quantitycov", "catalog_sales_quantitystdev"]
  }

  # --- Max Profit and Loss Metrics (Query 25) ---
  measure: max_store_sales_profit {
    type: max
    sql: ${ss_net_profit} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Maximum store sales net profit across matched pairs (MAX(ss_net_profit))."
    synonyms: ["store_sales_profit"]
  }

  measure: max_store_returns_loss {
    type: max
    sql: ${sr_net_loss} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Maximum store returns net loss across matched pairs (MAX(sr_net_loss))."
    synonyms: ["store_returns_loss"]
  }

  measure: max_catalog_sales_profit {
    type: max
    sql: ${cs_net_profit} ;;
    value_format_name: usd
    tags: ["non_additive"]
    description: "Maximum catalog sales net profit across matched pairs (MAX(cs_net_profit))."
    synonyms: ["catalog_sales_profit"]
  }
}
