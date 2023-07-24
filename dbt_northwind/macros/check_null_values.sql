--defines the macro name and the parameters
{% macro check_null_values(model_name, table_name) %}
  -- Check for null values in all columns
  {% set column_list = execute('SHOW COLUMNS FROM ' ~ table_name) %}
  {% for column in column_list %}
    SELECT
      '{{ model_name }}' AS model_name,
      '{{ table_name }}' AS table_name,
      '{{ column.Field }}' AS column_name,
      COUNT(*) AS null_count
    FROM {{ table_name }}
    WHERE `{{ column.Field }}` IS NULL
    UNION ALL
  {% endfor %}
  -- Return an empty result set if no null values found
  SELECT
    '{{ model_name }}' AS model_name,
    '{{ table_name }}' AS table_name,
    NULL AS column_name,
    0 AS null_count
{% endmacro %}
