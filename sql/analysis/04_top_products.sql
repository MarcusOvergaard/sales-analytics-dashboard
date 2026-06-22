SELECT
    dp.product_category_name,
    SUM(foi.price) AS revenue,
    COUNT(*) AS items_sold
FROM fact_order_items foi
JOIN dim_product dp
    ON dp.product_id = foi.product_id
GROUP BY
    dp.product_category_name
ORDER BY
    revenue DESC;