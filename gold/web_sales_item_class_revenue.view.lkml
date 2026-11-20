include: "/silver/explores/web_sales.explore.lkml"

view: web_sales_item_class_revenue {
  derived_table: {
    explore_source: web_sales {
      bind_filters: {
        from_field: web_sales_item_class_revenue.category_filter
        to_field: item.i_category
      }
      bind_filters: {
        from_field: web_sales_item_class_revenue.sold_date_filter
        to_field: date_dim.d_date
      }
      column: i_item_id { field: item.i_item_id }
      column: i_item_desc { field: item.i_item_desc }
      column: i_category { field: item.i_category }
      column: i_class { field: item.i_class }
      column: i_current_price { field: item.i_current_price }
      column: item_revenue { field: web_sales.total_ext_sales_price }
      derived_column: class_total_revenue {
        sql: SUM(item_revenue) OVER (PARTITION BY i_class) ;;
      }
      filters: {
        field: web_sales.ws_item_sk
        value: "NOT NULL"
      }
      filters: {
        field: item.i_item_sk
        value: "NOT NULL"
      }
      filters: {
        field: web_sales.ws_sold_date_sk
        value: "NOT NULL"
      }
      filters: {
        field: date_dim.d_date_sk
        value: "NOT NULL"
      }
    }
  }

  filter: category_filter {
    type: string
    label: "Item Category Filter"
    description: "Filters inner web sales item aggregation by item.i_category."
  }

  filter: sold_date_filter {
    type: date
    label: "Sold Date Filter"
    description: "Filters inner web sales item aggregation by date_dim.d_date."
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(COALESCE(${i_item_id}, ''), '|', COALESCE(${i_item_desc}, ''), '|', COALESCE(${i_category}, ''), '|', COALESCE(${i_class}, ''), '|', COALESCE(CAST(${i_current_price} AS STRING), '')) ;;
  }

  dimension: i_item_id {
    type: string
    label: "Item ID"
    description: "Business item identifier (i_item_id)."
    sql: ${TABLE}.i_item_id ;;
  }

  dimension: i_item_desc {
    type: string
    label: "Item Description"
    description: "Item description text (i_item_desc)."
    sql: ${TABLE}.i_item_desc ;;
  }

  dimension: i_category {
    type: string
    label: "Item Category"
    description: "Item product category (i_category)."
    sql: ${TABLE}.i_category ;;
  }

  dimension: i_class {
    type: string
    label: "Item Class"
    description: "Item product class within category (i_class)."
    sql: ${TABLE}.i_class ;;
  }

  dimension: i_current_price {
    type: number
    value_format_name: usd
    label: "Current Price"
    description: "Current retail price of the item (i_current_price)."
    sql: ${TABLE}.i_current_price ;;
  }

  dimension: item_revenue {
    hidden: yes
    type: number
    value_format_name: usd
    sql: ${TABLE}.item_revenue ;;
  }

  dimension: class_total_revenue {
    hidden: yes
    type: number
    value_format_name: usd
    sql: ${TABLE}.class_total_revenue ;;
  }

  measure: count {
    type: count
    description: "Count of grouped item rows in the filtered window."
  }

  measure: total_item_revenue {
    type: sum
    value_format_name: usd
    label: "Item Revenue"
    synonyms: ["itemrevenue"]
    description: "Total web extended sales revenue for the item group."
    sql: ${item_revenue} ;;
  }

  measure: total_class_revenue {
    type: max
    hidden: yes
    value_format_name: usd
    tags: ["non_additive"]
    description: "Total web extended sales revenue across all items in the same class."
    sql: ${class_total_revenue} ;;
  }

  measure: revenue_ratio {
    type: number
    value_format_name: percent_2
    label: "Class Revenue Share"
    synonyms: ["revenueratio"]
    tags: ["non_additive"]
    description: "Share of item web sales revenue within its item class (item_revenue / class_total_revenue)."
    sql: ${total_item_revenue} / NULLIF(${total_class_revenue}, 0) ;;
  }
}
