include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/web_returns.view.lkml"
include: "/bronze/web_returns.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/catalog_returns.view.lkml"
include: "/bronze/catalog_returns.refinement.lkml"
include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/store_returns.view.lkml"
include: "/bronze/store_returns.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

view: channel_item_return_rankings {
  # ponytail: single 3-channel UNION ALL Gold SDT computing per-channel return_ratio, currency_ratio, return_rank, and currency_rank in one pass; split into per-channel NDTs if unranked channel aggregates are needed elsewhere
  derived_table: {
    sql:
      WITH in_web AS (
        SELECT
          IF({{ _sdt_ws.pk._sql }} IS NOT NULL, 'web', 'web') AS channel,
          {{ _sdt_ws.ws_item_sk._sql }} AS item_sk,
          SUM(COALESCE({{ _sdt_wr.wr_return_quantity._sql }}, 0)) / SUM(COALESCE({{ _sdt_ws.ws_quantity._sql }}, 0)) AS return_ratio,
          SUM(COALESCE({{ _sdt_wr.wr_return_amt._sql }}, 0)) / SUM(COALESCE({{ _sdt_ws.ws_net_paid._sql }}, 0)) AS currency_ratio
        FROM ${web_sales.SQL_TABLE_NAME} AS {{ _sdt_ws._name }}
        LEFT OUTER JOIN ${web_returns.SQL_TABLE_NAME} AS {{ _sdt_wr._name }}
          ON {{ _sdt_ws.ws_order_number._sql }} = {{ _sdt_wr.wr_order_number._sql }}
          AND {{ _sdt_ws.ws_item_sk._sql }} = {{ _sdt_wr.wr_item_sk._sql }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_d._name }}
          ON {{ _sdt_ws.ws_sold_date_sk._sql }} = {{ _sdt_d.d_date_sk._sql }}
        WHERE {{ _sdt_wr.wr_return_amt._sql }} > 10000
          AND {{ _sdt_ws.ws_net_profit._sql }} > 1
          AND {{ _sdt_ws.ws_net_paid._sql }} > 0
          AND {{ _sdt_ws.ws_quantity._sql }} > 0
          AND {% condition year_filter %} {{ _sdt_d.d_year_num._sql }} {% endcondition %}
          AND {% condition month_filter %} {{ _sdt_d.d_moy._sql }} {% endcondition %}
        GROUP BY 1, 2
      ),
      in_cat AS (
        SELECT
          IF({{ _sdt_cs.pk._sql }} IS NOT NULL, 'catalog', 'catalog') AS channel,
          {{ _sdt_cs.cs_item_sk._sql }} AS item_sk,
          SUM(COALESCE({{ _sdt_cr.cr_return_quantity._sql }}, 0)) / SUM(COALESCE({{ _sdt_cs.cs_quantity._sql }}, 0)) AS return_ratio,
          SUM(COALESCE({{ _sdt_cr.cr_return_amount._sql }}, 0)) / SUM(COALESCE({{ _sdt_cs.cs_net_paid._sql }}, 0)) AS currency_ratio
        FROM ${catalog_sales.SQL_TABLE_NAME} AS {{ _sdt_cs._name }}
        LEFT OUTER JOIN ${catalog_returns.SQL_TABLE_NAME} AS {{ _sdt_cr._name }}
          ON {{ _sdt_cs.cs_order_number._sql }} = {{ _sdt_cr.cr_order_number._sql }}
          AND {{ _sdt_cs.cs_item_sk._sql }} = {{ _sdt_cr.cr_item_sk._sql }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_d._name }}
          ON {{ _sdt_cs.cs_sold_date_sk._sql }} = {{ _sdt_d.d_date_sk._sql }}
        WHERE {{ _sdt_cr.cr_return_amount._sql }} > 10000
          AND {{ _sdt_cs.cs_net_profit._sql }} > 1
          AND {{ _sdt_cs.cs_net_paid._sql }} > 0
          AND {{ _sdt_cs.cs_quantity._sql }} > 0
          AND {% condition year_filter %} {{ _sdt_d.d_year_num._sql }} {% endcondition %}
          AND {% condition month_filter %} {{ _sdt_d.d_moy._sql }} {% endcondition %}
        GROUP BY 1, 2
      ),
      in_store AS (
        SELECT
          IF({{ _sdt_ss.pk._sql }} IS NOT NULL, 'store', 'store') AS channel,
          {{ _sdt_ss.ss_item_sk._sql }} AS item_sk,
          SUM(COALESCE({{ _sdt_sr.sr_return_quantity._sql }}, 0)) / SUM(COALESCE({{ _sdt_ss.ss_quantity._sql }}, 0)) AS return_ratio,
          SUM(COALESCE({{ _sdt_sr.sr_return_amt._sql }}, 0)) / SUM(COALESCE({{ _sdt_ss.ss_net_paid._sql }}, 0)) AS currency_ratio
        FROM ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_ss._name }}
        LEFT OUTER JOIN ${store_returns.SQL_TABLE_NAME} AS {{ _sdt_sr._name }}
          ON {{ _sdt_ss.ss_ticket_number._sql }} = {{ _sdt_sr.sr_ticket_number._sql }}
          AND {{ _sdt_ss.ss_item_sk._sql }} = {{ _sdt_sr.sr_item_sk._sql }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_d._name }}
          ON {{ _sdt_ss.ss_sold_date_sk._sql }} = {{ _sdt_d.d_date_sk._sql }}
        WHERE {{ _sdt_sr.sr_return_amt._sql }} > 10000
          AND {{ _sdt_ss.ss_net_profit._sql }} > 1
          AND {{ _sdt_ss.ss_net_paid._sql }} > 0
          AND {{ _sdt_ss.ss_quantity._sql }} > 0
          AND {% condition year_filter %} {{ _sdt_d.d_year_num._sql }} {% endcondition %}
          AND {% condition month_filter %} {{ _sdt_d.d_moy._sql }} {% endcondition %}
        GROUP BY 1, 2
      )
      SELECT
        channel,
        item_sk,
        return_ratio,
        currency_ratio,
        RANK() OVER (ORDER BY return_ratio ASC) AS return_rank,
        RANK() OVER (ORDER BY currency_ratio ASC) AS currency_rank
      FROM in_web
      UNION ALL
      SELECT
        channel,
        item_sk,
        return_ratio,
        currency_ratio,
        RANK() OVER (ORDER BY return_ratio ASC) AS return_rank,
        RANK() OVER (ORDER BY currency_ratio ASC) AS currency_rank
      FROM in_cat
      UNION ALL
      SELECT
        channel,
        item_sk,
        return_ratio,
        currency_ratio,
        RANK() OVER (ORDER BY return_ratio ASC) AS return_rank,
        RANK() OVER (ORDER BY currency_ratio ASC) AS currency_rank
      FROM in_store ;;
  }

  filter: year_filter {
    type: number
    label: "Sold Year Filter"
    description: "Calendar year filter (date_dim.d_year) pushed into each channel sales-return cohort."
  }

  filter: month_filter {
    type: number
    label: "Sold Month Filter"
    description: "Calendar month of year filter (date_dim.d_moy) pushed into each channel sales-return cohort."
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${channel}, '_', CAST(${item_sk} AS STRING)) ;;
  }

  dimension: channel {
    type: string
    label: "Sales Channel"
    description: "Sales channel ('web', 'catalog', or 'store')."
    sql: ${TABLE}.channel ;;
  }

  dimension: item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    label: "Item SK"
    synonyms: ["item"]
    description: "Item surrogate key (ws_item_sk, cs_item_sk, or ss_item_sk)."
    sql: ${TABLE}.item_sk ;;
  }

  dimension: return_ratio {
    type: number
    value_format_name: decimal_4
    label: "Quantity Return Ratio"
    description: "Ratio of returned quantity to sold quantity for qualifying sales and returns."
    sql: ${TABLE}.return_ratio ;;
  }

  dimension: currency_ratio {
    type: number
    value_format_name: decimal_4
    label: "Currency Return Ratio"
    description: "Ratio of returned currency amount to net paid amount for qualifying sales and returns."
    sql: ${TABLE}.currency_ratio ;;
  }

  dimension: return_rank {
    type: number
    value_format_name: decimal_0
    label: "Quantity Return Rank"
    description: "Ascending within-channel rank by quantity return ratio."
    sql: ${TABLE}.return_rank ;;
  }

  dimension: currency_rank {
    type: number
    value_format_name: decimal_0
    label: "Currency Return Rank"
    description: "Ascending within-channel rank by currency return ratio."
    sql: ${TABLE}.currency_rank ;;
  }

  measure: count {
    type: count
    description: "Count of ranked channel-item return records."
  }
}
