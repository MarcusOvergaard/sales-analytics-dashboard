select 
	dc.customer_state,
	sum(foi.price) as revenue
from fact_order_items foi 
join dim_customer dc
	on dc.customer_id = foi.customer_id
group by 
	dc.customer_state
order by 
	revenue desc