# Data Dictionary

Phase 2 data dictionary foundation for the Sales Analytics Dashboard project.

Dataset: Olist Brazilian E-Commerce Public Dataset

Scope:
This document covers the most important fields likely to be used in reporting. It is not yet a final warehouse data dictionary.

## Orders

| Column Name | Table | Description | Expected Usage |
|---|---|---|---|
| `order_id` | `orders` | Unique order identifier. Main key connecting orders to order items, payments, and reviews. | Order count, joins, order-level reporting. |
| `customer_id` | `orders` | Order-level customer identifier linking an order to the customers table. | Join orders to customer geography and customer_unique_id. |
| `order_status` | `orders` | Order lifecycle status, such as delivered, shipped, canceled, unavailable, invoiced, processing, created, or approved. | Filter KPIs by completed/non-completed orders; status analysis. |
| `order_purchase_timestamp` | `orders` | Timestamp when the customer placed the order. | Main reporting date for revenue/order trends. |
| `order_approved_at` | `orders` | Timestamp when the order/payment was approved. | Approval timing and operational lifecycle analysis. |
| `order_delivered_carrier_date` | `orders` | Timestamp when the order was handed to the carrier. | Fulfillment timing and shipping process analysis. |
| `order_delivered_customer_date` | `orders` | Timestamp when the order was delivered to the customer. | Delivery-time calculation and on-time/late delivery analysis. |
| `order_estimated_delivery_date` | `orders` | Estimated/promised delivery date. | Late delivery calculation and delivery SLA reporting. |

## Order Items

| Column Name | Table | Description | Expected Usage |
|---|---|---|---|
| `order_id` | `order_items` | Order identifier linking each item line to the order header. | Join item-level revenue to order dates and customer geography. |
| `order_item_id` | `order_items` | Item sequence number within an order. | Composite key with `order_id`; item count. |
| `product_id` | `order_items` | Product identifier. | Join to product category and product attributes. |
| `seller_id` | `order_items` | Seller identifier. | Join to seller geography and seller performance reporting. |
| `shipping_limit_date` | `order_items` | Deadline/limit timestamp for seller shipment. | Seller fulfillment and shipping deadline analysis. |
| `price` | `order_items` | Item sale price, excluding freight. | Primary revenue measure for sales reporting. |
| `freight_value` | `order_items` | Freight/shipping amount associated with the item line. | Freight reporting; shipping-cost proxy; operational analysis. |

## Customers

| Column Name | Table | Description | Expected Usage |
|---|---|---|---|
| `customer_id` | `customers` | Order-level customer identifier; unique in the raw customers table. | Join customers to orders. |
| `customer_unique_id` | `customers` | Stable anonymized customer/person identifier. | Repeat customer analysis, customer counts, customer lifetime behavior. |
| `customer_zip_code_prefix` | `customers` | Customer ZIP/postal-code prefix. | Approximate geography joins; requires care because geolocation is not unique. |
| `customer_city` | `customers` | Customer city. | Customer geography reporting and drill-downs. |
| `customer_state` | `customers` | Customer Brazilian state code. | Regional revenue, orders, and customer reporting. |

## Products

| Column Name | Table | Description | Expected Usage |
|---|---|---|---|
| `product_id` | `products` | Unique product identifier. | Join products to order items; product-level performance reporting. |
| `product_category_name` | `products` | Product category in Portuguese. | Category reporting; join to English category translation. |
| `product_name_lenght` | `products` | Length of product name text. Raw source typo: `lenght`. | Optional product-content analysis; may be renamed later. |
| `product_description_lenght` | `products` | Length of product description text. Raw source typo: `lenght`. | Optional product-content analysis; may be renamed later. |
| `product_photos_qty` | `products` | Number of product photos. | Optional analysis of product content completeness versus sales. |
| `product_weight_g` | `products` | Product/package weight in grams. | Shipping and logistics analysis. |
| `product_length_cm` | `products` | Product/package length in centimeters. | Shipping and logistics analysis. |
| `product_height_cm` | `products` | Product/package height in centimeters. | Shipping and logistics analysis. |
| `product_width_cm` | `products` | Product/package width in centimeters. | Shipping and logistics analysis. |

## Product Category Translation

| Column Name | Table | Description | Expected Usage |
|---|---|---|---|
| `product_category_name` | `product_category_translation` | Portuguese product category name. | Join key from products to category translation. |
| `product_category_name_english` | `product_category_translation` | English product category name. | Dashboard category labels and stakeholder-readable reporting. |

## Sellers

| Column Name | Table | Description | Expected Usage |
|---|---|---|---|
| `seller_id` | `sellers` | Unique seller identifier. | Join sellers to order items; seller performance reporting. |
| `seller_zip_code_prefix` | `sellers` | Seller ZIP/postal-code prefix. | Approximate geography joins; requires care because geolocation is not unique. |
| `seller_city` | `sellers` | Seller city. | Seller geography reporting and drill-downs. |
| `seller_state` | `sellers` | Seller Brazilian state code. | Seller regional performance analysis. |

## Payments

| Column Name | Table | Description | Expected Usage |
|---|---|---|---|
| `order_id` | `order_payments` | Order identifier linking payment records to orders. | Payment analysis by order; must be aggregated carefully before joining to item revenue. |
| `payment_sequential` | `order_payments` | Payment sequence number within an order. | Composite key with `order_id`; supports multiple payment records per order. |
| `payment_type` | `order_payments` | Payment method, such as credit card, boleto, voucher, debit card, or not_defined. | Payment-method analysis and dashboard filters. |
| `payment_installments` | `order_payments` | Number of installments used for payment. | Installment behavior analysis; contains a small number of zero values requiring review. |
| `payment_value` | `order_payments` | Payment amount for the payment record. | Payment-value analysis; must be handled carefully to avoid double counting against item revenue. |

## Reviews

| Column Name | Table | Description | Expected Usage |
|---|---|---|---|
| `review_id` | `order_reviews` | Review identifier; not fully unique by itself in the raw data. | Review tracking; safest key is `review_id` plus `order_id`. |
| `order_id` | `order_reviews` | Order identifier linking reviews to orders. | Join review scores to order and delivery context. |
| `review_score` | `order_reviews` | Customer review score from 1 to 5. | Customer satisfaction KPI and operations-quality analysis. |
| `review_comment_title` | `order_reviews` | Optional review title. Mostly missing. | Optional text analysis later, not core KPI reporting. |
| `review_comment_message` | `order_reviews` | Optional review text. Mostly missing. | Optional text analysis later, not core KPI reporting. |
| `review_creation_date` | `order_reviews` | Review creation date. | Review timing analysis. |
| `review_answer_timestamp` | `order_reviews` | Timestamp when the review was answered/submitted. | Review response timing analysis. |

## Important Metric Notes

- Revenue should likely be based on `order_items.price`.
- Freight should be reported separately using `order_items.freight_value` unless later approved as part of total customer charge.
- Average Order Value should use order-level revenue after item lines are aggregated to orders.
- Customer count should likely use `customer_unique_id` for real customer/person counts.
- Payment records and review records can be multiple rows per order; avoid naive joins to order-item rows.
- Geolocation should be cleaned or aggregated before being used as a reporting dimension.
