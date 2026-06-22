# SQL Implementation Roadmap

Phase: 2.5 roadmap, with Phase 3 raw staging implementation notes

Status: Phase 2.5 was roadmap-only. Phase 3 has now implemented only the SQL environment and raw staging layer; no final facts, dimensions, views, analysis queries, or Power BI files have been created.

Purpose:
Define the safe implementation order for the SQL phase before development begins.

---

# Implementation Principles

- Preserve `data/raw/` files unchanged.
- Load raw data first, then clean and model in later layers.
- Build and validate one layer at a time.
- Protect the item-level grain of FactOrderItems.
- Avoid direct many-to-many joins between item facts, payment facts, and review facts.
- Validate row counts, keys, and joins before creating dashboard-ready outputs.

---

# Recommended SQL Implementation Order

## Step 1 - Confirm SQL Environment

Goal:
Choose and confirm the database engine and local connection approach before writing implementation scripts.

Planned decisions:
- Database engine
- Database name
- CSV import method
- Folder structure for SQL scripts
- Naming convention for schemas, tables, views, and validation outputs

Acceptance checks:
- Database can be created locally.
- CSV files can be accessed from the project path.
- No raw files are modified.

---

## Step 2 - Create Raw Staging Tables

Goal:
Create tables that mirror the CSV files as closely as possible.

Tables to stage:
- customers
- geolocation
- order_items
- order_payments
- order_reviews
- orders
- products
- sellers
- product_category_translation

Rules:
- Preserve raw column names, including source typos such as `product_name_lenght`.
- Preserve raw source values.
- Handle BOM/header issue in product category translation.
- Use permissive staging types first if needed, then typed cleaned layers later.

Acceptance checks:
- Staging table row counts match documented raw CSV row counts.
- Expected column counts match documented raw CSV column counts.
- No transformations are hidden in raw staging.

---

## Step 3 - Import CSV Files

Goal:
Load all raw CSV files into raw staging tables.

Import order:
1. customers
2. orders
3. order_items
4. order_payments
5. order_reviews
6. products
7. sellers
8. geolocation
9. product_category_translation

Acceptance checks:
- All nine CSV tables load successfully.
- Row counts match the dataset inventory.
- Null and blank handling is documented.

---

## Step 4 - Validate Raw Staging Layer

Goal:
Check source structure before cleaning or modeling.

Validation areas:
- Row counts
- Column counts
- Primary/candidate key uniqueness
- Foreign key coverage
- Missing values
- Duplicate full rows
- Date sequence anomalies
- Payment anomalies

Acceptance checks:
- Raw validation results match Phase 1.5 findings or explain any differences.
- Known issues are flagged rather than silently removed.

---

## Step 5 - Create Cleaned Staging Layer

Goal:
Standardize data types and prepare reliable modeling inputs.

Planned transformations:
- Convert dates and timestamps to proper date/time types.
- Convert numeric fields such as price, freight value, payment value, dimensions, and weight.
- Standardize city/state text fields.
- Add explicit data-quality flags.
- Preserve raw source columns where useful for lineage.
- Create fallback labels for missing categories and translations.

Acceptance checks:
- Typed fields convert without unexplained row loss.
- Known anomalies remain visible through flags.
- Cleaned staging row counts are reconciled to raw staging row counts.

---

## Step 6 - Create Required Dimensions

Goal:
Create the core conformed dimensions needed for sales reporting.

Build order:
1. DimDate
2. DimCustomer
3. DimProduct
4. DimSeller

Acceptance checks:
- Dimension keys are unique.
- Required attributes are populated or explicitly flagged as unknown.
- DimProduct contains English category labels where available.
- DimCustomer supports both `customer_id` joins and `customer_unique_id` analysis.

---

## Step 7 - Create Optional Lookup Dimensions

Goal:
Create small supporting dimensions where they improve clarity.

Recommended optional dimensions:
1. DimOrderStatus
2. DimPaymentType
3. DimGeography, only after geolocation cleanup/aggregation

Acceptance checks:
- Order statuses have approved groupings.
- Payment types preserve `not_defined` but flag it clearly.
- Geography does not create duplicate joins or many-to-many row multiplication.

