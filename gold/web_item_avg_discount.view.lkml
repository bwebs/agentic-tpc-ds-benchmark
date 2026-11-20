include: "/silver/explores/web_sales.explore.lkml"

view: web_item_avg_discount {
  derived_table: {
    explore_source: web_sales {
      bind_filters: {
        from_field: date_dim.d_date
        to_field: date_dim.d_date
      }
      column: ws_item_sk { field: web_sales.ws_item_sk }
      column: avg_ext_discount_amt { field: web_sales.average_ext_discount_amt }
      filters: {
        field: web_sales.ws_item_sk
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

  dimension: ws_item_sk {
    primary_key: yes
    hidden: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.ws_item_sk ;;
  }

  dimension: avg_ext_discount_amt {
    type: number
    value_format_name: usd
    description: "Average extended web sales discount amount for the item within the filtered sold-date window."
    sql: ${TABLE}.avg_ext_discount_amt ;;
  }
}
