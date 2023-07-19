-- models/order_purchase_analysis.model.sql

-- Define the model 
{{ config(materialized='table') }}

-- Join the factOrder view with the dim_products table
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
        p.product_id,
        p.product_name,
        p.category_id,
        p.supplier_id,
        p.quantity_per_unit,
        p.unit_price AS product_unit_price,
        p.units_in_stock AS product_units_in_stock,
        p.units_on_order AS product_units_on_order,
        p.reorder_level AS product_reorder_level

    FROM {{ ref('fact_order') }} AS fo
    JOIN {{ ref('dim_product') }} AS p ON fo.product_id = p.product_id
),

-- Select the popular products and their total quantity ordered
popular_products AS (
    SELECT
        product_id,
        product_name,
        SUM(units_on_order) AS total_quantity_ordered
    FROM factOrderCustomer
    GROUP BY product_id, product_name
    ORDER BY total_quantity_ordered DESC
    LIMIT 10 
)

-- Query to retrieve average revenue per product
SELECT
    pp.product_id,
    pp.product_name,
    AVG(unit_price * (1 - discount)) AS average_revenue_per_product
FROM factOrderCustomer AS fc
JOIN popular_products AS pp ON fc.product_id = pp.product_id
GROUP BY pp.product_id, pp.product_name
ORDER BY average_revenue_per_product DESC
