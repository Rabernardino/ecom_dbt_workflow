{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key= ['review_id','order_id']
    )

}}


WITH bronze_orders_reviews AS (

    SELECT
        *
    FROM
        {{ ref( 'bronze_orders_reviews' ) }}
    WHERE
        {% if is_incremental() %}

            review_creation_date >= (SELECT MAX(review_creation_date) FROM {{ this }})

        {% endif %}
    
),


deduplicado_bronze_orders_reviews AS (
    
    SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY review_id,order_id ORDER BY review_creation_date DESC) AS RN
    FROM
        bronze_orders_reviews
)


SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
FROM
    deduplicado_bronze_orders_reviews
WHERE
    RN = 1