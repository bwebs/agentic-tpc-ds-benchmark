include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/store.view.lkml"
include: "/bronze/store.refinement.lkml"

view: store_weekly_dow_sales_yoy {
  # ponytail: single Gold SDT computing weekly day-of-week store sales and 52-week YoY ratios across two 12-month date_dim windows; split wss into a reusable weekly store sales view if standalone non-YoY weekly day-of-week rollups are needed
  derived_table: {
    sql:
      WITH wss AS (
        SELECT
          {{ _sdt_d.d_week_seq._sql }} AS d_week_seq,
          {{ _sdt_ss.ss_store_sk._sql }} AS ss_store_sk,
          SUM(CASE WHEN ({{ _sdt_d.d_day_name._sql }} = 'Sunday') THEN {{ _sdt_ss.ss_sales_price._sql }} ELSE NULL END) AS sun_sales,
          SUM(CASE WHEN ({{ _sdt_d.d_day_name._sql }} = 'Monday') THEN {{ _sdt_ss.ss_sales_price._sql }} ELSE NULL END) AS mon_sales,
          SUM(CASE WHEN ({{ _sdt_d.d_day_name._sql }} = 'Tuesday') THEN {{ _sdt_ss.ss_sales_price._sql }} ELSE NULL END) AS tue_sales,
          SUM(CASE WHEN ({{ _sdt_d.d_day_name._sql }} = 'Wednesday') THEN {{ _sdt_ss.ss_sales_price._sql }} ELSE NULL END) AS wed_sales,
          SUM(CASE WHEN ({{ _sdt_d.d_day_name._sql }} = 'Thursday') THEN {{ _sdt_ss.ss_sales_price._sql }} ELSE NULL END) AS thu_sales,
          SUM(CASE WHEN ({{ _sdt_d.d_day_name._sql }} = 'Friday') THEN {{ _sdt_ss.ss_sales_price._sql }} ELSE NULL END) AS fri_sales,
          SUM(CASE WHEN ({{ _sdt_d.d_day_name._sql }} = 'Saturday') THEN {{ _sdt_ss.ss_sales_price._sql }} ELSE NULL END) AS sat_sales
        FROM ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_ss._name }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_d._name }}
          ON {{ _sdt_d.d_date_sk._sql }} = {{ _sdt_ss.ss_sold_date_sk._sql }}
        GROUP BY
          {{ _sdt_d.d_week_seq._sql }},
          {{ _sdt_ss.ss_store_sk._sql }}
      ),
      y AS (
        SELECT
          {{ _sdt_s.s_store_sk._sql }} AS y_store_sk,
          {{ _sdt_d.d_date_sk._sql }} AS y_date_sk,
          {{ _sdt_s.s_store_name._sql }} AS s_store_name1,
          wss.d_week_seq AS d_week_seq1,
          {{ _sdt_s.s_store_id._sql }} AS s_store_id1,
          wss.sun_sales AS sun_sales1,
          wss.mon_sales AS mon_sales1,
          wss.tue_sales AS tue_sales1,
          wss.wed_sales AS wed_sales1,
          wss.thu_sales AS thu_sales1,
          wss.fri_sales AS fri_sales1,
          wss.sat_sales AS sat_sales1
        FROM wss
        INNER JOIN ${store.SQL_TABLE_NAME} AS {{ _sdt_s._name }}
          ON wss.ss_store_sk = {{ _sdt_s.s_store_sk._sql }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_d._name }}
          ON {{ _sdt_d.d_week_seq._sql }} = wss.d_week_seq
        WHERE {{ _sdt_d.d_month_seq._sql }} BETWEEN {% parameter start_month_seq %} AND {% parameter start_month_seq %} + 11
      ),
      x AS (
        SELECT
          {{ _sdt_s.s_store_sk._sql }} AS x_store_sk,
          {{ _sdt_d.d_date_sk._sql }} AS x_date_sk,
          {{ _sdt_s.s_store_name._sql }} AS s_store_name2,
          wss.d_week_seq AS d_week_seq2,
          {{ _sdt_s.s_store_id._sql }} AS s_store_id2,
          wss.sun_sales AS sun_sales2,
          wss.mon_sales AS mon_sales2,
          wss.tue_sales AS tue_sales2,
          wss.wed_sales AS wed_sales2,
          wss.thu_sales AS thu_sales2,
          wss.fri_sales AS fri_sales2,
          wss.sat_sales AS sat_sales2
        FROM wss
        INNER JOIN ${store.SQL_TABLE_NAME} AS {{ _sdt_s._name }}
          ON wss.ss_store_sk = {{ _sdt_s.s_store_sk._sql }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_d._name }}
          ON {{ _sdt_d.d_week_seq._sql }} = wss.d_week_seq
        WHERE {{ _sdt_d.d_month_seq._sql }} BETWEEN {% parameter start_month_seq %} + 12 AND {% parameter start_month_seq %} + 23
      )
      SELECT
        y.y_store_sk,
        x.x_store_sk,
        y.y_date_sk,
        x.x_date_sk,
        y.s_store_name1,
        y.s_store_id1,
        y.d_week_seq1,
        x.d_week_seq2,
        y.sun_sales1 / NULLIF(x.sun_sales2, 0) AS sun_sales_ratio,
        y.mon_sales1 / NULLIF(x.mon_sales2, 0) AS mon_sales_ratio,
        y.tue_sales1 / NULLIF(x.tue_sales2, 0) AS tue_sales_ratio,
        y.wed_sales1 / NULLIF(x.wed_sales2, 0) AS wed_sales_ratio,
        y.thu_sales1 / NULLIF(x.thu_sales2, 0) AS thu_sales_ratio,
        y.fri_sales1 / NULLIF(x.fri_sales2, 0) AS fri_sales_ratio,
        y.sat_sales1 / NULLIF(x.sat_sales2, 0) AS sat_sales_ratio
      FROM y
      INNER JOIN x
        ON y.s_store_id1 = x.s_store_id2
        AND y.d_week_seq1 = x.d_week_seq2 - 52 ;;
  }

  parameter: start_month_seq {
    type: number
    default_value: "1196"
    label: "Start Month Sequence"
    description: "Starting d_month_seq for the 12-month Year 1 window (y: start..start+11, compared against Year 2 x: start+12..start+23)."
  }

  dimension: pk {
    primary_key: yes
    hidden: no
    type: string
    label: "Store Week Date Pair Key"
    description: "Composite primary key preserving exact Year 1 and Year 2 store and calendar day pairing grain across matched weeks."
    sql: CONCAT(CAST(${y_store_sk} AS STRING), '|', CAST(${x_store_sk} AS STRING), '|', CAST(${y_date_sk} AS STRING), '|', CAST(${x_date_sk} AS STRING)) ;;
  }

  dimension: y_store_sk {
    type: number
    hidden: yes
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.y_store_sk ;;
  }

  dimension: x_store_sk {
    type: number
    hidden: yes
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.x_store_sk ;;
  }

  dimension: y_date_sk {
    type: number
    hidden: yes
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.y_date_sk ;;
  }

  dimension: x_date_sk {
    type: number
    hidden: yes
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.x_date_sk ;;
  }

  dimension: s_store_name1 {
    type: string
    label: "Store Name"
    description: "Store name in the Year 1 comparison window (s_store_name1)."
    synonyms: ["store name"]
    sql: ${TABLE}.s_store_name1 ;;
  }

  dimension: s_store_id1 {
    type: string
    label: "Store ID"
    description: "Store business identifier shared across Year 1 and Year 2 windows (s_store_id1)."
    synonyms: ["store id"]
    sql: ${TABLE}.s_store_id1 ;;
  }

  dimension: d_week_seq1 {
    type: number
    label: "Year 1 Week Sequence"
    description: "Week sequence number in the Year 1 window (d_week_seq1 = d_week_seq2 - 52)."
    synonyms: ["week sequence"]
    sql: ${TABLE}.d_week_seq1 ;;
  }

  dimension: d_week_seq2 {
    type: number
    label: "Year 2 Week Sequence"
    description: "Comparison week sequence number 52 weeks later in Year 2 (d_week_seq2)."
    sql: ${TABLE}.d_week_seq2 ;;
  }

  dimension: sun_sales_ratio {
    type: number
    value_format_name: decimal_4
    tags: ["non_additive"]
    group_label: "Day-of-Week YoY Sales Ratios"
    label: "Sunday Sales YoY Ratio"
    description: "Ratio of Year 1 to Year 2 Sunday store sales price (sun_sales1 / sun_sales2)."
    sql: ${TABLE}.sun_sales_ratio ;;
  }

  dimension: mon_sales_ratio {
    type: number
    value_format_name: decimal_4
    tags: ["non_additive"]
    group_label: "Day-of-Week YoY Sales Ratios"
    label: "Monday Sales YoY Ratio"
    description: "Ratio of Year 1 to Year 2 Monday store sales price (mon_sales1 / mon_sales2)."
    sql: ${TABLE}.mon_sales_ratio ;;
  }

  dimension: tue_sales_ratio {
    type: number
    value_format_name: decimal_4
    tags: ["non_additive"]
    group_label: "Day-of-Week YoY Sales Ratios"
    label: "Tuesday Sales YoY Ratio"
    description: "Ratio of Year 1 to Year 2 Tuesday store sales price (tue_sales1 / tue_sales2)."
    sql: ${TABLE}.tue_sales_ratio ;;
  }

  dimension: wed_sales_ratio {
    type: number
    value_format_name: decimal_4
    tags: ["non_additive"]
    group_label: "Day-of-Week YoY Sales Ratios"
    label: "Wednesday Sales YoY Ratio"
    description: "Ratio of Year 1 to Year 2 Wednesday store sales price (wed_sales1 / wed_sales2)."
    sql: ${TABLE}.wed_sales_ratio ;;
  }

  dimension: thu_sales_ratio {
    type: number
    value_format_name: decimal_4
    tags: ["non_additive"]
    group_label: "Day-of-Week YoY Sales Ratios"
    label: "Thursday Sales YoY Ratio"
    description: "Ratio of Year 1 to Year 2 Thursday store sales price (thu_sales1 / thu_sales2)."
    sql: ${TABLE}.thu_sales_ratio ;;
  }

  dimension: fri_sales_ratio {
    type: number
    value_format_name: decimal_4
    tags: ["non_additive"]
    group_label: "Day-of-Week YoY Sales Ratios"
    label: "Friday Sales YoY Ratio"
    description: "Ratio of Year 1 to Year 2 Friday store sales price (fri_sales1 / fri_sales2)."
    sql: ${TABLE}.fri_sales_ratio ;;
  }

  dimension: sat_sales_ratio {
    type: number
    value_format_name: decimal_4
    tags: ["non_additive"]
    group_label: "Day-of-Week YoY Sales Ratios"
    label: "Saturday Sales YoY Ratio"
    description: "Ratio of Year 1 to Year 2 Saturday store sales price (sat_sales1 / sat_sales2)."
    sql: ${TABLE}.sat_sales_ratio ;;
  }

  measure: count {
    type: count
    description: "Count of Year 1 vs Year 2 matched store-week-day rows."
  }
}
