-- ============================================================
-- SQL Analysis Queries
-- Project: Impact of Middle East Conflict on India's Economy
-- Dataset: india_geopolitics_analysis_master.csv
-- Author: Sreeharsh
-- Note: These queries are written for SQLite / PostgreSQL syntax.
--       Import the CSV as a table named: india_geo
-- ============================================================


-- ============================================================
-- QUERY 1: Full Dataset Overview
-- ============================================================
SELECT
    year,
    ROUND(inflation_pct, 2)         AS inflation_pct,
    ROUND(avg_oil_price, 2)         AS avg_oil_price,
    ROUND(oil_volatility, 2)        AS oil_volatility,
    ROUND(oil_price_shock_pct, 2)   AS oil_price_shock_pct
FROM india_geo
ORDER BY year;


-- ============================================================
-- QUERY 2: Top 5 Most Volatile Oil Years (Conflict Markers)
-- These are the years where oil price uncertainty was highest,
-- often associated with Middle East conflicts & geopolitical events.
-- ============================================================
SELECT
    year,
    ROUND(avg_oil_price, 2)       AS avg_price_usd,
    ROUND(oil_volatility, 2)      AS price_std_dev,
    ROUND(oil_price_shock_pct, 2) AS yoy_shock_pct,
    ROUND(inflation_pct, 2)       AS india_inflation_pct
FROM india_geo
WHERE oil_volatility IS NOT NULL
ORDER BY oil_volatility DESC
LIMIT 5;


-- ============================================================
-- QUERY 3: Top 5 Largest Oil Price Shocks (YoY % Change)
-- Positive = oil price surge (demand spike / supply disruption)
-- Negative = oil price crash (demand collapse / oversupply)
-- ============================================================
SELECT
    year,
    ROUND(oil_price_shock_pct, 2) AS yoy_shock_pct,
    ROUND(avg_oil_price, 2)       AS avg_oil_price_usd,
    ROUND(inflation_pct, 2)       AS india_inflation_pct,
    CASE
        WHEN oil_price_shock_pct > 0 THEN 'Price Surge'
        ELSE 'Price Crash'
    END AS shock_type
FROM india_geo
WHERE oil_price_shock_pct IS NOT NULL
ORDER BY ABS(oil_price_shock_pct) DESC
LIMIT 5;


-- ============================================================
-- QUERY 4: Decade-Wise Average Inflation & Oil Price
-- Used for the Risk Heatmap in Power BI (Page 3)
-- ============================================================
SELECT
    CASE
        WHEN year BETWEEN 1987 AND 1999 THEN '1987-1999'
        WHEN year BETWEEN 2000 AND 2009 THEN '2000-2009'
        WHEN year BETWEEN 2010 AND 2019 THEN '2010-2019'
        WHEN year BETWEEN 2020 AND 2024 THEN '2020-2024'
    END AS decade,
    COUNT(*)                        AS num_years,
    ROUND(AVG(inflation_pct), 2)    AS avg_inflation,
    ROUND(MAX(inflation_pct), 2)    AS max_inflation,
    ROUND(MIN(inflation_pct), 2)    AS min_inflation,
    ROUND(AVG(avg_oil_price), 2)    AS avg_oil_price,
    ROUND(AVG(oil_volatility), 2)   AS avg_volatility
FROM india_geo
GROUP BY decade
ORDER BY MIN(year);


-- ============================================================
-- QUERY 5: Geopolitical Conflict Years — Key Event Analysis
-- Years with major Middle East events and India's response
-- ============================================================
SELECT
    year,
    ROUND(inflation_pct, 2)       AS india_inflation,
    ROUND(avg_oil_price, 2)       AS oil_price,
    ROUND(oil_price_shock_pct, 2) AS oil_shock_pct,
    ROUND(oil_volatility, 2)      AS oil_volatility,
    CASE year
        WHEN 1990 THEN 'Gulf War (Iraq invades Kuwait)'
        WHEN 1991 THEN 'Gulf War Peak + India BOP Crisis'
        WHEN 2003 THEN 'US Invasion of Iraq'
        WHEN 2008 THEN 'Global Financial Crisis + Oil Spike'
        WHEN 2011 THEN 'Arab Spring Uprisings'
        WHEN 2014 THEN 'ISIS Rise / Oil Glut Begins'
        WHEN 2020 THEN 'COVID-19 Pandemic Oil Collapse'
        WHEN 2022 THEN 'Russia-Ukraine War + Middle East Tensions'
        WHEN 2023 THEN 'Israel-Hamas War / Red Sea Disruptions'
        ELSE 'Non-Conflict Year'
    END AS geopolitical_event
FROM india_geo
WHERE year IN (1990, 1991, 2003, 2008, 2011, 2014, 2020, 2022, 2023)
ORDER BY year;


-- ============================================================
-- QUERY 6: Risk Classification Based on Oil Shock & Inflation
-- Classifies each year by rule-based thresholds on oil shock
-- and inflation to identify high-risk vs. resilient periods.
-- ============================================================
SELECT
    year,
    ROUND(inflation_pct, 2)             AS india_inflation,
    ROUND(avg_oil_price, 2)             AS avg_oil_price,
    ROUND(oil_price_shock_pct, 2)       AS oil_shock_pct,
    CASE
        WHEN oil_price_shock_pct > 15 AND inflation_pct > 6
            THEN 'HIGH RISK — Shock & Inflation Spike'
        WHEN oil_price_shock_pct > 15 AND inflation_pct <= 6
            THEN 'RESILIENT — Oil Spiked, Inflation Contained'
        WHEN oil_price_shock_pct <= 15 AND oil_price_shock_pct > 0
            THEN 'MODERATE — Mild Oil Increase'
        ELSE 'STABLE — Oil Stable or Declining'
    END AS risk_classification
FROM india_geo
WHERE oil_price_shock_pct IS NOT NULL
ORDER BY year;


-- ============================================================
-- QUERY 7: India's Inflation Resilience Over Time
-- Compares how India responded to oil shocks across eras
-- ============================================================
SELECT
    year,
    ROUND(inflation_pct, 2)       AS india_inflation,
    ROUND(avg_oil_price, 2)       AS oil_price,
    ROUND(oil_price_shock_pct, 2) AS shock_pct,
    CASE
        WHEN year < 2000 THEN 'Pre-Liberalization Era'
        WHEN year BETWEEN 2000 AND 2013 THEN 'Growth Era'
        ELSE 'Post-Reform / Digital Era'
    END AS india_economic_era
FROM india_geo
ORDER BY year;
