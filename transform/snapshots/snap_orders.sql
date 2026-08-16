{% snapshot snap_orders %}

{{
    config(
        target_schema='dev',
        unique_key='order_id',
        strategy='check',
        check_cols=['order_status', 'order_estimated_delivery_date', 'order_delivered_carrier_date', 'order_delivered_customer_date']
    )
}}

SELECT
    *
FROM
    {{ ref('bronze_orders') }}

{% endsnapshot %}


