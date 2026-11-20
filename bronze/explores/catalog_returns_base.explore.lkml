include: "/bronze/catalog_returns.view.lkml"
include: "/bronze/catalog_returns.refinement.lkml"

explore: catalog_returns_base {
  hidden: yes
  view_name: catalog_returns
}
