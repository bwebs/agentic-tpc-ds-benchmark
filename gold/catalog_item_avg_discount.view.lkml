include: "/silver/explores/catalog_sales.explore.lkml"

view: catalog_item_avg_discount {
  derived_table: {
    explore_source: catalog_sales {
      bind_filters: {
        from_field: date_dim.d_date
        to_field: date_dim.d_date
      }
      column: cs_item_sk { field: catalog_sales.cs_item_sk }
      column: avg_ext_discount_amt { field: catalog_sales.average_ext_discount_amt }
      filters: {
        field: catalog_sales.cs_item_sk
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

  dimension: cs_item_sk {
    primary_key: yes
    hidden: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.cs_item_sk ;;
  }

  dimension: avg_ext_discount_amt {
    type: number
    value_format_name: usd
    description: "Average extended catalog discount amount for the item within the filtered sold-date window."
    sql: ${TABLE}.avg_ext_discount_amt ;;
  }
}
