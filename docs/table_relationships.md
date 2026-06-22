# Table Relationships

Phase 1.5 relationship discovery for the Olist dataset. This is documentation only; no SQL schema was created.

## Relationship Map

```text

customers
  ↓ customer_id
orders
  ↓ order_id
order_items ── product_id ──→ products ── product_category_name ──→ product_category_translation
     │
     └─ seller_id ──→ sellers

orders ── order_id ──→ order_payments
orders ── order_id ──→ order_reviews

customers.customer_zip_code_prefix ──≈→ geolocation.geolocation_zip_code_prefix
sellers.seller_zip_code_prefix ─────≈→ geolocation.geolocation_zip_code_prefix
```

`≈` means approximate/reference relationship, not a strict one-to-one key. Geolocation has duplicate ZIP-prefix rows and should be cleaned or aggregated before dimensional modeling.

## Primary Keys and Candidate Keys

| Table | Recommended primary/candidate key | Notes |
|---|---|---|
| `customers` | `customer_id` | Unique and non-null. `customer_unique_id` is not unique; use for repeat-customer grouping. |
| `orders` | `order_id` | Unique and non-null. `customer_id` is also unique in this raw table and links one order row to one customer row. |
| `order_items` | `order_id`, `order_item_id` | Composite key is unique. |
| `order_payments` | `order_id`, `payment_sequential` | Composite key is unique. |
| `order_reviews` | `review_id`, `order_id` | Composite key is unique. `review_id` alone has duplicates; `order_id` alone has duplicates. |
| `products` | `product_id` | Unique and non-null. |
| `sellers` | `seller_id` | Unique and non-null. |
| `geolocation` | No safe raw primary key | Full-row duplicates exist; ZIP prefix is many-row. Aggregate/deduplicate before using as a dimension. |
| `product_category_translation` | `product_category_name` | Unique after reading the BOM-prefixed header correctly. English category is also unique in this file. |

## Foreign Key Discovery Checks

| Relationship | Child distinct keys | Parent distinct keys | Unmatched child keys | Notes |
|---|---:|---:|---:|---|
| `orders.customer_id -> customers.customer_id` | 99,441 | 99,441 | 0 | OK |
| `order_items.order_id -> orders.order_id` | 98,666 | 99,441 | 0 | OK |
| `order_items.product_id -> products.product_id` | 32,951 | 32,951 | 0 | OK |
| `order_items.seller_id -> sellers.seller_id` | 3,095 | 3,095 | 0 | OK |
| `payments.order_id -> orders.order_id` | 99,440 | 99,441 | 0 | OK |
| `reviews.order_id -> orders.order_id` | 98,673 | 99,441 | 0 | OK |
| `products.product_category_name -> translation.product_category_name` | 73 | 71 | 2 | Two product categories are not translated in the lookup. |
| `customers.customer_zip_code_prefix -> geolocation.geolocation_zip_code_prefix` | 14,994 | 19,015 | 157 | Approximate ZIP-prefix reference; some prefixes missing from geolocation. |
| `sellers.seller_zip_code_prefix -> geolocation.geolocation_zip_code_prefix` | 2,246 | 19,015 | 7 | Approximate ZIP-prefix reference; some prefixes missing from geolocation. |

## Relationship Notes

- `orders` is the central order header table.
- `order_items` is the best revenue fact grain because each row has `price` and `freight_value`.
- `order_payments` may contain multiple payment rows per order, so it should not be joined naively to item-level facts without aggregation or a separate payment fact.
- `order_reviews` can have multiple records per order and duplicate review IDs, so the safe key is composite.
- `geolocation` needs deduplication/aggregation before becoming a clean geography dimension.