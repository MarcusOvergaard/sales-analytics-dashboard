# Star Schema Recommendation

Phase 1.5 modeling recommendation only. No SQL tables, views, or Power BI model were created.

## Recommended Business Grain

Primary analytical grain:

`one row per order item`

Reason: `order_items` contains product, seller, item price, freight value, and item sequence. This grain supports revenue, product, seller, category, and shipping-cost analysis without losing item-level detail.

## Recommended Fact Tables

| Fact table | Source table(s) | Grain | Measures / useful fields | Notes |
|---|---|---|---|---|
| `fact_order_items` | `order_items` + selected order dates/status | One row per order item | item price, freight value, item count, order count helper | Main sales/revenue fact. |
| `fact_payments` | `order_payments` | One row per order payment sequence | payment value, installments | Keep separate or aggregate by order before joining to item facts to avoid double counting. |
| `fact_reviews` | `order_reviews` | One row per review/order review record | review score, review count | Useful for satisfaction and delivery-performance context. |
| `fact_orders` optional | `orders` | One row per order | order count, lifecycle timestamps, delivery duration fields later | Useful for order-status and delivery SLA analysis. Can also be folded into `fact_order_items` depending on design. |

## Recommended Dimension Tables

| Dimension table | Source table(s) | Key | Description |
|---|---|---|---|
| `dim_customer` | `customers` | `customer_id` | Order-level customer location and customer_unique_id. |
| `dim_product` | `products` + `product_category_translation` | `product_id` | Product category, English category, photo count, weight, and dimensions. |
| `dim_seller` | `sellers` | `seller_id` | Seller city/state/ZIP prefix. |
| `dim_date` | Derived from order and review/payment dates later | date key | Calendar table for purchase, approval, delivery, estimated delivery, review, and shipping-limit dates. |
| `dim_geography` optional | `geolocation` + customer/seller ZIP prefixes | ZIP prefix or cleaned geo key | Geography reference after deduplication/aggregation. |
| `dim_payment_type` optional | `order_payments.payment_type` | payment type | Small lookup if payment reporting needs cleaner labels. |
| `dim_order_status` optional | `orders.order_status` | order status | Small lifecycle-status lookup. |

## Possible Star Schema Map

```text
                           dim_date
                              ↑
                              │ purchase_date / approval_date / delivery_date / estimated_date / shipping_limit_date
                              │
dim_customer ───────→ fact_order_items ←────── dim_product ←──── product_category_translation
                              ↑                    ↑
                              │                    │
                           dim_seller          dim_geography optional

orders/order_items provide the main sales grain.

fact_payments links to orders by order_id and should be aggregated carefully.
fact_reviews links to orders by order_id and should be modeled separately or aggregated carefully.
```

## Recommended Modeling Rules Later

- Use `fact_order_items` as the main revenue fact.
- Calculate gross item revenue from `price`; calculate freight revenue/cost proxy from `freight_value` only after metric definitions are approved.
- Do not join payments directly to order items without order-level aggregation; one order can have multiple item rows and multiple payment rows.
- Do not join reviews directly to order items without review/order aggregation; some orders have multiple review records.
- Use `customer_unique_id` for repeat-customer analysis, but keep `customer_id` as the order-level customer key.
- Clean/aggregate geolocation before adding it to a formal dimensional model.
- Preserve raw tables unchanged in `data/raw/`; all cleaning should happen later in processed/database layers.

## Business Analysis Potential

The dataset appears suitable for these later analyses:

- Revenue analysis by month, category, product, seller, and region.
- Customer analysis by location and repeat-customer behavior.
- Product/category performance analysis using Portuguese and English category labels.
- Delivery performance using purchase, carrier, customer delivery, shipping-limit, and estimated delivery dates.
- Review analysis using review scores and optional comments.
- Payment analysis by payment type, installments, and payment value.
- Geographic analysis by customer/seller state, city, and ZIP prefix after cleaning.
- Executive KPI reporting: orders, revenue, average order value, freight value, delivery timeliness, review score, customer count, seller count.

No business conclusions were generated in Phase 1.5.
