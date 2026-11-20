-- query76
SELECT channel, 
               col_name, 
               d_year, 
               d_qoy, 
               i_category, 
               Count(*)             sales_cnt, 
               Sum(ext_sales_price) sales_amt 
FROM   (SELECT 'store'            AS channel, 
               'ss_hdemo_sk'      col_name, 
               d_year, 
               d_qoy, 
               i_category, 
               ss_ext_sales_price ext_sales_price 
        FROM   `bigquery-public-data.tpc_ds_1g.store_sales` AS store_sales, 
               `bigquery-public-data.tpc_ds_1g.item` AS item, 
               `bigquery-public-data.tpc_ds_1g.date_dim` AS date_dim 
        WHERE  ss_hdemo_sk IS NULL 
               AND ss_sold_date_sk = d_date_sk 
               AND ss_item_sk = i_item_sk 
        UNION ALL 
        SELECT 'web'              AS channel, 
               'ws_ship_hdemo_sk' col_name, 
               d_year, 
               d_qoy, 
               i_category, 
               ws_ext_sales_price ext_sales_price 
        FROM   `bigquery-public-data.tpc_ds_1g.web_sales` AS web_sales, 
               `bigquery-public-data.tpc_ds_1g.item` AS item, 
               `bigquery-public-data.tpc_ds_1g.date_dim` AS date_dim 
        WHERE  ws_ship_hdemo_sk IS NULL 
               AND ws_sold_date_sk = d_date_sk 
               AND ws_item_sk = i_item_sk 
        UNION ALL 
        SELECT 'catalog'          AS channel, 
               'cs_warehouse_sk'  col_name, 
               d_year, 
               d_qoy, 
               i_category, 
               cs_ext_sales_price ext_sales_price 
        FROM   `bigquery-public-data.tpc_ds_1g.catalog_sales` AS catalog_sales, 
               `bigquery-public-data.tpc_ds_1g.item` AS item, 
               `bigquery-public-data.tpc_ds_1g.date_dim` AS date_dim 
        WHERE  cs_warehouse_sk IS NULL 
               AND cs_sold_date_sk = d_date_sk 
               AND cs_item_sk = i_item_sk) foo 
GROUP  BY channel, 
          col_name, 
          d_year, 
          d_qoy, 
          i_category 
ORDER  BY channel, 
          col_name, 
          d_year, 
          d_qoy, 
          i_category
LIMIT 100; 
