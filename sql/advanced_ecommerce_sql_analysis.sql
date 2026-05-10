/*
===============================================================================
 File Name     : advanced_ecommerce_sql_analysis.sql
 Project       : Advanced Ecommerce SQL Analytics
 Purpose       : Portfolio-ready SQL analysis file for Data Analytics and AI roles
 Database      : PostgreSQL
 Author        : Dharani Perumal Samy
 Focus Areas   : Date-based analysis, window functions, ranking, retention,
                 payment analytics, and business KPI reporting
===============================================================================
*/


-- =============================================================================
-- 1. MONTHLY REVENUE
-- =============================================================================

SELECT
    DATE_TRUNC('month', o.created_at) AS revenue_month,
    SUM(o.grand_total) AS monthly_revenue
FROM orders o
WHERE o.status = 'PAID'
GROUP BY DATE_TRUNC('month', o.created_at)
ORDER BY revenue_month;


-- =============================================================================
-- 2. WEEKLY REVENUE
-- =============================================================================

SELECT
    DATE_TRUNC('week', o.created_at) AS week_start_date,
    SUM(o.grand_total) AS weekly_revenue
FROM orders o
WHERE o.status = 'PAID'
GROUP BY DATE_TRUNC('week', o.created_at)
ORDER BY week_start_date;


-- =============================================================================
-- 3. DAILY ORDER COUNT
-- =============================================================================

SELECT
    o.created_at::date AS order_date,
    COUNT(*) AS total_orders
FROM orders o
GROUP BY o.created_at::date
ORDER BY order_date;


-- =============================================================================
-- 4. REVENUE BY WEEKDAY
-- =============================================================================

SELECT
    EXTRACT(DOW FROM o.created_at) AS weekday_number,
    TRIM(TO_CHAR(o.created_at, 'Day')) AS weekday_name,
    SUM(o.grand_total) AS total_revenue,
    COUNT(*) AS total_orders,
    ROUND(AVG(o.grand_total), 2) AS average_order_value
FROM orders o
WHERE o.status = 'PAID'
GROUP BY
    EXTRACT(DOW FROM o.created_at),
    TRIM(TO_CHAR(o.created_at, 'Day'))
ORDER BY total_revenue DESC;


-- =============================================================================
-- 5. REVENUE BY HOUR
-- =============================================================================

SELECT
    EXTRACT(HOUR FROM o.created_at) AS order_hour,
    SUM(o.grand_total) AS total_revenue,
    COUNT(*) AS total_orders,
    ROUND(AVG(o.grand_total), 2) AS average_order_value
FROM orders o
WHERE o.status = 'PAID'
GROUP BY EXTRACT(HOUR FROM o.created_at)
ORDER BY order_hour;


-- =============================================================================
-- 6. TOP 10 PRODUCTS BY REVENUE
-- =============================================================================

SELECT
    oi.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.total_amount) AS total_revenue,
    DENSE_RANK() OVER (
        ORDER BY SUM(oi.total_amount) DESC
    ) AS revenue_rank
FROM order_items oi
GROUP BY oi.product_name
ORDER BY revenue_rank
LIMIT 10;


-- =============================================================================
-- 7. TOP PRODUCT PER CATEGORY
-- =============================================================================

WITH product_revenue AS (
    SELECT
        oi.category_name,
        oi.product_name,
        SUM(oi.quantity) AS total_quantity_sold,
        SUM(oi.total_amount) AS total_revenue
    FROM order_items oi
    GROUP BY
        oi.category_name,
        oi.product_name
),
ranked_products AS (
    SELECT
        pr.category_name,
        pr.product_name,
        pr.total_quantity_sold,
        pr.total_revenue,
        DENSE_RANK() OVER (
            PARTITION BY pr.category_name
            ORDER BY pr.total_revenue DESC
        ) AS category_product_rank
    FROM product_revenue pr
)
SELECT
    category_name,
    product_name,
    total_quantity_sold,
    total_revenue,
    category_product_rank
