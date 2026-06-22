# Dashboard Specification

Phase 2 dashboard design foundation for the Sales Analytics Dashboard project.

Dataset: Olist Brazilian E-Commerce Public Dataset

Project title:
Sales Analytics Dashboard: End-to-End E-Commerce Business Intelligence with SQL and Power BI

Dashboard tool:
Power BI

Status:
Specification only. No Power BI file or dashboard has been created.

## Dashboard Goals

The dashboard should help stakeholders understand e-commerce sales performance across revenue, orders, customers, products, and regions, with secondary views into delivery performance, review scores, and seller contribution.

Primary users:
- Executive Management
- Sales Management
- Product Management
- Operations Management

## Global Reporting Assumptions To Confirm Later

- Main revenue measure should likely use `order_items.price`.
- Freight should be reported separately using `order_items.freight_value` unless approved as part of total customer charge.
- Order count should likely use distinct `orders.order_id`.
- Customer count should likely use distinct `customers.customer_unique_id` for real customer/person count and `customer_id` for order-level customer keys.
- Completed/delivered order logic must be defined before final KPI reporting.
- Payment and review tables should not be directly joined to item-level rows without aggregation.

## Global Filters

Recommended dashboard-level filters:
- Date range based on `orders.order_purchase_timestamp`
- Order status
- Customer state
- Customer city
- Product category, preferably English category name where available
- Seller state
- Payment type

---

# Page 1 - Executive Overview

## Purpose

Provide a high-level view of business performance for executive stakeholders: revenue, order volume, customer reach, and regional/category contribution.

## KPIs

- Revenue
- Orders
- Customers
- Average Order Value

## Visuals

1. KPI Cards
   - Total Revenue
   - Total Orders
   - Total Customers
   - Average Order Value

2. Revenue Trend
   - Line chart by month using purchase date
   - Measure: revenue from item price

3. Revenue by Region
   - Map or bar chart by customer state
   - Optional drill-down to customer city

4. Revenue by Category
   - Bar chart using product category English name where available
   - Fallback to Portuguese category name when no translation exists

## Filters

- Date range
- Order status
- Customer state
- Product category
- Seller state

## Drill-Down Opportunities

- Revenue trend: year → quarter → month
- Region: state → city
- Category: category → product ID
- Orders: status-level breakdown

---

# Page 2 - Sales Performance

## Purpose

Help Sales Management understand how revenue and orders vary by time, product category, product, seller, and region.

## KPIs

- Revenue
- Orders
- Average Order Value
- Freight Value
- Number of Active Sellers

## Visuals

1. Revenue by Month
   - Line or column chart by purchase month
   - Optional secondary line for order count

2. Revenue by Category
   - Bar chart ranked by total revenue
   - Include order count and average order value in tooltip

3. Revenue by Product
   - Table or bar chart ranked by product ID
   - Include product category and order count

4. Revenue by Seller
   - Bar chart or table ranked by seller revenue
   - Include seller city/state

5. Freight Value by Region or Category
   - Bar chart to show shipping-cost pressure areas

## Filters

- Date range
- Product category
- Customer state
- Seller state
- Order status
- Payment type

## Drill-Down Opportunities

- Month → order date
- Category → product ID
- Seller state → seller city → seller ID
- Customer state → customer city

---

# Page 3 - Customer Analysis

## Purpose

Help stakeholders understand customer distribution, repeat purchase behavior, and regional demand patterns.

## KPIs

- Total Customers
- Total Orders
- Average Orders per Customer
- Average Order Value
- Repeat Customer Count or Repeat Customer Rate

## Visuals

1. Top Customers
   - Table ranked by revenue using `customer_unique_id`
   - Include order count, revenue, average order value, and customer state

2. Customer Geography
   - Map or bar chart by customer state/city
   - Measures: customers, orders, revenue

3. Repeat Purchase Indicators
   - Distribution of orders per `customer_unique_id`
   - Repeat vs one-time customer split

4. Customer Revenue Distribution
   - Histogram or ranked table showing concentration of revenue across customers

## Filters

- Date range
- Customer state
- Customer city
- Product category
- Order status

## Drill-Down Opportunities

- State → city
- Customer segment: one-time vs repeat customers
- Customer → orders → products purchased

---

# Page 4 - Product Analysis

## Purpose

Help Product Management understand which products and categories drive sales, order volume, review quality, and operational complexity.

## KPIs

- Revenue
- Sold Items
- Orders
- Average Item Price
- Average Review Score
- Number of Active Products

## Visuals

1. Category Performance
   - Bar chart by product category
   - Measures: revenue, sold items, orders, average item price

2. Product Performance
   - Ranked table by product ID
   - Include category, revenue, sold items, average price, average review score

3. Product Rankings
   - Top N products by revenue
   - Top N products by sold items
   - Lowest-performing products by revenue or review score, if appropriate later

4. Product Attributes
   - Optional scatter plot: product photos or description length versus revenue/order count
   - Requires careful interpretation; this should be exploratory, not causal

## Filters

- Date range
- Product category
- Customer state
- Seller state
- Review score range
- Order status

## Drill-Down Opportunities

- Category → product ID
- Product → seller contribution
- Product → review score distribution
- Product → delivery performance

---

# Page 5 - Operations & Delivery

## Purpose

Help Operations Management evaluate fulfillment performance, delivery delays, regional bottlenecks, and the relationship between delivery and customer review scores.

## KPIs

- Average Delivery Time
- Median Delivery Time
- Late Delivery Count
- Late Delivery Rate
- Average Review Score
- Delivered Orders

## Visuals

1. Delivery Time Distribution
   - Histogram of days from purchase timestamp to customer delivery date
   - Use delivered orders where valid delivery dates exist

2. Delivery Performance by Region
   - Bar chart or map by customer state
   - Measures: average delivery time, late delivery rate, delivered orders

3. Review Score Analysis
   - Bar chart of review score distribution
   - Average review score by delivery status or delivery-time bucket

4. Seller Delivery Performance
   - Table by seller ID or seller state
   - Measures: delivered orders, average delivery time, late rate, average review score

5. Estimated vs Actual Delivery
   - Late/on-time split based on `order_delivered_customer_date` compared with `order_estimated_delivery_date`

## Filters

- Date range
- Customer state
- Seller state
- Product category
- Order status
- Review score

## Drill-Down Opportunities

- State → city
- Seller state → seller ID
- Category → product ID
- Delivery bucket → order details

## Data Quality Notes For Dashboard Design

- Some order timestamps are missing and must be handled before delivery metrics are finalized.
- Geolocation data contains duplicates and should be cleaned or aggregated before map visuals.
- Review comments are mostly missing, but review scores are usable.
- Product categories need English translation where available; two categories lack translation in the lookup.
- Some payment values and installments contain anomalies that should be reviewed before payment reporting.
