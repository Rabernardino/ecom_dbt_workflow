{{
    config(
        materialized='view'
    )
}}


WITH raw_order_items AS (

    SELECT
        *
    FROM
        {{ source('ecom', 'order_items') }}
)


SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
FROM
    raw_order_items
WHERE
    order_id IS NOT NULL
    AND order_item_id IS NOT NULL


