{{
    config(
        tags=["this_run"],
        sql_header=snowplow_utils.set_query_tag(var('snowplow__query_tag', 'snowplow_dbt'))
    )
}}

with unique_transactions as (
    select
        e.event_id,
        e.page_view_id,

        e.domain_sessionid,
        e.event_in_session_index,

        e.domain_userid,
        e.network_userid,
        e.user_id,
        e.ecommerce_user_id,

        e.derived_tstamp,
        DATE(e.derived_tstamp) as derived_tstamp_date,

        e.transaction_id as transaction_id,
        e.transaction_currency as transaction_currency,
        e.transaction_payment_method,
        e.transaction_revenue,
        e.transaction_total_quantity,
        e.transaction_credit_order,
        e.transaction_discount_amount,
        e.transaction_discount_code,
        e.transaction_shipping,
        e.transaction_tax,

        e.ecommerce_user_email,
        e.ecommerce_user_is_guest
    from {{ ref('snowplow_ecommerce_base_events_this_run') }} as e
    where ecommerce_action_type = 'transaction'
    qualify row_number() over (partition by transaction_id order by derived_tstamp) = 1
),

transaction_info AS (
    select
        -- event fields
        e.event_id,
        e.page_view_id,

        -- session fields
        e.domain_sessionid,
        e.event_in_session_index,

        -- user fields
        e.domain_userid,
        e.network_userid,
        e.user_id,
        e.ecommerce_user_id,

        -- timestamp fields
        e.derived_tstamp,
        DATE(e.derived_tstamp) as derived_tstamp_date,

        -- ecommerce transaction fields
        e.transaction_id as transaction_id,
        e.transaction_currency as transaction_currency,
        e.transaction_payment_method,
        e.transaction_revenue,
        e.transaction_total_quantity,
        e.transaction_credit_order,
        e.transaction_discount_amount,
        e.transaction_discount_code,
        e.transaction_shipping,
        e.transaction_tax,

        -- ecommerce user fields
        e.ecommerce_user_email,
        e.ecommerce_user_is_guest,

        {% if (var("snowplow__use_product_quantity", false) and not var("snowplow__disable_ecommerce_products", false) | as_bool() )  -%}
        SUM(pi.product_quantity) as number_products
        {%- else -%}
        COUNT(*) as number_products -- count all products added
        {%- endif %}
    from unique_transactions as e
    {% if not var("snowplow__disable_ecommerce_products", false)  -%}
    left join {{ ref('snowplow_ecommerce_product_interactions_this_run') }} as pi on e.transaction_id = pi.transaction_id AND pi.is_product_transaction
    {%- endif %}
    group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22
)

select *

from transaction_info
