select 
	case
		when max_temp < 0 then 'Freezing'
		when max_temp >= 0 and max_temp < 10 then 'Cold'
		when max_temp >= 10 and max_temp < 20 then 'Cool'
		when max_temp >= 20 and max_temp < 25 then 'Warm'
		when max_temp >= 25 then 'Hot'
	end as weather_temperature,
	round(avg(total),0) as avg_daily_traffic
from rad_tage 
group by weather_temperature
order by avg_daily_traffic desc

	