

{% test minimum_rows_counts(model, row_count) %}
{{ config(severity = 'warn') }}

SELECT
    COUNT(*) as ctn
FROM
    {{ model }}
HAVING
    COUNT(*) < {{ row_count }}

{% endtest %}