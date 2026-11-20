-- query91
SELECT cc_call_center_id Call_Center, 
       cc_name           Call_Center_Name, 
       cc_manager        Manager, 
       Sum(cr_net_loss)  Returns_Loss 
FROM   `bigquery-public-data.tpc_ds_1g.call_center` AS call_center, 
       `bigquery-public-data.tpc_ds_1g.catalog_returns` AS catalog_returns, 
       `bigquery-public-data.tpc_ds_1g.date_dim` AS date_dim, 
       `bigquery-public-data.tpc_ds_1g.customer` AS customer, 
       `bigquery-public-data.tpc_ds_1g.customer_address` AS customer_address, 
       `bigquery-public-data.tpc_ds_1g.customer_demographics` AS customer_demographics, 
       `bigquery-public-data.tpc_ds_1g.household_demographics` AS household_demographics 
WHERE  cr_call_center_sk = cc_call_center_sk 
       AND cr_returned_date_sk = d_date_sk 
       AND cr_returning_customer_sk = c_customer_sk 
       AND cd_demo_sk = c_current_cdemo_sk 
       AND hd_demo_sk = c_current_hdemo_sk 
       AND ca_address_sk = c_current_addr_sk 
       AND d_year = 1999 
       AND d_moy = 12 
       AND ( ( cd_marital_status = 'M' 
               AND cd_education_status = 'Unknown' ) 
              OR ( cd_marital_status = 'W' 
                   AND cd_education_status = 'Advanced Degree' ) ) 
       AND hd_buy_potential LIKE 'Unknown%' 
       AND ca_gmt_offset = -7 
GROUP  BY cc_call_center_id, 
          cc_name, 
          cc_manager, 
          cd_marital_status, 
          cd_education_status 
ORDER  BY Sum(cr_net_loss) DESC; 
