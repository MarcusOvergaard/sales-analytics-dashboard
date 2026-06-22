\set ON_ERROR_STOP on

-- Phase 3: Import raw Olist CSV files into raw staging tables.
-- Run with: psql -d sales_analytics_dashboard -f "sql/schema/02_import_raw_staging_data.sql"
-- Blank CSV fields are loaded as NULL by PostgreSQL COPY CSV defaults.

TRUNCATE TABLE
    raw_customers,
    raw_geolocation,
    raw_order_items,
    raw_order_payments,
    raw_order_reviews,
    raw_orders,
    raw_products,
    raw_sellers,
    raw_product_category_translation;

\copy raw_customers FROM '/home/marcusai/MyProjects/Sales Analytics Dashboard/data/raw/olist_customers_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy raw_geolocation FROM '/home/marcusai/MyProjects/Sales Analytics Dashboard/data/raw/olist_geolocation_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy raw_order_items FROM '/home/marcusai/MyProjects/Sales Analytics Dashboard/data/raw/olist_order_items_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy raw_order_payments FROM '/home/marcusai/MyProjects/Sales Analytics Dashboard/data/raw/olist_order_payments_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy raw_order_reviews FROM '/home/marcusai/MyProjects/Sales Analytics Dashboard/data/raw/olist_order_reviews_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy raw_orders FROM '/home/marcusai/MyProjects/Sales Analytics Dashboard/data/raw/olist_orders_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy raw_products FROM '/home/marcusai/MyProjects/Sales Analytics Dashboard/data/raw/olist_products_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy raw_sellers FROM '/home/marcusai/MyProjects/Sales Analytics Dashboard/data/raw/olist_sellers_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy raw_product_category_translation FROM '/home/marcusai/MyProjects/Sales Analytics Dashboard/data/raw/product_category_name_translation.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