---

## Step 8 - Create FactOrderItems

Goal:
Create the main revenue fact at one row per order item.

Required inputs:
- Cleaned order_items
- Cleaned orders
- DimCustomer
- DimProduct
- DimSeller
- DimDate
- Optional DimOrderStatus

Acceptance checks:
- Composite key `order_id` + `order_item_id` is unique.
- Row count matches raw order_items count unless an approved filtering rule exists.
- Sum of item revenue reconciles to staged order_items price totals.
- Sum of freight value reconciles to staged order_items freight totals.
- No payment or review join has multiplied item rows.

---

## Step 9 - Create Optional FactOrders

Goal:
Create one row per order for lifecycle and delivery reporting.

Required inputs:
- Cleaned orders
- DimCustomer
- DimDate
- Optional DimOrderStatus

Acceptance checks:
- One row per order.
- Order count matches staged orders row count unless an approved filtering rule exists.
- Delivery metrics exclude or flag invalid/missing timestamp rows.
- Late-delivery calculation uses approved rules.

---

## Step 10 - Create Optional FactPayments

Goal:
Create payment analysis table without distorting item-level revenue.

Required inputs:
- Cleaned order_payments
- Optional DimPaymentType
- Orders for purchase-date/status context if needed

Acceptance checks:
- Composite key `order_id` + `payment_sequential` is unique.
- Payment total reconciles to staged order_payments totals.
- Invalid payment rows are flagged.
- Payment fact is not joined directly to FactOrderItems in a way that multiplies rows.

---

## Step 11 - Create Optional FactReviews

Goal:
Create review analysis table without distorting item-level revenue.

Required inputs:
- Cleaned order_reviews
- Orders for customer and delivery context if needed
- DimDate

Acceptance checks:
- Composite key `review_id` + `order_id` is unique.
- Review counts reconcile to staged order_reviews counts.
- Missing comments are handled as optional fields, not data loss.
- Review fact is not joined directly to FactOrderItems in a way that multiplies rows.

---

## Step 12 - Create Dashboard-Ready Views or Marts

Goal:
Prepare simplified outputs for Power BI after the core model is validated.

Planned output areas:
- Sales summary by date, category, seller, and region
- Customer summary by customer unique ID and geography
- Product/category summary
- Delivery performance summary
- Review score summary
- Payment summary, if payment reporting is included

Important:
This phase does not create views. This is only the future implementation order.

Acceptance checks:
- Each output has a defined grain.
- Each output maps to one or more dashboard pages.
- Measures reconcile back to fact tables.

---

## Step 13 - Create Validation Query Set

Goal:
Create repeatable checks for correctness before Power BI development.

Validation themes:
- Row-count reconciliation
- Key uniqueness
- Foreign-key coverage
- No accidental row multiplication
- Revenue and freight totals reconciliation
- Date range sanity checks
- Payment anomaly checks
- Review count checks
- Geography join behavior

Acceptance checks:
- Validation outputs are documented.
- Any failing checks are either fixed or explicitly accepted as known limitations.

---

## Step 14 - Document Final SQL Layer

Goal:
Update project documentation after implementation.

Docs to update later:
- Data dictionary
- Final model notes
- SQL implementation notes
- Dashboard specification, if measure definitions change
- Research log

Acceptance checks:
- Documentation matches the implemented SQL objects.
- Known caveats are visible to a portfolio reviewer.

---

# Recommended Script Organization For Later Phase

Suggested future folder usage:

- `sql/schema/` for table creation scripts
- `sql/views/` for dashboard-ready views or marts
- `sql/analysis/` for business-question outputs
- `sql/validation/` for quality checks and reconciliation queries

No files were added to those folders in Phase 2.5.

---

# Implementation Stop Conditions

Before moving from SQL implementation into Power BI, confirm:

- Required dimensions exist and validate.
- FactOrderItems exists and validates.
- Optional facts are either implemented or consciously deferred.
- Business questions have SQL-ready outputs.
- Dashboard dependencies are mapped to available tables and measures.
- Validation checks pass or have documented exceptions.

