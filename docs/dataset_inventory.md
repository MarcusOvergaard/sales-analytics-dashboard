# Dataset Inventory

Phase 1.5 documentation for the approved Olist Brazilian E-Commerce Public Dataset.

Raw data location: `data/raw/`

Source: Kaggle API public dataset endpoint for `olistbr/brazilian-ecommerce`.

Raw files are stored unmodified after download/extraction. No SQL, Power BI, or analysis artifacts were created.

## File and Table Inventory

| Raw file | Working table name | Rows | Columns | File size | Short description |
|---|---:|---:|---:|---:|---|
| `olist_customers_dataset.csv` | `customers` | 99,441 | 5 | 9,033,957 bytes | One row per order-level customer ID, including stable customer_unique_id and customer location. |
| `olist_geolocation_dataset.csv` | `geolocation` | 1,000,163 | 5 | 61,273,883 bytes | Brazilian ZIP prefix latitude/longitude and city/state reference data; not unique by ZIP prefix. |
| `olist_order_items_dataset.csv` | `order_items` | 112,650 | 7 | 15,438,671 bytes | One row per item line within an order, including product, seller, price, freight, and shipping-limit date. |
| `olist_order_payments_dataset.csv` | `order_payments` | 103,886 | 5 | 5,777,138 bytes | One row per payment event/sequence for an order, including payment type, installments, and payment value. |
| `olist_order_reviews_dataset.csv` | `order_reviews` | 99,224 | 7 | 14,451,670 bytes | Customer review records for orders, including score, optional comments, and review timestamps. |
| `olist_orders_dataset.csv` | `orders` | 99,441 | 8 | 17,654,914 bytes | One row per order, including customer ID, order status, purchase date, approval date, delivery dates, and estimated delivery date. |
| `olist_products_dataset.csv` | `products` | 32,951 | 9 | 2,379,446 bytes | One row per product ID, including category, description/name metadata, photo count, weight, and package dimensions. |
| `olist_sellers_dataset.csv` | `sellers` | 3,095 | 4 | 174,703 bytes | One row per marketplace seller, including seller ZIP prefix, city, and state. |
| `product_category_name_translation.csv` | `product_category_translation` | 71 | 2 | 2,613 bytes | Portuguese-to-English product category lookup table. |

Additional downloaded archive retained for provenance: `data/raw/olist_brazilian_ecommerce.zip`.

## Column Catalog

### `customers` (`olist_customers_dataset.csv`)

One row per order-level customer ID, including stable customer_unique_id and customer location.

| Column | Identified data type | Business meaning |
|---|---|---|
| `customer_id` | text | Order-level customer identifier; joins customers to orders. Olist treats this as unique per order context. |
| `customer_unique_id` | text | Stable anonymized customer/person identifier; supports repeat-customer analysis across orders. |
| `customer_zip_code_prefix` | text | Customer ZIP/postal-code prefix; can be linked approximately to geolocation. |
| `customer_city` | text | Customer city. |
| `customer_state` | text | Customer Brazilian state code. |

### `geolocation` (`olist_geolocation_dataset.csv`)

Brazilian ZIP prefix latitude/longitude and city/state reference data; not unique by ZIP prefix.

| Column | Identified data type | Business meaning |
|---|---|---|
| `geolocation_zip_code_prefix` | text | ZIP/postal-code prefix represented by a coordinate/city/state row. |
| `geolocation_lat` | decimal | Latitude for the ZIP prefix/location row. |
| `geolocation_lng` | decimal | Longitude for the ZIP prefix/location row. |
| `geolocation_city` | text | City name for the geolocation row. |
| `geolocation_state` | text | Brazilian state code for the geolocation row. |

### `order_items` (`olist_order_items_dataset.csv`)

One row per item line within an order, including product, seller, price, freight, and shipping-limit date.

| Column | Identified data type | Business meaning |
|---|---|---|
| `order_id` | text | Order identifier; main key connecting orders, order items, payments, and reviews. |
| `order_item_id` | integer | Line-item sequence number within an order; with order_id identifies an item line. |
| `product_id` | text | Product identifier; joins order items to products. |
| `seller_id` | text | Seller identifier; joins order items to sellers. |
| `shipping_limit_date` | datetime | Seller shipping deadline/limit timestamp for the item. |
| `price` | decimal | Item sale price, excluding freight. |
| `freight_value` | decimal | Freight/shipping amount charged for the item. |

