include: "/bronze/date_dim.view.lkml"
include: "/bronze/date_dim.refinement.lkml"
include: "/bronze/inventory.view.lkml"
include: "/bronze/inventory.refinement.lkml"

view: date_dim_inventory_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${inventory.pk} ;;
  }

  dimension: inv_before_2000_05_13_qty {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_raw} < DATE '2000-05-13' THEN ${inventory.inv_quantity_on_hand} ELSE 0 END ;;
  }

  dimension: inv_on_or_after_2000_05_13_qty {
    hidden: yes
    type: number
    sql: CASE WHEN ${date_dim.d_raw} >= DATE '2000-05-13' THEN ${inventory.inv_quantity_on_hand} ELSE 0 END ;;
  }

  measure: inv_before {
    type: sum
    sql: ${inv_before_2000_05_13_qty} ;;
    value_format_name: decimal_0
    description: "Sum of inventory quantity on hand before 2000-05-13 (0 when no before-cutoff rows match)."
  }

  measure: inv_after {
    type: sum
    sql: ${inv_on_or_after_2000_05_13_qty} ;;
    value_format_name: decimal_0
    description: "Sum of inventory quantity on hand on or after 2000-05-13 (0 when no on/after-cutoff rows match)."
  }

  measure: inv_after_to_before_ratio {
    type: number
    sql: CASE WHEN ${inv_before} > 0 THEN ${inv_after} / ${inv_before} ELSE NULL END ;;
    value_format_name: decimal_4
    tags: ["non_additive"]
    description: "Ratio of inventory quantity on hand on/after 2000-05-13 to before 2000-05-13 (NULL when inv_before <= 0)."
  }

  measure: is_inv_ratio_within_two_thirds_to_three_halves {
    type: yesno
    sql: ${inv_after_to_before_ratio} BETWEEN 2.0 / 3.0 AND 3.0 / 2.0 ;;
    tags: ["non_additive"]
    description: "True when inv_after / inv_before is between 2/3 and 3/2 (with inv_before > 0)."
  }
}
