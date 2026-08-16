{{
    config(
        materialized='table'
    )
}}


WITH bronze_customers AS (

    SELECT
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state
    FROM
        {{ ref('bronze_customers') }}
)


SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM
    bronze_customers