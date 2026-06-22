# Final Data Model

Phase: 2.5 - Final Data Model & SQL Roadmap

Status: Documentation only. No SQL scripts, schema files, queries, views, or Power BI files were created in this phase.

Dataset: Olist Brazilian E-Commerce Public Dataset

## Modeling Decision

The production model should use a star-schema design centered on item-level sales.

Primary analytical grain:

One row per order item.

Reason:
`order_items` contains the sellable line-item grain: order ID, item sequence, product, seller, price, freight value, and shipping-limit date. This is the safest grain for revenue, product, seller, category, and freight reporting.

Important rule:
Payments and reviews must not be joined directly to item-level facts without aggregation or separate fact tables, because one order can have multiple items, multiple payment rows, and multiple review rows.

---

# Recommended Production Star Schema

## Fact Tables

### Required: FactOrderItems

Purpose:
Main sales and revenue fact table.

Grain:
One row per order item, using the raw `order_items` line-item grain.

Primary key:
Composite key: `order_id` + `order_item_id`.

Foreign keys:
- `order_id` to FactOrders or order-level reporting logic
- `purchase_date_key` to DimDate
- `shipping_limit_date_key` to DimDate
- `customer_id` to DimCustomer, via `orders.customer_id`
- `product_id` to DimProduct
- `seller_id` to DimSeller
- `order_status` to DimOrderStatus, optional

Measures:
- Item revenue: `price`
- Freight value: `freight_value`
- Sold item count: one per fact row
- Distinct order count: count distinct `order_id`
- Average item price: average `price`
- Freight-to-revenue ratio: derived later from freight value divided by item revenue

Source tables:
- `order_items`
- `orders` for purchase date, order status, customer ID, and delivery fields where needed

Notes:
- Revenue should use item price by default.
- Freight should remain a separate measure unless explicitly approved as part of total customer charge.
- Canceled, unavailable, and non-delivered orders need explicit KPI rules before final reporting.

---

### Optional: FactPayments

Purpose:
Payment behavior and payment-value reporting.

Grain:
One row per payment sequence for each order.

Primary key:
Composite key: `order_id` + `payment_sequential`.

Foreign keys:
- `order_id` to FactOrders or order-level reporting logic
- `payment_type` to DimPaymentType
- `purchase_date_key` to DimDate, via `orders.order_purchase_timestamp` if payment trends use purchase date
- `order_status` to DimOrderStatus, optional

Measures:
- Payment value: `payment_value`
- Payment record count: one per fact row
- Installments: `payment_installments`
- Average payment value: derived
- Average installments: derived

Source tables:
- `order_payments`
- `orders` for purchase date and status context, if needed

Notes:
- Payment value should not be summed together with item revenue unless reconciliation logic is explicitly defined.
- Invalid payment rows must be reviewed before payment KPIs are trusted.

---

### Optional: FactReviews

Purpose:
Customer satisfaction and review-performance reporting.

Grain:
One row per order-review record.

Primary key:
Composite key: `review_id` + `order_id`.

Foreign keys:
- `order_id` to FactOrders or order-level reporting logic
- `review_creation_date_key` to DimDate
- `review_answer_date_key` to DimDate
- `customer_id` to DimCustomer, via orders if needed

Measures:
- Review score: `review_score`
- Review count: one per fact row
- Has review title flag: derived from `review_comment_title`
- Has review message flag: derived from `review_comment_message`
- Review response time: derived from `review_answer_timestamp` minus `review_creation_date`

Source tables:
- `order_reviews`
- `orders` for customer, order status, and delivery context if needed

Notes:
- Review comments are mostly missing, so review score should be the main review metric.
- Reviews should be aggregated to order level before combining with item-level revenue if used in the same visual.

---

### Optional: FactOrders

Purpose:
Order lifecycle, delivery performance, order-status reporting, and order-level KPI support.

Grain:
One row per order.

Primary key:
`order_id`.

Foreign keys:
- `customer_id` to DimCustomer
- `purchase_date_key` to DimDate
- `approved_date_key` to DimDate
- `carrier_delivery_date_key` to DimDate
- `customer_delivery_date_key` to DimDate
- `estimated_delivery_date_key` to DimDate
- `order_status` to DimOrderStatus

