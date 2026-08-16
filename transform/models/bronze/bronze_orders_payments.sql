{{
    config(
      materialized='view'   
    )
}}


WITH raw_order_payments AS (

    SELECT
        *
    FROM
        {{ source( 'ecom', 'orders_payments' ) }}

)

SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM
    raw_order_payments