{{
    config(
        materialized='table'
    )
}}


WITH silver_order_items AS (

    SELECT
        *
    FROM
        {{ ref('silver_orders_items') }}

),


silver_products AS (

    SELECT
        *
    FROM
        {{ ref('silver_products') }}
)

select
  t1.order_id,
  t2.product_category_name,
  SUM(t1.price) as total_amount
from
  silver_order_items t1
LEFT JOIN
  silver_products t2
ON t1.product_id = t2.product_id
group by
  t1.order_id,
  t2.product_category_name