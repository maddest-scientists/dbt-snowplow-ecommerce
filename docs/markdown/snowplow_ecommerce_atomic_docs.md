{% docs table_page_view_context %}

This context table contains the `page_view_id` associated with a given page view.

{% enddocs %}

{% docs table_ecommerce_user_context %}

This context table contains the data generated by the [E-commerce user context](iglu:com.snowplowanalytics.snowplow.ecommerce/user/jsonschema/1-0-0). This context enables you to generate more user information about the user that is completing an action, such as whether they are a guest or not, and what their email address and user_id is in the case that they are logged in.

{% enddocs %}

{% docs table_checkout_step_context %}

This context table contains the data generated by the [E-commerce checkout step context](iglu:com.snowplowanalytics.snowplow.ecommerce/checkout_step/jsonschema/1-0-0). This context enables you to track checkout step events, where checkout step events are used for tracking the progress and option selections of a user in the checkout funnel. These event can fit any multi-page or single-page checkout scenario.

{% enddocs %}

{% docs table_tracking_page_context %}

This context table contains the data generated by the [E-commerce tracking page context](iglu:com.snowplowanalytics.snowplow.ecommerce/page/jsonschema/1-0-0). This context enables you to track extra metadata around which page a user is currently on, such as whether this is the homepage, a product page, etc.

{% enddocs %}

{% docs table_transaction_context %}

This context table contains the data generated by the [E-commerce transaction context](iglu:com.snowplowanalytics.snowplow.ecommerce/transaction/jsonschema/1-0-0). This context enables you to track transactions, where transaction events are used to track the successful completion of a purchase/transaction.

{% enddocs %}

{% docs table_cart_context %}

This context table contains the data generated by the [E-commerce cart context](iglu:com.snowplowanalytics.snowplow.ecommerce/cart/jsonschema/1-0-0). This context enables you to track events related to carts, where cart events are used for tracking additions and removals from a shopping cart.

{% enddocs %}

{% docs table_product_context %}

This context table contains the data generated by the [E-commerce product context](iglu:com.snowplowanalytics.snowplow.ecommerce/product/jsonschema/1-0-0). This context enables you to track events related to products and product views, where product view events are commonly used to track a user visiting a product page, what information they see on that product page, and how they then interact with it. You can also track product list events, which are used for tracking views and interactions of any kind of list of products on an ecommerce store. These events are more commonly used for product list pages, but can also be used to track similar list-like elements.

{% enddocs %}

{% docs table_events %}

The `events` table contains all canonical events generated by [Snowplow's](https://snowplow.io/) trackers, including web, mobile and server side events.

{% enddocs %}