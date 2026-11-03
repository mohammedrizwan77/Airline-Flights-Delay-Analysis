use pytable;
select * from flight_delay;
-- 1. Total flights and cancellation rate per airline
SELECT airline, COUNT(*) AS total_flights,ROUND(100 * SUM(cancelled = 'Yes') / COUNT(*), 2) AS cancel_pct
FROM flight_delay GROUP BY airline ORDER BY cancel_pct DESC;

-- 2. Average departure and arrival delay by airline

SELECT airline,ROUND(AVG(departure_delay_min), 2) AS avg_dep_delay,ROUND(AVG(arrival_delay_min), 2) AS avg_arr_delay
FROM flight_delay GROUP BY airline ORDER BY avg_arr_delay DESC;

-- 3. Which weather causes the most delay?
SELECT weather, COUNT(*) AS delay_flights,ROUND(AVG(departure_delay_min), 2)
 AS avg_delay FROM flight_delay GROUP BY weather ORDER BY avg_delay DESC;
 
 -- 4. Top 5 busiest routes
 SELECT origin, destination, COUNT(*) AS flights FROM flight_delay
GROUP BY origin, destination ORDER BY flights DESC LIMIT 5;


-- 5. Total revenue and profit per airline
SELECT airline,
SUM(passengers * avg_ticket_price_inr) AS revenue,SUM(passengers * avg_ticket_price_inr - fuel_cost_inr) AS profit
FROM flight_delay WHERE cancelled = 'No' GROUP BY airline ORDER BY profit DESC;

-- 6. Load factor (seat occupancy %) per airline
SELECT airline,ROUND(100 * SUM(passengers) / SUM(seats_available), 2) AS load_factor_pct FROM flight_delay
WHERE cancelled = 'No'
GROUP BY airline;

-- 7. Worst hours to fly (highest avg delay)
SELECT scheduled_dep_hour, ROUND(AVG(departure_delay_min), 2) AS avg_delay
FROM flight_delay GROUP BY scheduled_dep_hour ORDER BY avg_delay DESC LIMIT 5;


-- 8. Rank airlines by customer rating (window function)
SELECT airline, ROUND(AVG(customer_rating), 2) AS avg_rating,
RANK() OVER (ORDER BY AVG(customer_rating) DESC) AS rnk FROM flight_delay GROUP BY airline; 

-- 9. Delay category using CASE
SELECT CASE WHEN departure_delay_min <= 0  THEN 'On time/Early'
WHEN departure_delay_min <= 30 THEN 'Minor' WHEN departure_delay_min <= 60 THEN 'Moderate'
ELSE 'Severe'END AS delay_category,COUNT(*) AS flights FROM flight_delay GROUP BY delay_category;

-- 10. Most delayed route per airline (CTE + window)
WITH route_delay AS (SELECT airline, origin, destination,AVG(arrival_delay_min) AS avg_delay,
ROW_NUMBER() OVER (PARTITION BY airline ORDER BY AVG(arrival_delay_min) DESC) AS rn
FROM flight_delay GROUP BY airline, origin, destination)
SELECT airline, origin, destination, ROUND(avg_delay, 2) AS avg_delay
FROM route_delay WHERE rn = 1;