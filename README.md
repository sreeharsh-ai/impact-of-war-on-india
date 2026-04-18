# 🛢️ Impact of Middle East Conflict on India's Economy

### A Data Analytics Project | Power BI · Python · SQL

![Python](https://img.shields.io/badge/Python-3.10+-blue?logo=python)
![SQL](https://img.shields.io/badge/SQL-SQLite%2FPostgreSQL-orange?logo=postgresql)
![Power BI](https://img.shields.io/badge/PowerBI-Dashboard-yellow?logo=powerbi)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

---

## 📌 Project Overview

This project analyzes how geopolitical instability in the Middle East — including events such as the Gulf War, Arab Spring, ISIS rise, and recent conflicts — has **influenced and is associated with changes in India's macroeconomic indicators**, particularly **oil prices and inflation**.

India imports over **85% of its crude oil**, making it highly sensitive to global oil price fluctuations. This project combines historical data to understand how oil price shocks relate to inflation trends over time.

---

## 🗂️ Repository Structure

📁 india-geopolitics-economy/
│
├── 📄 data_cleaning.py
├── 📄 SQL_Analysis_Queries.sql
├── 📄 india_geopolitics_analysis_master.csv
├── 📊 power_bi_pbix.zip
└── 📄 README.md

---

## 📦 Dataset

The final dataset (`india_geopolitics_analysis_master.csv`) was created through a custom ETL pipeline using Python. It covers the period **1987–2024**.

### Dataset Columns

| Column                | Description                            |
| --------------------- | -------------------------------------- |
| `year`                | Calendar year                          |
| `country_name`        | India                                  |
| `country_code`        | IND                                    |
| `Region`              | South Asia                             |
| `IncomeGroup`         | Lower middle income                    |
| `inflation_pct`       | India CPI inflation (%)                |
| `avg_oil_price`       | Average Brent crude price (USD/barrel) |
| `oil_volatility`      | Standard deviation of oil prices       |
| `oil_price_shock_pct` | Year-over-year % change in oil price   |

---

## 🌐 Data Sources

The dataset was built using publicly available data:

* **World Bank Open Data**
  Indicator: *Inflation, Consumer Prices (FP.CPI.TOTL.ZG)*
  Source: https://data.worldbank.org

* **U.S. Energy Information Administration (EIA)**
  Dataset: *Europe Brent Spot Price FOB (Daily)*
  Source: https://www.eia.gov

These raw datasets were cleaned, transformed, and merged using Python. 

---

## ⚙️ ETL Pipeline (`data_cleaning.py`)

The project includes a complete ETL pipeline:

1. Load raw CSV files (skip metadata rows)
2. Clean and convert data types
3. Aggregate oil prices from daily → yearly
4. Calculate oil volatility and price shocks
5. Transform inflation data (wide → long format)
6. Merge datasets (inflation + oil + metadata)
7. Validate data (nulls, stats, missing years)
8. Export final dataset

---

## 🔍 SQL Analysis

Seven analytical SQL queries were written to extract insights:

| Query | Description                    |
| ----- | ------------------------------ |
| Q1    | Dataset overview               |
| Q2    | Top volatile oil years         |
| Q3    | Largest oil price shocks       |
| Q4    | Decade-wise trends             |
| Q5    | Geopolitical event analysis    |
| Q6    | Risk classification            |
| Q7    | Inflation resilience over time |

---

## 📊 Power BI Dashboard

The Power BI dashboard includes **3 interactive pages**:

* **Trend Analysis**
  Oil price vs inflation (dual-axis visualization)

* **Shock Analysis**
  Oil price shocks and geopolitical events

* **Risk Heatmap**
  Decade-wise inflation and volatility patterns

---

## 📌 Key Insights

* Oil price volatility is often associated with major geopolitical events
* India's inflation response to oil shocks has reduced over time
* Economic reforms and policy measures have improved resilience
* High-risk years cluster around major global conflicts

---

## ⚠️ Limitations

* This analysis shows **association, not causation**
* Inflation is influenced by multiple factors beyond oil prices
* Annual aggregation may hide short-term fluctuations
* Risk classification is rule-based, not predictive

---

## 🛠️ Tech Stack

| Tool                    | Purpose             |
| ----------------------- | ------------------- |
| Python (pandas, numpy)  | Data cleaning & ETL |
| SQL (SQLite/PostgreSQL) | Data analysis       |
| Power BI                | Visualization       |
| Excel                   | Data inspection     |

---

## 🚀 How to Run

### 1. Clone Repository

```bash
git clone https://github.com/<your-username>/india-geopolitics-economy.git
cd india-geopolitics-economy
```

### 2. Install Dependencies

```bash
pip install pandas numpy
```

### 3. Run ETL

```bash
python data_cleaning.py
```

### 4. Run SQL

Import CSV as `india_geo` and execute queries.

### 5. Open Dashboard

Open `.pbix` file in Power BI Desktop.

---

## 👤 Author

**Sreeharsh**
B.Tech Computer Science Engineering

---

## 📄 License

This project is for academic and educational purposes.
Data sourced from World Bank and U.S. EIA open data platforms.
