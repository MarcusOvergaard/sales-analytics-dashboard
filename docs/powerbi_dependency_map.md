# Power BI Dependency Map

Phase: 2.5 - Final Data Model & SQL Roadmap

Status: Dependency map only. No Power BI file, dashboard, model, report, or DAX measure was created in this phase.

Purpose:
Identify the tables, measures, dimensions, and filters needed for each planned dashboard page.

---

# Shared Semantic Model Dependencies

## Required core tables

- FactOrderItems
- DimDate
- DimCustomer
- DimProduct
- DimSeller

## Recommended optional tables

- FactOrders for order lifecycle and delivery metrics
- FactReviews for review-score reporting
- FactPayments for payment reporting and payment-type filters
- DimOrderStatus for explicit order-status filtering
- DimPaymentType for payment-type filters
- DimGeography if map visuals require cleaned latitude/longitude

## Global planned measures

- Revenue
- Freight Value
- Orders
- Sold Items
- Customers
- Average Order Value
- Average Item Price
- Average Review Score
- Delivered Orders
- Average Delivery Time
- Median Delivery Time
- Late Delivery Count
- Late Delivery Rate
- Active Sellers
- Active Products

## Global filters

- Date range based on purchase date
- Order status or status group
- Customer state
- Customer city
- Product category
- Seller state
- Payment type, if FactPayments and DimPaymentType are included

---

# Page 1 - Executive Overview

Purpose:
High-level view of revenue, order volume, customer reach, and regional/category contribution.

Required tables:
- FactOrderItems
- DimDate
- DimCustomer
- DimProduct
- DimSeller
- DimOrderStatus optional

Required measures:
- Revenue
- Orders
- Customers
- Average Order Value
- Revenue by month
- Revenue by customer state
- Revenue by product category

Required dimensions:
- Purchase date from DimDate
- Customer state and customer city from DimCustomer
- Product category from DimProduct
- Seller state from DimSeller
- Order status/status group from DimOrderStatus or order status field

Required filters:
- Date range
- Order status
- Customer state
- Product category
- Seller state

Dependency notes:
- AOV must be calculated at order level, not by averaging item rows.
- Revenue should use item price by default, excluding freight.

---

# Page 2 - Sales Performance

Purpose:
Show how revenue and orders vary by time, product category, product, seller, freight, and region.

Required tables:
- FactOrderItems
- DimDate
- DimProduct
- DimSeller
- DimCustomer
- DimOrderStatus optional
- FactPayments and DimPaymentType optional, only if payment-type filtering is required

Required measures:
- Revenue
- Orders
- Average Order Value
- Freight Value
- Active Sellers
- Sold Items
- Freight-to-Revenue Ratio

Required dimensions:
- Purchase month from DimDate
- Product category and product ID from DimProduct
- Seller ID, seller city, seller state from DimSeller
- Customer state and customer city from DimCustomer
- Order status/status group
- Payment type, optional

Required filters:
- Date range
- Product category
- Customer state
- Seller state
- Order status
- Payment type, optional

Dependency notes:
- Payment type filtering should only be added after a safe payment-order relationship is implemented.
- Freight should remain visually separate from revenue unless total charge is approved later.

---

# Page 3 - Customer Analysis

Purpose:
Show customer distribution, repeat-purchase behavior, and regional demand.

Required tables:
- FactOrderItems
- DimCustomer
- DimDate
- DimProduct
- DimOrderStatus optional

Required measures:
- Customers
- Orders
- Revenue
- Average Orders per Customer
- Average Order Value
- Repeat Customer Count
- Repeat Customer Rate

Required dimensions:
- Customer unique ID from DimCustomer
- Customer state and customer city from DimCustomer
- Purchase date from DimDate
- Product category from DimProduct
- Customer segment, derived later from repeat-customer logic
- Order status/status group

Required filters:
- Date range
- Customer state
- Customer city
- Product category
- Order status

Dependency notes:
- Person-level customer reporting should use `customer_unique_id`.
- Order-level joins should still use `customer_id`.

---

# Page 4 - Product Analysis

Purpose:
Show which products and categories drive sales, item volume, review quality, and operational complexity.

Required tables:
- FactOrderItems
- DimProduct
- DimDate
- DimCustomer
- DimSeller
- FactReviews optional but recommended for review score
- FactOrders optional for delivery metrics
- DimOrderStatus optional

Required measures:
- Revenue
- Sold Items
- Orders
- Average Item Price
- Average Review Score
- Active Products
- Delivery Time, optional
- Late Delivery Rate, optional

Required dimensions:
- Product category
- Product ID
- Product photos quantity
- Product description length
- Product weight/dimensions, optional
- Review score, if FactReviews is included
- Customer state
- Seller state
- Purchase date
- Order status/status group

Required filters:
- Date range
- Product category
- Customer state
- Seller state
- Review score range
- Order status

Dependency notes:
- Review score must be aggregated carefully to avoid multiplication by item rows.
- Product attribute analysis is exploratory and should not be presented as causal.

---

# Page 5 - Operations & Delivery

Purpose:
Evaluate fulfillment performance, delivery delays, regional bottlenecks, and relationship between delivery and customer review scores.

Required tables:
- FactOrders
- FactOrderItems, aggregated carefully when product/seller/category context is needed
- FactReviews, for review score
- DimDate
- DimCustomer
- DimSeller
- DimProduct
- DimOrderStatus optional
- DimGeography optional for map visuals

Required measures:
- Average Delivery Time
- Median Delivery Time
- Late Delivery Count
- Late Delivery Rate
- Average Review Score
- Delivered Orders
- Orders

Required dimensions:
- Purchase date
- Delivered customer date
- Estimated delivery date
- Customer state and city
- Seller state, seller city, seller ID
- Product category
- Product ID
- Review score
- Delivery bucket, derived later
- Order status/status group

Required filters:
- Date range
- Customer state
- Seller state
- Product category
- Order status
- Review score

Dependency notes:
- Delivery metrics require valid purchase and delivered-customer timestamps.
- Late delivery requires delivered-customer date compared with estimated delivery date.
- Rows with missing or impossible timestamps should be flagged or excluded according to approved rules.
- Raw geolocation should not be used directly for map visuals until cleaned or aggregated.

---

# Dashboard Readiness Checklist

Before Power BI development begins:

- FactOrderItems exists and reconciles to raw order_items.
- DimDate, DimCustomer, DimProduct, and DimSeller exist and validate.
- Status logic for delivered versus non-completed orders is approved.
- AOV is implemented from order-level revenue, not item-row averages.
- Review and payment joins do not multiply item-level facts.
- Delivery metrics have valid timestamp rules.
- Product categories have English labels or fallback labels.
- Geography is either cleaned or limited to customer/seller city-state fields.

