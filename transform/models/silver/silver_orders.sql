{{
    config(
        materialized='table'
    )
}}


WITH bronze_orders AS(

    SELECT
        *
    FROM
        {{ ref('snap_orders' )}}
    WHERE
        dbt_valid_to IS NULL
)

SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM
    bronze_orders
WHERE
    dbt_valid_to IS NULL



