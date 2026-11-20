include: "/bronze/catalog_returns.view.lkml"
include: "/bronze/catalog_returns.refinement.lkml"
include: "/bronze/catalog_sales.view.lkml"
include: "/bronze/catalog_sales.refinement.lkml"
include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"

view: catalog_returns_catalog_sales_date_dim_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${catalog_sales.pk} ;;
  }

  dimension: net_sales_before_2002_06_01 {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_raw} < DATE '2002-06-01' THEN ${catalog_sales.cs_sales_price} - COALESCE(${catalog_returns.cr_refunded_cash}, 0) ELSE 0 END ;;
  }

  dimension: net_sales_on_or_after_2002_06_01 {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_raw} >= DATE '2002-06-01' THEN ${catalog_sales.cs_sales_price} - COALESCE(${catalog_returns.cr_refunded_cash}, 0) ELSE 0 END ;;
  }

  measure: sales_before {
    type: sum
    sql: ${net_sales_before_2002_06_01} ;;
    value_format_name: usd
    description: "Sum of catalog sales price minus refunded cash (cs_sales_price - COALESCE(cr_refunded_cash, 0)) before 2002-06-01 (0 when no before-cutoff rows match)."
  }

  measure: sales_after {
    type: sum
    sql: ${net_sales_on_or_after_2002_06_01} ;;
    value_format_name: usd
    description: "Sum of catalog sales price minus refunded cash (cs_sales_price - COALESCE(cr_refunded_cash, 0)) on or after 2002-06-01 (0 when no on/after-cutoff rows match)."
  }
}
