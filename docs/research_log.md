# Research Log

## Phase 1.5 - Dataset Acquisition & Inspection

Date: 2026-06-18

Approved dataset:
Olist Brazilian E-Commerce Public Dataset

Public source:
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

Acquisition notes:
- Downloaded the approved dataset using the Kaggle public dataset API endpoint.
- Stored the original downloaded archive in `data/raw/olist_brazilian_ecommerce.zip`.
- Extracted the raw CSV files into `data/raw/` without modifying their contents.
- No SQL scripts, Power BI files, dashboards, or business insights were created.

Files identified:
- `olist_customers_dataset.csv`
- `olist_geolocation_dataset.csv`
- `olist_order_items_dataset.csv`
- `olist_order_payments_dataset.csv`
- `olist_order_reviews_dataset.csv`
- `olist_orders_dataset.csv`
- `olist_products_dataset.csv`
- `olist_sellers_dataset.csv`
- `product_category_name_translation.csv`

Inspection outputs created:
- `docs/dataset_inventory.md`
- `docs/table_relationships.md`
- `docs/data_quality_report.md`
- `docs/star_schema_recommendation.md`

Key inspection findings:
- The dataset has strong relational structure around orders, customers, order items, products, sellers, payments, and reviews.
- The best future sales fact grain is likely one row per order item.
- Payment and review tables should be modeled carefully to avoid double counting.
- Geolocation needs deduplication or aggregation before dimensional use.
- Product category translation is mostly complete but misses two observed product categories.
- This phase stopped after acquisition and inspection only.

## Phase 2.5 - Final Data Model & SQL Roadmap

Date: 2026-06-18

Scope:
- Finalized the recommended production star schema as documentation.
- Defined required and optional fact tables.
- Defined required and optional dimension tables.
- Classified required data-cleaning work by priority.
- Created a SQL implementation roadmap without writing SQL code.
- Mapped business questions to future SQL outputs.
- Mapped Power BI dashboard pages to required model dependencies.

Deliverables created:
- `docs/final_data_model.md`
- `docs/sql_implementation_roadmap.md`
- `docs/analysis_mapping.md`
- `docs/powerbi_dependency_map.md`

Key modeling decisions:
- `FactOrderItems` remains the required primary sales fact table.
- Main analytical grain remains one row per order item.
- `FactPayments`, `FactReviews`, and `FactOrders` are useful optional facts but must be modeled at their own grains.
- Required dimensions are `DimDate`, `DimCustomer`, `DimProduct`, and `DimSeller`.
- Optional dimensions are `DimPaymentType`, `DimOrderStatus`, and `DimGeography`.
- Payment and review tables must not be naively joined to item-level revenue because they can multiply rows.
- Geolocation must be cleaned or aggregated before dimensional use.

Constraint confirmation:
- No SQL scripts were created.
- No schema files were created.
- No views or queries were created.
- No Power BI files were created.
- No business insights were generated.
- Work stopped at Phase 2.5 documentation.

## Phase 3 - SQL Environment and Raw Staging Setup

Date: 2026-06-21

Scope:
- Confirmed PostgreSQL as the SQL environment.
- Created the local database `sales_analytics_dashboard`.
- Created raw staging tables for all nine Olist CSV files.
- Imported the raw CSV files into PostgreSQL using the local `psql` client and `\copy`.
- Created a repeatable row-count validation script.

SQL environment:
- Engine: PostgreSQL 16.14.
- Database: `sales_analytics_dashboard`.
- Connection method: local PostgreSQL socket via `psql`.
- SQL client used: `psql`.

Raw staging objects created:
- `raw_customers`
- `raw_geolocation`
- `raw_order_items`
- `raw_order_payments`
- `raw_order_reviews`
- `raw_orders`
- `raw_products`
- `raw_sellers`
- `raw_product_category_translation`

Import and validation notes:
- Source CSV files remained unchanged in `data/raw/`.
- Blank CSV fields were loaded as NULL by PostgreSQL COPY CSV defaults.
- All nine raw staging table row counts matched the documented dataset inventory.

Deliverables created:
- `sql/schema/01_create_raw_staging_tables.sql`
- `sql/schema/02_import_raw_staging_data.sql`
- `sql/validation/01_validate_raw_staging_counts.sql`

Constraint confirmation:
- No final dimension tables were created.
- No final fact tables were created.
- No dashboard-ready views were created.
- No analysis queries were created.
- No Power BI files were created.
- No business insights were generated.
- Work stopped at raw staging and validation only.
