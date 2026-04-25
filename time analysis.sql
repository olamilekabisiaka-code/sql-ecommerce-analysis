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
