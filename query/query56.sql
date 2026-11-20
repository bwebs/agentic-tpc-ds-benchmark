-- query56
WITH ss 
     AS (SELECT i_item_id, 
                Sum(ss_ext_sales_price) total_sales 
         FROM   `bigquery-public-data.tpc_ds_1g.store_sales` AS store_sales, 
                `bigquery-public-data.tpc_ds_1g.date_dim` AS date_dim, 
                `bigquery-public-data.tpc_ds_1g.customer_address` AS customer_address, 
                `bigquery-public-data.tpc_ds_1g.item` AS item 
         WHERE  i_item_id IN (SELECT i_item_id 
                              FROM   `bigquery-public-data.tpc_ds_1g.item` AS item 
                              WHERE  i_color IN ( 'firebrick', 'rosy', 'white' ) 
                             ) 
                AND ss_item_sk = i_item_sk 
                AND ss_sold_date_sk = d_date_sk 
                AND d_year = 1998 
                AND d_moy = 3 
                AND ss_addr_sk = ca_address_sk 
                AND ca_gmt_offset = -6 
         GROUP  BY i_item_id), 
     cs 
     AS (SELECT i_item_id, 
                Sum(cs_ext_sales_price) total_sales 
         FROM   `bigquery-public-data.tpc_ds_1g.catalog_sales` AS catalog_sales, 
                `bigquery-public-data.tpc_ds_1g.date_dim` AS date_dim, 
                `bigquery-public-data.tpc_ds_1g.customer_address` AS customer_address, 
                `bigquery-public-data.tpc_ds_1g.item` AS item 
         WHERE  i_item_id IN (SELECT i_item_id 
                              FROM   `bigquery-public-data.tpc_ds_1g.item` AS item 
                              WHERE  i_color IN ( 'firebrick', 'rosy', 'white' ) 
                             ) 
                AND cs_item_sk = i_item_sk 
                AND cs_sold_date_sk = d_date_sk 
                AND d_year = 1998 
                AND d_moy = 3 
                AND cs_bill_addr_sk = ca_address_sk 
                AND ca_gmt_offset = -6 
         GROUP  BY i_item_id), 
     ws 
     AS (SELECT i_item_id, 
                Sum(ws_ext_sales_price) total_sales 
         FROM   `bigquery-public-data.tpc_ds_1g.web_sales` AS web_sales, 
                `bigquery-public-data.tpc_ds_1g.date_dim` AS date_dim, 
                `bigquery-public-data.tpc_ds_1g.customer_address` AS customer_address, 
                `bigquery-public-data.tpc_ds_1g.item` AS item 
         WHERE  i_item_id IN (SELECT i_item_id 
                              FROM   `bigquery-public-data.tpc_ds_1g.item` AS item 
                              WHERE  i_color IN ( 'firebrick', 'rosy', 'white' ) 
                             ) 
                AND ws_item_sk = i_item_sk 
                AND ws_sold_date_sk = d_date_sk 
                AND d_year = 1998 
                AND d_moy = 3 
                AND ws_bill_addr_sk = ca_address_sk 
                AND ca_gmt_offset = -6 
         GROUP  BY i_item_id) 
SELECT i_item_id, 
               Sum(total_sales) total_sales 
FROM   (SELECT * 
        FROM   ss 
        UNION ALL 
        SELECT * 
        FROM   cs 
        UNION ALL 
        SELECT * 
        FROM   ws) tmp1 
GROUP  BY i_item_id 
ORDER  BY total_sales
LIMIT 100; 
