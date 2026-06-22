CREATE TABLE dim_customer (
    customer_id TEXT PRIMARY KEY,
    customer_unique_id TEXT,
    customer_city TEXT,
    customer_state TEXT
);
CREATE TABLE dim_seller (
    seller_id TEXT PRIMARY KEY,
    seller_city TEXT,
    seller_state TEXT
);
CREATE TABLE dim_product (
    product_id TEXT PRIMARY KEY,
    product_category_name TEXT,
    product_category_name_english TEXT
);
CREATE TABLE dim_date (
    date_key INTEGER PRIMARY KEY,
    year INTEGER,
    quarter INTEGER,
    month INTEGER,
    day INTEGER,
    day_of_week TEXT,
    week INTEGER
);
CREATE TABLE fact_order_items (
    order_id TEXT,
    order_item_id INTEGER,
    customer_id TEXT,
    product_id TEXT,
    seller_id TEXT,
    purchase_date_key DATE,
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),
    quantity INTEGER,

    PRIMARY KEY (order_id, order_item_id)
);