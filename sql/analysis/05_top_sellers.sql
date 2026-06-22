SELECT
    ds.seller_id,
    ds.seller_city,
    SUM(foi.price) AS revenue,
    COUNT(*) AS items_sold
FROM fact_order_items foi
JOIN dim_seller ds
    ON ds.seller_id = foi.seller_id
GROUP BY
    ds.seller_id
ORDER BY
    revenue DESC;
	