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
include: "/bronze/store.view.lkml"
include: "/bronze/store.refinement.lkml"
include: "/bronze/customer.view.lkml"
include: "/bronze/customer.refinement.lkml"
include: "/bronze/customer_demographics.view.lkml"
include: "/bronze/customer_demographics.refinement.lkml"
include: "/bronze/promotion.view.lkml"
include: "/bronze/promotion.refinement.lkml"
include: "/bronze/household_demographics.view.lkml"
include: "/bronze/household_demographics.refinement.lkml"
include: "/bronze/customer_address.view.lkml"
include: "/bronze/customer_address.refinement.lkml"
include: "/bronze/income_band.view.lkml"
include: "/bronze/income_band.refinement.lkml"
include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"

view: cross_channel_store_sales_yoy {
  # ponytail: single Gold SDT self-joining cross_sales (cs1 vs cs2 on syear + 1 and cs2.cnt <= cs1.cnt) over cs_ui (>2x catalog sale-to-refund items) and marital-status-changed store returns; split cs_ui or cross_sales into standalone Silver views if non-YoY cross-channel queries reuse them
  derived_table: {
    sql:
      WITH cs_ui AS (
        SELECT
          {{ _sdt_cs.cs_item_sk._sql }} AS cs_item_sk,
          SUM({{ _sdt_cs.cs_ext_list_price._sql }}) AS sale,
          SUM(
            {{ _sdt_cr.cr_refunded_cash._sql }}
            + {{ _sdt_cr.cr_reversed_charge._sql }}
            + {{ _sdt_cr.cr_store_credit._sql }}
          ) AS refund
        FROM ${catalog_sales.SQL_TABLE_NAME} AS {{ _sdt_cs._name }}
        INNER JOIN ${catalog_returns.SQL_TABLE_NAME} AS {{ _sdt_cr._name }}
          ON {{ _sdt_cs.cs_item_sk._sql }} = {{ _sdt_cr.cr_item_sk._sql }}
          AND {{ _sdt_cs.cs_order_number._sql }} = {{ _sdt_cr.cr_order_number._sql }}
        GROUP BY {{ _sdt_cs.cs_item_sk._sql }}
        HAVING SUM({{ _sdt_cs.cs_ext_list_price._sql }}) > 2 * SUM(
          {{ _sdt_cr.cr_refunded_cash._sql }}
          + {{ _sdt_cr.cr_reversed_charge._sql }}
          + {{ _sdt_cr.cr_store_credit._sql }}
        )
      ),
      cross_sales AS (
        SELECT
          {{ _sdt_i.i_product_name._sql }} AS product_name,
          {{ _sdt_i.i_item_sk._sql }} AS item_sk,
          {{ _sdt_i.i_color._sql }} AS i_color,
          {{ _sdt_i.i_current_price._sql }} AS i_current_price,
          {{ _sdt_s.s_store_name._sql }} AS store_name,
          {{ _sdt_s.s_zip._sql }} AS store_zip,
          {{ _sdt_ad1.ca_street_number._sql }} AS b_street_number,
          {{ _sdt_ad1.ca_street_name._sql }} AS b_street_name,
          {{ _sdt_ad1.ca_city._sql }} AS b_city,
          {{ _sdt_ad1.ca_zip._sql }} AS b_zip,
          {{ _sdt_ad2.ca_street_number._sql }} AS c_street_number,
          {{ _sdt_ad2.ca_street_name._sql }} AS c_street_name,
          {{ _sdt_ad2.ca_city._sql }} AS c_city,
          {{ _sdt_ad2.ca_zip._sql }} AS c_zip,
          {{ _sdt_d1.d_year_num._sql }} AS syear,
          {{ _sdt_d2.d_year_num._sql }} AS fsyear,
          {{ _sdt_d3.d_year_num._sql }} AS s2year,
          COUNT(*) AS cnt,
          SUM({{ _sdt_ss.ss_wholesale_cost._sql }}) AS s1,
          SUM({{ _sdt_ss.ss_list_price._sql }}) AS s2,
          SUM({{ _sdt_ss.ss_coupon_amt._sql }}) AS s3
        FROM ${store_sales.SQL_TABLE_NAME} AS {{ _sdt_ss._name }}
        INNER JOIN ${store_returns.SQL_TABLE_NAME} AS {{ _sdt_sr._name }}
          ON {{ _sdt_ss.ss_item_sk._sql }} = {{ _sdt_sr.sr_item_sk._sql }}
          AND {{ _sdt_ss.ss_ticket_number._sql }} = {{ _sdt_sr.sr_ticket_number._sql }}
        INNER JOIN cs_ui
          ON {{ _sdt_ss.ss_item_sk._sql }} = cs_ui.cs_item_sk
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_d1._name }}
          ON {{ _sdt_ss.ss_sold_date_sk._sql }} = {{ _sdt_d1.d_date_sk._sql }}
        INNER JOIN ${store.SQL_TABLE_NAME} AS {{ _sdt_s._name }}
          ON {{ _sdt_ss.ss_store_sk._sql }} = {{ _sdt_s.s_store_sk._sql }}
        INNER JOIN ${customer.SQL_TABLE_NAME} AS {{ _sdt_c._name }}
          ON {{ _sdt_ss.ss_customer_sk._sql }} = {{ _sdt_c.c_customer_sk._sql }}
        INNER JOIN ${customer_demographics.SQL_TABLE_NAME} AS {{ _sdt_cd1._name }}
          ON {{ _sdt_ss.ss_cdemo_sk._sql }} = {{ _sdt_cd1.cd_demo_sk._sql }}
        INNER JOIN ${customer_demographics.SQL_TABLE_NAME} AS {{ _sdt_cd2._name }}
          ON {{ _sdt_c.c_current_cdemo_sk._sql }} = {{ _sdt_cd2.cd_demo_sk._sql }}
        INNER JOIN ${promotion.SQL_TABLE_NAME} AS {{ _sdt_p._name }}
          ON {{ _sdt_ss.ss_promo_sk._sql }} = {{ _sdt_p.p_promo_sk._sql }}
        INNER JOIN ${household_demographics.SQL_TABLE_NAME} AS {{ _sdt_hd1._name }}
          ON {{ _sdt_ss.ss_hdemo_sk._sql }} = {{ _sdt_hd1.hd_demo_sk._sql }}
        INNER JOIN ${household_demographics.SQL_TABLE_NAME} AS {{ _sdt_hd2._name }}
          ON {{ _sdt_c.c_current_hdemo_sk._sql }} = {{ _sdt_hd2.hd_demo_sk._sql }}
        INNER JOIN ${customer_address.SQL_TABLE_NAME} AS {{ _sdt_ad1._name }}
          ON {{ _sdt_ss.ss_addr_sk._sql }} = {{ _sdt_ad1.ca_address_sk._sql }}
        INNER JOIN ${customer_address.SQL_TABLE_NAME} AS {{ _sdt_ad2._name }}
          ON {{ _sdt_c.c_current_addr_sk._sql }} = {{ _sdt_ad2.ca_address_sk._sql }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_d2._name }}
          ON {{ _sdt_c.c_first_sales_date_sk._sql }} = {{ _sdt_d2.d_date_sk._sql }}
        INNER JOIN ${date_dim.SQL_TABLE_NAME} AS {{ _sdt_d3._name }}
          ON {{ _sdt_c.c_first_shipto_date_sk._sql }} = {{ _sdt_d3.d_date_sk._sql }}
        INNER JOIN ${income_band.SQL_TABLE_NAME} AS {{ _sdt_ib1._name }}
          ON {{ _sdt_hd1.hd_income_band_sk._sql }} = {{ _sdt_ib1.ib_income_band_sk._sql }}
        INNER JOIN ${income_band.SQL_TABLE_NAME} AS {{ _sdt_ib2._name }}
          ON {{ _sdt_hd2.hd_income_band_sk._sql }} = {{ _sdt_ib2.ib_income_band_sk._sql }}
        INNER JOIN ${item.SQL_TABLE_NAME} AS {{ _sdt_i._name }}
          ON {{ _sdt_ss.ss_item_sk._sql }} = {{ _sdt_i.i_item_sk._sql }}
        WHERE {{ _sdt_cd1.cd_marital_status._sql }} <> {{ _sdt_cd2.cd_marital_status._sql }}
        GROUP BY
          {{ _sdt_i.i_product_name._sql }},
          {{ _sdt_i.i_item_sk._sql }},
          {{ _sdt_i.i_color._sql }},
          {{ _sdt_i.i_current_price._sql }},
          {{ _sdt_s.s_store_name._sql }},
          {{ _sdt_s.s_zip._sql }},
          {{ _sdt_ad1.ca_street_number._sql }},
          {{ _sdt_ad1.ca_street_name._sql }},
          {{ _sdt_ad1.ca_city._sql }},
          {{ _sdt_ad1.ca_zip._sql }},
          {{ _sdt_ad2.ca_street_number._sql }},
          {{ _sdt_ad2.ca_street_name._sql }},
          {{ _sdt_ad2.ca_city._sql }},
          {{ _sdt_ad2.ca_zip._sql }},
          {{ _sdt_d1.d_year_num._sql }},
          {{ _sdt_d2.d_year_num._sql }},
          {{ _sdt_d3.d_year_num._sql }}
      )
      SELECT
        TO_JSON_STRING(STRUCT(
          cs1.item_sk,
          cs1.store_name,
          cs1.store_zip,
          cs1.syear,
          cs1.fsyear,
          cs1.s2year,
          cs1.b_street_number,
          cs1.b_street_name,
          cs1.b_city,
          cs1.b_zip,
          cs1.c_street_number,
          cs1.c_street_name,
          cs1.c_city,
          cs1.c_zip,
          cs2.fsyear AS cs2_fsyear,
          cs2.s2year AS cs2_s2year,
          cs2.b_street_number AS cs2_b_street_number,
          cs2.b_street_name AS cs2_b_street_name,
          cs2.b_city AS cs2_b_city,
          cs2.b_zip AS cs2_b_zip,
          cs2.c_street_number AS cs2_c_street_number,
          cs2.c_street_name AS cs2_c_street_name,
          cs2.c_city AS cs2_c_city,
          cs2.c_zip AS cs2_c_zip
        )) AS pk,
        cs1.item_sk,
        cs1.i_color,
        cs1.i_current_price,
        cs1.product_name,
        cs1.store_name,
        cs1.store_zip,
        cs1.b_street_number,
        cs1.b_street_name,
        cs1.b_city,
        cs1.b_zip,
        cs1.c_street_number,
        cs1.c_street_name,
        cs1.c_city,
        cs1.c_zip,
        cs1.syear,
        cs1.fsyear,
        cs1.s2year,
        cs1.cnt,
        cs1.s1 AS wholesale_cost_1,
        cs1.s2 AS list_price_1,
        cs1.s3 AS coupon_amt_1,
        cs2.s1 AS wholesale_cost_2,
        cs2.s2 AS list_price_2,
        cs2.s3 AS coupon_amt_2,
        cs2.syear AS comparison_syear,
        cs2.cnt AS comparison_cnt
      FROM cross_sales AS cs1
      INNER JOIN cross_sales AS cs2
        ON cs1.item_sk = cs2.item_sk
        AND cs2.syear = cs1.syear + 1
        AND cs2.cnt <= cs1.cnt
        AND cs1.store_name = cs2.store_name
        AND cs1.store_zip = cs2.store_zip ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: no
    type: string
    label: "Cross-Sales YoY Pair Key"
    description: "Composite JSON key preserving exact Year 1 and Year 2 cross_sales row-pair grain without GROUP BY deduplication."
    sql: ${TABLE}.pk ;;
  }

  dimension: item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    label: "Item SK"
    description: "Item surrogate key shared across Year 1 and Year 2 store sales."
    sql: ${TABLE}.item_sk ;;
  }

  dimension: i_color {
    type: string
    label: "Item Color"
    description: "Item color attribute from item (i_color)."
    sql: ${TABLE}.i_color ;;
  }

  dimension: i_current_price {
    type: number
    value_format_name: usd
    label: "Item Current Price"
    description: "Current retail price of the item (i_current_price)."
    sql: ${TABLE}.i_current_price ;;
  }

  dimension: product_name {
    type: string
    label: "Product Name"
    description: "Product name from item (i_product_name)."
    sql: ${TABLE}.product_name ;;
  }

  dimension: store_name {
    type: string
    label: "Store Name"
    description: "Store name matched across Year 1 and Year 2 (s_store_name)."
    sql: ${TABLE}.store_name ;;
  }

  dimension: store_zip {
    type: string
    label: "Store ZIP"
    description: "Store ZIP code matched across Year 1 and Year 2 (s_zip)."
    sql: ${TABLE}.store_zip ;;
  }

  dimension: b_street_number {
    type: string
    group_label: "Billing Address (At Sale)"
    label: "Billing Street Number"
    description: "Transaction-time customer address street number in Year 1 (ad1.ca_street_number)."
    sql: ${TABLE}.b_street_number ;;
  }

  dimension: b_street_name {
    type: string
    group_label: "Billing Address (At Sale)"
    label: "Billing Street Name"
    description: "Transaction-time customer address street name in Year 1 (ad1.ca_street_name)."
    synonyms: ["b_streen_name"]
    sql: ${TABLE}.b_street_name ;;
  }

  dimension: b_city {
    type: string
    group_label: "Billing Address (At Sale)"
    label: "Billing City"
    description: "Transaction-time customer address city in Year 1 (ad1.ca_city)."
    sql: ${TABLE}.b_city ;;
  }

  dimension: b_zip {
    type: string
    group_label: "Billing Address (At Sale)"
    label: "Billing ZIP"
    description: "Transaction-time customer address ZIP code in Year 1 (ad1.ca_zip)."
    sql: ${TABLE}.b_zip ;;
  }

  dimension: c_street_number {
    type: string
    group_label: "Current Customer Address"
    label: "Current Street Number"
    description: "Current customer address street number in Year 1 (ad2.ca_street_number)."
    sql: ${TABLE}.c_street_number ;;
  }

  dimension: c_street_name {
    type: string
    group_label: "Current Customer Address"
    label: "Current Street Name"
    description: "Current customer address street name in Year 1 (ad2.ca_street_name)."
    sql: ${TABLE}.c_street_name ;;
  }

  dimension: c_city {
    type: string
    group_label: "Current Customer Address"
    label: "Current City"
    description: "Current customer address city in Year 1 (ad2.ca_city)."
    sql: ${TABLE}.c_city ;;
  }

  dimension: c_zip {
    type: string
    group_label: "Current Customer Address"
    label: "Current ZIP"
    description: "Current customer address ZIP code in Year 1 (ad2.ca_zip)."
    sql: ${TABLE}.c_zip ;;
  }

  dimension: syear {
    type: number
    group_label: "Year 1 Store Metrics"
    label: "Year 1 Sale Year"
    description: "Calendar year of Year 1 store sales (cs1.syear)."
    sql: ${TABLE}.syear ;;
  }

  dimension: fsyear {
    type: number
    hidden: yes
    sql: ${TABLE}.fsyear ;;
  }

  dimension: s2year {
    type: number
    hidden: yes
    sql: ${TABLE}.s2year ;;
  }

  dimension: cnt {
    type: number
    group_label: "Year 1 Store Metrics"
    label: "Year 1 Transaction Count"
    description: "Returned store sales line count in Year 1 (cs1.cnt)."
    sql: ${TABLE}.cnt ;;
  }

  dimension: wholesale_cost_1 {
    type: number
    value_format_name: usd
    group_label: "Year 1 Store Metrics"
    label: "Year 1 Wholesale Cost"
    description: "Sum of store wholesale cost in Year 1 (cs1.s1)."
    synonyms: ["s1"]
    sql: ${TABLE}.wholesale_cost_1 ;;
  }

  dimension: list_price_1 {
    type: number
    value_format_name: usd
    group_label: "Year 1 Store Metrics"
    label: "Year 1 List Price"
    description: "Sum of store list price in Year 1 (cs1.s2)."
    synonyms: ["s2"]
    sql: ${TABLE}.list_price_1 ;;
  }

  dimension: coupon_amt_1 {
    type: number
    value_format_name: usd
    group_label: "Year 1 Store Metrics"
    label: "Year 1 Coupon Amount"
    description: "Sum of store coupon amount in Year 1 (cs1.s3)."
    synonyms: ["s3"]
    sql: ${TABLE}.coupon_amt_1 ;;
  }

  dimension: wholesale_cost_2 {
    type: number
    value_format_name: usd
    group_label: "Year 2 Store Metrics"
    label: "Year 2 Wholesale Cost"
    description: "Sum of store wholesale cost in Year 2 (cs2.s1)."
    synonyms: ["s1_"]
    sql: ${TABLE}.wholesale_cost_2 ;;
  }

  dimension: list_price_2 {
    type: number
    value_format_name: usd
    group_label: "Year 2 Store Metrics"
    label: "Year 2 List Price"
    description: "Sum of store list price in Year 2 (cs2.s2)."
    synonyms: ["s2_"]
    sql: ${TABLE}.list_price_2 ;;
  }

  dimension: coupon_amt_2 {
    type: number
    value_format_name: usd
    group_label: "Year 2 Store Metrics"
    label: "Year 2 Coupon Amount"
    description: "Sum of store coupon amount in Year 2 (cs2.s3)."
    synonyms: ["s3_"]
    sql: ${TABLE}.coupon_amt_2 ;;
  }

  dimension: comparison_syear {
    type: number
    group_label: "Year 2 Store Metrics"
    label: "Year 2 Sale Year"
    description: "Comparison calendar year (cs2.syear = cs1.syear + 1)."
    synonyms: ["syear_"]
    sql: ${TABLE}.comparison_syear ;;
  }

  dimension: comparison_cnt {
    type: number
    group_label: "Year 2 Store Metrics"
    label: "Year 2 Transaction Count"
    description: "Returned store sales line count in Year 2 where cs2.cnt <= cs1.cnt."
    synonyms: ["cnt_"]
    sql: ${TABLE}.comparison_cnt ;;
  }

  measure: count {
    type: count
    description: "Count of matched cross-channel year-over-year store sales rows."
  }
}
