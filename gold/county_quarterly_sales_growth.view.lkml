include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"

view: county_quarterly_sales_growth {
  # ponytail: single Gold SDT pivoting store_sales and web_sales Q1..Q3 totals by (ca_county, d_year) in one pass; split into channel-specific quarterly NDTs if reused independently
  derived_table: {
    sql:
      WITH ss AS (
        SELECT
          {{ _sdt_ca.ca_county._sql }} AS ca_county,
          {{ _sdt_d.d_year_num._sql }} AS d_year,
          SUM(IF({{ _sdt_d.d_qoy._sql }} = 1, {{ _sdt_ss.ss_ext_sales_price._sql }}, NULL)) AS ss_q1,
          SUM(IF({{ _sdt_d.d_qoy._sql }} = 2, {{ _sdt_ss.ss_ext_sales_price._sql }}, NULL)) AS ss_q2,
          SUM(IF({{ _sdt_d.d_qoy._sql }} = 3, {{ _sdt_ss.ss_ext_sales_price._sql }}, NULL)) AS ss_q3,
          COUNTIF({{ _sdt_d.d_qoy._sql }} = 1) AS ss_q1_rows,
          COUNTIF({{ _sdt_d.d_qoy._sql }} = 2) AS ss_q2_rows,
          COUNTIF({{ _sdt_d.d_qoy._sql }} = 3) AS ss_q3_rows
        FROM ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_ss._name }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_d._name }}
          ON {{ _sdt_ss.ss_sold_date_sk._sql }} = {{ _sdt_d.d_date_sk._sql }}
        INNER JOIN ${customer_address.SQL_TABLE_NAME} AS {{ _sdt_ca._name }}
          ON {{ _sdt_ss.ss_addr_sk._sql }} = {{ _sdt_ca.ca_address_sk._sql }}
        WHERE {{ _sdt_ca.ca_county._sql }} IS NOT NULL
          AND {{ _sdt_d.d_year_num._sql }} IS NOT NULL
          AND {{ _sdt_d.d_qoy._sql }} IN (1, 2, 3)
        GROUP BY 1, 2
      ),
      ws AS (
        SELECT
          {{ _sdt_ca.ca_county._sql }} AS ca_county,
          {{ _sdt_d.d_year_num._sql }} AS d_year,
          SUM(IF({{ _sdt_d.d_qoy._sql }} = 1, {{ _sdt_ws.ws_ext_sales_price._sql }}, NULL)) AS ws_q1,
          SUM(IF({{ _sdt_d.d_qoy._sql }} = 2, {{ _sdt_ws.ws_ext_sales_price._sql }}, NULL)) AS ws_q2,
          SUM(IF({{ _sdt_d.d_qoy._sql }} = 3, {{ _sdt_ws.ws_ext_sales_price._sql }}, NULL)) AS ws_q3,
          COUNTIF({{ _sdt_d.d_qoy._sql }} = 1) AS ws_q1_rows,
          COUNTIF({{ _sdt_d.d_qoy._sql }} = 2) AS ws_q2_rows,
          COUNTIF({{ _sdt_d.d_qoy._sql }} = 3) AS ws_q3_rows
        FROM ${web_sales.SQL_TABLE_NAME} AS {{ _sdt_ws._name }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_d._name }}
          ON {{ _sdt_ws.ws_sold_date_sk._sql }} = {{ _sdt_d.d_date_sk._sql }}
        INNER JOIN ${customer_address.SQL_TABLE_NAME} AS {{ _sdt_ca._name }}
          ON {{ _sdt_ws.ws_bill_addr_sk._sql }} = {{ _sdt_ca.ca_address_sk._sql }}
        WHERE {{ _sdt_ca.ca_county._sql }} IS NOT NULL
          AND {{ _sdt_d.d_year_num._sql }} IS NOT NULL
          AND {{ _sdt_d.d_qoy._sql }} IN (1, 2, 3)
        GROUP BY 1, 2
      )
      SELECT
        COALESCE(ss.ca_county, ws.ca_county) AS ca_county,
        COALESCE(ss.d_year, ws.d_year) AS d_year,
        ss.ss_q1,
        ss.ss_q2,
        ss.ss_q3,
        ws.ws_q1,
        ws.ws_q2,
        ws.ws_q3,
        COALESCE(ss.ss_q1_rows, 0) AS ss_q1_rows,
        COALESCE(ss.ss_q2_rows, 0) AS ss_q2_rows,
        COALESCE(ss.ss_q3_rows, 0) AS ss_q3_rows,
        COALESCE(ws.ws_q1_rows, 0) AS ws_q1_rows,
        COALESCE(ws.ws_q2_rows, 0) AS ws_q2_rows,
        COALESCE(ws.ws_q3_rows, 0) AS ws_q3_rows
      FROM ss
      FULL OUTER JOIN ws
        ON ss.ca_county = ws.ca_county
        AND ss.d_year = ws.d_year ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${ca_county}, '|', CAST(${d_year} AS STRING)) ;;
  }

  dimension: ca_county {
    type: string
    label: "County"
    description: "Customer address county name (ca_county)."
    synonyms: ["county"]
    sql: ${TABLE}.ca_county ;;
  }

  dimension: d_year {
    type: number
    label: "Calendar Year Number"
    description: "Four-digit calendar year integer (d_year)."
    synonyms: ["year"]
    sql: ${TABLE}.d_year ;;
  }

  dimension: ss_q1 {
    hidden: yes
    type: number
    sql: ${TABLE}.ss_q1 ;;
  }

  dimension: ss_q2 {
    hidden: yes
    type: number
    sql: ${TABLE}.ss_q2 ;;
  }

  dimension: ss_q3 {
    hidden: yes
    type: number
    sql: ${TABLE}.ss_q3 ;;
  }

  dimension: ws_q1 {
    hidden: yes
    type: number
    sql: ${TABLE}.ws_q1 ;;
  }

  dimension: ws_q2 {
    hidden: yes
    type: number
    sql: ${TABLE}.ws_q2 ;;
  }

  dimension: ws_q3 {
    hidden: yes
    type: number
    sql: ${TABLE}.ws_q3 ;;
  }

  dimension: ss_q1_rows {
    hidden: yes
    type: number
    sql: ${TABLE}.ss_q1_rows ;;
  }

  dimension: ss_q2_rows {
    hidden: yes
    type: number
    sql: ${TABLE}.ss_q2_rows ;;
  }

  dimension: ss_q3_rows {
    hidden: yes
    type: number
    sql: ${TABLE}.ss_q3_rows ;;
  }

  dimension: ws_q1_rows {
    hidden: yes
    type: number
    sql: ${TABLE}.ws_q1_rows ;;
  }

  dimension: ws_q2_rows {
    hidden: yes
    type: number
    sql: ${TABLE}.ws_q2_rows ;;
  }

  dimension: ws_q3_rows {
    hidden: yes
    type: number
    sql: ${TABLE}.ws_q3_rows ;;
  }

  measure: count {
    type: count
    description: "Count of county-year rows with Q1..Q3 store or web sales."
  }

  measure: _ss_q1_rows_sum {
    hidden: yes
    type: sum
    sql: ${ss_q1_rows} ;;
  }

  measure: _ss_q2_rows_sum {
    hidden: yes
    type: sum
    sql: ${ss_q2_rows} ;;
  }

  measure: _ss_q3_rows_sum {
    hidden: yes
    type: sum
    sql: ${ss_q3_rows} ;;
  }

  measure: _ws_q1_rows_sum {
    hidden: yes
    type: sum
    sql: ${ws_q1_rows} ;;
  }

  measure: _ws_q2_rows_sum {
    hidden: yes
    type: sum
    sql: ${ws_q2_rows} ;;
  }

  measure: _ws_q3_rows_sum {
    hidden: yes
    type: sum
    sql: ${ws_q3_rows} ;;
  }

  measure: store_sales_q1 {
    type: sum
    sql: ${ss_q1} ;;
    value_format_name: usd
    description: "Total Q1 store extended sales price (SUM(ss_ext_sales_price))."
  }

  measure: store_sales_q2 {
    type: sum
    sql: ${ss_q2} ;;
    value_format_name: usd
    description: "Total Q2 store extended sales price (SUM(ss_ext_sales_price))."
  }

  measure: store_sales_q3 {
    type: sum
    sql: ${ss_q3} ;;
    value_format_name: usd
    description: "Total Q3 store extended sales price (SUM(ss_ext_sales_price))."
  }

  measure: web_sales_q1 {
    type: sum
    sql: ${ws_q1} ;;
    value_format_name: usd
    description: "Total Q1 web extended sales price (SUM(ws_ext_sales_price))."
  }

  measure: web_sales_q2 {
    type: sum
    sql: ${ws_q2} ;;
    value_format_name: usd
    description: "Total Q2 web extended sales price (SUM(ws_ext_sales_price))."
  }

  measure: web_sales_q3 {
    type: sum
    sql: ${ws_q3} ;;
    value_format_name: usd
    description: "Total Q3 web extended sales price (SUM(ws_ext_sales_price))."
  }

  measure: web_q1_q2_increase {
    type: number
    sql: 1.0 * ${web_sales_q2} / NULLIF(${web_sales_q1}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Ratio of Q2 to Q1 web extended sales (ws2.web_sales / ws1.web_sales)."
  }

  measure: store_q1_q2_increase {
    type: number
    sql: 1.0 * ${store_sales_q2} / NULLIF(${store_sales_q1}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Ratio of Q2 to Q1 store extended sales (ss2.store_sales / ss1.store_sales)."
  }

  measure: web_q2_q3_increase {
    type: number
    sql: 1.0 * ${web_sales_q3} / NULLIF(${web_sales_q2}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Ratio of Q3 to Q2 web extended sales (ws3.web_sales / ws2.web_sales)."
  }

  measure: store_q2_q3_increase {
    type: number
    sql: 1.0 * ${store_sales_q3} / NULLIF(${store_sales_q2}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Ratio of Q3 to Q2 store extended sales (ss3.store_sales / ss2.store_sales)."
  }

  measure: is_web_outgrowing_store_q1_to_q3 {
    type: yesno
    label: "Web Outgrowing Store Q1 to Q3"
    tags: ["non_additive"]
    description: "True when Q1, Q2, and Q3 store and web sales rows all exist, Q1 and Q2 totals are positive in both channels, and web sales growth exceeds store sales growth in both Q1->Q2 and Q2->Q3."
    sql: ${_ss_q1_rows_sum} > 0
      AND ${_ss_q2_rows_sum} > 0
      AND ${_ss_q3_rows_sum} > 0
      AND ${_ws_q1_rows_sum} > 0
      AND ${_ws_q2_rows_sum} > 0
      AND ${_ws_q3_rows_sum} > 0
      AND ${web_sales_q1} > 0
      AND ${store_sales_q1} > 0
      AND ${web_sales_q2} > 0
      AND ${store_sales_q2} > 0
      AND ${web_q1_q2_increase} > ${store_q1_q2_increase}
      AND ${web_q2_q3_increase} > ${store_q2_q3_increase} ;;
  }
}
