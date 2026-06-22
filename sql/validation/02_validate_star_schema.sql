-- Row counts

SELECT 'dim_customer' AS table_name, COUNT(*) AS row_count FROM dim_customer
UNION ALL SELECT 'dim_product', COUNT(*) FROM dim_product
UNION ALL SELECT 'dim_seller', COUNT(*) FROM dim_seller
UNION ALL SELECT 'dim_date', COUNT(*) FROM dim_date
UNION ALL SELECT 'fact_order_items', COUNT(*) FROM fact_order_items;

-- Validate fact table total revenue against raw order items

SELECT
    'revenue_check' AS validation_check,
    (SELECT SUM(price) FROM raw_order_items) AS raw_total_price,
    (SELECT SUM(price) FROM fact_order_items) AS fact_total_price,
    (SELECT SUM(price) FROM fact_order_items) - (SELECT SUM(price) FROM raw_order_items) AS difference;

-- Relationship checks

SELECT COUNT(*) AS missing_customers
FROM fact_order_items f
LEFT JOIN dim_customer c ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL;