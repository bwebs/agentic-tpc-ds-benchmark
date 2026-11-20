-- query93
SELECT ss_customer_sk, 
               Sum(act_sales) sumsales 
FROM   (SELECT ss_item_sk, 
               ss_ticket_number, 
               ss_customer_sk, 
               CASE 
                 WHEN sr_return_quantity IS NOT NULL THEN 
                 ( ss_quantity - sr_return_quantity ) * ss_sales_price 
                 ELSE ( ss_quantity * ss_sales_price ) 
               END act_sales 
        FROM   `bigquery-public-data.tpc_ds_1g.store_sales` AS store_sales 
               LEFT OUTER JOIN `bigquery-public-data.tpc_ds_1g.store_returns` AS store_returns 
                            ON ( sr_item_sk = ss_item_sk 
                                 AND sr_ticket_number = ss_ticket_number ), 
               `bigquery-public-data.tpc_ds_1g.reason` AS reason 
        WHERE  sr_reason_sk = r_reason_sk 
               AND r_reason_desc = 'reason 38') t 
GROUP  BY ss_customer_sk 
ORDER  BY sumsales, 
          ss_customer_sk
LIMIT 100; 
