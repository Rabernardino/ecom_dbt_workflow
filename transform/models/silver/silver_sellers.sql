{{
    config(
        materialized='table'
    )
}}


WITH bronze_sellers AS (
    SELECT
        *
    FROM
        {{ ref('bronze_sellers') }}
)


SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM
    bronze_sellers