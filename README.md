
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

---

### Day 3: How Temperature Affects Bike Traffic

* **Folder:** `day_3_temperature_analysis/`
* **Question:** How does the daily high temperature affect the average number of cyclists?
* **Process:**
    * Wrote a SQL query using a `CASE` statement to group days into five logical temperature "buckets," from "Freezing" (<0°C) to "Hot" (>=25°C).
    * Calculated the average `total` traffic for each bucket, rounded the result, and ordered it from highest traffic to lowest.
* **Finding:**
    There is a strong, positive correlation between temperature and traffic. As the weather gets warmer, the number of cyclists consistently increases. "Hot" days see nearly six times more traffic than "Freezing" days.

**Final Results Table:**
| weather_temperature | avg_daily_traffic |
| :--- | :--- |
| Hot | 3,231 |
| Warm | 2,725 |
| Cool | 1,828 |
| Cold | 1,179 |
| Freezing | 569 |



---

### Day 4: Commuter Traffic Analysis (Weekday vs. Daily)

* **Folder:** `day_4_weekday_vs_weekend/`
* **Question:** What is the traffic pattern during the week? Is it driven by commuters or leisure?
* **Process:**
    1.  First, I compared "Weekdays" vs. "Weekends" using an `EXTRACT(DOW ...)` function and a `CASE` statement.
    2.  Second, to confirm the finding, I wrote a more advanced query using a **Common Table Expression (CTE)** to get a 7-day breakdown and check for mid-week peaks.
* **Finding 1 (Simple):**
    Weekday traffic (avg. 2,223) is ~43% higher than weekend traffic (avg. 1,550). This suggests traffic is driven by commuting, not leisure.

* **Finding 2 (Detailed):**
    The 7-day breakdown confirms the commuter hypothesis. Traffic is lowest on weekends and peaks in the middle of the work week (Tuesday & Wednesday), with slightly less traffic on Monday and Friday.

**Final Results Table (Daily Breakdown):**
| day_name | avg_traffic |
| :--- | :--- |
| Wednesday | 2,320 |
| Tuesday | 2,308 |
| Thursday | 2,294 |
| Monday | 2,124 |
| Friday | 2,068 |
| Saturday | 1,594 |
| Sunday | 1,507 |


---

### Day 5: Finding the Peak Commute Hours (Simple & Advanced)

* **Folder:** `day_5_peak_commute_hours/`
* **Question:** When are the specific "rush hours"? And how do they differ for commuters vs. leisure riders?
* **Process:**
    1.  **Simple Analysis:** First, I found the busiest hour by averaging *all* days together. I used `EXTRACT(HOUR ...)` and `GROUP BY hour_of_day`.
    2.  **Advanced Analysis:** Second, I wrote an advanced query using **three CTEs** and a **`ROW_NUMBER()` window function** to find the "Top 3" busiest hours, partitioning the data by 'Weekday' and 'Weekend'.

* **Finding 1 (Simple):**
    The busiest hours *overall* are the evening commute (5 PM & 6 PM) and the morning commute (8 AM).
    * **Top 3 Overall:** 17:00 (5 PM), 18:00 (6 PM), 08:00 (8 AM).

* **Finding 2 (Advanced):**
    The advanced query proved that Munich has two distinct traffic profiles:
    * **Weekdays (Commuters):** Traffic peaks at 8 AM, 6 PM, and 5 PM.
    * **Weekends (Leisure):** Traffic peaks in the mid-afternoon (2 PM, 3 PM, 4 PM), with no morning/evening rush hour.

**Advanced Results Table (Top 3):**
| day_type | hour_of_day | avg_traffic | rank_num |
| :--- | :--- | :--- | :--- |
| WeekDay | 8 | 59 | 1 |
| WeekDay | 18 | 54 | 2 |
| WeekDay | 17 | 53 | 3 |
| WeekEnd | 14 | 38 | 1 |
| WeekEnd | 15 | 38 | 2 |
| WeekEnd | 16 | 36 | 3 |


---

### Day 6: Directional Imbalance at Stations

* **Folder:** `day_6_directional_imbalance/`
* **Question:** Is bike traffic at each station balanced, or do some stations act as "one-way" arteries?
* **Process:**
    * Wrote a query that **`JOINS`** the `rad_15min` (for counts) and `radzaehlstellen` (for direction names) tables.
    * Summed the totals for `direction_1` and `direction_2` for each station.
    * Calculated the total traffic and the *percentage* of traffic for each direction.
    * Solved integer division by `CAST`ing the denominator to `numeric`.
    * Solved order-of-operations issues by multiplying by 100 *inside* the `ROUND()` function.
* **Finding:**
    The analysis revealed a dramatic difference between stations. Some are perfectly balanced, while others are heavily skewed.
    * **"Arnulf"** is a major eastbound artery, with **94.17%** of its traffic flowing East.
    * **"Olympia"** is almost perfectly balanced (50.33% / 49.67%).

**Final Results Table (Sample):**
| station_name_short | direction_1 | total_traffic_dir_1 | direction_2 | total_traffic_dir_2 | percent_dir_1 | percent_dir_2 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Arnulf | Ost | 2,833,542 | West | 175,263 | 94.17 | 5.83 |
| Erhardt | Süd | 6,442,653 | Nord | 6,126,304 | 51.26 | 48.74 |
| Olympia | Nord | 2,788,426 | Süd | 2,751,734 | 50.33 | 49.67 |



---

### Day 7: Advanced (LAG) - The "Heatwave Effect"

* **Folder:** `day_7_heatwave_effect/`
* **Question:** How does a sustained heatwave affect traffic compared to a single isolated hot day?
* **Process:**
    * Wrote an advanced query using the **`LAG()`** window function in a CTE to get the temperatures for the two previous days.
    * Used **`PARTITION BY station_name_short`** in the `OVER()` clause to prevent data "cross-talk" between stations, ensuring an accurate time-series for each location.
    * Created two buckets: 'HeatWave Day' (3+ consecutive days > 25°C) and 'Normal Hot Day'.
    * Aggregated the average traffic for each bucket.
* **Finding:**
    The data revealed a counter-intuitive insight: average traffic on "HeatWave Days" (3,153) is slightly **lower** than on "Normal Hot Days" (3,318).
* **Hypothesis:**
    The novelty of a single hot day encourages biking. However, the sustained, oppressive heat of a multi-day heatwave drains energy and can discourage outdoor activity.

**Final Results Table:**
| condition_temp | avg_traffic | num_of_days |
| :--- | :--- | :--- |
| Normal Hot Day | 3,318 | 1,480 |
| HeatWave Day | 3,153 | 1,604 |