### `order_payments` (`olist_order_payments_dataset.csv`)

One row per payment event/sequence for an order, including payment type, installments, and payment value.

| Column | Identified data type | Business meaning |
|---|---|---|
| `order_id` | text | Order identifier; main key connecting orders, order items, payments, and reviews. |
| `payment_sequential` | integer | Payment sequence number within an order; supports multiple payments per order. |
| `payment_type` | text | Payment method, such as credit card, boleto, voucher, debit card, or not_defined. |
| `payment_installments` | integer | Number of payment installments. |
| `payment_value` | decimal | Payment amount for the payment record. |

### `order_reviews` (`olist_order_reviews_dataset.csv`)

Customer review records for orders, including score, optional comments, and review timestamps.

| Column | Identified data type | Business meaning |
|---|---|---|
| `review_id` | text | Review identifier; not fully unique by itself in this raw dataset. |
| `order_id` | text | Order identifier; main key connecting orders, order items, payments, and reviews. |
| `review_score` | integer | Customer review score from 1 to 5. |
| `review_comment_title` | text | Optional review comment title. |
| `review_comment_message` | text | Optional review free-text message. |
| `review_creation_date` | datetime | Date the review was created/sent to customer after fulfillment. |
| `review_answer_timestamp` | datetime | Timestamp when the customer answered/submitted the review. |

### `orders` (`olist_orders_dataset.csv`)

One row per order, including customer ID, order status, purchase date, approval date, delivery dates, and estimated delivery date.

| Column | Identified data type | Business meaning |
|---|---|---|
| `order_id` | text | Order identifier; main key connecting orders, order items, payments, and reviews. |
| `customer_id` | text | Order-level customer identifier; joins customers to orders. Olist treats this as unique per order context. |
| `order_status` | text | Current/final order lifecycle status. |
| `order_purchase_timestamp` | datetime | Timestamp when the customer placed the order. |
| `order_approved_at` | datetime | Timestamp when payment/order approval occurred. |
| `order_delivered_carrier_date` | datetime | Timestamp when the order was handed to the carrier. |
| `order_delivered_customer_date` | datetime | Timestamp when the order was delivered to the customer. |
| `order_estimated_delivery_date` | datetime | Estimated delivery deadline/date promised to the customer. |

### `products` (`olist_products_dataset.csv`)

One row per product ID, including category, description/name metadata, photo count, weight, and package dimensions.

| Column | Identified data type | Business meaning |
|---|---|---|
| `product_id` | text | Product identifier; joins order items to products. |
| `product_category_name` | text | Portuguese product category name; joins products to category translation. |
| `product_name_lenght` | integer | Length of product name text. Raw column name contains Olist typo: lenght. |
| `product_description_lenght` | integer | Length of product description text. Raw column name contains Olist typo: lenght. |
| `product_photos_qty` | integer | Number of product photos. |
| `product_weight_g` | integer | Product weight in grams. |
| `product_length_cm` | integer | Product package length in centimeters. |
| `product_height_cm` | integer | Product package height in centimeters. |
| `product_width_cm` | integer | Product package width in centimeters. |

### `sellers` (`olist_sellers_dataset.csv`)

One row per marketplace seller, including seller ZIP prefix, city, and state.

| Column | Identified data type | Business meaning |
|---|---|---|
| `seller_id` | text | Seller identifier; joins order items to sellers. |
| `seller_zip_code_prefix` | text | Seller ZIP/postal-code prefix; can be linked approximately to geolocation. |
| `seller_city` | text | Seller city. |
| `seller_state` | text | Seller Brazilian state code. |

### `product_category_translation` (`product_category_name_translation.csv`)

Portuguese-to-English product category lookup table.

| Column | Identified data type | Business meaning |
|---|---|---|
| `product_category_name` | text | Portuguese product category name; joins products to category translation. |
| `product_category_name_english` | text | English product category name. |
