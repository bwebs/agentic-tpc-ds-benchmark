-- query34
SELECT c_last_name, 
       c_first_name, 
       c_salutation, 
       c_preferred_cust_flag, 
       ss_ticket_number, 
       cnt 
FROM   (SELECT ss_ticket_number, 
               ss_customer_sk, 
               Count(*) cnt 
        FROM   `bigquery-public-data.tpc_ds_1g.store_sales` AS store_sales, 
               `bigquery-public-data.tpc_ds_1g.date_dim` AS date_dim, 
               `bigquery-public-data.tpc_ds_1g.store` AS store, 
               `bigquery-public-data.tpc_ds_1g.household_demographics` AS household_demographics 
        WHERE  store_sales.ss_sold_date_sk = date_dim.d_date_sk 
               AND store_sales.ss_store_sk = store.s_store_sk 
               AND store_sales.ss_hdemo_sk = household_demographics.hd_demo_sk 
               AND ( date_dim.d_dom BETWEEN 1 AND 3 
                      OR date_dim.d_dom BETWEEN 25 AND 28 ) 
               AND ( household_demographics.hd_buy_potential = '>10000' 
                      OR household_demographics.hd_buy_potential = 'unknown' ) 
               AND household_demographics.hd_vehicle_count > 0 
               AND ( CASE 
                       WHEN household_demographics.hd_vehicle_count > 0 THEN 
                       household_demographics.hd_dep_count / 
                       household_demographics.hd_vehicle_count 
                       ELSE NULL 
                     END ) > 1.2 
               AND date_dim.d_year IN ( 1999, 1999 + 1, 1999 + 2 ) 
               AND store.s_county IN ( 'Williamson County', 'Williamson County', 
                                       'Williamson County', 
                                                             'Williamson County' 
                                       , 
                                       'Williamson County', 'Williamson County', 
                                           'Williamson County', 
                                                             'Williamson County' 
                                     ) 
        GROUP  BY ss_ticket_number, 
                  ss_customer_sk) dn, 
       `bigquery-public-data.tpc_ds_1g.customer` AS customer 
WHERE  ss_customer_sk = c_customer_sk 
       AND cnt BETWEEN 15 AND 20 
ORDER  BY c_last_name, 
          c_first_name, 
          c_salutation, 
          c_preferred_cust_flag DESC; 
