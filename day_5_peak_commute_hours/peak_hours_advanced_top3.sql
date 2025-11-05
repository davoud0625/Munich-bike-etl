with alltagged_data as (
	select
		total,
		extract(hour from start_time) as hour_of_day,
		case
			when extract(dow from date) = 0 or extract(dow from date)  = 6 then 'WeekEnd'
			else 'Week_Day'
		end as day_type			
	from rad_15min
),
aggregated_data as (
	select 
		day_type,
		hour_of_day,
		round(avg(total),0) as avg_traffic
	from alltagged_data
	group by day_type, hour_of_day
),
ranked_data as (
	select 
		*,
		row_number() over( partition by day_type order by avg_traffic desc) as rank_num
	from aggregated_data
)
select 
	day_type,
	hour_of_day,
	avg_traffic,
	rank_num
from ranked_data
where rank_num <= 3;
	
