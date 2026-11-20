-- query70
SELECT Sum(ss_net_profit)                     AS total_sum, 
               s_state, 
               s_county, 
               Rank() 
                 OVER ( 
                   PARTITION BY s_state, s_county
                   ORDER BY Sum(ss_net_profit) DESC)  AS rank_within_parent 
FROM   `bigquery-public-data.tpc_ds_1g.store_sales` AS store_sales, 
       `bigquery-public-data.tpc_ds_1g.date_dim` d1, 
       `bigquery-public-data.tpc_ds_1g.store` AS store 
WHERE  d1.d_month_seq BETWEEN 1200 AND 1200 + 11 
       AND d1.d_date_sk = ss_sold_date_sk 
       AND s_store_sk = ss_store_sk 
       AND s_state IN (SELECT s_state 
                       FROM   (SELECT s_state                               AS 
                                      s_state, 
                                      Rank() 
                                        OVER ( 
                                          partition BY s_state 
                                          ORDER BY Sum(ss_net_profit) DESC) AS 
                                      ranking 
                               FROM   `bigquery-public-data.tpc_ds_1g.store_sales` AS store_sales, 
                                      `bigquery-public-data.tpc_ds_1g.store` AS store, 
                                      `bigquery-public-data.tpc_ds_1g.date_dim` AS date_dim 
                               WHERE  d_month_seq BETWEEN 1200 AND 1200 + 11 
                                      AND d_date_sk = ss_sold_date_sk 
                                      AND s_store_sk = ss_store_sk 
                               GROUP  BY s_state) tmp1 
                       WHERE  ranking <= 5) 
GROUP  BY s_state, s_county 
ORDER  BY s_state, 
          rank_within_parent
LIMIT 100; 
