-- dbt analysis model: product_analysis_stats
WITH productStats AS (
  SELECT
    product_id,
    COUNT(DISTINCT category_id) AS unique_categories, -- Count the number of unique categories the product belongs to
    COUNT(DISTINCT supplier_id) AS unique_suppliers, -- Count the number of unique suppliers for the product
    AVG(unit_price) AS avg_unit_price,
    MAX(units_in_stock) AS max_units_in_stock,
    MAX(units_on_order) AS max_units_on_order
  FROM {{ ref('dim_product') }}
  GROUP BY product_id
)

SELECT
  p.product_id,
  p.product_name,
  p.category_id,
  p.supplier_id,
  p.quantity_per_unit,
  p.unit_price,
  p.units_in_stock,
  p.units_on_order,
  p.reorder_level,
  p.category_name,
  p.units_in_stock * p.unit_price AS total_stock_value,
  CASE WHEN p.units_in_stock < p.reorder_level THEN 'Reorder' ELSE 'No Reorder' END AS reorder_status,
  ps.unique_categories,
  ps.unique_suppliers,
  ps.avg_unit_price,
  ps.max_units_in_stock,
  ps.max_units_on_order
FROM {{ ref('dim_product') }} AS p
JOIN productStats AS ps ON p.product_id = ps.product_id
