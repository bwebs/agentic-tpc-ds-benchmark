include: "/bronze/store_sales.view.lkml"
include: "/bronze/store_sales.refinement.lkml"

view: store_item_profit_rank_pairs {
  # ponytail: single Gold SDT computing eligible store items (AVG(ss_net_profit) > 0.9 * null-cdemo store average) and pairing ascending/descending ranks in one SQL pass; split into an unranked eligible-item NDT/SDT if standalone item-level rankings are queried
  derived_table: {
    sql:
      WITH null_cdemo_benchmark AS (
        SELECT
          AVG({{ _sdt_ss.ss_net_profit._sql }}) AS benchmark_avg_profit
        FROM ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_ss._name }}
        WHERE {% condition store_sk_filter %} {{ _sdt_ss.ss_store_sk._sql }} {% endcondition %}
          AND {{ _sdt_ss.ss_cdemo_sk._sql }} IS NULL
        GROUP BY {{ _sdt_ss.ss_store_sk._sql }}
      ),
      eligible_items AS (
        SELECT
          {{ _sdt_ss.ss_item_sk._sql }} AS item_sk,
          AVG({{ _sdt_ss.ss_net_profit._sql }}) AS rank_col
        FROM ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_ss._name }}
        WHERE {% condition store_sk_filter %} {{ _sdt_ss.ss_store_sk._sql }} {% endcondition %}
        GROUP BY 1
        HAVING AVG({{ _sdt_ss.ss_net_profit._sql }}) > 0.9 * (SELECT benchmark_avg_profit FROM null_cdemo_benchmark)
      ),
      ascending AS (
        SELECT
          item_sk,
          rank_col,
          RANK() OVER (ORDER BY rank_col ASC) AS rnk
        FROM eligible_items
      ),
      descending AS (
        SELECT
          item_sk,
          rank_col,
          RANK() OVER (ORDER BY rank_col DESC) AS rnk
        FROM eligible_items
      )
      SELECT
        ascending.rnk AS rnk,
        ascending.item_sk AS ascending_item_sk,
        ascending.rank_col AS ascending_avg_net_profit,
        descending.item_sk AS descending_item_sk,
        descending.rank_col AS descending_avg_net_profit
      FROM ascending
      INNER JOIN descending
        ON ascending.rnk = descending.rnk ;;
  }

  filter: store_sk_filter {
    type: number
    label: "Store SK Filter"
    description: "Store surrogate key filter applied to both item average net profit and the null-customer-demographics store benchmark."
  }

  dimension: pk {
    primary_key: yes
    type: string
    label: "Rank Item Pair Key"
    description: "Composite primary key combining performance rank, ascending item SK, and descending item SK."
    sql: CONCAT(CAST(${rnk} AS STRING), '_', CAST(${ascending_item_sk} AS STRING), '_', CAST(${descending_item_sk} AS STRING)) ;;
  }

  dimension: rnk {
    type: number
    label: "Performance Rank"
    description: "Shared 1-based performance rank pairing ascending (lowest qualifying net profit) and descending (highest qualifying net profit) items."
    synonyms: ["rank"]
    sql: ${TABLE}.rnk ;;
  }

  dimension: ascending_item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    label: "Ascending Rank Item SK"
    description: "Item surrogate key ranked in ascending order of qualifying average net profit."
    sql: ${TABLE}.ascending_item_sk ;;
  }

  dimension: ascending_avg_net_profit {
    type: number
    value_format_name: usd
    label: "Ascending Rank Avg Net Profit"
    description: "Average store net profit for the item ranked in ascending order."
    sql: ${TABLE}.ascending_avg_net_profit ;;
  }

  dimension: descending_item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    label: "Descending Rank Item SK"
    description: "Item surrogate key ranked in descending order of qualifying average net profit."
    sql: ${TABLE}.descending_item_sk ;;
  }

  dimension: descending_avg_net_profit {
    type: number
    value_format_name: usd
    label: "Descending Rank Avg Net Profit"
    description: "Average store net profit for the item ranked in descending order."
    sql: ${TABLE}.descending_avg_net_profit ;;
  }

  measure: count {
    type: count
    description: "Count of paired best/worst performing item rank rows."
  }
}
