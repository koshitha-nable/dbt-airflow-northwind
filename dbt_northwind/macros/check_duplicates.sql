--defines the macro name and the arguments
{% macro check_duplicates(model_name, table_name, primary_key) %}
  -- Check for duplicates based on primary key
  SELECT
    '{{ model_name }}' AS model_name,
    '{{ table_name }}' AS table_name,
    '{{ primary_key }}' AS column_name,
    COUNT(*) - COUNT(DISTINCT {{ primary_key }}) AS duplicate_count
  FROM {{ table_name }}
  GROUP BY {{ primary_key }}
  HAVING COUNT(*) > 1
  UNION ALL
  -- Return an empty result set if no duplicates found
  SELECT
    '{{ model_name }}' AS model_name,
    '{{ table_name }}' AS table_name,
    NULL AS column_name,
    0 AS duplicate_count
{% endmacro %}
