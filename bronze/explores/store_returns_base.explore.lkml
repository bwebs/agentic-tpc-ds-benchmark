include: "/bronze/store_returns.view.lkml"
include: "/bronze/store_returns.refinement.lkml"

explore: store_returns_base {
  hidden: yes
  view_name: store_returns
}
