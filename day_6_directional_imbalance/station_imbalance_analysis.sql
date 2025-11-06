select  
	r.station_name_short,
	s.direction_1,
	sum(r.direction_1) as total_traffic_dir_1,
	s.direction_2,
	sum(r.direction_2) as total_traffic_dir_2,
	sum(r.direction_1) + sum(r.direction_2) as total_station_traffic,
	round(sum(r.direction_1) / cast((sum(r.direction_1) + sum(r.direction_2))  as numeric) * 100,2)  as percent_dir_1,
	round(sum(r.direction_2) / cast((sum(r.direction_1) + sum(r.direction_2)) as numeric)* 100 ,2) as percent_dir_2
from rad_15min r
join radzaehlstellen s
on r.station_name_short = s.station_name_short
group by r.station_name_short, s.direction_1, s.direction_2