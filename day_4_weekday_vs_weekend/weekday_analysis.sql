/*How does average daily bike traffic differ between weekdays and weekends?*/


select 
	case
		when extract(dow from date)= 0 or extract(dow from date) = 6 then 'Weekend'
		else 'Weekdays' 
	end as the_week,
	round(avg(total),0) as avg_traffic 
from rad_tage 
group by the_week
	