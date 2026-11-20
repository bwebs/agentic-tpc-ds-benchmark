include: "/silver/explores/store_sales.explore.lkml"
include: "/silver/preferred_customer_zip_prefix_facts.view.lkml"
include: "/silver/preferred_customer_zip_prefix_facts_store_sales_fields.view.lkml"

explore: store_sales_common_zip {
  extends: [store_sales]
  hidden: no
  label: "Store Sales Common Zip"
  view_name: store_sales
  tags: ["gold"]

  join: preferred_customer_zip_prefix_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store.s_zip_prefix_2} = ${preferred_customer_zip_prefix_facts.ca_zip_prefix_2} ;;
  }

  join: preferred_customer_zip_prefix_facts_store_sales_fields {
    sql: ;;
    relationship: one_to_one
  }

  query: q2_2000_store_net_profit_common_zips {
    description: "Q2 2000 store net profit across stores matching preferred-customer common ZIP 2-digit prefixes"
    dimensions: [store.s_store_name]
    measures: [preferred_customer_zip_prefix_facts_store_sales_fields.total_common_zip_net_profit]
    filters: [
      date_dim.d_qoy: "2",
      date_dim.d_year_num: "2000",
      store_sales.ss_store_sk: "NOT NULL",
      store.s_store_sk: "NOT NULL",
      store_sales.ss_sold_date_sk: "NOT NULL",
      date_dim.d_date_sk: "NOT NULL",
      store.s_zip_prefix_2: "-NULL",
      preferred_customer_zip_prefix_facts.ca_zip_prefix_2: "-NULL"
    ]
    sorts: [store.s_store_name: asc]
    limit: 100
  }
}
