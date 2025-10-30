# Munich Bike Traffic ETL & Analysis

This repository contains a series of daily data engineering and analysis projects using a dataset of bike traffic in Munich.

---

### Day 1: Top 5 Busiest Stations

* **Folder:** `day_1_top_5_peaks/`
* **Question:** What were the top 5 busiest bike counting stations?
* **Process:** Wrote a SQL query to aggregate traffic by station, joined with the station metadata table to get the full names, and selected the top 5.
* **Files:**
    * `top_5_peaks_with_full_name.sql`: The SQL query used for the analysis.
    * `top_5_peaks.csv`: The exported CSV result.

---

### Day 2: How Precipitation Affects Bike Traffic

* **Folder:** `day_2_precipitation_analysis/`
* **Question:** How does the amount of rain affect the average number of daily cyclists?
* **Process:**
    * Used the `rad_tage` table, which includes daily traffic counts and weather data.
    * Wrote a SQL query using a `CASE` statement to group days into four precipitation "buckets": No rain, Light rain, Moderate rain, and Heavy rain.
    * Calculated the average `total` traffic for each bucket and rounded the result.
* **Finding:**
    As expected, bike traffic consistently decreases as precipitation increases. "Light rain" reduces traffic by ~23%, while "Heavy rain" reduces it by ~33%.

**Final Results Table:**
| weather_group | avg_daily_traffic |
| :--- | :--- |
| No rain | 2,337 |
| Light rain | 1,787 |
| Moderate rain | 1,624 |
| Heavy rain | 1,571 |