DROP TABLE IF EXISTS raw_product_category_translation;
DROP TABLE IF EXISTS raw_sellers;
DROP TABLE IF EXISTS raw_products;
DROP TABLE IF EXISTS raw_orders;
DROP TABLE IF EXISTS raw_order_reviews;
DROP TABLE IF EXISTS raw_order_payments;
DROP TABLE IF EXISTS raw_order_items;
DROP TABLE IF EXISTS raw_geolocation;
DROP TABLE IF EXISTS raw_customers;

CREATE TABLE raw_customers (
    customer_id varchar(32),
    customer_unique_id varchar(32),
    customer_zip_code_prefix varchar(5),
    customer_city text,
    customer_state char(2)
);

CREATE TABLE raw_geolocation (
    geolocation_zip_code_prefix varchar(5),
    geolocation_lat double precision,
    geolocation_lng double precision,
    geolocation_city text,
    geolocation_state char(2)
);

CREATE TABLE raw_order_items (
    order_id varchar(32),
    order_item_id integer,
    product_id varchar(32),
    seller_id varchar(32),
    shipping_limit_date timestamp,
    price numeric(10,2),
    freight_value numeric(10,2)
);

CREATE TABLE raw_order_payments (
    order_id varchar(32),
    payment_sequential integer,
    payment_type text,
    payment_installments integer,
    payment_value numeric(10,2)
);

CREATE TABLE raw_order_reviews (
    review_id varchar(32),
    order_id varchar(32),
    review_score integer,
    review_comment_title text,
    review_comment_message text,
    review_creation_date timestamp,
    review_answer_timestamp timestamp
);

CREATE TABLE raw_orders (
    order_id varchar(32),
    customer_id varchar(32),
    order_status text,
    order_purchase_timestamp timestamp,
    order_approved_at timestamp,
    order_delivered_carrier_date timestamp,
    order_delivered_customer_date timestamp,
    order_estimated_delivery_date timestamp
);

CREATE TABLE raw_products (
    product_id varchar(32),
    product_category_name text,
    product_name_lenght integer,
    product_description_lenght integer,
    product_photos_qty integer,
    product_weight_g integer,
    product_length_cm integer,
    product_height_cm integer,
    product_width_cm integer
);

CREATE TABLE raw_sellers (
    seller_id varchar(32),
    seller_zip_code_prefix varchar(5),
    seller_city text,
    seller_state char(2)
);

CREATE TABLE raw_product_category_translation (
    product_category_name text,
    product_category_name_english text
);
