-- Use WITH to define a CTE (a temporary table)
with daily_data as (
	select 
		extract(dow from date) as day_of_week_num,
		total
	from rad_tage
)
select 
	case 
		when day_of_week_num = 0 then 'Sunday'
		when day_of_week_num = 1 then 'Monday'
		when day_of_week_num = 2 then 'Tuesday'
		when day_of_week_num = 3 then 'Wednesday'
		when day_of_week_num = 4 then 'Thursday'
		when day_of_week_num = 5 then 'Friday'
		when day_of_week_num = 6 then 'Saturday'
	end as day_of_week,
	round(avg(total),0) as avg_traffic
from daily_data
group by day_of_week
order by avg_traffic desc;
	
	