# Business Questions

Phase 2 documentation foundation for the Sales Analytics Dashboard project.

Dataset: Olist Brazilian E-Commerce Public Dataset

Business focus:
- Primary: revenue, orders, customers, products, regions
- Secondary: delivery performance, reviews, seller performance

These are stakeholder questions the later SQL analysis and Power BI dashboard should be designed to answer. No analysis has been performed yet.

## Executive Management

1. How much total revenue was generated over the reporting period?
2. How many orders were placed, and how did order volume change over time?
3. What is the average order value, based on item price revenue at the order level?
4. Which customer regions or states generate the most revenue?
5. Which product categories contribute the largest share of revenue?
6. How much revenue is associated with delivered orders versus canceled, unavailable, or other non-completed order statuses?

## Sales Management

7. How has monthly revenue changed over time using `orders.order_purchase_timestamp`?
8. Which product categories generate the highest revenue from `order_items.price`?
9. Which individual products generate the highest revenue and order volume?
10. Which sellers contribute the most revenue and orders?
11. Which customer states have the highest order count and average order value?
12. How does freight value compare with item revenue across categories and regions?

## Product Management

13. Which product categories have the highest number of orders and sold items?
14. Which product categories have the highest average item price?
15. Which categories receive the highest and lowest average review scores?
16. Are products with richer product information, such as more photos or longer descriptions, associated with stronger sales performance?
17. Which product categories have the longest delivery times or highest late-delivery rates?

## Operations Management

18. What is the typical delivery time from purchase date to customer delivery date?
19. Which regions or states have the longest average delivery times?
20. Which sellers or seller regions are associated with longer delivery times or lower review scores?

## Dataset Fields Supporting These Questions

Key source tables:
- `orders`: order status, purchase timestamp, delivery timestamps, estimated delivery date, customer ID
- `order_items`: item price, freight value, product ID, seller ID, shipping limit date
- `customers`: customer unique ID, city, state, ZIP prefix
- `products`: product category, product attributes, package dimensions
- `product_category_translation`: English product category labels
- `sellers`: seller city, state, ZIP prefix
- `order_reviews`: review score and optional review text
- `order_payments`: payment type, installments, payment value

Important modeling caution:
Payment and review records can be multiple rows per order. They should be modeled or aggregated carefully before combining with order-item revenue.
