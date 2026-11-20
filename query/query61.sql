-- query61
SELECT promotions, 
               total, 
               promotions / 
               total * 100 
FROM   (SELECT Sum(ss_ext_sales_price) promotions 
        FROM   `bigquery-public-data.tpc_ds_1g.store_sales` AS store_sales, 
               `bigquery-public-data.tpc_ds_1g.store` AS store, 
               `bigquery-public-data.tpc_ds_1g.promotion` AS promotion, 
               `bigquery-public-data.tpc_ds_1g.date_dim` AS date_dim, 
               `bigquery-public-data.tpc_ds_1g.customer` AS customer, 
               `bigquery-public-data.tpc_ds_1g.customer_address` AS customer_address, 
               `bigquery-public-data.tpc_ds_1g.item` AS item 
        WHERE  ss_sold_date_sk = d_date_sk 
               AND ss_store_sk = s_store_sk 
               AND ss_promo_sk = p_promo_sk 
               AND ss_customer_sk = c_customer_sk 
               AND ca_address_sk = c_current_addr_sk 
               AND ss_item_sk = i_item_sk 
               AND ca_gmt_offset = -7 
               AND i_category = 'Books' 
               AND ( p_channel_dmail = 'Y' 
                      OR p_channel_email = 'Y' 
                      OR p_channel_tv = 'Y' ) 
               AND s_gmt_offset = -7 
               AND d_year = 2001 
               AND d_moy = 12) promotional_sales, 
       (SELECT Sum(ss_ext_sales_price) total 
        FROM   `bigquery-public-data.tpc_ds_1g.store_sales` AS store_sales, 
               `bigquery-public-data.tpc_ds_1g.store` AS store, 
               `bigquery-public-data.tpc_ds_1g.date_dim` AS date_dim, 
               `bigquery-public-data.tpc_ds_1g.customer` AS customer, 
               `bigquery-public-data.tpc_ds_1g.customer_address` AS customer_address, 
               `bigquery-public-data.tpc_ds_1g.item` AS item 
        WHERE  ss_sold_date_sk = d_date_sk 
               AND ss_store_sk = s_store_sk 
               AND ss_customer_sk = c_customer_sk 
               AND ca_address_sk = c_current_addr_sk 
               AND ss_item_sk = i_item_sk 
               AND ca_gmt_offset = -7 
               AND i_category = 'Books' 
               AND s_gmt_offset = -7 
               AND d_year = 2001 
               AND d_moy = 12) all_sales 
ORDER  BY promotions, 
          total
LIMIT 100; 
