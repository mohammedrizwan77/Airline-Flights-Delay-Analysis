✈️ Airline Flight Delay Analysis

End-to-end analysis of 5,000 Indian domestic flights (2024) using Python, MySQL and Power BI to find what causes delays, cancellations and revenue differences across airlines.

📊 Dashboard

Power BI Dashboard

🎯 Objectives
Find which airlines, routes, hours and weather conditions cause the most delay
Compare airlines on cancellations, load factor, revenue and customer rating
Build a dashboard for quick decision making
🗂️ Dataset
Column	Description
flight_id, flight_date	Flight identifier and date
airline, origin, destination	Carrier and route
distance_km, scheduled_dep_hour	Distance and scheduled hour
weather	Clear, Fog, Rain, Storm, Unknown
departure_delay_min, arrival_delay_min	Delays in minutes
cancelled	Yes / No
seats_available, passengers	Capacity and occupancy
avg_ticket_price_inr, fuel_cost_inr	Revenue and cost inputs
customer_rating	Rating out of 5
🛠️ Tools
Python: Pandas, NumPy, Matplotlib, Seaborn
MySQL 8: aggregations, CASE, CTE, window functions, subqueries
Power BI: KPIs, slicers, trend charts, route matrix
🔍 Key Findings
Weather matters most: storm flights average 39 min delay vs 15 min in clear weather.
SpiceJet is weakest: highest delay (21 min arrival) and highest cancellation rate (3.18%).
IndiGo leads: most flights, best punctuality (14.7 min), lowest cancellations (0.84%), top revenue (₹1.55bn).
Evenings are riskiest: delay peaks at 9 PM (25 min) and 7 PM (24 min).
Delays don't hurt ratings: all airlines rate near 3.7 / 5.
Load factor is steady at about 81-82% for all airlines.
Departure and arrival delay are highly correlated (r = 0.95).
🐍 Python EDA

EDA

Six visuals: delay distribution, delay by airline, delay by weather, cancellation rate, delay by hour, correlation heatmap.

🗄️ SQL Analysis

Queries are in sql/analysis_queries.sql:

Cancellation rate per airline
Average departure and arrival delay per airline
Delay by weather
Top 5 busiest routes
Revenue and profit per airline
Load factor per airline
Worst departure hours
Customer rating rank (window function)
Delay categories (CASE)
Most delayed route per airline (CTE + window function)
💡 Recommendations
Add buffer time or extra ground crew for 7-9 PM departures.
Pre-plan rebooking and slot swaps for fog and storm days.
Focus on SpiceJet and weak routes such as Hyderabad → Delhi (Air India) and Mumbai → Bengaluru (SpiceJet).
📁 Project Structure
airline-flight-delay-analysis/
├── data/
│   └── airline_flight_delay.csv
├── notebooks/
│   └── flight_delay_eda.ipynb
├── sql/
│   └── analysis_queries.sql
├── powerbi/
│   └── flight_delay_dashboard.pbix
├── images/
│   ├── powerbi_dashboard.png
│   └── python_eda.png
├── Airline_Flight_Delay_Report.docx
└── README.md
▶️ How to Run
bash
git clone https://github.com/<your-username>/airline-flight-delay-analysis.git
cd airline-flight-delay-analysis
pip install pandas numpy matplotlib seaborn jupyter
jupyter notebook notebooks/flight_delay_eda.ipynb

For SQL: import the CSV into a MySQL 8+ table named flights, then run sql/analysis_queries.sql.

👤 Author

Mohammed Rizwan - Aspiring Data Analyst LinkedIn | GitHub
