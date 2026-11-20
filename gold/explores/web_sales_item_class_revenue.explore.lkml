include: "/gold/web_sales_item_class_revenue.view.lkml"

explore: web_sales_item_class_revenue {
  view_name: web_sales_item_class_revenue
  label: "Web Sales Item Class Revenue"
  tags: ["gold"]

  always_filter: {
    filters: [
      web_sales_item_class_revenue.category_filter: "Home,Men,Women",
      web_sales_item_class_revenue.sold_date_filter: "2000-05-11 to 2000-06-12"
    ]
  }

  query: item_revenue_and_class_share_may_jun_2000 {
    description: "Web sales item revenue and share of class revenue for Home, Men, and Women categories from 2000-05-11 through 2000-06-11"
    dimensions: [
      web_sales_item_class_revenue.i_item_id,
      web_sales_item_class_revenue.i_item_desc,
      web_sales_item_class_revenue.i_category,
      web_sales_item_class_revenue.i_class,
      web_sales_item_class_revenue.i_current_price
    ]
    measures: [
      web_sales_item_class_revenue.total_item_revenue,
      web_sales_item_class_revenue.revenue_ratio
    ]
    filters: [
      web_sales_item_class_revenue.category_filter: "Home,Men,Women",
      web_sales_item_class_revenue.sold_date_filter: "2000-05-11 to 2000-06-12"
    ]
    sorts: [
      web_sales_item_class_revenue.i_category: asc,
      web_sales_item_class_revenue.i_class: asc,
      web_sales_item_class_revenue.i_item_id: asc,
      web_sales_item_class_revenue.i_item_desc: asc,
      web_sales_item_class_revenue.revenue_ratio: asc
    ]
    limit: 100
  }
}
