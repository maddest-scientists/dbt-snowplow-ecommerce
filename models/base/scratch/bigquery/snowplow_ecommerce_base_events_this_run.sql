{{
  config(
    tags=["this_run"]
  )
}}

{%- set lower_limit, upper_limit = snowplow_utils.return_limits_from_model(ref('snowplow_ecommerce_base_sessions_this_run'),
                                                                          'start_tstamp',
                                                                          'end_tstamp') %}


select
  *,
  dense_rank() over (partition by ev.domain_sessionid order by ev.derived_tstamp) AS event_in_session_index,

from (
  -- without downstream joins, it's safe to dedupe by picking the first event_id found.
  select
    array_agg(e order by e.collector_tstamp limit 1)[offset(0)].*

  from (

  select
      {% if var('snowplow__enable_mobile_events', false) %}
        coalesce(
          {{ snowplow_utils.get_optional_fields(
          enabled=var('snowplow__enable_mobile_events', false),
          fields=[{'field': 'id', 'dtype': 'string'}],
          col_prefix='contexts_com_snowplowanalytics_mobile_screen_1_',
          relation=source('atomic', 'events'),
          relation_alias='a',
          include_field_alias=false) }},
          a.contexts_com_snowplowanalytics_snowplow_web_page_1_0_0[safe_offset(0)].id
        ) as page_view_id,
        coalesce(
          {{ snowplow_utils.get_optional_fields(
          enabled=var('snowplow__enable_mobile_events', false),
          fields=[{'field': 'session_id', 'dtype': 'string'}],
          col_prefix='contexts_com_snowplowanalytics_snowplow_client_session_1_',
          relation=source('atomic', 'events'),
          relation_alias='a',
          include_field_alias=false) }},
          a.domain_sessionid
        ) as domain_sessionid,
      {% else %}
        a.contexts_com_snowplowanalytics_snowplow_web_page_1_0_0[safe_offset(0)].id as page_view_id,
        a.domain_sessionid,
      {% endif %}
      b.domain_userid,

      -- unpacking the ecommerce user object
      {{ snowplow_utils.get_optional_fields(
          enabled=not var('snowplow__disable_ecommerce_user_context', false),
          fields=user_fields(),
          col_prefix='contexts_com_snowplowanalytics_snowplow_ecommerce_user_1_',
          relation=source('atomic', 'events'),
          relation_alias='a') }},

      -- unpacking the ecommerce checkout step object
      {{ snowplow_utils.get_optional_fields(
          enabled=not var('snowplow__disable_ecommerce_checkouts', false),
          fields=checkout_step_fields(),
          col_prefix='contexts_com_snowplowanalytics_snowplow_ecommerce_checkout_step_1_',
          relation=source('atomic', 'events'),
          relation_alias='a') }},

      -- unpacking the ecommerce page object
      {{ snowplow_utils.get_optional_fields(
          enabled=not var('snowplow__disable_ecommerce_page_context', false),
          fields=tracking_page_fields(),
          col_prefix='contexts_com_snowplowanalytics_snowplow_ecommerce_page_1_',
          relation=source('atomic', 'events'),
          relation_alias='a') }},

      -- unpacking the ecommerce transaction object
      {{ snowplow_utils.get_optional_fields(
          enabled=not var('snowplow__disable_ecommerce_transactions', false),
          fields=transaction_fields(),
          col_prefix='contexts_com_snowplowanalytics_snowplow_ecommerce_transaction_1_',
          relation=source('atomic', 'events'),
          relation_alias='a') }},

      -- unpacking the ecommerce cart object
      {{ snowplow_utils.get_optional_fields(
          enabled=not var('snowplow__disable_ecommerce_carts', false),
          fields=cart_fields(),
          col_prefix='contexts_com_snowplowanalytics_snowplow_ecommerce_cart_1_',
          relation=source('atomic', 'events'),
          relation_alias='a') }},

      -- unpacking the ecommerce action object
      {{ snowplow_utils.get_optional_fields(
          enabled=true,
          fields=tracking_action_fields(),
          col_prefix='unstruct_event_com_snowplowanalytics_snowplow_ecommerce_snowplow_ecommerce_action_1_',
          relation=source('atomic', 'events'),
          relation_alias='a') }},

    a.* except (domain_userid,
                contexts_com_snowplowanalytics_snowplow_web_page_1_0_0, domain_sessionid)

    from {{ var('snowplow__events') }} as a
    inner join {{ ref('snowplow_ecommerce_base_sessions_this_run') }} as b
    {% if var('snowplow__enable_mobile_events', false) %}
      on coalesce(
        {{ snowplow_utils.get_optional_fields(
        enabled=var('snowplow__enable_mobile_events', false),
        fields=[{'field': 'session_id', 'dtype': 'string'}],
        col_prefix='contexts_com_snowplowanalytics_snowplow_client_session_1_',
        relation=source('atomic', 'events'),
        relation_alias='a',
        include_field_alias=false) }},
        a.domain_sessionid
      ) = b.session_id
    {% else %}
      on a.domain_sessionid = b.session_id
    {% endif %}

    where a.collector_tstamp <= {{ snowplow_utils.timestamp_add('day', var("snowplow__max_session_days", 3), 'b.start_tstamp') }}
    and a.dvce_sent_tstamp <= {{ snowplow_utils.timestamp_add('day', var("snowplow__days_late_allowed", 3), 'a.dvce_created_tstamp') }}
    and a.collector_tstamp >= {{ lower_limit }}
    and a.collector_tstamp <= {{ upper_limit }}
    {% if var('snowplow__derived_tstamp_partitioned', true) and target.type == 'bigquery' | as_bool() %}
      and a.derived_tstamp >= {{ snowplow_utils.timestamp_add('hour', -1, lower_limit) }}
      and a.derived_tstamp <= {{ upper_limit }}
    {% endif %}
    and {{ snowplow_utils.app_id_filter(var("snowplow__app_id",[])) }}
    and {{ snowplow_ecommerce.event_name_filter(var("snowplow__ecommerce_event_names", "['snowplow_ecommerce_action']")) }}
  ) e
  group by e.event_id
) ev
