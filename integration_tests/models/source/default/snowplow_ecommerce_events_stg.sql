select
    app_id,
    platform,
    etl_tstamp,
    collector_tstamp,
    dvce_created_tstamp,
    event,
    event_id,
    txn_id,
    name_tracker,
    v_tracker,
    v_collector,
    v_etl,
    user_id,
    user_ipaddress,
    user_fingerprint,
    domain_userid,
    domain_sessionidx,
    network_userid,
    geo_country,
    geo_region,
    geo_city,
    geo_zipcode,
    geo_latitude,
    geo_longitude,
    geo_region_name,
    ip_isp,
    ip_organization,
    ip_domain,
    ip_netspeed,
    page_url,
    page_title,
    page_referrer,
    page_urlscheme,
    page_urlhost,
    page_urlport,
    page_urlpath,
    page_urlquery,
    page_urlfragment,
    refr_urlscheme,
    refr_urlhost,
    refr_urlport,
    refr_urlpath,
    refr_urlquery,
    refr_urlfragment,
    refr_medium,
    refr_source,
    refr_term,
    mkt_medium,
    mkt_source,
    mkt_term,
    mkt_content,
    mkt_campaign,
    se_category,
    se_action,
    se_label,
    se_property,
    se_value,
    null as tr_orderid,
    null as tr_affiliation,
    null as tr_total,
    null as tr_tax,
    null as tr_shipping,
    null as tr_city,
    null as tr_state,
    null as tr_country,
    null as ti_orderid,
    null as ti_sku,
    null as ti_name,
    null as ti_category,
    null as ti_price,
    null as ti_quantity,
    null as pp_xoffset_min,
    null as pp_xoffset_max,
    null as pp_yoffset_min,
    null as pp_yoffset_max,
    useragent,
    null as br_name,
    null as br_family,
    null as br_version,
    null as br_type,
    null as br_renderengine,
    null as br_lang,
    null as br_features_pdf,
    null as br_features_flash,
    null as br_features_java,
    null as br_features_director,
    null as br_features_quicktime,
    null as br_features_realplayer,
    null as br_features_windowsmedia,
    null as br_features_gears,
    null as br_features_silverlight,
    null as br_cookies,
    null as br_colordepth,
    null as br_viewwidth,
    null as br_viewheight,
    os_name,
    os_family,
    os_manufacturer,
    os_timezone,
    null as dvce_type,
    null as dvce_ismobile,
    null as dvce_screenwidth,
    null as dvce_screenheight,
    null as doc_charset,
    null as doc_width,
    null as doc_height,
    null as tr_currency,
    null as tr_total_base,
    null as tr_tax_base,
    null as tr_shipping_base,
    null as ti_currency,
    null as ti_price_base,
    base_currency,
    geo_timezone,
    mkt_clickid,
    mkt_network,
    etl_tags,
    dvce_sent_tstamp,
    refr_domain_userid,
    refr_dvce_tstamp,
    domain_sessionid,
    derived_tstamp,
    event_vendor,
    event_name,
    event_format,
    event_version,
    event_fingerprint,
    cast(null as {{ type_timestamp() }}) as true_tstamp,
    cast(null as {{ type_timestamp() }}) load_tstamp

from {{ ref('snowplow_ecommerce_events') }}
