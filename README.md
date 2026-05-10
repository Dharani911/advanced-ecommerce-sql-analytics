# Advanced Ecommerce SQL Analytics

## Project Overview

This project demonstrates advanced SQL analytics for a realistic ecommerce business scenario using PostgreSQL.

The project focuses on practical business analysis such as revenue trends, product performance, customer behavior, repeat customers, payment status analysis, and month-over-month growth.

This project is designed as a portfolio project for roles such as:

- Data Analyst
- Business Analyst
- BI Analyst
- Product Analyst
- Junior Analytics Engineer
- AI/Data Analyst

## Business Scenario

An ecommerce company wants to understand:

- How much revenue is generated monthly, weekly, and daily
- Which products and categories perform best
- Which customers generate the highest value
- Whether payment failures are increasing
- How many customers are new vs returning
- How repeat customer behavior affects business performance

The SQL queries in this project answer these questions using clean, business-focused analysis.

## Skills Demonstrated

- PostgreSQL query writing
- Date-based analysis using `DATE_TRUNC`
- Aggregations using `SUM`, `COUNT`, and `AVG`
- Window functions using `LAG`, `DENSE_RANK`, and running totals
- Customer retention analysis
- Payment status and payment failure analysis
- Product and category performance analysis
- Month-over-month growth analysis
- Portfolio-ready SQL documentation

## Project Structure

```text
ecommerce-sql-analytics-portfolio/
│
├── README.md
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_insert_sample_data.sql
│   └── advanced_ecommerce_sql_analysis.sql
│
├── docs/
│   ├── business_questions.md
│   └── project_explanation.md
│
└── screenshots/
    └── add_query_result_screenshots_here.txt
```

## Database Used

This project uses PostgreSQL.

You can run the queries using:

- pgAdmin
- DBeaver
- PostgreSQL command line
- DataGrip
- Supabase SQL Editor

## How to Run This Project

### Step 1: Create the tables

Run:

```sql
sql/01_create_tables.sql
```

### Step 2: Insert sample data

Run:

```sql
sql/02_insert_sample_data.sql
```

### Step 3: Run the analysis queries

Run:

```sql
sql/advanced_ecommerce_sql_analysis.sql
```

## Main Business Questions Answered

1. What is the monthly revenue trend?
2. What is the weekly revenue trend?
3. How many orders are placed each day?
4. Which weekday generates the highest revenue?
5. Which hour generates the highest revenue?
6. What are the top 10 products by revenue?
7. Which product performs best in each category?
8. Who is the top customer each month?
9. What is the running total revenue?
10. What is the month-over-month revenue growth?
11. What was each customer's previous order date?
12. How many days pass between customer purchases?
13. What percentage of customers are repeat customers?
14. What is the monthly payment status percentage?
15. Are payment failures increasing or decreasing?
16. What is the average order value by month?
17. How many unique customers purchase each month?
18. How many customers are new vs returning?
19. What is each category's monthly revenue share?
20. Which customers have the highest lifetime value?

## Suggested Portfolio Improvements

After running the SQL queries, add:

- Screenshots of query outputs
- A Power BI or Tableau dashboard
- A short business insight report
- A LinkedIn post explaining the project

## Author

Dharani Perumal Samy

MSc Data Analytics | SQL | Python | Power BI/Tableau | AI-assisted Analytics