FROM ranked_products
WHERE category_product_rank = 1
ORDER BY category_name;


-- =============================================================================
-- 8. TOP CUSTOMER PER MONTH
-- =============================================================================

WITH monthly_customer_revenue AS (
    SELECT
        DATE_TRUNC('month', o.created_at) AS revenue_month,
        o.customer_id,
        c.name AS customer_name,
        c.email AS customer_email,
        SUM(o.grand_total) AS customer_monthly_revenue
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.id
    WHERE o.status = 'PAID'
    GROUP BY
        DATE_TRUNC('month', o.created_at),
        o.customer_id,
        c.name,
        c.email
),
ranked_customers AS (
    SELECT
        mcr.revenue_month,
        mcr.customer_id,
        mcr.customer_name,
        mcr.customer_email,
        mcr.customer_monthly_revenue,
        DENSE_RANK() OVER (
            PARTITION BY mcr.revenue_month
            ORDER BY mcr.customer_monthly_revenue DESC
        ) AS monthly_customer_rank
    FROM monthly_customer_revenue mcr
)
SELECT
    revenue_month,
    customer_id,
    customer_name,
    customer_email,
    customer_monthly_revenue,
    monthly_customer_rank
FROM ranked_customers
WHERE monthly_customer_rank = 1
ORDER BY revenue_month;


-- =============================================================================
-- 9. RUNNING MONTHLY REVENUE
-- =============================================================================

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.created_at) AS revenue_month,
        SUM(o.grand_total) AS monthly_revenue
    FROM orders o
    WHERE o.status = 'PAID'
    GROUP BY DATE_TRUNC('month', o.created_at)
)
SELECT
    ms.revenue_month,
    ms.monthly_revenue,
    SUM(ms.monthly_revenue) OVER (
        ORDER BY ms.revenue_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue
FROM monthly_sales ms
ORDER BY ms.revenue_month;


-- =============================================================================
-- 10. MONTH-OVER-MONTH REVENUE GROWTH
-- =============================================================================

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.created_at) AS revenue_month,
        SUM(o.grand_total) AS monthly_revenue
    FROM orders o
    WHERE o.status = 'PAID'
    GROUP BY DATE_TRUNC('month', o.created_at)
),
sales_with_previous_month AS (
    SELECT
        ms.revenue_month,
        ms.monthly_revenue,
        LAG(ms.monthly_revenue) OVER (
            ORDER BY ms.revenue_month
        ) AS previous_month_revenue
    FROM monthly_sales ms
)
SELECT
    swpm.revenue_month,
    swpm.monthly_revenue,
    swpm.previous_month_revenue,
    swpm.monthly_revenue - swpm.previous_month_revenue AS revenue_difference,
    ROUND(
        (
            (swpm.monthly_revenue - swpm.previous_month_revenue)
            / NULLIF(swpm.previous_month_revenue, 0)
        ) * 100,
        2
    ) AS month_over_month_growth_percentage
FROM sales_with_previous_month swpm
ORDER BY swpm.revenue_month;


-- =============================================================================
-- 11. PREVIOUS ORDER DATE PER CUSTOMER
-- =============================================================================

SELECT
    o.customer_id,
    c.name AS customer_name,
    o.id AS order_id,
    o.created_at AS current_order_date,
    LAG(o.created_at) OVER (
        PARTITION BY o.customer_id
        ORDER BY o.created_at
    ) AS previous_order_date
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.id
WHERE o.status = 'PAID'
ORDER BY
    o.customer_id,
    o.created_at;


-- =============================================================================
-- 12. DAYS BETWEEN CUSTOMER PURCHASES
-- =============================================================================

