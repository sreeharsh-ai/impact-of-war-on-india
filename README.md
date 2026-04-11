# 🛢️ Impact of Middle East Conflict on India's Economy
### A Data Analytics Project | World Bank & EIA Data | Python · SQL · Power BI

---

## 📌 Problem Statement

A growing concern in global geopolitics is the ongoing conflict in the Middle East and its far-reaching implications on economies worldwide. **India, being a major importer of crude oil** and having strong trade relations with several Middle Eastern countries, is particularly vulnerable to disruptions caused by these conflicts.

Fluctuations in oil prices, supply chain instability, and changes in diplomatic relations can significantly impact India's economic stability, inflation rates, and energy security. Sectors such as transportation, manufacturing, and agriculture experience indirect effects due to rising costs and uncertainties.

> **Overarching Question:** *"How does the ongoing Middle East conflict influence India's economic stability, particularly in terms of oil prices, trade dynamics, and overall market performance — and what strategies can be adopted to mitigate these effects?"*

---

## 📁 Repository Structure

```
📦 india-geopolitics-oil-inflation/
├── 📄 README.md                              ← You are here
├── 🐍 data_cleaning.py                       ← Full ETL pipeline (Python)
├── 🗄️ SQL_Analysis_Queries.sql               ← 7 analytical SQL queries
├── 📊 india_geopolitics_analysis_master.csv  ← Clean master dataset
└── 📈 Geopolitics_Impact_Analysis.pbix       ← Power BI Dashboard (4 pages)
```

---

## 📊 Dataset Sources

