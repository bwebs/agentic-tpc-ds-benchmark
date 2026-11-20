include: "/gold/store_item_monthly_sales_rank.view.lkml"

explore: store_item_monthly_sales_rank {
  view_name: store_item_monthly_sales_rank
  label: "Store Item Monthly Sales Rank"
  tags: ["gold"]

  always_filter: {
    filters: [
      store_item_monthly_sales_rank.month_seq_filter: "[1181, 1192]"
    ]
  }

  query: top_100_ranked_store_item_monthly_sales_m1181_1192 {
    description: "Top 100 ranked monthly store sales within each item category, class, brand, and product name across month sequences 1181-1192"
    dimensions: [
      store_item_monthly_sales_rank.i_category,
      store_item_monthly_sales_rank.i_class,
      store_item_monthly_sales_rank.i_brand,
      store_item_monthly_sales_rank.i_product_name,
      store_item_monthly_sales_rank.d_year,
      store_item_monthly_sales_rank.d_qoy,
      store_item_monthly_sales_rank.d_moy,
      store_item_monthly_sales_rank.s_store_id,
      store_item_monthly_sales_rank.sumsales,
      store_item_monthly_sales_rank.rk
    ]
    filters: [
      store_item_monthly_sales_rank.month_seq_filter: "[1181, 1192]",
      store_item_monthly_sales_rank.rk: "<=100"
    ]
    sorts: [
      store_item_monthly_sales_rank.i_category: asc,
      store_item_monthly_sales_rank.i_class: asc,
      store_item_monthly_sales_rank.i_brand: asc,
      store_item_monthly_sales_rank.i_product_name: asc,
      store_item_monthly_sales_rank.d_year: asc,
      store_item_monthly_sales_rank.d_qoy: asc,
      store_item_monthly_sales_rank.d_moy: asc,
      store_item_monthly_sales_rank.s_store_id: asc,
      store_item_monthly_sales_rank.sumsales: asc,
      store_item_monthly_sales_rank.rk: asc
    ]
    limit: 100
  }
}
