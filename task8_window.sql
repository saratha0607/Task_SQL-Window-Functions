WITH customer_sales AS (
    SELECT
        customer_id,
        customer_name,
        region,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id, customer_name, region
)
SELECT
    customer_id,
    customer_name,
    region,
    total_sales,
    DENSE_RANK() OVER (
        PARTITION BY region
        ORDER BY total_sales DESC
    ) AS rank_in_region
FROM customer_sales;



WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS monthly_total
    FROM orders
    GROUP BY month
)
SELECT
    month,
    monthly_total,
    LAG(monthly_total) OVER (ORDER BY month) AS prev_month_sales,
    ROUND(
        ((monthly_total - LAG(monthly_total) OVER (ORDER BY month))
        / LAG(monthly_total) OVER (ORDER BY month)) * 100,
        2
    ) AS mom_growth_percent
FROM monthly_sales
ORDER BY month;