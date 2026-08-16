{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key=['order_id','order_item_id']
    )
}}


WITH bronze_orders_items AS (

    SELECT
        *
    FROM
        {{ ref('bronze_orders_items') }}
    WHERE
        order_id IS NOT NULL
        AND order_item_id IS NOT NULL
        {% if is_incremental() %}
        
            AND shipping_limit_date >= (SELECT MAX(shipping_limit_date) FROM {{ this }})
        
        {% endif %}
),


bronze_orders_items_deduplicado AS (

    SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY order_id, order_item_id ORDER BY shipping_limit_date DESC) as RN
    FROM
        bronze_orders_items
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
    bronze_orders_items_deduplicado
WHERE
    RN = 1

