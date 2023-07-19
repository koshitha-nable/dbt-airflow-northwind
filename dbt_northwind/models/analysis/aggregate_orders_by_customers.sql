SELECT
    c.customer_id,
    c.contact_name,
    COUNT(o.order_id) AS total_orders,
    SUM(
        CAST(o.unit_price AS FLOAT) * CAST(o.quantity AS FLOAT)
    ) AS total_orders_value,
    AVG(
        CAST(o.unit_price AS FLOAT) * CAST(o.quantity AS FLOAT)
    ) AS average_order_value
FROM {{ ref('fact_order') }} AS o
INNER JOIN {{ ref('dim_customer') }} AS c ON o.customer_id = c.customer_id
GROUP BY 1, 2
