-- query96
SELECT Count(*) 
FROM   `bigquery-public-data.tpc_ds_1g.store_sales` AS store_sales, 
       `bigquery-public-data.tpc_ds_1g.household_demographics` AS household_demographics, 
       `bigquery-public-data.tpc_ds_1g.time_dim` AS time_dim, 
       `bigquery-public-data.tpc_ds_1g.store` AS store 
WHERE  ss_sold_time_sk = time_dim.t_time_sk 
       AND ss_hdemo_sk = household_demographics.hd_demo_sk 
       AND ss_store_sk = s_store_sk 
       AND time_dim.t_hour = 15 
       AND time_dim.t_minute >= 30 
       AND household_demographics.hd_dep_count = 7 
       AND store.s_store_name = 'ese' 
ORDER  BY Count(*)
LIMIT 100; 
