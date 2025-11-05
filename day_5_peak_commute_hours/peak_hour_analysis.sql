select 
	extract(hour from start_time) as hour_of_day,
	round(avg(total),0) as avg_traffic
from rad_15min
group by  hour_of_day
order by  avg_traffic desc
