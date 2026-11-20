include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"
include: "/bronze/store.view.lkml"
include: "/bronze/store.refinement.lkml"

view: customer_post_online_store_revenue_segments {
  # ponytail: single customer-grain Gold SDT uniting catalog/web cohort selection with 3-month local store follow-on revenue; split my_customers into a standalone cohort view if reused across other explores
  derived_table: {
    sql:
      WITH my_customers AS (
        SELECT DISTINCT
          {{ _sdt_customer.c_customer_sk._sql }} AS c_customer_sk,
          {{ _sdt_customer.c_current_addr_sk._sql }} AS c_current_addr_sk
        FROM (
          SELECT
            {{ _sdt_catalog_sales.cs_sold_date_sk._sql }} AS sold_date_sk,
            {{ _sdt_catalog_sales.cs_bill_customer_sk._sql }} AS customer_sk,
            {{ _sdt_catalog_sales.cs_item_sk._sql }} AS item_sk
          FROM ${catalog_sales.SQL_TABLE_NAME} AS {{ _sdt_catalog_sales._name }}
          UNION ALL
          SELECT
            {{ _sdt_web_sales.ws_sold_date_sk._sql }} AS sold_date_sk,
            {{ _sdt_web_sales.ws_bill_customer_sk._sql }} AS customer_sk,
            {{ _sdt_web_sales.ws_item_sk._sql }} AS item_sk
          FROM ${web_sales.SQL_TABLE_NAME} AS {{ _sdt_web_sales._name }}
        ) AS cs_or_ws_sales
        INNER JOIN ${item.SQL_TABLE_NAME} AS {{ _sdt_item._name }}
          ON cs_or_ws_sales.item_sk = {{ _sdt_item.i_item_sk._sql }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_date_dim._name }}
          ON cs_or_ws_sales.sold_date_sk = {{ _sdt_date_dim.d_date_sk._sql }}
        INNER JOIN ${customer.SQL_TABLE_NAME} AS {{ _sdt_customer._name }}
          ON cs_or_ws_sales.customer_sk = {{ _sdt_customer.c_customer_sk._sql }}
        WHERE {% condition category_filter %} {{ _sdt_item.i_category._sql }} {% endcondition %}
          AND {% condition class_filter %} {{ _sdt_item.i_class._sql }} {% endcondition %}
          AND {% condition cohort_month_filter %} {{ _sdt_date_dim.d_moy._sql }} {% endcondition %}
          AND {% condition cohort_year_filter %} {{ _sdt_date_dim.d_year_num._sql }} {% endcondition %}
      ),
      my_revenue AS (
        SELECT
          my_customers.c_customer_sk,
          SUM({{ _sdt_store_sales.ss_ext_sales_price._sql }}) AS revenue
        FROM my_customers
        INNER JOIN ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_store_sales._name }}
          ON my_customers.c_customer_sk = {{ _sdt_store_sales.ss_customer_sk._sql }}
        INNER JOIN ${customer_address.SQL_TABLE_NAME} AS {{ _sdt_customer_address._name }}
          ON my_customers.c_current_addr_sk = {{ _sdt_customer_address.ca_address_sk._sql }}
        INNER JOIN ${store.SQL_TABLE_NAME} AS {{ _sdt_store._name }}
          ON {{ _sdt_customer_address.ca_county._sql }} = {{ _sdt_store.s_county._sql }}
          AND {{ _sdt_customer_address.ca_state._sql }} = {{ _sdt_store.s_state._sql }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_date_dim._name }}
          ON {{ _sdt_store_sales.ss_sold_date_sk._sql }} = {{ _sdt_date_dim.d_date_sk._sql }}
        WHERE {{ _sdt_date_dim.d_month_seq._sql }} BETWEEN (
            SELECT MIN({{ _sdt_date_dim.d_month_seq._sql }}) + 1
            FROM ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_date_dim._name }}
            WHERE {% condition cohort_year_filter %} {{ _sdt_date_dim.d_year_num._sql }} {% endcondition %}
              AND {% condition cohort_month_filter %} {{ _sdt_date_dim.d_moy._sql }} {% endcondition %}
          ) AND (
            SELECT MAX({{ _sdt_date_dim.d_month_seq._sql }}) + 3
            FROM ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_date_dim._name }}
            WHERE {% condition cohort_year_filter %} {{ _sdt_date_dim.d_year_num._sql }} {% endcondition %}
              AND {% condition cohort_month_filter %} {{ _sdt_date_dim.d_moy._sql }} {% endcondition %}
          )
        GROUP BY 1
      )
      SELECT
        c_customer_sk,
        FLOOR(revenue / 50) AS segment
      FROM my_revenue ;;
  }

  filter: cohort_year_filter {
    type: number
    label: "Cohort Year Filter"
    description: "Calendar year (date_dim.d_year) of initial catalog or web cohort purchase."
  }

  filter: cohort_month_filter {
    type: number
    label: "Cohort Month Filter"
    description: "Calendar month number 1-12 (date_dim.d_moy) of initial catalog or web cohort purchase."
  }

  filter: category_filter {
    type: string
    label: "Item Category Filter"
    description: "Item category (item.i_category) of initial catalog or web cohort purchase."
  }

  filter: class_filter {
    type: string
    label: "Item Class Filter"
    description: "Item class (item.i_class) of initial catalog or web cohort purchase."
  }

  dimension: c_customer_sk {
    primary_key: yes
    type: number
    value_format_name: id
    description: "Qualifying customer surrogate key."
    sql: ${TABLE}.c_customer_sk ;;
  }

  dimension: segment {
    type: number
    value_format_name: decimal_0
    description: "Floor $50 revenue segment index (FLOOR(revenue / 50)) over the 3 months following the online/catalog cohort purchase."
    sql: ${TABLE}.segment ;;
  }

  dimension: segment_base {
    type: number
    value_format_name: decimal_0
    description: "Lower dollar bound of the $50 revenue segment (segment * 50)."
    sql: ${segment} * 50 ;;
  }

  measure: num_customers {
    type: count
    description: "Number of qualifying customers in the post-online store revenue segment."
    synonyms: ["customer_count"]
  }
}
