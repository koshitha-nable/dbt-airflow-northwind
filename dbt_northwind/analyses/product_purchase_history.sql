-- models/product_purchase_history.model.sql

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

-- Create a table to store the product purchase history analysis
product_purchase_history_analysis AS (
    SELECT
        p.product_id,
        p.product_name,
        COUNT(DISTINCT fo.order_id) AS total_orders,
        SUM(fo.unit_price * (1 - fo.discount) * fo.quantity) AS total_revenue,
        AVG(fo.unit_price * (1 - fo.discount)) AS average_price,
        SUM(fo.quantity) AS total_quantity,
        MAX(fo.order_date) AS last_purchase_date
    FROM factOrderCustomer AS fo
    JOIN dim_products AS p ON fo.product_id = p.product_id
    GROUP BY p.product_id, p.product_name
);

-- Specify the output table for the model
SELECT * FROM product_purchase_history_analysis
