include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

view: item_cumulative_web_vs_store_sales {
  # ponytail: single Gold SDT computing per-item daily cumulative web and store sales, FULL OUTER JOIN alignment on (item_sk, d_date), and running MAX cumulative carry-forward; split into separate web/store cumulative NDTs if single-channel running totals are queried independently
  derived_table: {
    sql:
      WITH web_v1 AS (
        SELECT
          {{ _sdt_ws.ws_item_sk._sql }} AS item_sk,
          {{ _sdt_d.d_raw._sql }} AS d_date,
          SUM(SUM({{ _sdt_ws.ws_sales_price._sql }})) OVER (
            PARTITION BY {{ _sdt_ws.ws_item_sk._sql }}
            ORDER BY {{ _sdt_d.d_raw._sql }}
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
          ) AS cume_sales
        FROM ${web_sales.SQL_TABLE_NAME} AS {{ _sdt_ws._name }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_d._name }}
          ON {{ _sdt_ws.ws_sold_date_sk._sql }} = {{ _sdt_d.d_date_sk._sql }}
        WHERE {% condition month_seq_filter %} {{ _sdt_d.d_month_seq._sql }} {% endcondition %}
          AND {{ _sdt_ws.ws_item_sk._sql }} IS NOT NULL
        GROUP BY
          {{ _sdt_ws.ws_item_sk._sql }},
          {{ _sdt_d.d_raw._sql }}
      ),
      store_v1 AS (
        SELECT
          {{ _sdt_ss.ss_item_sk._sql }} AS item_sk,
          {{ _sdt_d.d_raw._sql }} AS d_date,
          SUM(SUM({{ _sdt_ss.ss_sales_price._sql }})) OVER (
            PARTITION BY {{ _sdt_ss.ss_item_sk._sql }}
            ORDER BY {{ _sdt_d.d_raw._sql }}
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
          ) AS cume_sales
        FROM ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_ss._name }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_d._name }}
          ON {{ _sdt_ss.ss_sold_date_sk._sql }} = {{ _sdt_d.d_date_sk._sql }}
        WHERE {% condition month_seq_filter %} {{ _sdt_d.d_month_seq._sql }} {% endcondition %}
          AND {{ _sdt_ss.ss_item_sk._sql }} IS NOT NULL
        GROUP BY
          {{ _sdt_ss.ss_item_sk._sql }},
          {{ _sdt_d.d_raw._sql }}
      )
      SELECT
        item_sk,
        d_date,
        web_sales,
        store_sales,
        MAX(web_sales) OVER (
          PARTITION BY item_sk
          ORDER BY d_date
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS web_cumulative,
        MAX(store_sales) OVER (
          PARTITION BY item_sk
          ORDER BY d_date
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS store_cumulative
      FROM (
        SELECT
          CASE WHEN web.item_sk IS NOT NULL THEN web.item_sk ELSE store.item_sk END AS item_sk,
          CASE WHEN web.d_date IS NOT NULL THEN web.d_date ELSE store.d_date END AS d_date,
          web.cume_sales AS web_sales,
          store.cume_sales AS store_sales
        FROM web_v1 AS web
        FULL OUTER JOIN store_v1 AS store
          ON web.item_sk = store.item_sk
          AND web.d_date = store.d_date
      ) AS x ;;
  }

  filter: month_seq_filter {
    type: number
    label: "Month Sequence Filter"
    description: "Month sequence range (date_dim.d_month_seq) pushed into both web and store cumulative sales subqueries."
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${item_sk} AS STRING), '_', CAST(${d_raw} AS STRING)) ;;
  }

  dimension: item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    label: "Item SK"
    synonyms: ["item"]
    description: "Item surrogate key (ws_item_sk or ss_item_sk)."
    sql: ${TABLE}.item_sk ;;
  }

  dimension_group: d {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    label: "Sale"
    description: "Calendar sale date across web and store channels (d_date)."
    sql: ${TABLE}.d_date ;;
  }

  dimension: web_sales {
    type: number
    value_format_name: usd
    label: "Web Cumulative Sales on Date"
    description: "Cumulative web sales price up to this date on dates with web sales activity; NULL on store-only dates."
    sql: ${TABLE}.web_sales ;;
  }

  dimension: store_sales {
    type: number
    value_format_name: usd
    label: "Store Cumulative Sales on Date"
    description: "Cumulative store sales price up to this date on dates with store sales activity; NULL on web-only dates."
    sql: ${TABLE}.store_sales ;;
  }

  dimension: web_cumulative {
    type: number
    value_format_name: usd
    label: "Web Cumulative Sales"
    description: "Running maximum of cumulative web sales price carried forward across all dates for the item."
    sql: ${TABLE}.web_cumulative ;;
  }

  dimension: store_cumulative {
    type: number
    value_format_name: usd
    label: "Store Cumulative Sales"
    description: "Running maximum of cumulative store sales price carried forward across all dates for the item."
    sql: ${TABLE}.store_cumulative ;;
  }

  dimension: is_web_exceeding_store_cumulative {
    type: yesno
    label: "Web Exceeding Store Cumulative Sales"
    description: "True when running cumulative web sales strictly exceeds running cumulative store sales for the item and date."
    sql: ${web_cumulative} > ${store_cumulative} ;;
  }

  measure: count {
    type: count
    description: "Count of item-date cumulative sales comparison rows."
  }
}