Measures:
- Order count: one per fact row
- Delivered order count: derived from status and delivery date rules
- Late delivery flag: derived from delivered customer date versus estimated delivery date
- Delivery days: derived from purchase timestamp to delivered customer timestamp
- Approval days or hours: derived from purchase timestamp to approval timestamp
- Carrier handling days: derived from approval timestamp to carrier handoff timestamp, if valid

Source tables:
- `orders`
- `customers` only for customer key validation, not as a measure source

Notes:
- This table is useful for delivery and operational analysis.
- Delivery metrics should exclude rows with missing or invalid delivery timestamps unless a separate exception category is needed.

---

## Dimension Tables

### Required: DimDate

Key:
`date_key`, recommended format: YYYYMMDD integer.

Attributes:
- Date
- Year
- Quarter
- Month number
- Month name
- Year-month
- Week number
- Day of month
- Day of week
- Weekend flag

Source columns:
Derived from all date/timestamp fields needed for reporting:
- `orders.order_purchase_timestamp`
- `orders.order_approved_at`
- `orders.order_delivered_carrier_date`
- `orders.order_delivered_customer_date`
- `orders.order_estimated_delivery_date`
- `order_items.shipping_limit_date`
- `order_reviews.review_creation_date`
- `order_reviews.review_answer_timestamp`

Notes:
- Purchase date should be the default reporting date for sales trends.
- Delivery and review dates should use role-playing date relationships in Power BI or clearly named date keys in SQL outputs.

---

### Required: DimCustomer

Key:
`customer_id`.

Attributes:
- Customer unique ID
- Customer ZIP code prefix
- Customer city
- Customer state
- Optional geography key after geography cleaning
- Repeat-customer flag or segment, derived later from `customer_unique_id`

Source columns:
- `customers.customer_id`
- `customers.customer_unique_id`
- `customers.customer_zip_code_prefix`
- `customers.customer_city`
- `customers.customer_state`

Notes:
- Use `customer_id` for joins.
- Use `customer_unique_id` for real customer/person counts and repeat-customer analysis.

---

### Required: DimProduct

Key:
`product_id`.

Attributes:
- Portuguese product category
- English product category
- Category reporting label, using English when available and a fallback when missing
- Product name length
- Product description length
- Product photo quantity
- Product weight in grams
- Product length in centimeters
- Product height in centimeters
- Product width in centimeters
- Optional product volume, derived from length x height x width
- Optional product completeness flags

Source columns:
- `products.product_id`
- `products.product_category_name`
- `products.product_name_lenght`
- `products.product_description_lenght`
- `products.product_photos_qty`
- `products.product_weight_g`
- `products.product_length_cm`
- `products.product_height_cm`
- `products.product_width_cm`
- `product_category_translation.product_category_name`
- `product_category_translation.product_category_name_english`

Notes:
- Preserve the raw source typo columns during staging, but expose clean reporting names later.
- Missing and untranslated categories need explicit fallback labels.

---

### Required: DimSeller

Key:
`seller_id`.

Attributes:
- Seller ZIP code prefix
- Seller city
- Seller state
- Optional seller geography key after geography cleaning

Source columns:
- `sellers.seller_id`
- `sellers.seller_zip_code_prefix`
- `sellers.seller_city`
- `sellers.seller_state`

Notes:
- Seller state and city support seller-performance and delivery-performance reporting.

---

### Optional: DimPaymentType

Key:
`payment_type`.

Attributes:
- Payment type raw value
- Payment type label
- Payment category/group
- Undefined-payment flag

Source columns:
- `order_payments.payment_type`

Notes:
- The raw value `not_defined` should be preserved but flagged.

---

### Optional: DimOrderStatus

Key:
`order_status`.

Attributes:
- Order status raw value
- Order status label
- Status group, such as completed, active, canceled, unavailable, or other
- Include-in-revenue flag, to be approved before final KPI reporting
- Include-in-delivery-analysis flag, to be approved before final KPI reporting

Source columns:
- `orders.order_status`

Notes:
- This dimension prevents hidden logic inside reports.
- The treatment of delivered versus canceled/unavailable orders must be explicit.

---

### Optional: DimGeography

Key:
Recommended cleaned geography key, based on ZIP prefix plus normalized city and state, or another explicit surrogate key during implementation.

Attributes:
- ZIP code prefix
- City
- State
- Average latitude
- Average longitude
- Source row count used in aggregation
- Geography quality flag

