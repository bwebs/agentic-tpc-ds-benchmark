include: "catalog_sales.view.lkml"

view: +catalog_sales {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${cs_item_sk} AS STRING), '_', CAST(${cs_order_number} AS STRING)) ;;
  }

  dimension: cs_sold_date_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.cs_sold_date_sk ;;
  }

  dimension: cs_item_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.cs_item_sk ;;
  }

  dimension: cs_bill_customer_sk {
    type: number
    value_format_name: id
    tags: ["foreign_key"]
    sql: ${TABLE}.cs_bill_customer_sk ;;
  }

  measure: count {
    description: "Count of catalog sales records."
  }

  measure: total_ext_sales_price {
    type: sum
    sql: ${cs_ext_sales_price} ;;
    value_format_name: usd
    description: "Sum of extended catalog sales price (cs_ext_sales_price)."
  }

  measure: total_sales_price {
    type: sum
    sql: ${cs_sales_price} ;;
    value_format_name: usd
    description: "Sum of catalog item sales price (cs_sales_price)."
  }
}
