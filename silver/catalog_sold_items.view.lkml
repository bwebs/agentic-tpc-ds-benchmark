include: "/silver/explores/catalog_sales.explore.lkml"

view: catalog_sold_items {
  derived_table: {
    explore_source: catalog_sales {
      column: cs_item_sk {}
      filters: [catalog_sales.cs_item_sk: "NOT NULL"]
    }
  }

  dimension: cs_item_sk {
    primary_key: yes
    type: number
    value_format_name: id
    description: "Sold catalog item surrogate key (NULL when left-joined item has no catalog sales)."
  }

  dimension: has_catalog_sales {
    type: yesno
    label: "Has Catalog Sales"
    sql: ${cs_item_sk} IS NOT NULL ;;
    description: "Whether the item has at least one catalog sales line item."
  }
}
