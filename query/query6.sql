-- query6
SELECT a.ca_state state, 
               Count(*)   cnt 
FROM   `bigquery-public-data.tpc_ds_1g.customer_address` a, 
       `bigquery-public-data.tpc_ds_1g.customer` c, 
       `bigquery-public-data.tpc_ds_1g.store_sales` s, 
       `bigquery-public-data.tpc_ds_1g.date_dim` d, 
       `bigquery-public-data.tpc_ds_1g.item` i 
WHERE  a.ca_address_sk = c.c_current_addr_sk 
       AND c.c_customer_sk = s.ss_customer_sk 
       AND s.ss_sold_date_sk = d.d_date_sk 
       AND s.ss_item_sk = i.i_item_sk 
       AND d.d_month_seq = (SELECT DISTINCT ( d_month_seq ) 
                            FROM   `bigquery-public-data.tpc_ds_1g.date_dim` AS date_dim 
                            WHERE  d_year = 1998 
                                   AND d_moy = 7) 
       AND i.i_current_price > 1.2 * (SELECT Avg(j.i_current_price) 
                                      FROM   `bigquery-public-data.tpc_ds_1g.item` j 
                                      WHERE  j.i_category = i.i_category) 
GROUP  BY a.ca_state 
HAVING Count(*) >= 10 
ORDER  BY cnt
LIMIT 100; 
