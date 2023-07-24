-- This test verifies that there are no null records in the table

{% macro required_fields_not_null_test(schema_name_int,table_name_int,field_name) %}
SELECT COUNT(*) AS null_record_count
FROM {{schema_name_int}}.{{table_name_int}}
WHERE {{field_name}} IS NULL
{% endmacro %}

{% set null_records_count = required_fields_not_null_test() %}

{{ assert_equal(null_records_count, 0) }}
 