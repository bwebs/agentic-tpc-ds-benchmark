

-- query99
SELECT Substr(w_warehouse_name, 1, 20), 
               sm_type, 
               cc_name, 
               Sum(CASE 
                     WHEN ( cs_ship_date_sk - cs_sold_date_sk <= 30 ) THEN 1 
                     ELSE 0 
                   END) AS days_30, 
               Sum(CASE 
                     WHEN ( cs_ship_date_sk - cs_sold_date_sk > 30 ) 
                          AND ( cs_ship_date_sk - cs_sold_date_sk <= 60 ) THEN 1 
                     ELSE 0 
                   END) AS days_31_60, 
               Sum(CASE 
                     WHEN ( cs_ship_date_sk - cs_sold_date_sk > 60 ) 
                          AND ( cs_ship_date_sk - cs_sold_date_sk <= 90 ) THEN 1 
                     ELSE 0 
                   END) AS days_61_90, 
               Sum(CASE 
                     WHEN ( cs_ship_date_sk - cs_sold_date_sk > 90 ) 
                          AND ( cs_ship_date_sk - cs_sold_date_sk <= 120 ) THEN 
                     1 
                     ELSE 0 
                   END) AS days_91_120, 
               Sum(CASE 
                     WHEN ( cs_ship_date_sk - cs_sold_date_sk > 120 ) THEN 1 
                     ELSE 0 
                   END) AS days_over_120 
FROM   `bigquery-public-data.tpc_ds_1g.catalog_sales` AS catalog_sales, 
       `bigquery-public-data.tpc_ds_1g.warehouse` AS warehouse, 
       `bigquery-public-data.tpc_ds_1g.ship_mode` AS ship_mode, 
       `bigquery-public-data.tpc_ds_1g.call_center` AS call_center, 
       `bigquery-public-data.tpc_ds_1g.date_dim` AS date_dim 
WHERE  d_month_seq BETWEEN 1200 AND 1200 + 11 
       AND cs_ship_date_sk = d_date_sk 
       AND cs_warehouse_sk = w_warehouse_sk 
       AND cs_ship_mode_sk = sm_ship_mode_sk 
       AND cs_call_center_sk = cc_call_center_sk 
GROUP  BY 1, 2, 3
ORDER  BY 1, 2, 3
LIMIT 100; 
