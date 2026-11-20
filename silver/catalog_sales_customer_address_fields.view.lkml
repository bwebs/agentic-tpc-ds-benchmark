view: catalog_sales_customer_address_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${catalog_sales.pk} ;;
  }

  dimension: is_target_zip_state_or_high_price {
    type: yesno
    label: "Target Zip, State, or High Sales Price"
    description: "True when customer billing address 5-digit postal code is in the target list, state is CA/WA/GA, or catalog item sales price exceeds $500."
    sql: ${customer_address.ca_zip_5} IN ('85669', '86197', '88274', '83405', '86475', '85392', '85460', '80348', '81792')
      OR ${customer_address.ca_state} IN ('CA', 'WA', 'GA')
      OR ${catalog_sales.cs_sales_price} > 500 ;;
  }
}
