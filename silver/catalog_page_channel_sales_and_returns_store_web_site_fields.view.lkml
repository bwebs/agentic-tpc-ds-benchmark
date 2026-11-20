include: "/silver/channel_sales_and_returns.view.lkml"
include: "/bronze/store.view.lkml"
include: "/bronze/store.refinement.lkml"
include: "/bronze/catalog_page.view.lkml"
include: "/bronze/catalog_page.refinement.lkml"
include: "/bronze/web_site.view.lkml"
include: "/bronze/web_site.refinement.lkml"

view: catalog_page_channel_sales_and_returns_store_web_site_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${channel_sales_and_returns.pk} ;;
  }

  dimension: channel_entity_id {
    type: string
    label: "Channel Entity ID"
    description: "Prefixed channel entity identifier ('store' + s_store_id, 'catalog_page' + cp_catalog_page_id, or 'web_site' + web_site_id)."
    synonyms: ["id"]
    sql:
      CASE ${channel_sales_and_returns.channel}
        WHEN 'store channel' THEN CONCAT('store', ${store.s_store_id})
        WHEN 'catalog channel' THEN CONCAT('catalog_page', ${catalog_page.cp_catalog_page_id})
        WHEN 'web channel' THEN CONCAT('web_site', ${web_site.web_site_id})
      END ;;
  }
}
