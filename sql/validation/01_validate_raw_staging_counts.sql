-- Validate raw staging row counts against the original CSV files

SELECT 'raw_customers' AS table_name, COUNT(*) AS row_count FROM raw_customers
UNION ALL SELECT 'raw_geolocation', COUNT(*) FROM raw_geolocation
UNION ALL SELECT 'raw_order_items', COUNT(*) FROM raw_order_items
UNION ALL SELECT 'raw_order_payments', COUNT(*) FROM raw_order_payments
UNION ALL SELECT 'raw_order_reviews', COUNT(*) FROM raw_order_reviews
UNION ALL SELECT 'raw_orders', COUNT(*) FROM raw_orders
UNION ALL SELECT 'raw_products', COUNT(*) FROM raw_products
UNION ALL SELECT 'raw_sellers', COUNT(*) FROM raw_sellers
UNION ALL SELECT 'raw_product_category_translation', COUNT(*) FROM raw_product_category_translation;
