{{
    config(
        materialized='view'
    )
}}

WITH raw_geo AS (

    SELECT
        *
    FROM
        {{ source('ecom','geolocation') }}

)

SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
FROM
    raw_geo