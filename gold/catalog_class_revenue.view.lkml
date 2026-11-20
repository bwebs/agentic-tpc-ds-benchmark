include: "/silver/explores/catalog_sales.explore.lkml"

view: catalog_class_revenue {
  derived_table: {
    explore_source: catalog_sales {
      bind_filters: {
        from_field: item.i_category
        to_field: item.i_category
      }
      bind_filters: {
        from_field: date_dim.d_date
        to_field: date_dim.d_date
      }
      column: i_class { field: item.i_class }
      column: class_total_revenue { field: catalog_sales.total_ext_sales_price }
      filters: {
        field: catalog_sales.cs_item_sk
        value: "NOT NULL"
      }
      filters: {
        field: item.i_item_sk
        value: "NOT NULL"
      }
      filters: {
        field: catalog_sales.cs_sold_date_sk
        value: "NOT NULL"
      }
      filters: {
        field: date_dim.d_date_sk
        value: "NOT NULL"
      }
    }
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: COALESCE(${i_class}, '__NULL__') ;;
  }

  dimension: i_class {
    hidden: yes
    type: string
    sql: ${TABLE}.i_class ;;
  }

  dimension: class_total_revenue {
    hidden: yes
    type: number
    value_format_name: usd
    sql: ${TABLE}.class_total_revenue ;;
  }

  measure: total_class_revenue {
    type: max
    hidden: yes
    value_format_name: usd
    tags: ["non_additive"]
    description: "Total catalog extended sales revenue across all items in the same class."
    sql: ${class_total_revenue} ;;
  }
}
