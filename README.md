# ✈️ Airline Flight Delay Analysis

End-to-end analysis of 5,000 Indian domestic flights (2024) using **Python**, **MySQL** and **Power BI** to find what causes delays, cancellations and revenue differences across airlines.

## 📊 Dashboard

![Power BI Dashboard](images/powerbi_dashboard.png)

## 🌐 Interactive HTML Dashboard

Open [`dashboard.html`](dashboard.html) in any browser (needs internet for Chart.js). Features:

- Airline filter buttons with a quick stats panel
- Metric switch: delay, cancellation, revenue, profit, rating
- Charts for weather, delay categories, worst hours and busiest routes

**Live demo:** enable GitHub Pages (Settings → Pages → Deploy from branch `main`) and open
`https://<your-username>.github.io/airline-flight-delay-analysis/dashboard.html`

## 🎯 Objectives

- Find which airlines, routes, hours and weather conditions cause the most delay
- Compare airlines on cancellations, load factor, revenue and customer rating
- Build a dashboard for quick decision making

## 🗂️ Dataset

| Column | Description |
|---|---|
| flight_id, flight_date | Flight identifier and date |
| airline, origin, destination | Carrier and route |
| distance_km, scheduled_dep_hour | Distance and scheduled hour |
| weather | Clear, Fog, Rain, Storm, Unknown |
| departure_delay_min, arrival_delay_min | Delays in minutes |
| cancelled | Yes / No |
| seats_available, passengers | Capacity and occupancy |
| avg_ticket_price_inr, fuel_cost_inr | Revenue and cost inputs |
| customer_rating | Rating out of 5 |

## 🛠️ Tools

- **Python:** Pandas, NumPy, Matplotlib, Seaborn
- **MySQL 8:** aggregations, CASE, CTE, window functions, subqueries
- **Power BI:** KPIs, slicers, trend charts, route matrix
- **HTML / JavaScript:** interactive dashboard with Chart.js

## 🔍 Key Findings

- **Weather matters most:** storm flights average 39 min delay vs 15 min in clear weather.
- **SpiceJet is weakest:** highest delay (21 min arrival) and highest cancellation rate (3.18%).
- **IndiGo leads:** most flights, best punctuality (14.7 min), lowest cancellations (0.84%), top revenue (₹1.55bn).
- **Evenings are riskiest:** delay peaks at 9 PM (25 min) and 7 PM (24 min).
- **Delays don't hurt ratings:** all airlines rate near 3.7 / 5.
- **Load factor is steady** at about 81-82% for all airlines.
- Departure and arrival delay are highly correlated (r = 0.95).

## 🐍 Python EDA

![EDA](images/python_eda.png)

Six visuals: delay distribution, delay by airline, delay by weather, cancellation rate, delay by hour, correlation heatmap.

### 🔎 Finding Missing Values with Pandas

```python
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

df = pd.read_csv("data/airline_flight_delay.csv")

# 1. Count and % of missing values per column
missing = df.isnull().sum()
summary = pd.DataFrame({
    "missing": missing,
    "missing_%": (missing / len(df) * 100).round(2)
}).query("missing > 0").sort_values("missing", ascending=False)
print(summary)

# 2. Rows with any missing value
print(df[df.isnull().any(axis=1)].head())

# 3. Visual check
sns.heatmap(df.isnull(), cbar=False, yticklabels=False)
plt.title("Missing Values Map")
plt.show()

# 4. Hidden missing values (text like "unknown")
print((df["weather"].str.lower() == "unknown").sum(), "unknown weather rows")

# 5. Handling
df["weather"] = df["weather"].replace("unknown", pd.NA)
num_cols = df.select_dtypes("number").columns
df[num_cols] = df[num_cols].fillna(df[num_cols].median())   # numeric: median
df["weather"] = df["weather"].fillna(df["weather"].mode()[0])  # category: mode
# or drop: df = df.dropna(subset=["flight_id"])
```

**Tips**
- `isnull().sum()` only catches real NaN. Check text placeholders like `"unknown"` separately.
- Cancelled flights may have no delay values. Decide whether to keep them as NaN or exclude them before averaging.

## 🗄️ SQL Analysis

Queries are in [`sql/analysis_queries.sql`](sql/analysis_queries.sql):

1. Cancellation rate per airline
2. Average departure and arrival delay per airline
3. Delay by weather
4. Top 5 busiest routes
5. Revenue and profit per airline
6. Load factor per airline
7. Worst departure hours
8. Customer rating rank (window function)
9. Delay categories (CASE)
10. Most delayed route per airline (CTE + window function)

## 🧱 How the HTML Dashboard Was Made

1. **Get the numbers:** run the SQL queries (or Pandas `groupby`) and copy the results.
2. **Export to JSON** (optional, with Pandas):
   ```python
   summary = df.groupby("airline").agg(
       flights=("flight_id", "count"),
       avg_arr_delay=("arrival_delay_min", "mean")
   ).round(2)
   print(summary.to_json(orient="index"))
   ```
3. **Paste the JSON** into the `const A = {...}` object inside `dashboard.html`.
4. **Add Chart.js** with one line in `<head>`:
   ```html
   <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>
   ```
5. **Build the page:** a `<canvas>` per chart, then `new Chart(canvas, {type: "bar", data: {...}})`.
6. **Add interactivity:** filter buttons and a metric dropdown that update `chart.data` and call `chart.update()`.
7. **Style with CSS:** grid layout, KPI cards, light and dark mode with `prefers-color-scheme`.
8. **Publish:** push to GitHub and enable Pages (Settings → Pages).

## 💡 Recommendations

- Add buffer time or extra ground crew for 7-9 PM departures.
- Pre-plan rebooking and slot swaps for fog and storm days.
- Focus on SpiceJet and weak routes such as Hyderabad → Delhi (Air India) and Mumbai → Bengaluru (SpiceJet).

## 📁 Project Structure

```
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
├── dashboard.html
├── Airline_Flight_Delay_Report.pdf
└── README.md
```

## ▶️ How to Run

```bash
git clone https://github.com/mohammedrizwan77/Airline-Flights-Delay-Analysis.git
cd airline-flight-delay-analysis
pip install pandas numpy matplotlib seaborn jupyter
jupyter notebook notebooks/flight_delay_eda.ipynb
```

For SQL: import the CSV into a MySQL 8+ table named `flights`, then run `sql/analysis_queries.sql`.

## 👤 Author

**Mohammed Rizwan** - Aspiring Data Analyst
[LinkedIn](https://www.linkedin.com/in/mohammed-rizwan-data-analyst/)
[GitHub](https://github.com/mohammedrizwan77/Airline-Flights-Delay-Analysis/edit/main/README.md)
