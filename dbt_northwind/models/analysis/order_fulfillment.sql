SELECT
    o.order_id,
    c.contact_name,
    CONCAT(EXTRACT(DAY FROM (CAST(o.required_date AS timestamp) - CAST(o.order_date AS timestamp))), ' days') AS expected_delivery_time,
    CONCAT(EXTRACT(DAY FROM (CAST(o.shipped_date AS timestamp) - CAST(o.order_date AS timestamp))), ' days' )AS actual_delivery_time,
    CASE
    WHEN (CAST(o.required_date AS timestamp) - CAST(o.order_date AS timestamp)) > (CAST(o.shipped_date AS timestamp) - CAST(o.order_date AS timestamp))
    THEN true
    ELSE false
    END AS is_delivery_delayed_onTime
FROM {{ ref('fact_order') }} AS o
JOIN {{ ref('dim_customer') }} AS c ON o.customer_id = c.customer_id

