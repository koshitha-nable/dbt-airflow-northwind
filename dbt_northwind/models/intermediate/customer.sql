-- transformed/customers.sql
-- Extract data from the staging table in the northwind schema
-- Transform and save in intermediate schema

with intermediate_customer_details as (
  SELECT
    DISTINCT CAST("customerID" AS char(5)) AS customer_id,
    "companyName" AS company_name,
    "contactName" AS contact_name,
    "contactTitle" AS contact_title,
    address,
    city,
    region,
    "postalCode" AS postal_code,
    country,
    phone,
    fax,
    CAST(false AS boolean) AS flag_status,
    CAST({{ dbt_date.today() }} AS date) AS start_date,
    NULL AS end_date
  FROM {{ source('northwind_csv', 'customers') }}
  WHERE "customerID" IS NOT NULL
  ORDER BY customer_id
),

updated_customer_details AS (
  SELECT
    icd.customer_id,
    icd.company_name,
    icd.contact_name,
    icd.contact_title,
    icd.address,
    icd.city,
    icd.region,
    icd.postal_code,
    icd.country,
    icd.phone,
    icd.fax,
    icd.flag_status,
    icd.start_date,
    CAST({{ dbt_date.today() }} AS date) AS end_date
  FROM intermediate_customer_details icd
  LEFT JOIN (
    SELECT
      customer_id,
      MAX(start_date) AS max_start_date,
      MAX(end_date) AS end_date
    FROM intermediate_customer_details
    GROUP BY customer_id
  ) latest ON icd.customer_id = latest.customer_id AND icd.start_date = latest.max_start_date
)

SELECT
  customer_id,
  company_name,
  contact_name,
  contact_title,
  address,
  city,
  region,
  postal_code,
  country,
  phone,
  fax,
  flag_status,
  start_date,
  end_date
FROM updated_customer_details
