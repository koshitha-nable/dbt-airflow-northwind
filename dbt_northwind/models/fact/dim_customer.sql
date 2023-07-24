{{
    config(
        materialized='incremental',
        unique_key='customer_id'
    )
}}

  WITH incremental_data AS (
    SELECT
        customer_id,
        company_name,
        contact_name,
        flag_status,
        CAST(start_date AS date) AS start_date,
        CAST(end_date AS date) AS end_date
    FROM {{ ref('customer') }}
    {% if is_incremental() %}

      -- this filter will only be applied on an incremental run
      where start_date > (select max(start_date) from {{ this }})

    {% endif %}
  )


  SELECT *
  FROM incremental_data



