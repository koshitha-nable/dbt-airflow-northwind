-- transformed/employee.sql
-- Extract data from the staging table in the northwind schema
-- Transform and save in intermediate schema

with intermediate_employee_details as (
  SELECT
    DISTINCT CAST("EmployeeID" AS INT) AS employee_id,
    "LastName" AS last_name,
    "FirstName" AS first_name,
    "Title" AS title,
    "TitleOfCourtesy" AS title_of_courtesy,
    CAST(CONCAT(SUBSTRING("BirthDate", 7, 4), '-', SUBSTRING("BirthDate", 4, 2), '-', SUBSTRING("BirthDate", 1, 2)) AS TIMESTAMP) AS birth_date,
    CAST(CONCAT(SUBSTRING("HireDate", 7, 4), '-', SUBSTRING("HireDate", 4, 2), '-', SUBSTRING("HireDate", 1, 2)) AS TIMESTAMP) AS hire_date,
    "Address" as address,
    "City" as city,
    "Region" as region,
    "PostalCode" AS postal_code,
    "Country" as country,
    "HomePhone" AS phone_number,
    CAST("Extension" AS INT) AS extension,
    CAST(COALESCE("ReportsTo", 0) AS INT) AS reports_to,
    CAST(false AS boolean) AS flag_status,
    CAST({{ dbt_date.today() }} AS date) AS start_date,
    NULL AS end_date
  FROM {{ source('northwind_csv', 'employees') }}
  WHERE "EmployeeID" IS NOT NULL
  ORDER BY employee_id
),

updated_employee_details AS (
  SELECT
    ied.employee_id,
    ied.last_name,
    ied.first_name,
    ied.title,
    ied.title_of_courtesy,
    ied.birth_date,
    ied.hire_date,
    ied.address,
    ied.city,
    ied.region,
    ied.postal_code,
    ied.country,
    ied.phone_number,
    ied.extension,
    ied.reports_to,
    ied.flag_status,
    ied.start_date,
    CAST({{ dbt_date.today() }} AS date) AS end_date
  FROM intermediate_employee_details ied
  LEFT JOIN (
    SELECT
      employee_id,
      MAX(start_date) AS max_start_date,
      MAX(end_date) AS end_date
    FROM intermediate_employee_details
    GROUP BY employee_id
  ) latest ON ied.employee_id = latest.employee_id AND ied.start_date = latest.max_start_date
)

SELECT
  employee_id,
  last_name,
  first_name,
  title,
  title_of_courtesy,
  birth_date,
  hire_date,
  address,
  city,
  region,
  postal_code,
  country,
  phone_number,
  extension,
  reports_to,
  flag_status,
  start_date,
  end_date
FROM updated_employee_details