Source columns:
- `geolocation.geolocation_zip_code_prefix`
- `geolocation.geolocation_city`
- `geolocation.geolocation_state`
- `geolocation.geolocation_lat`
- `geolocation.geolocation_lng`
- `customers.customer_zip_code_prefix`
- `sellers.seller_zip_code_prefix`

Notes:
- Geolocation is not a clean raw dimension. It has duplicate rows and non-unique ZIP prefixes.
- Use it only after deduplication or aggregation.
- Customer and seller location fields can still support state/city reporting before full geolocation modeling.

---

# Data Cleaning Roadmap

## Critical Issues

| Issue | Tables | Required transformation | Reason |
|---|---|---|---|
| Preserve raw data unchanged | All raw CSVs | Load raw files into staging without modifying `data/raw/` | Reproducibility and auditability |
| Fact grain control | `order_items`, `order_payments`, `order_reviews` | Keep payments and reviews as separate facts or aggregate to order level before joining to item facts | Prevent double counting revenue, payments, and review scores |
| Order-status KPI rules | `orders` | Define completed, canceled, unavailable, and active-status treatment before revenue KPIs | Incorrect status handling can distort core KPIs |
| Timestamp validity for delivery metrics | `orders` | Flag missing delivery dates and impossible date sequences before deriving delivery days or late flags | Delivery KPIs depend on valid timestamps |
| Invalid payment records | `order_payments` | Flag non-positive payment values, zero installments, and `not_defined` payment types | Payment analysis needs trustworthy payment rows |
| Translation header handling | `product_category_translation` | Handle UTF-8 BOM in the raw header during import/staging | Prevent failed or incorrect category joins |

## Important Issues

| Issue | Tables | Required transformation | Reason |
|---|---|---|---|
| Missing product categories | `products` | Create explicit fallback category labels such as Unknown Category | Avoid blank category reporting |
| Missing English category translations | `products`, `product_category_translation` | Use English category when available; otherwise fall back to Portuguese or Untranslated Category | Dashboard labels should be readable and complete |
| Duplicate geolocation rows | `geolocation` | Deduplicate or aggregate by ZIP prefix/city/state before creating DimGeography | Prevent many-to-many geography joins |
| ZIP-prefix gaps | `customers`, `sellers`, `geolocation` | Allow unmatched geography keys and flag missing geolocation coverage | Some customer and seller ZIP prefixes are absent from geolocation |
| City/state standardization | `customers`, `sellers`, `geolocation` | Normalize text casing and whitespace for city/state fields | Cleaner filters and geography grouping |
| Product typo column names | `products` | Rename exposed reporting fields from `lenght` to `length` while preserving raw column lineage | Cleaner reporting layer and professional documentation |
| Product dimensions and weight anomalies | `products` | Flag missing or non-positive weight/dimension values | Shipping and logistics metrics depend on valid dimensions |
| Review key uniqueness | `order_reviews` | Use composite key `review_id` + `order_id` | `review_id` alone is not fully unique |

## Optional Enhancements

| Issue | Tables | Optional transformation | Reason |
|---|---|---|---|
| Product volume | `products` | Derive product volume from length, height, and width | Useful for logistics exploration |
| Product-content completeness | `products` | Create flags for missing photos, short descriptions, or missing category | Useful for product-quality analysis |
| Repeat-customer segments | `customers`, `orders` | Derive one-time versus repeat customer labels from `customer_unique_id` | Useful for customer dashboard page |
| Delivery buckets | `orders` | Create buckets such as same-week, 8-14 days, 15+ days, late/on-time | Useful for Power BI filtering and charts |
| Review-comment flags | `order_reviews` | Create has-comment and has-title flags | Useful because comment text is mostly missing |
| Payment grouping | `order_payments` | Group payment types into card, boleto, voucher, debit, undefined | Cleaner payment reporting |

---

# Model Acceptance Criteria Before SQL Development

Before implementation begins, the model design should be considered acceptable if:

- FactOrderItems is confirmed as the main sales fact.
- The primary item-level grain is explicitly protected.
- Payment and review double-counting risks are documented.
- Required dimensions are clearly defined.
- Optional dimensions are scoped but not overbuilt.
- Cleaning rules are classified by priority.
- Every planned dashboard page has a clear dependency on tables, measures, dimensions, and filters.

