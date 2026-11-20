include: "/bronze/item.view.lkml"
include: "/bronze/item.refinement.lkml"
include: "/bronze/explores/item.explore.lkml"
include: "/silver/item_manufact_apparel_cohort.view.lkml"

explore: item_catalog {
  extends: [item]
  hidden: no
  label: "Item Catalog"
  view_name: item

  join: item_manufact_apparel_cohort {
    type: left_outer
    relationship: many_to_one
    sql_on: ${item.i_manufact} = ${item_manufact_apparel_cohort.i_manufact} ;;
  }

  query: apparel_manufacturer_products_765_805 {
    description: "Distinct product names for manufacturers 765–805 producing at least one qualifying Men/Women apparel specification item."
    dimensions: [item.i_product_name]
    filters: [
      item.i_manufact_id: "[765, 805]",
      item_manufact_apparel_cohort.has_apparel_spec_match: "yes"
    ]
    sorts: [item.i_product_name: asc]
    limit: 100
  }
}
