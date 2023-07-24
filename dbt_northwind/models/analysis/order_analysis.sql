-- Join the factOrder view with the intermediate.customer table
with factOrderCustomer as (
    SELECT
        fo.order_id,
        fo.customer_id,
        fo.product_id,
        fo.unit_price,
        fo.discount,
        fo.units_in_stock,
        fo.units_on_order,
        fo.reorder_level,
        fo.order_date,
        fo.country,
        c.company_name,
        c.contact_name
    FROM {{ ref('fact_order') }} AS fo
    JOIN {{ ref('dim_customer') }} AS c ON fo.customer_id = c.customer_id
),

-- Calculate aggregate statistics
orderStats AS (
    SELECT
        order_id,
        customer_id,
        product_id,
        AVG(unit_price) AS avg_unit_price,
        MAX(discount) AS max_discount,
        AVG(units_in_stock) AS avg_units_in_stock,
        MAX(units_on_order) AS max_units_on_order
    FROM factOrderCustomer
    GROUP BY
        order_id,
        customer_id,
        product_id
)

-- SELECT the desired columns from the factOrderCustomer and orderStats views
SELECT
    foc.order_id,
    foc.customer_id,
    foc.product_id,
    foc.unit_price,
    foc.discount,
    foc.units_in_stock,
    foc.units_on_order,
    foc.reorder_level,
    foc.order_date,
    foc.country,
    foc.company_name,
    foc.contact_name,
    os.avg_unit_price,
    os.max_discount,
    os.avg_units_in_stock,
    os.max_units_on_order
FROM factOrderCustomer AS foc
JOIN orderStats AS os ON foc.order_id = os.order_id
   AND foc.customer_id = os.customer_id
   AND foc.product_id = os.product_id
