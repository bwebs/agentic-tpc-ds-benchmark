include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"

view: frequent_item_best_customer_sales {
  # ponytail: single Gold SDT uniting frequent_ss_items, max_store_sales, and best_ss_customer cohorts with catalog/web sales; split into standalone cohort NDTs if reused across other explores
  derived_table: {
    sql:
      WITH frequent_ss_items AS (
        SELECT
          SUBSTR({{ _sdt_item.i_item_desc._sql }}, 1, 30) AS itemdesc,
          {{ _sdt_item.i_item_sk._sql }} AS item_sk,
          {{ _sdt_date_dim.d_raw._sql }} AS solddate,
          COUNT(*) AS cnt
        FROM ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_store_sales._name }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_date_dim._name }}
          ON {{ _sdt_store_sales.ss_sold_date_sk._sql }} = {{ _sdt_date_dim.d_date_sk._sql }}
        INNER JOIN ${item.SQL_TABLE_NAME} AS {{ _sdt_item._name }}
          ON {{ _sdt_store_sales.ss_item_sk._sql }} = {{ _sdt_item.i_item_sk._sql }}
        WHERE {% condition store_cohort_year_filter %} {{ _sdt_date_dim.d_year_num._sql }} {% endcondition %}
        GROUP BY 1, 2, 3
        HAVING COUNT(*) > 4
      ),
      max_store_sales AS (
        SELECT MAX(csales) AS tpcds_cmax
        FROM (
          SELECT
            {{ _sdt_customer.c_customer_sk._sql }} AS c_customer_sk,
            SUM({{ _sdt_store_sales.ss_quantity._sql }} * {{ _sdt_store_sales.ss_sales_price._sql }}) AS csales
          FROM ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_store_sales._name }}
          INNER JOIN ${customer.SQL_TABLE_NAME} AS {{ _sdt_customer._name }}
            ON {{ _sdt_store_sales.ss_customer_sk._sql }} = {{ _sdt_customer.c_customer_sk._sql }}
          INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_date_dim._name }}
            ON {{ _sdt_store_sales.ss_sold_date_sk._sql }} = {{ _sdt_date_dim.d_date_sk._sql }}
          WHERE {% condition store_cohort_year_filter %} {{ _sdt_date_dim.d_year_num._sql }} {% endcondition %}
          GROUP BY 1
        )
      ),
      best_ss_customer AS (
        SELECT
          {{ _sdt_customer.c_customer_sk._sql }} AS c_customer_sk,
          SUM({{ _sdt_store_sales.ss_quantity._sql }} * {{ _sdt_store_sales.ss_sales_price._sql }}) AS ssales
        FROM ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_store_sales._name }}
        INNER JOIN ${customer.SQL_TABLE_NAME} AS {{ _sdt_customer._name }}
          ON {{ _sdt_store_sales.ss_customer_sk._sql }} = {{ _sdt_customer.c_customer_sk._sql }}
        GROUP BY 1
        HAVING SUM({{ _sdt_store_sales.ss_quantity._sql }} * {{ _sdt_store_sales.ss_sales_price._sql }}) > (95 / 100.0) * (SELECT tpcds_cmax FROM max_store_sales)
      )
      SELECT
        IF({{ _sdt_catalog_sales.cs_order_number._sql }} IS NOT NULL, 'catalog', 'catalog') AS channel,
        {{ _sdt_catalog_sales.cs_order_number._sql }} AS order_number,
        {{ _sdt_catalog_sales.cs_item_sk._sql }} AS item_sk,
        {{ _sdt_catalog_sales.cs_bill_customer_sk._sql }} AS bill_customer_sk,
        {{ _sdt_catalog_sales.cs_sold_date_sk._sql }} AS sold_date_sk,
        {{ _sdt_catalog_sales.cs_quantity._sql }} * {{ _sdt_catalog_sales.cs_list_price._sql }} AS sales
      FROM ${catalog_sales.SQL_TABLE_NAME} AS {{ _sdt_catalog_sales._name }}
      WHERE {{ _sdt_catalog_sales.cs_item_sk._sql }} IN (SELECT item_sk FROM frequent_ss_items)
        AND {{ _sdt_catalog_sales.cs_bill_customer_sk._sql }} IN (SELECT c_customer_sk FROM best_ss_customer)
      UNION ALL
      SELECT
        IF({{ _sdt_web_sales.ws_order_number._sql }} IS NOT NULL, 'web', 'web') AS channel,
        {{ _sdt_web_sales.ws_order_number._sql }} AS order_number,
        {{ _sdt_web_sales.ws_item_sk._sql }} AS item_sk,
        {{ _sdt_web_sales.ws_bill_customer_sk._sql }} AS bill_customer_sk,
        {{ _sdt_web_sales.ws_sold_date_sk._sql }} AS sold_date_sk,
        {{ _sdt_web_sales.ws_quantity._sql }} * {{ _sdt_web_sales.ws_list_price._sql }} AS sales
      FROM ${web_sales.SQL_TABLE_NAME} AS {{ _sdt_web_sales._name }}
      WHERE {{ _sdt_web_sales.ws_item_sk._sql }} IN (SELECT item_sk FROM frequent_ss_items)
        AND {{ _sdt_web_sales.ws_bill_customer_sk._sql }} IN (SELECT c_customer_sk FROM best_ss_customer) ;;
  }

  filter: store_cohort_year_filter {
    type: number
    label: "Store Cohort Year Filter"
    description: "Calendar year filter applied to frequent_ss_items and max_store_sales store cohort CTEs."
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${channel}, '_', CAST(${item_sk} AS STRING), '_', CAST(${order_number} AS STRING)) ;;
  }

  dimension: channel {
    type: string
    description: "Sales channel ('catalog' or 'web')."
    sql: ${TABLE}.channel ;;
  }

  dimension: order_number {
    type: number
    value_format_name: id
    sql: ${TABLE}.order_number ;;
  }

  dimension: item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.item_sk ;;
  }

  dimension: bill_customer_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.bill_customer_sk ;;
  }

  dimension: sold_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.sold_date_sk ;;
  }

  dimension: sales {
    type: number
    value_format_name: usd
    description: "Line-item gross list sales (quantity * list_price) across catalog and web channels."
    sql: ${TABLE}.sales ;;
  }

  measure: count {
    type: count
    description: "Count of qualifying catalog and web sales line items."
  }

  measure: total_sales {
    type: sum
    hidden: yes
    sql: ${sales} ;;
    value_format_name: usd
  }

  measure: sum_sales {
    type: number
    sql: CASE WHEN ${count} = 0 THEN NULL ELSE ${total_sales} END ;;
    value_format_name: usd
    tags: ["non_additive"]
    synonyms: ["sales"]
    description: "Sum of catalog and web list sales (quantity * list_price) for frequent store items bought by best store customers, preserving SQL NULL when zero rows qualify."
  }
}
