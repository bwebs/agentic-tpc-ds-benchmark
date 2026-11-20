include: "/bronze/inventory.view.lkml"
include: "/bronze/inventory.refinement.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/warehouse.view.lkml"
include: "/bronze/warehouse.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

view: inventory_monthly_dispersion_pair {
  # ponytail: single Gold SDT computing high-dispersion (COV > 1) monthly inventory pairs (d_moy -> d_moy + 1) in one SQL pass; split into a general monthly dispersion view if non-paired months or COV <= 1 are needed
  derived_table: {
    sql:
      WITH inv AS (
        SELECT
          w_warehouse_name,
          w_warehouse_sk,
          i_item_sk,
          d_year,
          d_moy,
          stdev,
          mean,
          CASE mean
            WHEN 0 THEN NULL
            ELSE stdev / mean
          END AS cov
        FROM (
          SELECT
            {{ _sdt_w.w_warehouse_name._sql }} AS w_warehouse_name,
            {{ _sdt_w.w_warehouse_sk._sql }} AS w_warehouse_sk,
            {{ _sdt_i.i_item_sk._sql }} AS i_item_sk,
            {{ _sdt_d.d_year_num._sql }} AS d_year,
            {{ _sdt_d.d_moy._sql }} AS d_moy,
            STDDEV_SAMP({{ _sdt_inv.inv_quantity_on_hand._sql }}) AS stdev,
            AVG({{ _sdt_inv.inv_quantity_on_hand._sql }}) AS mean
          FROM ${inventory.SQL_TABLE_NAME} AS {{ _sdt_inv._name }}
          INNER JOIN ${item.SQL_TABLE_NAME} AS {{ _sdt_i._name }}
            ON {{ _sdt_inv.inv_item_sk._sql }} = {{ _sdt_i.i_item_sk._sql }}
          INNER JOIN ${warehouse.SQL_TABLE_NAME} AS {{ _sdt_w._name }}
            ON {{ _sdt_inv.inv_warehouse_sk._sql }} = {{ _sdt_w.w_warehouse_sk._sql }}
          INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_d._name }}
            ON {{ _sdt_inv.inv_date_sk._sql }} = {{ _sdt_d.d_date_sk._sql }}
          GROUP BY 1, 2, 3, 4, 5
        ) AS foo
        WHERE CASE mean
            WHEN 0 THEN 0
            ELSE stdev / mean
          END > 1
      )
      SELECT
        inv1.w_warehouse_name AS w_warehouse_name,
        inv1.w_warehouse_sk AS w_warehouse_sk,
        inv1.i_item_sk AS i_item_sk,
        inv1.d_year AS d_year,
        inv1.d_moy AS d_moy,
        inv1.mean AS mean,
        inv1.cov AS cov,
        inv2.d_moy AS d_moy_2,
        inv2.mean AS mean_2,
        inv2.cov AS cov_2
      FROM inv AS inv1
      INNER JOIN inv AS inv2
        ON inv1.i_item_sk = inv2.i_item_sk
        AND inv1.w_warehouse_sk = inv2.w_warehouse_sk
        AND inv1.d_year = inv2.d_year
        AND inv2.d_moy = inv1.d_moy + 1 ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${w_warehouse_sk} AS STRING), '|', CAST(${i_item_sk} AS STRING), '|', CAST(${d_year} AS STRING), '|', CAST(${d_moy} AS STRING)) ;;
  }

  dimension: w_warehouse_name {
    type: string
    label: "Warehouse Name"
    description: "Warehouse name (w_warehouse_name)."
    sql: ${TABLE}.w_warehouse_name ;;
  }

  dimension: w_warehouse_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    label: "Warehouse SK"
    description: "Warehouse surrogate key (w_warehouse_sk)."
    sql: ${TABLE}.w_warehouse_sk ;;
  }

  dimension: i_item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    label: "Item SK"
    description: "Item surrogate key (i_item_sk)."
    sql: ${TABLE}.i_item_sk ;;
  }

  dimension: d_year {
    type: number
    label: "Calendar Year Number"
    description: "Four-digit calendar year integer (d_year)."
    synonyms: ["year"]
    sql: ${TABLE}.d_year ;;
  }

  dimension: d_moy {
    type: number
    label: "Month of Year"
    description: "Starting month of year integer (1-11) for the consecutive high-dispersion pair (inv1.d_moy)."
    sql: ${TABLE}.d_moy ;;
  }

  dimension: mean {
    type: number
    value_format_name: decimal_4
    label: "Month 1 Mean Quantity on Hand"
    description: "Average inventory quantity on hand in the first month of the consecutive pair (inv1.mean)."
    sql: ${TABLE}.mean ;;
  }

  dimension: cov {
    type: number
    value_format_name: decimal_4
    label: "Month 1 Coefficient of Variation"
    description: "Coefficient of variation (STDDEV_SAMP / AVG) of inventory quantity on hand in the first month (inv1.cov > 1)."
    sql: ${TABLE}.cov ;;
  }

  dimension: d_moy_2 {
    type: number
    label: "Next Month of Year"
    description: "Following consecutive month of year integer (inv1.d_moy + 1) for the high-dispersion pair (inv2.d_moy)."
    sql: ${TABLE}.d_moy_2 ;;
  }

  dimension: mean_2 {
    type: number
    value_format_name: decimal_4
    label: "Month 2 Mean Quantity on Hand"
    description: "Average inventory quantity on hand in the second consecutive month (inv2.mean)."
    sql: ${TABLE}.mean_2 ;;
  }

  dimension: cov_2 {
    type: number
    value_format_name: decimal_4
    label: "Month 2 Coefficient of Variation"
    description: "Coefficient of variation (STDDEV_SAMP / AVG) of inventory quantity on hand in the second consecutive month (inv2.cov > 1)."
    sql: ${TABLE}.cov_2 ;;
  }

  measure: count {
    type: count
    description: "Count of consecutive monthly high-dispersion (COV > 1) warehouse-item pairs."
  }
}
