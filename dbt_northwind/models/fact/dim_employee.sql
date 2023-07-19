{{ 
  config(
    materialized = 'incremental',
    unique_key = 'employee_id'
  )
}}

WITH incremental_data AS (
  SELECT
    employee_id,
    last_name,
    first_name,
    city,
    country,
    flag_status,
    start_date,
    end_date
  FROM {{ ref('employee') }}
  {% if is_incremental() %}
    -- this filter will be applied on incremental run
    WHERE start_date > (SELECT MAX(start_date) FROM {{ this }})
  {% endif %}
  WHERE flag_status = FALSE
)

SELECT *
FROM incremental_data
ORDER BY employee_id


