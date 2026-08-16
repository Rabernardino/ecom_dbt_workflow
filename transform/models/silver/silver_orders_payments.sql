{{
    config(
        materialized='table'
    )
}}


WITH bronze_orders_payments AS (

    SELECT
        *
    FROM
        {{ ref('bronze_orders_payments') }}
)


SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM
    bronze_orders_payments


