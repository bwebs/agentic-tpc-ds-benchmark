-- query54
WITH my_customers 
     AS (SELECT DISTINCT c_customer_sk, 
                         c_current_addr_sk 
         FROM   (SELECT cs_sold_date_sk     sold_date_sk, 
                        cs_bill_customer_sk customer_sk, 
                        cs_item_sk          item_sk 
                 FROM   `bigquery-public-data.tpc_ds_1g.catalog_sales` AS catalog_sales 
                 UNION ALL 
                 SELECT ws_sold_date_sk     sold_date_sk, 
                        ws_bill_customer_sk customer_sk, 
                        ws_item_sk          item_sk 
                 FROM   `bigquery-public-data.tpc_ds_1g.web_sales` AS web_sales) cs_or_ws_sales, 
                `bigquery-public-data.tpc_ds_1g.item` AS item, 
                `bigquery-public-data.tpc_ds_1g.date_dim` AS date_dim, 
                `bigquery-public-data.tpc_ds_1g.customer` AS customer 
         WHERE  sold_date_sk = d_date_sk 
                AND item_sk = i_item_sk 
                AND i_category = 'Sports' 
                AND i_class = 'fitness' 
                AND c_customer_sk = cs_or_ws_sales.customer_sk 
                AND d_moy = 5 
                AND d_year = 2000), 
     my_revenue 
     AS (SELECT c_customer_sk, 
                Sum(ss_ext_sales_price) AS revenue 
         FROM   my_customers, 
                `bigquery-public-data.tpc_ds_1g.store_sales` AS store_sales, 
                `bigquery-public-data.tpc_ds_1g.customer_address` AS customer_address, 
                `bigquery-public-data.tpc_ds_1g.store` AS store, 
                `bigquery-public-data.tpc_ds_1g.date_dim` AS date_dim 
         WHERE  c_current_addr_sk = ca_address_sk 
                AND ca_county = s_county 
                AND ca_state = s_state 
                AND ss_sold_date_sk = d_date_sk 
                AND c_customer_sk = ss_customer_sk 
                AND d_month_seq BETWEEN (SELECT DISTINCT d_month_seq + 1 
                                         FROM   `bigquery-public-data.tpc_ds_1g.date_dim` AS date_dim 
                                         WHERE  d_year = 2000 
                                                AND d_moy = 5) AND 
                                        (SELECT DISTINCT 
                                        d_month_seq + 3 
                                         FROM   `bigquery-public-data.tpc_ds_1g.date_dim` AS date_dim 
                                         WHERE  d_year = 2000 
                                                AND d_moy = 5) 
         GROUP  BY c_customer_sk), 
     segments 
     AS (SELECT Floor(revenue / 50) AS segment 
         FROM   my_revenue) 
SELECT segment, 
               Count(*)     AS num_customers, 
               segment * 50 AS segment_base 
FROM   segments 
GROUP  BY segment 
ORDER  BY segment, 
          num_customers
LIMIT 100; 
