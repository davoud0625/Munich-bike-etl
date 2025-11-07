with three_day_temp as (
	select 
		date,
		total,
		max_temp as today,
		lag(max_temp, 1) over(partition by station_name_short order by date) as yesterday,
		lag(max_temp, 2) over(partition by station_name_short order by date) as befor_yesterday
	from rad_tage
)
select 
	case 
		when today > 25 and yesterday > 25 and befor_yesterday > 25 then 'HeatWave Day'
		when today > 25 and yesterday <= 25 or befor_yesterday <= 25 then 'Normal Hot Day'
	end as condition_temp,
	round(avg(total),0) as avg_traffic,
	count (*) num_of_days
from three_day_temp 
where today > 25
group by condition_temp

	
	