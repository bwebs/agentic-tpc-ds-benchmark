include: "/bronze/web_sales.view.lkml"
include: "/bronze/web_sales.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/warehouse.view.lkml"
include: "/bronze/warehouse.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/time_dim.view.lkml"
include: "/bronze/time_dim.refinement.lkml"
include: "/bronze/ship_mode.view.lkml"
include: "/bronze/ship_mode.refinement.lkml"

view: web_catalog_warehouse_sales {
  derived_table: {
    sql:
      SELECT
        'web' AS channel,
        {{ _sdt_web_sales.ws_item_sk._sql }} AS item_sk,
        {{ _sdt_web_sales.ws_order_number._sql }} AS order_number,
        {{ _sdt_web_sales.ws_warehouse_sk._sql }} AS warehouse_sk,
        {{ _sdt_web_sales.ws_sold_date_sk._sql }} AS sold_date_sk,
        {{ _sdt_web_sales.ws_sold_time_sk._sql }} AS sold_time_sk,
        {{ _sdt_web_sales.ws_ship_mode_sk._sql }} AS ship_mode_sk,
        {{ _sdt_web_sales.ws_ext_sales_price._sql }} * {{ _sdt_web_sales.ws_quantity._sql }} AS line_sales,
        {{ _sdt_web_sales.ws_net_paid_inc_ship._sql }} * {{ _sdt_web_sales.ws_quantity._sql }} AS line_net
      FROM ${web_sales.SQL_TABLE_NAME} AS {{ _sdt_web_sales._name }}
      UNION ALL
      SELECT
        'catalog' AS channel,
        {{ _sdt_catalog_sales.cs_item_sk._sql }} AS item_sk,
        {{ _sdt_catalog_sales.cs_order_number._sql }} AS order_number,
        {{ _sdt_catalog_sales.cs_warehouse_sk._sql }} AS warehouse_sk,
        {{ _sdt_catalog_sales.cs_sold_date_sk._sql }} AS sold_date_sk,
        {{ _sdt_catalog_sales.cs_sold_time_sk._sql }} AS sold_time_sk,
        {{ _sdt_catalog_sales.cs_ship_mode_sk._sql }} AS ship_mode_sk,
        {{ _sdt_catalog_sales.cs_ext_sales_price._sql }} * {{ _sdt_catalog_sales.cs_quantity._sql }} AS line_sales,
        {{ _sdt_catalog_sales.cs_net_paid._sql }} * {{ _sdt_catalog_sales.cs_quantity._sql }} AS line_net
      FROM ${catalog_sales.SQL_TABLE_NAME} AS {{ _sdt_catalog_sales._name }} ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${channel}, '_', CAST(${item_sk} AS STRING), '_', CAST(${order_number} AS STRING)) ;;
  }

  dimension: channel {
    type: string
    description: "Sales channel ('web' or 'catalog')."
    sql: ${TABLE}.channel ;;
  }

  dimension: item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.item_sk ;;
  }

  dimension: order_number {
    type: number
    value_format_name: id
    sql: ${TABLE}.order_number ;;
  }

  dimension: warehouse_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.warehouse_sk ;;
  }

  dimension: sold_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.sold_date_sk ;;
  }

  dimension: sold_time_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.sold_time_sk ;;
  }

  dimension: ship_mode_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.ship_mode_sk ;;
  }

  dimension: line_sales {
    type: number
    value_format_name: usd
    description: "Extended sales price multiplied by quantity."
    sql: ${TABLE}.line_sales ;;
  }

  dimension: line_net {
    type: number
    value_format_name: usd
    description: "Net paid (including shipping on web, net paid on catalog) multiplied by quantity."
    sql: ${TABLE}.line_net ;;
  }

  dimension: _jan_sales_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 1 THEN ${line_sales} ELSE 0 END ;;
  }

  measure: jan_sales {
    type: sum
    sql: ${_jan_sales_val} ;;
    value_format_name: usd
    description: "January combined web and catalog sales (0 when no January sales)."
  }

  dimension: _feb_sales_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 2 THEN ${line_sales} ELSE 0 END ;;
  }

  measure: feb_sales {
    type: sum
    sql: ${_feb_sales_val} ;;
    value_format_name: usd
    description: "February combined web and catalog sales (0 when no February sales)."
  }

  dimension: _mar_sales_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 3 THEN ${line_sales} ELSE 0 END ;;
  }

  measure: mar_sales {
    type: sum
    sql: ${_mar_sales_val} ;;
    value_format_name: usd
    description: "March combined web and catalog sales (0 when no March sales)."
  }

  dimension: _apr_sales_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 4 THEN ${line_sales} ELSE 0 END ;;
  }

  measure: apr_sales {
    type: sum
    sql: ${_apr_sales_val} ;;
    value_format_name: usd
    description: "April combined web and catalog sales (0 when no April sales)."
  }

  dimension: _may_sales_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 5 THEN ${line_sales} ELSE 0 END ;;
  }

  measure: may_sales {
    type: sum
    sql: ${_may_sales_val} ;;
    value_format_name: usd
    description: "May combined web and catalog sales (0 when no May sales)."
  }

  dimension: _jun_sales_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 6 THEN ${line_sales} ELSE 0 END ;;
  }

  measure: jun_sales {
    type: sum
    sql: ${_jun_sales_val} ;;
    value_format_name: usd
    description: "June combined web and catalog sales (0 when no June sales)."
  }

  dimension: _jul_sales_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 7 THEN ${line_sales} ELSE 0 END ;;
  }

  measure: jul_sales {
    type: sum
    sql: ${_jul_sales_val} ;;
    value_format_name: usd
    description: "July combined web and catalog sales (0 when no July sales)."
  }

  dimension: _aug_sales_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 8 THEN ${line_sales} ELSE 0 END ;;
  }

  measure: aug_sales {
    type: sum
    sql: ${_aug_sales_val} ;;
    value_format_name: usd
    description: "August combined web and catalog sales (0 when no August sales)."
  }

  dimension: _sep_sales_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 9 THEN ${line_sales} ELSE 0 END ;;
  }

  measure: sep_sales {
    type: sum
    sql: ${_sep_sales_val} ;;
    value_format_name: usd
    description: "September combined web and catalog sales (0 when no September sales)."
  }

  dimension: _oct_sales_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 10 THEN ${line_sales} ELSE 0 END ;;
  }

  measure: oct_sales {
    type: sum
    sql: ${_oct_sales_val} ;;
    value_format_name: usd
    description: "October combined web and catalog sales (0 when no October sales)."
  }

  dimension: _nov_sales_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 11 THEN ${line_sales} ELSE 0 END ;;
  }

  measure: nov_sales {
    type: sum
    sql: ${_nov_sales_val} ;;
    value_format_name: usd
    description: "November combined web and catalog sales (0 when no November sales)."
  }

  dimension: _dec_sales_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 12 THEN ${line_sales} ELSE 0 END ;;
  }

  measure: dec_sales {
    type: sum
    sql: ${_dec_sales_val} ;;
    value_format_name: usd
    description: "December combined web and catalog sales (0 when no December sales)."
  }

  measure: jan_sales_per_sq_foot {
    type: number
    sql: ${web_catalog_warehouse_sales.jan_sales} / NULLIF(${warehouse.max_warehouse_sq_ft}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "January combined web and catalog sales per warehouse square foot."
  }

  measure: feb_sales_per_sq_foot {
    type: number
    sql: ${web_catalog_warehouse_sales.feb_sales} / NULLIF(${warehouse.max_warehouse_sq_ft}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "February combined web and catalog sales per warehouse square foot."
  }

  measure: mar_sales_per_sq_foot {
    type: number
    sql: ${web_catalog_warehouse_sales.mar_sales} / NULLIF(${warehouse.max_warehouse_sq_ft}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "March combined web and catalog sales per warehouse square foot."
  }

  measure: apr_sales_per_sq_foot {
    type: number
    sql: ${web_catalog_warehouse_sales.apr_sales} / NULLIF(${warehouse.max_warehouse_sq_ft}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "April combined web and catalog sales per warehouse square foot."
  }

  measure: may_sales_per_sq_foot {
    type: number
    sql: ${web_catalog_warehouse_sales.may_sales} / NULLIF(${warehouse.max_warehouse_sq_ft}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "May combined web and catalog sales per warehouse square foot."
  }

  measure: jun_sales_per_sq_foot {
    type: number
    sql: ${web_catalog_warehouse_sales.jun_sales} / NULLIF(${warehouse.max_warehouse_sq_ft}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "June combined web and catalog sales per warehouse square foot."
  }

  measure: jul_sales_per_sq_foot {
    type: number
    sql: ${web_catalog_warehouse_sales.jul_sales} / NULLIF(${warehouse.max_warehouse_sq_ft}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "July combined web and catalog sales per warehouse square foot."
  }

  measure: aug_sales_per_sq_foot {
    type: number
    sql: ${web_catalog_warehouse_sales.aug_sales} / NULLIF(${warehouse.max_warehouse_sq_ft}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "August combined web and catalog sales per warehouse square foot."
  }

  measure: sep_sales_per_sq_foot {
    type: number
    sql: ${web_catalog_warehouse_sales.sep_sales} / NULLIF(${warehouse.max_warehouse_sq_ft}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "September combined web and catalog sales per warehouse square foot."
  }

  measure: oct_sales_per_sq_foot {
    type: number
    sql: ${web_catalog_warehouse_sales.oct_sales} / NULLIF(${warehouse.max_warehouse_sq_ft}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "October combined web and catalog sales per warehouse square foot."
  }

  measure: nov_sales_per_sq_foot {
    type: number
    sql: ${web_catalog_warehouse_sales.nov_sales} / NULLIF(${warehouse.max_warehouse_sq_ft}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "November combined web and catalog sales per warehouse square foot."
  }

  measure: dec_sales_per_sq_foot {
    type: number
    sql: ${web_catalog_warehouse_sales.dec_sales} / NULLIF(${warehouse.max_warehouse_sq_ft}, 0) ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "December combined web and catalog sales per warehouse square foot."
  }

  dimension: _jan_net_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 1 THEN ${line_net} ELSE 0 END ;;
  }

  measure: jan_net {
    type: sum
    sql: ${_jan_net_val} ;;
    value_format_name: usd
    description: "January combined web and catalog net paid (0 when no January sales)."
  }

  dimension: _feb_net_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 2 THEN ${line_net} ELSE 0 END ;;
  }

  measure: feb_net {
    type: sum
    sql: ${_feb_net_val} ;;
    value_format_name: usd
    description: "February combined web and catalog net paid (0 when no February sales)."
  }

  dimension: _mar_net_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 3 THEN ${line_net} ELSE 0 END ;;
  }

  measure: mar_net {
    type: sum
    sql: ${_mar_net_val} ;;
    value_format_name: usd
    description: "March combined web and catalog net paid (0 when no March sales)."
  }

  dimension: _apr_net_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 4 THEN ${line_net} ELSE 0 END ;;
  }

  measure: apr_net {
    type: sum
    sql: ${_apr_net_val} ;;
    value_format_name: usd
    description: "April combined web and catalog net paid (0 when no April sales)."
  }

  dimension: _may_net_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 5 THEN ${line_net} ELSE 0 END ;;
  }

  measure: may_net {
    type: sum
    sql: ${_may_net_val} ;;
    value_format_name: usd
    description: "May combined web and catalog net paid (0 when no May sales)."
  }

  dimension: _jun_net_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 6 THEN ${line_net} ELSE 0 END ;;
  }

  measure: jun_net {
    type: sum
    sql: ${_jun_net_val} ;;
    value_format_name: usd
    description: "June combined web and catalog net paid (0 when no June sales)."
  }

  dimension: _jul_net_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 7 THEN ${line_net} ELSE 0 END ;;
  }

  measure: jul_net {
    type: sum
    sql: ${_jul_net_val} ;;
    value_format_name: usd
    description: "July combined web and catalog net paid (0 when no July sales)."
  }

  dimension: _aug_net_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 8 THEN ${line_net} ELSE 0 END ;;
  }

  measure: aug_net {
    type: sum
    sql: ${_aug_net_val} ;;
    value_format_name: usd
    description: "August combined web and catalog net paid (0 when no August sales)."
  }

  dimension: _sep_net_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 9 THEN ${line_net} ELSE 0 END ;;
  }

  measure: sep_net {
    type: sum
    sql: ${_sep_net_val} ;;
    value_format_name: usd
    description: "September combined web and catalog net paid (0 when no September sales)."
  }

  dimension: _oct_net_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 10 THEN ${line_net} ELSE 0 END ;;
  }

  measure: oct_net {
    type: sum
    sql: ${_oct_net_val} ;;
    value_format_name: usd
    description: "October combined web and catalog net paid (0 when no October sales)."
  }

  dimension: _nov_net_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 11 THEN ${line_net} ELSE 0 END ;;
  }

  measure: nov_net {
    type: sum
    sql: ${_nov_net_val} ;;
    value_format_name: usd
    description: "November combined web and catalog net paid (0 when no November sales)."
  }

  dimension: _dec_net_val {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_moy} = 12 THEN ${line_net} ELSE 0 END ;;
  }

  measure: dec_net {
    type: sum
    sql: ${_dec_net_val} ;;
    value_format_name: usd
    description: "December combined web and catalog net paid (0 when no December sales)."
  }

  measure: count {
    type: count
    description: "Count of web and catalog warehouse sales line items."
  }
}
