WITH employees_orders AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_date,
        o.required_date,
        o.shipped_date,
        o.ship_via,
        o.freight,
        o.ship_name,
        o.ship_address,
        o.ship_city,
        o.ship_region,
        o.ship_postal_code,
        o.ship_country,
        o.current_flag,
        e.employee_id,
        e.last_name,
        e.first_name,
        e.title,
        e.title_of_courtesy,
        e.birth_date,
        e.hire_date,
        e.address,
        e.city,
        e.postal_code,
        e.country,
        e.phone_number,
        e.extension,
        e.reports_to
    FROM
        {{ ref('employee') }} e
    JOIN
        {{ ref('inter_orders') }} o ON e.employee_id = o.employee_id
)

SELECT *
FROM employees_orders
