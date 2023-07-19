-- models/my_view.sql
with orders_by_customers_view as (
    SELECT
        c.customer_id,
        c.contact_name AS customer_contact_name,
        c.contact_title AS customer_contact_title,
        c.address AS customer_address,
        c.city AS customer_city,
        c.region AS customer_region,
        c.postal_code AS customer_postal_code,
        c.country AS customer_country,
        c.phone AS customer_phone,
        c.fax AS customer_fax,
        c.flag_status AS customer_status,
        o.order_id,
        o.order_date,
        o.required_date AS order_required_date,
        o.shipped_date AS order_shipped_date,
        o.ship_via AS order_ship_via,
        o.freight AS order_freight,
        o.ship_name AS order_ship_name,
        o.ship_address AS order_ship_address,
        o.ship_city AS order_ship_city,
        o.ship_region AS order_ship_region,
        o.ship_postal_code AS order_ship_postal_code,
        o.ship_country AS order_ship_country
    FROM {{ ref('customer') }} AS c
    JOIN {{ ref('inter_orders') }} AS o
    ON c.customer_id = o.customer_id
    ORDER BY c.customer_id
)

SELECT *
FROM orders_by_customers_view

