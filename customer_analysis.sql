/* =========================================
   Total Customer Spending
   Description: Calculates total spending per customer
========================================= */

SELECT
    c.customer_name,
    SUM(o.sales_amount) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_date IS NOT NULL
GROUP BY c.customer_name;


/* =========================================
   File: 02_customer_analysis.sql
   Section: High-Value Customers

   Description:
   Identifies customers whose total spending
   exceeds the average customer spending.
========================================= */

WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(o.sales_amount) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_date IS NOT NULL
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_name,
    total_spending
FROM customer_spending
WHERE total_spending > (
    SELECT AVG(total_spending)
    FROM customer_spending
)
ORDER BY total_spending DESC;



/* =========================================
   Section: Customer Segmentation

   Description:
   Segments customers based on total spending
   into VIP, Regular, and Low categories.

   VIP     → Spending > 5000
   Regular → Spending between 1001 and 5000
   Low     → Spending ≤ 1000
========================================= */

WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(o.sales_amount) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_date IS NOT NULL
    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_name,
    total_spending,
    CASE 
        WHEN total_spending > 5000 THEN 'VIP'
        WHEN total_spending > 1000 THEN 'Regular'
        ELSE 'Low'
    END AS customer_segment
FROM customer_spending
ORDER BY total_spending DESC;


/* =========================================
   File: 02_customer_analysis.sql
   Section: Customer Product Diversity

   Description:
   Identifies customers who have purchased
   more than 3 distinct products.
========================================= */

SELECT
    c.customer_name,
    COUNT(DISTINCT o.product_id) AS number_of_products
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_date IS NOT NULL
GROUP BY c.customer_name
HAVING COUNT(DISTINCT o.product_id) > 3
ORDER BY number_of_products DESC;
