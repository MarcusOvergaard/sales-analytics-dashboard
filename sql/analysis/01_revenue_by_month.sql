select 
	dd.year,
	dd.month,
	sum(price) as revenue
from fact_order_items foi 
join dim_date dd 
	on dd.date_key = foi.purchase_date_key
group by 
	dd.year,
	dd.month
order by
	dd.year,
	dd.month;