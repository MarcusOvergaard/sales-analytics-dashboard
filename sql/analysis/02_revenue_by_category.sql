select 
	dp.product_category_name,
	sum(price) as revenue
from fact_order_items foi 
join dim_product dp 
	on dp.product_id = foi.product_id
group by 
	dp.product_category_name
order by 
	revenue desc