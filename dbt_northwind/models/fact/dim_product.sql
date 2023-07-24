{{ 
  config(
    materialized = 'incremental',
    unique_key = 'product_id'
  )
}}

WITH incremental_data AS (
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
    p.current_flag,
    c.category_name,
    c.description,
    c.flag_status
  FROM {{ ref('inter_products') }} p
  JOIN {{ ref('category') }} c ON p.category_id = c.category_id
  {% if is_incremental() %}
    -- this filter will only be applied on an incremental run
    WHERE p.product_id > (SELECT MAX(product_id) FROM {{ this }})
  {% endif %}
  order by p.product_id
)

SELECT *
FROM incremental_data
