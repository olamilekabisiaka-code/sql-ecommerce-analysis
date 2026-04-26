/* =========================================
   Monthly Revenue Trend
   Description: Analyzes total revenue by month
========================================= */

SELECT
    DATETRUNC(MONTH, order_date) AS order_month,
    SUM(sales_amount) AS total_revenue
FROM orders
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY order_month;


/* =========================================
   Monthly Revenue & Order Volume
   Description: Tracks revenue and order count per month
========================================= */

SELECT
    DATETRUNC(MONTH, order_date) AS order_month,
    SUM(sales_amount) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY order_month;


/* =========================================
   Running Total Revenue
   Description: Cumulative revenue over time
========================================= */

SELECT
    order_month,
    total_revenue,
    SUM(total_revenue) OVER (ORDER BY order_month) AS running_total_revenue
FROM (
    SELECT
        DATETRUNC(MONTH, order_date) AS order_month,
        SUM(sales_amount) AS total_revenue
    FROM orders
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
) t
ORDER BY order_month;


/* =========================================
   Month-over-Month Revenue Change
Description:
   Calculates monthly revenue, previous month revenue,
   and revenue change using window functions.
========================================= */

WITH monthly_revenue AS (
    SELECT
        DATETRUNC(MONTH, order_date) AS order_month,
        SUM(sales_amount) AS total_revenue
    FROM orders
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
),
revenue_lag AS (
    SELECT
        order_month,
        total_revenue,
        LAG(total_revenue) OVER (ORDER BY order_month) AS previous_month_revenue
    FROM monthly_revenue
)

SELECT
    order_month,
    total_revenue,
    previous_month_revenue,
    total_revenue - previous_month_revenue AS revenue_change
FROM revenue_lag
ORDER BY order_month;

/* =========================================
   Section: Month-over-Month Growth Analysis

   Description:
   Calculates monthly revenue, previous month revenue,
   revenue change, and growth percentage.
========================================= */

WITH monthly_revenue AS (
    SELECT
        DATETRUNC(MONTH, order_date) AS order_month,
        SUM(sales_amount) AS total_revenue
    FROM orders
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
),
revenue_lag AS (
    SELECT
        order_month,
        total_revenue,
        LAG(total_revenue) OVER (ORDER BY order_month) AS previous_month_revenue
    FROM monthly_revenue
)

SELECT
    order_month,
    total_revenue,
    previous_month_revenue,
    total_revenue - previous_month_revenue AS revenue_change,
    CASE 
        WHEN previous_month_revenue IS NULL OR previous_month_revenue = 0 THEN NULL
        ELSE ROUND(
            (total_revenue - previous_month_revenue) * 100.0 / previous_month_revenue,
        2)
    END AS growth_percentage
FROM revenue_lag
ORDER BY order_month;
