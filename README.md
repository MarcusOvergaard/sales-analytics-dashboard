# Sales Analytics Dashboard: End-to-End E-Commerce Business Intelligence with SQL and Power BI

## Project Overview

This project is an end-to-end Business Intelligence portfolio project using the Olist Brazilian E-Commerce Public Dataset.

The goal is to simulate the workflow of a Junior Data Analyst: inspect raw data, design a relational model, write SQL analysis, build a Power BI dashboard, and communicate business findings clearly.

Current status:
Phase 2 - Documentation Foundation

No final analysis results have been produced yet.

## Business Problem

An e-commerce marketplace needs a clearer view of sales performance across revenue, orders, customers, products, and regions.

The planned dashboard will help stakeholders answer questions such as:

- How is revenue changing over time?
- Which regions drive the most sales?
- Which product categories and products generate the most revenue?
- Which customers and sellers contribute most to order activity?
- Where are delivery delays or review-score problems likely to appear?

Final conclusions and recommendations will be added only after SQL analysis and dashboard development are complete.

## Dataset Overview

Approved dataset:
Olist Brazilian E-Commerce Public Dataset

Source:
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

Raw data location:
`data/raw/`

Main tables:

| Table | Description |
|---|---|
| `customers` | Customer identifiers and location fields. |
| `orders` | Order status and lifecycle timestamps. |
| `order_items` | Item-level sales records with product, seller, price, and freight value. |
| `order_payments` | Payment method, installments, and payment value. |
| `order_reviews` | Review scores and optional review comments. |
| `products` | Product categories and product attributes. |
| `sellers` | Seller identifiers and location fields. |
| `geolocation` | ZIP-prefix geography reference data. |
| `product_category_translation` | Portuguese-to-English product category labels. |

Dataset notes:

- The recommended main reporting grain is one row per order item.
- Revenue will likely be based on `order_items.price`.
- Freight should be reported separately using `order_items.freight_value` unless later approved as part of total customer charge.
- Payment and review tables require careful modeling to avoid double counting.
- Geolocation data requires cleaning or aggregation before reliable map reporting.

## Planned Analysis

Planned SQL and business analysis areas:

- Revenue by month
- Revenue by customer region
- Revenue by product category
- Revenue by product
- Order volume over time
- Average order value
- Customer geography and repeat purchase indicators
- Seller performance
- Freight value analysis
- Delivery time analysis
- Late delivery analysis
- Review score analysis

Placeholder for final findings:
Final findings will be added after SQL analysis is complete.

Placeholder for business recommendations:
Business recommendations will be added after dashboard review and insight generation.

## Planned Dashboards

The planned Power BI report will contain five pages:

1. Executive Overview
   - Revenue
   - Orders
   - Customers
   - Average Order Value
   - Revenue trend
   - Revenue by region
   - Revenue by category

2. Sales Performance
   - Revenue by month
   - Revenue by category
   - Revenue by product
   - Seller contribution
   - Freight value context

3. Customer Analysis
   - Top customers
   - Customer geography
   - Repeat purchase indicators
   - Customer revenue distribution

4. Product Analysis
   - Category performance
   - Product performance
   - Product rankings
   - Review-score context

5. Operations & Delivery
   - Delivery time distribution
   - Delivery performance by region
   - Review score analysis
   - Seller delivery performance

Placeholder for dashboard screenshots:
Dashboard screenshots will be added after Power BI development.

## Tools Used

Planned tools:

- SQL for data modeling, cleaning, and analysis
- Power BI for dashboard creation
- Git/GitHub for version control
- Markdown for documentation
- Python may be used for lightweight data inspection or validation if needed

No SQL scripts or Power BI files have been created yet.

## Repository Structure

```text
sales-analytics-dashboard/
├── README.md
├── LICENSE
├── PROJECT_PLAN.md
├── data/
│   ├── raw/
│   ├── processed/
│   └── exports/
├── sql/
│   ├── schema/
│   ├── views/
│   ├── analysis/
│   └── validation/
├── powerbi/
│   ├── dashboard_design/
│   ├── screenshots/
│   └── exports/
├── docs/
│   ├── project_plan.md
│   ├── dataset_inventory.md
│   ├── table_relationships.md
│   ├── data_quality_report.md
│   ├── star_schema_recommendation.md
│   ├── data_dictionary.md
│   ├── business_questions.md
│   ├── dashboard_specification.md
│   └── research_log.md
└── assets/
    └── images/
```

## Documentation

Current documentation:

- `docs/dataset_inventory.md` - raw dataset files, tables, row counts, and column catalog
- `docs/table_relationships.md` - discovered keys and table relationships
- `docs/data_quality_report.md` - missing values, duplicates, and quality issues
- `docs/star_schema_recommendation.md` - documentation-only recommended dimensional model
- `docs/business_questions.md` - stakeholder questions for later analysis
- `docs/dashboard_specification.md` - planned Power BI pages, KPIs, visuals, filters, and drill-downs
- `docs/data_dictionary.md` - foundation data dictionary for reporting fields
- `docs/research_log.md` - dataset acquisition and inspection notes

## Project Status

Completed:

- Phase 0: Project Initialization
- Phase 1: Dataset Selection
- Phase 1.5: Dataset Acquisition & Inspection
- Phase 2: Documentation Foundation

Not started:

- SQL implementation
- Database schema creation
- Data cleaning scripts
- Power BI dashboard creation
- Business insight generation

## License

This project is licensed under the MIT License.
