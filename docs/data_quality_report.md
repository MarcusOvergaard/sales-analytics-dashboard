# Data Quality Report

Phase 1.5 raw-data quality assessment. This report identifies issues only; it does not clean or transform data.

## Summary by Table

| Table | Rows | Duplicate full rows | Missing values | Potential issues | Columns requiring cleaning/review |
|---|---:|---:|---|---|---|
| `customers` | 99,441 | 0 | None | None obvious in raw table. | `customer_zip_code_prefix`, `customer_city`, `customer_state` for standardization/geography modeling. |
| `geolocation` | 1,000,163 | 261,831 | None | 261,831 duplicate full rows; ZIP prefix is not unique. | All columns; especially city spelling/case and ZIP-prefix aggregation. |
| `order_items` | 112,650 | 0 | None | No missing values; item grain is composite. Must avoid double counting when joined to payments/reviews. | `shipping_limit_date`, `price`, `freight_value`. |
| `order_payments` | 103,886 | 0 | None | 9 non-positive payment values; 2 records with zero installments; 3 `not_defined` payment types. | `payment_type`, `payment_installments`, `payment_value`. |
| `order_reviews` | 99,224 | 0 | `review_comment_title`: 87,658, `review_comment_message`: 58,274 | Optional comment fields are mostly missing; `review_id` alone is not unique. | `review_comment_title`, `review_comment_message`, review timestamps. |
| `orders` | 99,441 | 0 | `order_approved_at`: 160, `order_delivered_carrier_date`: 1,783, `order_delivered_customer_date`: 2,965 | Missing approval/carrier/customer delivery dates; 166 carrier dates before purchase; 23 customer delivery dates before carrier. | All timestamp columns and `order_status`. |
| `products` | 32,951 | 0 | `product_category_name`: 610, `product_name_lenght`: 610, `product_description_lenght`: 610, `product_photos_qty`: 610, `product_weight_g`: 2, `product_length_cm`: 2, `product_height_cm`: 2, `product_width_cm`: 2 | 610 products missing category/name/description/photo fields; 2 products missing weight/dimensions; 2 untranslated categories. | `product_category_name`, typo columns ending in `lenght`, weight/dimension fields. |
| `sellers` | 3,095 | 0 | None | None obvious in raw table. | `seller_zip_code_prefix`, `seller_city`, `seller_state` for standardization/geography modeling. |
| `product_category_translation` | 71 | 0 | None | Raw header contains UTF-8 BOM; translation table does not cover two product categories found in products. | `product_category_name` header/BOM, untranslated categories. |

## Detailed Checks

### Order status counts

| Status | Rows |
|---|---:|
| `delivered` | 96,478 |
| `shipped` | 1,107 |
| `canceled` | 625 |
| `unavailable` | 609 |
| `invoiced` | 314 |
| `processing` | 301 |
| `created` | 5 |
| `approved` | 2 |

### Order date checks

| Check | Count | Interpretation |
|---|---:|---|
| `approved_before_purchase` | 0 | Potentially impossible approval sequence. |
| `carrier_before_purchase` | 166 | Potential raw timestamp inconsistency requiring review. |
| `customer_before_purchase` | 0 | Potentially impossible delivery sequence. |
| `customer_before_carrier` | 23 | Potential carrier/customer timestamp inconsistency requiring review. |
| `estimated_before_purchase` | 0 | Potentially impossible estimate sequence. |
| `delivered_after_estimated` | 7,827 | Valid operational event for delivery-performance analysis, not necessarily dirty data. |

### Payment checks

- Non-positive `payment_value` rows: 9
- Zero `payment_installments` rows: 2
- Payment type counts: `credit_card` 76,795, `boleto` 19,784, `voucher` 5,775, `debit_card` 1,529, `not_defined` 3

### Product checks

- `weight_nonpositive_or_missing`: 6
- `length_nonpositive_or_missing`: 2
- `height_nonpositive_or_missing`: 2
- `width_nonpositive_or_missing`: 2

## Cleaning Needed Later

- Standardize timestamp columns and derive delivery-time fields only after approval.
- Deduplicate or aggregate geolocation before use.
- Decide how to handle canceled/unavailable orders in revenue KPIs.
- Preserve raw Portuguese categories, then add English category labels where available.
- Treat payment and review tables as separate fact-like tables or pre-aggregate them before joining to item-level revenue.