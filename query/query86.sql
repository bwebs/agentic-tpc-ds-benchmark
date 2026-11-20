-- query86
SELECT Sum(ws_net_paid)                         AS total_sum, 
               i_category, 
               i_class, 
               Rank() 
                 OVER ( 
                   PARTITION BY i_category, i_class
                   ORDER BY Sum(ws_net_paid) DESC)      AS rank_within_parent 
FROM   `bigquery-public-data.tpc_ds_1g.web_sales` AS web_sales, 
       `bigquery-public-data.tpc_ds_1g.date_dim` d1, 
       `bigquery-public-data.tpc_ds_1g.item` AS item 
WHERE  d1.d_month_seq BETWEEN 1183 AND 1183 + 11 
       AND d1.d_date_sk = ws_sold_date_sk 
       AND i_item_sk = ws_item_sk 
GROUP  BY i_category, i_class 
ORDER  BY i_category, 
          rank_within_parent
LIMIT 100; 
