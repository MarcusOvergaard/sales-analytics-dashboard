INSERT INTO fact_order_items (
    order_id,
    order_item_id,
    customer_id,
    product_id,
    seller_id,
    purchase_date_key,
    price,
    freight_value,
    quantity
)
SELECT
    oi.order_id,
    oi.order_item_id,
    o.customer_id,
    oi.product_id,
    oi.seller_id,
    o.order_purchase_timestamp::date,
    oi.price,
    oi.freight_value,
    1
FROM raw_order_items oi
JOIN raw_orders o
    ON oi.order_id = o.order_id;