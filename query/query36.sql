-- query36
SELECT Sum(ss_net_profit) / Sum(ss_ext_sales_price)                 AS 
               gross_margin, 
               i_category, 
               i_class, 
               Rank() 
                 OVER ( 
                   PARTITION BY i_category, i_class 
                   ORDER BY Sum(ss_net_profit)/Sum(ss_ext_sales_price) ASC) AS 
               rank_within_parent 
FROM   `bigquery-public-data.tpc_ds_1g.store_sales` AS store_sales, 
       `bigquery-public-data.tpc_ds_1g.date_dim` d1, 
       `bigquery-public-data.tpc_ds_1g.item` AS item, 
       `bigquery-public-data.tpc_ds_1g.store` AS store 
WHERE  d1.d_year = 2000 
       AND d1.d_date_sk = ss_sold_date_sk 
       AND i_item_sk = ss_item_sk 
       AND s_store_sk = ss_store_sk 
       AND s_state IN ( 'TN', 'TN', 'TN', 'TN', 
                        'TN', 'TN', 'TN', 'TN' ) 
GROUP  BY i_category, i_class 
ORDER  BY i_category, 
          rank_within_parent
LIMIT 100; 
