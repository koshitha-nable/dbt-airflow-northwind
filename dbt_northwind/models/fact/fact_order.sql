-- models/my_view.sql
{{
  config(
    materialized='incremental',
  )
}}

with incremental_fact_order as (
    SELECT
        o.order_id,
        c.customer_id,
        e.employee_id,
        p.product_id,
        o.required_date,
        o.shipped_date,
        o.ship_via,
        o.freight,
        o.ship_name,
        od.unit_price,
        od.quantity,
        od.discount,
        p.units_in_stock,
        p.units_on_order,
        p.reorder_level,
        o.order_date,
        l.country
    FROM {{ ref('inter_orders') }} AS o
    JOIN {{ ref('customer') }} AS c ON o.customer_id = c.customer_id
    JOIN {{ ref('employee') }} AS e ON o.employee_id = e.employee_id
    JOIN {{ ref('inter_order_details') }} AS od ON o.order_id = od.order_id
    JOIN {{ ref('inter_products') }} AS p ON od.product_id = p.product_id
    JOIN {{ ref('location') }} AS l ON o.ship_country = l.country
    {% if is_incremental() %}

      -- this filter will only be applied on an incremental run
      where o.start_date > (select max(o.start_date) from {{ this }})

    {% endif %}
    ORDER BY o.order_id
)

SELECT *
FROM incremental_fact_order