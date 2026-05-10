# Advanced Ecommerce SQL Analytics

## Project Overview

This project demonstrates advanced SQL analytics for a realistic ecommerce business scenario using PostgreSQL.

The project focuses on practical business analysis such as revenue trends, product performance, customer behavior, repeat customers, payment status analysis, and month-over-month growth.

The goal of this project is to show how SQL can be used to answer real business questions and support data-driven decision-making.

This project is designed for portfolio demonstration for roles such as:

- Data Analyst
- Business Analyst
- BI Analyst
- Product Analyst
- Junior Analytics Engineer
- AI/Data Analyst

---

## Business Scenario

An ecommerce company wants to understand its sales, customer, product, and payment performance.

The business wants to answer questions such as:

- How much revenue is generated monthly, weekly, and daily?
- Which products and categories perform best?
- Which customers generate the highest value?
- Are payment failures increasing or decreasing?
- How many customers are new vs returning?
- How strong is repeat customer behavior?
- What is the month-over-month revenue growth?

The SQL queries in this project answer these questions using clean, business-focused PostgreSQL analysis.

---

## Skills Demonstrated

- PostgreSQL query writing
- Date-based analysis using `DATE_TRUNC`
- Aggregations using `SUM`, `COUNT`, and `AVG`
- Window functions using `LAG`, `DENSE_RANK`, and running totals
- Customer retention analysis
- Payment status and payment failure analysis
- Product and category performance analysis
- Month-over-month growth analysis
- Customer lifetime value ranking
- Portfolio-ready SQL documentation

---

## Project Structure

```text
advanced-ecommerce-sql-analytics/
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
    ├── monthly_revenue.png
    ├── top_products_by_revenue.png
    ├── month_over_month_growth.png
    ├── payment_status_percentage.png
    └── new_vs_returning_customers.png
