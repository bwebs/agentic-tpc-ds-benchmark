view: sales_customer_address_store_sales_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${store_sales.pk} ;;
  }

  dimension: is_qualifying_us_state_net_profit_tier {
    type: yesno
    label: "Qualifying US State Net Profit Tier"
    description: "True when store sale shipping/billing address is in the United States and matches one of three state group and net profit range tiers."
    sql: ${sales_customer_address.ca_country} = 'United States' AND (
      (${sales_customer_address.ca_state} IN ('AZ', 'NE', 'IA') AND ${store_sales.ss_net_profit} BETWEEN 100 AND 200)
      OR (${sales_customer_address.ca_state} IN ('MS', 'CA', 'NV') AND ${store_sales.ss_net_profit} BETWEEN 150 AND 300)
      OR (${sales_customer_address.ca_state} IN ('GA', 'TX', 'NJ') AND ${store_sales.ss_net_profit} BETWEEN 50 AND 250)
    ) ;;
  }
}
