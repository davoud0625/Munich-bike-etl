ALTER TABLE rad_15min RENAME COLUMN datum TO "date";
ALTER TABLE rad_15min RENAME COLUMN uhrzeit_start TO start_time;
ALTER TABLE rad_15min RENAME COLUMN uhrzeit_ende TO end_time;
ALTER TABLE rad_15min RENAME COLUMN zaehlstelle TO station_name_short;
ALTER TABLE rad_15min RENAME COLUMN richtung_1 TO direction_1;
ALTER TABLE rad_15min RENAME COLUMN richtung_2 TO direction_2;
ALTER TABLE rad_15min RENAME COLUMN gesamt TO total;


--Change column names for radzaehlstellen

ALTER TABLE rad_tage RENAME COLUMN datum TO "date";
ALTER TABLE rad_tage RENAME COLUMN uhrzeit_start TO start_time;
ALTER TABLE rad_tage RENAME COLUMN uhrzeit_ende TO end_time;
ALTER TABLE rad_tage RENAME COLUMN zaehlstelle TO station_name_short;
ALTER TABLE rad_tage RENAME COLUMN richtung_1 TO direction_1;
ALTER TABLE rad_tage RENAME COLUMN richtung_2 TO direction_2;
ALTER TABLE rad_tage RENAME COLUMN gesamt TO total;
ALTER TABLE rad_tage RENAME COLUMN "min-temp" TO min_temp;
ALTER TABLE rad_tage RENAME COLUMN "max-temp" TO max_temp;
ALTER TABLE rad_tage RENAME COLUMN niederschlag TO precipitation;
ALTER TABLE rad_tage RENAME COLUMN bewoelkung TO cloudiness;
ALTER TABLE rad_tage RENAME COLUMN sonnenstunden TO sunshine_hours;

--Change column names for radzaehlstellen

ALTER TABLE radzaehlstellen RENAME COLUMN zaehlstelle TO station_name_short;
ALTER TABLE radzaehlstellen RENAME COLUMN zaehlstelle_lang TO station_name_long;
ALTER TABLE radzaehlstellen RENAME COLUMN richtung_1 TO direction_1;
ALTER TABLE radzaehlstellen RENAME COLUMN richtung_2 TO direction_2;
ALTER TABLE radzaehlstellen RENAME COLUMN besonderheiten TO notes;


select column_name, data_type
from information_schema.columns 
where table_name = 'rad_15min'
order by ordinal_position;




with peaks as (
	select 
		r.date,
		r.start_time || '-' || r.end_time as time_slot,
		r.station_name_short,
		s.station_name_long,
		s.latitude,
		s.longitude,
		r.total,
		RANK() over (order by r.total DESC) as peak_rank
	from rad_15min r
	join radzaehlstellen s on r.station_name_short = s.station_name_short
	where r.total > 0
)
select 
	peak_rank,
	date,
	time_slot,
	coalesce(station_name_long, station_name_short) as station_name,
	total as total_bike,
	ROUND(latitude, 4) as latitude,
	ROUND(longitude, 4) as longitude
from peaks 
where peak_rank <=5
order by peak_rank;


