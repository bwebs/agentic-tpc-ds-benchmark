include: "/silver/explores/store_sales.explore.lkml"

view: store_item_monthly_sales_rank {
  # ponytail: Liquid-free Gold NDT over store_sales with bind_filters + derived_column RANK() OVER (PARTITION BY i_category, i_class, i_brand, i_product_name ORDER BY sumsales DESC); skipped unused dw3 CTE from query67.sql
  derived_table: {
    explore_source: store_sales {
      bind_filters: {
        from_field: store_item_monthly_sales_rank.month_seq_filter
        to_field: date_dim.d_month_seq
      }
      column: i_category { field: item.i_category }
      column: i_class { field: item.i_class }
      column: i_brand { field: item.i_brand }
      column: i_product_name { field: item.i_product_name }
      column: d_year { field: date_dim.d_year_num }
      column: d_qoy { field: date_dim.d_qoy }
      column: d_moy { field: date_dim.d_moy }
      column: s_store_id { field: store.s_store_id }
      column: sumsales { field: store_sales.total_sales_price_x_quantity }
      derived_column: rk {
        sql: RANK() OVER (PARTITION BY i_category, i_class, i_brand, i_product_name ORDER BY sumsales DESC) ;;
      }
      filters: {
        field: date_dim.d_date_sk
        value: "NOT NULL"
      }
      filters: {
        field: item.i_item_sk
        value: "NOT NULL"
      }
      filters: {
        field: store.s_store_sk
        value: "NOT NULL"
      }
    }
  }

  filter: month_seq_filter {
    type: number
    label: "Month Sequence Filter"
    description: "Filters inner store sales aggregation by date_dim.d_month_seq."
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(COALESCE(${i_category}, ''), '|', COALESCE(${i_class}, ''), '|', COALESCE(${i_brand}, ''), '|', COALESCE(${i_product_name}, ''), '|', COALESCE(CAST(${d_year} AS STRING), ''), '|', COALESCE(CAST(${d_qoy} AS STRING), ''), '|', COALESCE(CAST(${d_moy} AS STRING), ''), '|', COALESCE(${s_store_id}, '')) ;;
  }

  dimension: i_category {
    type: string
    label: "Item Category"
    description: "Item category name (i_category)."
    sql: ${TABLE}.i_category ;;
  }

  dimension: i_class {
    type: string
    label: "Item Class"
    description: "Item class name (i_class)."
    sql: ${TABLE}.i_class ;;
  }

  dimension: i_brand {
    type: string
    label: "Item Brand"
    description: "Item brand name (i_brand)."
    sql: ${TABLE}.i_brand ;;
  }

  dimension: i_product_name {
    type: string
    label: "Item Product Name"
    description: "Item product name (i_product_name)."
    sql: ${TABLE}.i_product_name ;;
  }

  dimension: d_year {
    type: number
    label: "Calendar Year"
    description: "Four-digit calendar year integer (d_year)."
    sql: ${TABLE}.d_year ;;
  }

  dimension: d_qoy {
    type: number
    label: "Quarter of Year"
    description: "Calendar quarter of year integer 1-4 (d_qoy)."
    sql: ${TABLE}.d_qoy ;;
  }

  dimension: d_moy {
    type: number
    label: "Month of Year"
    description: "Calendar month of year integer 1-12 (d_moy)."
    sql: ${TABLE}.d_moy ;;
  }

  dimension: s_store_id {
    type: string
    label: "Store ID"
    description: "Store business identifier (s_store_id)."
    sql: ${TABLE}.s_store_id ;;
  }

  dimension: sumsales {
    type: number
    value_format_name: usd
    label: "Store Item Monthly Sales"
    description: "Total sales price times quantity for the item taxonomy, calendar month, and store (sumsales)."
    sql: ${TABLE}.sumsales ;;
  }

  dimension: rk {
    type: number
    value_format_name: decimal_0
    label: "Product Monthly Store Sales Rank"
    description: "Descending rank of monthly store sales partitioned by item category, class, brand, and product name (rk)."
    sql: ${TABLE}.rk ;;
  }

  measure: count {
    type: count
    description: "Count of ranked item-month-store sales rows."
  }
}
