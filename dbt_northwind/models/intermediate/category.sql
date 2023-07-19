-- transformed/category.sql
-- Extract data from the staging table in the northwind schema
-- Transform and save in intermediate schema

with intermediate_category_details as (
  SELECT
    DISTINCT CAST("categoryID" AS INT) AS category_id,
    "categoryName" AS category_name,
    description,
    CAST(false AS boolean) AS flag_status
  FROM {{ source('northwind_csv', 'categories') }}
  WHERE "categoryID" IS NOT NULL
  ORDER BY "categoryID"
)

SELECT
    category_id,
    category_name,
    description,
    flag_status
FROM intermediate_category_details
