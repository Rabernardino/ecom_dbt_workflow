{{
    config(
        materialized='table'
    )
}}


WITH customers_timestamps AS (
  select
    customer_id,
    order_id,
    order_purchase_timestamp,
    order_delivered_customer_date,
    extract(day from order_delivered_customer_date - order_purchase_timestamp) as customer_lead_time
  from
    {{ ref('silver_orders') }}

  where
    1=1
    AND order_status = 'delivered'
),

customers_info AS (
    select
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
  from
    {{ ref('silver_customers') }}
)

select
  t2.customer_unique_id,
  t1.order_id,
  t1.customer_lead_time,
  t2.customer_city,
  t2.customer_state
from
  customers_timestamps t1
LEFT JOIN
  customers_info t2

ON t1.customer_id = t2.customer_id