WITH customer_order_sequence AS (
    SELECT
        o.customer_id,
        c.name AS customer_name,
        o.id AS order_id,
        o.created_at AS current_order_date,
        LAG(o.created_at) OVER (
            PARTITION BY o.customer_id
            ORDER BY o.created_at
        ) AS previous_order_date
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.id
    WHERE o.status = 'PAID'
)
SELECT
    cos.customer_id,
    cos.customer_name,
    cos.order_id,
    cos.current_order_date,
    cos.previous_order_date,
    EXTRACT(
        DAY FROM cos.current_order_date - cos.previous_order_date
    ) AS days_since_previous_purchase
FROM customer_order_sequence cos
ORDER BY
    cos.customer_id,
    cos.current_order_date;


-- =============================================================================
-- 13. REPEAT CUSTOMER PERCENTAGE
-- =============================================================================

WITH customer_order_count AS (
    SELECT
        o.customer_id,
        COUNT(*) AS paid_order_count
    FROM orders o
    WHERE o.status = 'PAID'
    GROUP BY o.customer_id
)
SELECT
    COUNT(*) AS total_purchasing_customers,
    COUNT(*) FILTER (
        WHERE coc.paid_order_count > 1
    ) AS repeat_customers,
    ROUND(
        COUNT(*) FILTER (
            WHERE coc.paid_order_count > 1
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_customer_percentage
FROM customer_order_count coc;


-- =============================================================================
-- 14. PAYMENT STATUS PERCENTAGE BY MONTH
-- =============================================================================

WITH monthly_payment_status AS (
    SELECT
        DATE_TRUNC('month', p.created_at) AS payment_month,
        p.status AS payment_status,
        COUNT(*) AS payment_count
    FROM payments p
    GROUP BY
        DATE_TRUNC('month', p.created_at),
        p.status
),
monthly_payment_total AS (
    SELECT
        mps.payment_month,
        SUM(mps.payment_count) AS total_payments
    FROM monthly_payment_status mps
    GROUP BY mps.payment_month
)
SELECT
    mps.payment_month,
    mps.payment_status,
    mps.payment_count,
    mpt.total_payments,
    ROUND(
        mps.payment_count * 100.0 / NULLIF(mpt.total_payments, 0),
        2
    ) AS payment_status_percentage
FROM monthly_payment_status mps
INNER JOIN monthly_payment_total mpt
    ON mps.payment_month = mpt.payment_month
ORDER BY
    mps.payment_month,
    mps.payment_status;


-- =============================================================================
-- 15. PAYMENT FAILURE MONTH-OVER-MONTH TREND
-- =============================================================================

WITH monthly_failed_payments AS (
    SELECT
        DATE_TRUNC('month', p.created_at) AS payment_month,
        COUNT(*) AS failed_payment_count
    FROM payments p
    WHERE p.status = 'FAILED'
    GROUP BY DATE_TRUNC('month', p.created_at)
),
failed_payments_with_previous_month AS (
    SELECT
        mfp.payment_month,
        mfp.failed_payment_count,
        LAG(mfp.failed_payment_count) OVER (
            ORDER BY mfp.payment_month
        ) AS previous_month_failed_payment_count
    FROM monthly_failed_payments mfp
)
SELECT
    fpwpm.payment_month,
    fpwpm.failed_payment_count,
    fpwpm.previous_month_failed_payment_count,
    fpwpm.failed_payment_count
        - fpwpm.previous_month_failed_payment_count AS failed_payment_difference,
    ROUND(
        (
            (
                fpwpm.failed_payment_count
                - fpwpm.previous_month_failed_payment_count
            )
            / NULLIF(fpwpm.previous_month_failed_payment_count, 0)
        ) * 100,
        2
    ) AS failed_payment_growth_percentage
FROM failed_payments_with_previous_month fpwpm
ORDER BY fpwpm.payment_month;


-- =============================================================================
-- 16. AVERAGE ORDER VALUE BY MONTH
-- =============================================================================

SELECT
    DATE_TRUNC('month', o.created_at) AS revenue_month,
    COUNT(*) AS total_paid_orders,
    SUM(o.grand_total) AS total_revenue,
    ROUND(AVG(o.grand_total), 2) AS average_order_value
FROM orders o
WHERE o.status = 'PAID'
GROUP BY DATE_TRUNC('month', o.created_at)
ORDER BY revenue_month;


-- =============================================================================
-- 17. MONTHLY UNIQUE CUSTOMERS
-- =============================================================================

SELECT
    DATE_TRUNC('month', o.created_at) AS revenue_month,
    COUNT(DISTINCT o.customer_id) AS unique_purchasing_customers
FROM orders o
WHERE o.status = 'PAID'
GROUP BY DATE_TRUNC('month', o.created_at)
ORDER BY revenue_month;


-- =============================================================================
-- 18. NEW VS RETURNING CUSTOMERS BY MONTH
-- =============================================================================

WITH customer_first_order AS (
    SELECT
        o.customer_id,
        MIN(DATE_TRUNC('month', o.created_at)) AS first_purchase_month
    FROM orders o
    WHERE o.status = 'PAID'
    GROUP BY o.customer_id
),
monthly_customer_activity AS (
    SELECT DISTINCT
        DATE_TRUNC('month', o.created_at) AS activity_month,
        o.customer_id
    FROM orders o
    WHERE o.status = 'PAID'
)
SELECT
    mca.activity_month,
    COUNT(*) FILTER (
        WHERE cfo.first_purchase_month = mca.activity_month
    ) AS new_customers,
    COUNT(*) FILTER (
        WHERE cfo.first_purchase_month < mca.activity_month
    ) AS returning_customers
FROM monthly_customer_activity mca
INNER JOIN customer_first_order cfo
    ON mca.customer_id = cfo.customer_id
GROUP BY mca.activity_month
ORDER BY mca.activity_month;


-- =============================================================================
-- 19. CATEGORY REVENUE SHARE BY MONTH
-- =============================================================================

WITH monthly_category_revenue AS (
    SELECT
        DATE_TRUNC('month', o.created_at) AS revenue_month,
        oi.category_name,
        SUM(oi.total_amount) AS category_revenue
    FROM orders o
    INNER JOIN order_items oi
        ON o.id = oi.order_id
    WHERE o.status = 'PAID'
    GROUP BY
        DATE_TRUNC('month', o.created_at),
        oi.category_name
),
monthly_total_revenue AS (
    SELECT
        mcr.revenue_month,
        SUM(mcr.category_revenue) AS total_monthly_revenue
    FROM monthly_category_revenue mcr
    GROUP BY mcr.revenue_month
)
SELECT
    mcr.revenue_month,
    mcr.category_name,
    mcr.category_revenue,
    mtr.total_monthly_revenue,
    ROUND(
        mcr.category_revenue * 100.0 / NULLIF(mtr.total_monthly_revenue, 0),
        2
    ) AS category_revenue_share_percentage
FROM monthly_category_revenue mcr
INNER JOIN monthly_total_revenue mtr
    ON mcr.revenue_month = mtr.revenue_month
ORDER BY
    mcr.revenue_month,
    category_revenue_share_percentage DESC;


-- =============================================================================
-- 20. CUSTOMER LIFETIME VALUE RANKING
-- =============================================================================

WITH customer_lifetime_value AS (
    SELECT
        o.customer_id,
        c.name AS customer_name,
        c.email AS customer_email,
        COUNT(*) AS total_paid_orders,
        SUM(o.grand_total) AS lifetime_revenue,
        ROUND(AVG(o.grand_total), 2) AS average_order_value
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.id
    WHERE o.status = 'PAID'
    GROUP BY
        o.customer_id,
        c.name,
        c.email
)
SELECT
    clv.customer_id,
    clv.customer_name,
    clv.customer_email,
    clv.total_paid_orders,
    clv.lifetime_revenue,
    clv.average_order_value,
    DENSE_RANK() OVER (
        ORDER BY clv.lifetime_revenue DESC
    ) AS customer_value_rank
FROM customer_lifetime_value clv
ORDER BY customer_value_rank;


-- =============================================================================
-- END OF FILE
-- =============================================================================
