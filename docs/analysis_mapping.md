# Analysis Mapping

Phase: 2.5 - Final Data Model & SQL Roadmap

Status: Documentation only. No SQL queries, views, analysis outputs, or insights were created in this phase.

Purpose:
Map each approved business question to the model tables, measures, dimensions, and future SQL output needed to answer it.

---

# Core Measure Definitions To Use Later

These are planned definitions, not implemented calculations.

| Measure | Planned basis | Notes |
|---|---|---|
| Revenue | Sum of FactOrderItems item revenue from `order_items.price` | Freight excluded by default |
| Freight Value | Sum of FactOrderItems freight value from `order_items.freight_value` | Report separately from revenue |
| Orders | Distinct count of `order_id` | Avoid counting item rows as orders |
| Sold Items | Count of FactOrderItems rows | One row per order item |
| Customers | Distinct count of `customer_unique_id` | Better person-level customer count |
| Average Order Value | Order-level revenue divided by distinct orders | Requires item revenue aggregated to order level |
| Average Item Price | Average item price | From FactOrderItems |
| Average Review Score | Average review score | Prefer order/category-level aggregation to avoid duplication |
| Average Delivery Time | Delivered customer timestamp minus purchase timestamp | Valid delivered orders only |
| Late Delivery Rate | Late delivered orders divided by delivered orders | Uses delivered date versus estimated delivery date |

---

# Business Question Mapping

| # | Business question | Required tables | Required measures | Required dimensions / filters | Future SQL output grain |
|---:|---|---|---|---|---|
| 1 | How much total revenue was generated over the reporting period? | FactOrderItems, DimDate, DimOrderStatus optional | Revenue | Purchase date, order status | One row summary, optionally by period |
| 2 | How many orders were placed, and how did order volume change over time? | FactOrderItems or FactOrders, DimDate | Orders | Purchase date | Month or date |
| 3 | What is the average order value, based on item price revenue at the order level? | FactOrderItems, DimDate, DimOrderStatus optional | Revenue, Orders, Average Order Value | Purchase date, order status | Order-level aggregation, then period summary |
| 4 | Which customer regions or states generate the most revenue? | FactOrderItems, DimCustomer, DimDate | Revenue, Orders, Customers | Customer state, customer city, purchase date | Customer state/city |
| 5 | Which product categories contribute the largest share of revenue? | FactOrderItems, DimProduct, DimDate | Revenue, Revenue Share, Orders, Sold Items | Product category, purchase date | Product category |
| 6 | How much revenue is associated with delivered orders versus canceled, unavailable, or other non-completed order statuses? | FactOrderItems, DimOrderStatus, DimDate | Revenue, Orders | Order status, status group, purchase date | Order status/status group |
| 7 | How has monthly revenue changed over time using purchase timestamp? | FactOrderItems, DimDate | Revenue, Orders | Purchase month, year | Month |
| 8 | Which product categories generate the highest revenue from item price? | FactOrderItems, DimProduct | Revenue, Orders, Sold Items | Product category | Product category |
| 9 | Which individual products generate the highest revenue and order volume? | FactOrderItems, DimProduct | Revenue, Orders, Sold Items, Average Item Price | Product ID, product category | Product ID |
| 10 | Which sellers contribute the most revenue and orders? | FactOrderItems, DimSeller | Revenue, Orders, Sold Items | Seller ID, seller city, seller state | Seller ID |
| 11 | Which customer states have the highest order count and average order value? | FactOrderItems, DimCustomer | Orders, Revenue, Average Order Value | Customer state | Customer state |
| 12 | How does freight value compare with item revenue across categories and regions? | FactOrderItems, DimProduct, DimCustomer | Revenue, Freight Value, Freight-to-Revenue Ratio | Product category, customer state/city | Category plus region |
| 13 | Which product categories have the highest number of orders and sold items? | FactOrderItems, DimProduct | Orders, Sold Items | Product category | Product category |
| 14 | Which product categories have the highest average item price? | FactOrderItems, DimProduct | Average Item Price, Revenue, Sold Items | Product category | Product category |
| 15 | Which categories receive the highest and lowest average review scores? | FactReviews, FactOrderItems aggregated to order/category, DimProduct | Average Review Score, Review Count | Product category, review score | Product category |
| 16 | Are products with richer product information associated with stronger sales performance? | FactOrderItems, DimProduct | Revenue, Orders, Sold Items, Average Item Price | Product photos, description length, product category | Product ID or product attribute bucket |
| 17 | Which product categories have the longest delivery times or highest late-delivery rates? | FactOrders, FactOrderItems aggregated to order/category, DimProduct | Average Delivery Time, Late Delivery Rate, Delivered Orders | Product category, purchase date | Product category |
| 18 | What is the typical delivery time from purchase date to customer delivery date? | FactOrders, DimDate | Average Delivery Time, Median Delivery Time, Delivered Orders | Purchase date, order status | Overall, period, or delivery bucket |
| 19 | Which regions or states have the longest average delivery times? | FactOrders, FactOrderItems or order/customer bridge, DimCustomer | Average Delivery Time, Late Delivery Rate, Delivered Orders | Customer state/city | Customer state/city |
| 20 | Which sellers or seller regions are associated with longer delivery times or lower review scores? | FactOrders, FactOrderItems aggregated to order/seller, FactReviews, DimSeller | Average Delivery Time, Late Delivery Rate, Average Review Score, Delivered Orders | Seller ID, seller state/city | Seller or seller region |

---

# Analysis Output Groups For Later SQL Phase

## Executive outputs

Planned outputs:
- Revenue and order KPI summary
- Monthly revenue and order trend
- Revenue by customer region
- Revenue by product category
- Revenue by order status group

Business questions covered:
1, 2, 3, 4, 5, 6, 7

---

## Sales outputs

Planned outputs:
- Revenue by category
- Revenue by product
- Revenue by seller
- Revenue and freight by region/category
- AOV by customer state

Business questions covered:
7, 8, 9, 10, 11, 12

---

## Product outputs

Planned outputs:
- Category performance summary
- Product performance summary
- Category review summary
- Product attribute performance summary
- Category delivery performance summary

Business questions covered:
13, 14, 15, 16, 17

---

## Operations outputs

Planned outputs:
- Delivery-time summary
- Late-delivery summary
- Delivery performance by customer region
- Seller delivery and review summary

Business questions covered:
18, 19, 20

---

# Modeling Warnings For Later SQL Analysis

- Average Order Value must be calculated after grouping item revenue to order level.
- Review scores must not be multiplied by item rows.
- Payment values must not be multiplied by item rows.
- Delivery metrics should use valid delivered orders only unless exception reporting is explicitly required.
- Category labels need fallback handling for missing or untranslated categories.
- Geography joins must not use raw geolocation rows directly because ZIP prefix is not unique.

