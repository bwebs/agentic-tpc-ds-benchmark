
-- query98
SELECT i_item_id, 
       i_item_desc, 
       i_category, 
       i_class, 
       i_current_price, 
       Sum(ss_ext_sales_price)                                   AS itemrevenue, 
       Sum(ss_ext_sales_price) * 100 / Sum(Sum(ss_ext_sales_price)) 
                                         OVER ( 
                                           PARTITION BY i_class) AS revenueratio 
FROM   `bigquery-public-data.tpc_ds_1g.store_sales` AS store_sales, 
       `bigquery-public-data.tpc_ds_1g.item` AS item, 
       `bigquery-public-data.tpc_ds_1g.date_dim` AS date_dim 
WHERE  ss_item_sk = i_item_sk 
       AND i_category IN ( 'Men', 'Home', 'Electronics' ) 
       AND ss_sold_date_sk = d_date_sk 
       AND Cast(d_date AS DATE) BETWEEN CAST('2000-05-18' AS DATE) AND ( 
                          CAST('2000-06-18' AS DATE) ) 
GROUP  BY i_item_id, 
          i_item_desc, 
          i_category, 
          i_class, 
          i_current_price 
ORDER  BY i_category, 
          i_class, 
          i_item_id, 
          i_item_desc, 
          revenueratio; 
