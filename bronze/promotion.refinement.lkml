include: "promotion.view.lkml"

view: +promotion {
  dimension: p_promo_sk {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.p_promo_sk ;;
  }

  dimension: p_promo_id {
    primary_key: no
  }

  dimension: is_non_email_or_non_event_channel {
    label: "Non-Email or Non-Event Channel"
    description: "Whether the promotion is inactive on the email channel or event channel (p_channel_email = 'N' OR p_channel_event = 'N')."
    type: yesno
    sql: ${p_channel_email} = 'N' OR ${p_channel_event} = 'N' ;;
  }

  dimension: is_dmail_email_or_tv_channel {
    label: "Direct Mail, Email, or TV Channel"
    description: "Whether the promotion is active on direct mail, email, or TV (p_channel_dmail = 'Y' OR p_channel_email = 'Y' OR p_channel_tv = 'Y')."
    type: yesno
    sql: ${p_channel_dmail} = 'Y' OR ${p_channel_email} = 'Y' OR ${p_channel_tv} = 'Y' ;;
  }
}
