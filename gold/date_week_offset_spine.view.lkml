include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

view: date_week_offset_spine {
  derived_table: {
    sql:
      SELECT
        {{ _sdt_curr_date.d_date_sk._sql }} AS d_date_sk,
        {{ _sdt_curr_date.d_week_seq._sql }} AS d_week_seq,
        {{ _sdt_curr_date.d_year_num._sql }} AS d_year_num,
        {{ _sdt_next_date.d_date_sk._sql }} AS next_year_d_date_sk,
        {{ _sdt_next_date.d_week_seq._sql }} AS next_year_d_week_seq,
        {{ _sdt_next_date.d_year_num._sql }} AS next_year_d_year_num
      FROM ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_curr_date._name }}
      INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_next_date._name }}
        ON {{ _sdt_curr_date.d_week_seq._sql }} = {{ _sdt_next_date.d_week_seq._sql }} - 53 ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${d_date_sk} AS STRING), '_', CAST(${next_year_d_date_sk} AS STRING)) ;;
  }

  dimension: d_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.d_date_sk ;;
  }

  dimension: d_week_seq {
    type: number
    synonyms: ["d_week_seq1"]
    description: "Current-year week sequence paired against next_year_d_week_seq (+53 weeks)."
    sql: ${TABLE}.d_week_seq ;;
  }

  dimension: d_year_num {
    type: number
    description: "Calendar year integer for the base date in the 53-week offset spine."
    sql: ${TABLE}.d_year_num ;;
  }

  dimension: next_year_d_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.next_year_d_date_sk ;;
  }

  dimension: next_year_d_week_seq {
    type: number
    synonyms: ["d_week_seq2"]
    description: "Comparison week sequence 53 weeks ahead (d_week_seq + 53)."
    sql: ${TABLE}.next_year_d_week_seq ;;
  }

  dimension: next_year_d_year_num {
    type: number
    description: "Calendar year integer for the +53-week comparison date."
    sql: ${TABLE}.next_year_d_year_num ;;
  }
}
