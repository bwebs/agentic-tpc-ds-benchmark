view: customer_demographics_household_demographics_store_sales_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${store_sales.pk} ;;
  }

  dimension: is_qualifying_demographic_sales_price_tier {
    type: yesno
    label: "Qualifying Demographic Sales Price Tier"
    description: "True when store sale matches one of three marital status, education status, household dependent count, and sales price tiers."
    sql: (
      ${customer_demographics.cd_marital_status} = 'U'
      AND ${customer_demographics.cd_education_status} = 'Advanced Degree'
      AND ${store_sales.ss_sales_price} BETWEEN 100.00 AND 150.00
      AND ${household_demographics.hd_dep_count} = 3
    ) OR (
      ${customer_demographics.cd_marital_status} = 'M'
      AND ${customer_demographics.cd_education_status} = 'Primary'
      AND ${store_sales.ss_sales_price} BETWEEN 50.00 AND 100.00
      AND ${household_demographics.hd_dep_count} = 1
    ) OR (
      ${customer_demographics.cd_marital_status} = 'D'
      AND ${customer_demographics.cd_education_status} = 'Secondary'
      AND ${store_sales.ss_sales_price} BETWEEN 150.00 AND 200.00
      AND ${household_demographics.hd_dep_count} = 1
    ) ;;
  }
}
