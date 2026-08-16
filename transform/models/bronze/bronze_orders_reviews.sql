{{
    config(
        materialized='view'
    )

}}


WITH raw_order_reviews AS (

    SELECT
        *
    FROM
        {{ source ( 'ecom', 'orders_reviews' ) }}
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
    raw_order_reviews