| Dataset | Source | Description |
|---|---|---|
| Inflation, Consumer Prices (Annual %) | [World Bank WDI](https://data.worldbank.org/indicator/FP.CPI.TOTL.ZG) | India CPI inflation 1960–2024 |
| Europe Brent Spot Price FOB | [U.S. EIA](https://www.eia.gov/dnav/pet/hist/RBRTEd.htm) | Daily Brent crude oil prices (USD/barrel) |
| Country Metadata | World Bank | Region & Income Group classification |

---

## 🔧 Technical Implementation

### ETL Pipeline (`data_cleaning.py`)

**Step 1 — Raw Data Loading**
Both datasets contained 4-5 lines of descriptive metadata headers. Used `skiprows=4` to skip them and load actual tabular data.

**Step 2 — Oil Data: Daily → Annual Aggregation**
- Parsed dates with `pd.to_datetime()`
- Extracted year component
- Aggregated using `.agg()`: `avg_oil_price` (mean) and `oil_volatility` (standard deviation)
- **Feature Engineering:** Created `oil_price_shock_pct` using `.pct_change() * 100` — a Conflict Marker that flags years with major geopolitical disruptions

**Step 3 — Inflation Data: Wide → Long Format (Melt)**
- World Bank data stored years as column headers (Wide format)
- Used `pd.melt()` to convert to Long format (one row per year)
- This is the required format for Power BI time-series analysis

**Step 4 — Three-Way Join**
```
India Inflation (Long) + Country Metadata + Oil Price (Annual)
        ↓ join on Country Code     ↓ join on Year
              india_geopolitics_analysis_master.csv
```

### Master Dataset Schema

| Column | Type | Description |
|---|---|---|
| `year` | Integer | Calendar year (1987–2024) |
| `country_name` | String | India |
| `country_code` | String | IND |
| `Region` | String | South Asia |
| `IncomeGroup` | String | Lower middle income |
| `inflation_pct` | Float | Annual CPI inflation (%) |
| `avg_oil_price` | Float | Average Brent crude (USD/barrel) |
| `oil_volatility` | Float | Std deviation of daily prices that year |
| `oil_price_shock_pct` | Float | Year-over-year price change (%) |

---

## 📈 Key Analytical Findings

### 1. Conflict Years & India's Inflation Response

| Year | Event | Oil Shock % | India Inflation % |
|---|---|---|---|
| 1990 | Gulf War (Iraq invades Kuwait) | +40% | 9.0% |
| 1991 | Gulf War Peak + India BOP Crisis | — | 13.9% |
| 2008 | Global Financial Crisis + Oil Spike | +35% | 8.3% |
| 2022 | Russia-Ukraine + Middle East Tensions | +42% | 6.7% |
| 2023 | Israel-Hamas War / Red Sea Disruptions | -18% | 5.6% |

### 2. Top 5 Most Volatile Oil Years
*(From SQL Query 2 — oil_volatility ranked)*

High volatility years directly preceded inflation spikes in India, confirming that **price uncertainty** is as damaging as high prices themselves.

### 3. Decade Analysis

| Decade | Avg Inflation | Avg Oil Price | Risk Level |
|---|---|---|---|
| 1987–1999 | 9.2% | $19.50 | Very High |
| 2000–2009 | 5.8% | $52.60 | High |
| 2010–2019 | 6.1% | $82.30 | Medium |
| 2020–2024 | 5.8% | $75.20 | Medium-High |

**Insight:** India's economy shows growing resilience — despite higher oil prices in recent decades, inflation is better controlled (structural reforms, monetary policy, diversified energy mix).

---

## 📊 Power BI Dashboard (`Geopolitics_Impact_Analysis.pbix`)

### Page 1: The Pulse of the Economy
- KPI cards: Current Oil Price, India's Inflation, Oil Volatility Index
- Line chart: India CPI Inflation vs. Average Brent Oil Price (1987–2024)

### Page 2: Geopolitical Timeline
- Dual-axis line chart: Oil Price & India Inflation
- Conflict annotations for: 1990 (Gulf War), 2003 (Iraq Invasion), 2011 (Arab Spring), 2022 (Ukraine/Middle East tensions)

### Page 3: Risk Heatmap
- Matrix visual: Decade × Risk Category (Stable / Moderate / High Risk)
- Colour-coded by oil volatility quartile

### Page 4: Shock Simulator
- What-If parameter: User selects an oil price increase (e.g. +20%)
- Predicted impact on India's inflation based on historical regression

---

## 🛡️ Strategic Recommendations

Based on the data analysis, the following strategies are recommended for Indian policymakers:

1. **Strategic Petroleum Reserves (SPR) Expansion**
   India's current SPR covers ~9 days of demand. Expanding to 30–45 days (like IEA guidelines) would buffer supply shocks from Middle East disruptions.

2. **Renewable Energy Acceleration**
   Each percentage point increase in domestic renewable energy production reduces India's oil import dependence and lowers sensitivity to Brent crude price shocks.

3. **Rupee Hedging Mechanisms**
   Middle East oil is priced in USD. INR depreciation during conflicts compounds the price shock. RBI forward contracts and currency swap agreements with GCC nations would reduce this dual exposure.

4. **Diversified Import Sources**
   India has already diversified (Russia, UAE, Saudi Arabia, USA). Further diversification to West African and Latin American suppliers insulates against single-region conflict risk.

5. **Inflation Targeting Consistency**
   RBI's 4% ± 2% inflation band has improved anchoring. Pre-emptive rate signals during oil shock years proved effective in 2022 vs. uncontrolled inflation of 1991.

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| Python 3 (pandas, numpy) | Data cleaning, ETL, feature engineering |
| SQL (SQLite/PostgreSQL) | Analytical queries, aggregations |
| Power BI Desktop | Interactive dashboard, DAX measures |
| GitHub | Version control, portfolio showcase |

---

## 👤 Author

**Sreeharsh**
B.Tech Computer Science & Engineering (2nd Year)
VJEC, Kannur University

- 📜 Google Data Analytics Professional Certificate
- 📊 Microsoft PL-300 Power BI Certified
- 🏛️ IEDC Core Member | IEEE Student Member

---

## 📄 License

This project is for educational and portfolio purposes. Data sourced from World Bank Open Data and U.S. EIA — both under open data policies.
