INSERT INTO dim_customer (
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
)
SELECT
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
FROM raw_customers
ON CONFLICT (customer_id) DO NOTHING;



INSERT INTO dim_seller (
    seller_id,
    seller_city,
    seller_state
)
SELECT
    seller_id,
    seller_city,
    seller_state
FROM raw_sellers
ON CONFLICT (seller_id) DO NOTHING;



INSERT INTO dim_product (
    product_id,
    product_category_name
)
SELECT
    p.product_id,
    p.product_category_name
FROM raw_products p
LEFT JOIN raw_product_category_translation t
    ON p.product_category_name = t.product_category_name
ON CONFLICT (product_id) DO NOTHING;



INSERT INTO dim_date (
    date_key,
    year,
    quarter,
    month,
    day,
    week,
    day_of_week
)
SELECT DISTINCT
    order_purchase_timestamp::date AS date_key,
    EXTRACT(YEAR FROM order_purchase_timestamp)::INTEGER AS year,
    EXTRACT(QUARTER FROM order_purchase_timestamp)::INTEGER AS quarter,
    EXTRACT(MONTH FROM order_purchase_timestamp)::INTEGER AS month,
    EXTRACT(DAY FROM order_purchase_timestamp)::INTEGER AS day,
    EXTRACT(WEEK FROM order_purchase_timestamp)::INTEGER AS week,
    TRIM(TO_CHAR(order_purchase_timestamp, 'Day')) AS day_of_week
FROM raw_orders
WHERE order_purchase_timestamp IS NOT NULL
ON CONFLICT (date_key) DO NOTHING;



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