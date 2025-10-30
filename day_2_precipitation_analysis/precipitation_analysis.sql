select 
	case 
		when precipitation = 0 then 'No rain'
		when precipitation > 0 and precipitation < 2.5 then 'Light rain'
		when precipitation >= 2.5 and precipitation < 7.5 then 'Moderate rain'
		when precipitation >= 7.5 then 'Heavy rain'
	end as weather_group,
	round(avg(total),0) as avg_daily_traffic
from rad_tage 
group by weather_group
order by avg_daily_traffic desc
	
	

	