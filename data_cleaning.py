"""
=============================================================================
Data Cleaning & ETL Pipeline
Project: Impact of Middle East Conflict on India's Economy
Author: Sreeharsh
Dataset Sources:
    - World Bank: Inflation, Consumer Prices (Annual %) - FP.CPI.TOTL.ZG
    - U.S. EIA: Europe Brent Spot Price FOB (Daily, USD/Barrel)
=============================================================================
"""

import pandas as pd
import numpy as np
import os

# ============================================================
# STEP 1: LOAD RAW DATA
# ============================================================

print("=" * 60)
print("STEP 1: Loading Raw Data")
print("=" * 60)

# World Bank Inflation data (Wide format, 4-row metadata header)
inflation_raw = pd.read_csv(
    "API_FP_CPI_TOTL_ZG_DS2_en_csv_v2_287.csv",
    skiprows=4
)

# Country metadata (Region, Income Group)
metadata_country = pd.read_csv(
    "Metadata_Country_API_FP_CPI_TOTL_ZG_DS2_en_csv_v2_287.csv"
)

# Europe Brent Spot Price (Daily, 4-row header)
oil_raw = pd.read_csv(
    "Europe_Brent_Spot_Price_FOB.csv",
    skiprows=4
)

print(f"  Inflation dataset: {inflation_raw.shape[0]} countries, {inflation_raw.shape[1]} columns")
print(f"  Country metadata: {metadata_country.shape}")
print(f"  Oil price dataset: {oil_raw.shape[0]} daily records")


# ============================================================
# STEP 2: OIL DATA — AGGREGATE DAILY → YEARLY
# ============================================================

print("\n" + "=" * 60)
print("STEP 2: Processing Brent Oil Price Data")
print("=" * 60)

# Standardize column names (snake_case)
oil_raw.columns = ['date', 'oil_price']

# Parse dates and drop invalid rows
oil_raw['date'] = pd.to_datetime(oil_raw['date'], errors='coerce')
oil_raw = oil_raw.dropna(subset=['date'])
oil_raw['oil_price'] = pd.to_numeric(oil_raw['oil_price'], errors='coerce')
oil_raw = oil_raw.dropna(subset=['oil_price'])

# Extract year for aggregation
oil_raw['year'] = oil_raw['date'].dt.year

# Aggregate: Average Price & Volatility (Std Dev) per year
oil_yearly = oil_raw.groupby('year')['oil_price'].agg(
    avg_oil_price='mean',
    oil_volatility='std'
).reset_index()

# Feature Engineering: Year-over-Year Price Shock %
# This is a "Conflict Marker" — high values indicate geopolitical events
oil_yearly['oil_price_shock_pct'] = oil_yearly['avg_oil_price'].pct_change() * 100

print(f"  Daily records: {len(oil_raw):,}")
print(f"  Years covered after aggregation: {oil_yearly['year'].min()} – {oil_yearly['year'].max()}")
print(f"  Oil columns created: {oil_yearly.columns.tolist()}")


# ============================================================
# STEP 3: INFLATION DATA — WIDE → LONG FORMAT (MELT)
# ============================================================

print("\n" + "=" * 60)
print("STEP 3: Transforming Inflation Data (Wide → Long)")
print("=" * 60)

# Identify year columns (numeric column names)
year_cols = [c for c in inflation_raw.columns if str(c).strip().isdigit()]

# Filter for India only
india_wide = inflation_raw[
    inflation_raw['Country Code'] == 'IND'
][['Country Name', 'Country Code'] + year_cols]

# Melt: each year becomes its own row
india_long = india_wide.melt(
    id_vars=['Country Name', 'Country Code'],
    value_vars=year_cols,
    var_name='year',
    value_name='inflation_pct'
)

# Type conversion and cleaning
india_long['year'] = india_long['year'].astype(int)
india_long['inflation_pct'] = pd.to_numeric(india_long['inflation_pct'], errors='coerce')
india_long = india_long.dropna(subset=['inflation_pct'])
india_long = india_long.sort_values('year').reset_index(drop=True)

print(f"  India inflation records: {len(india_long)}")
print(f"  Year range: {india_long['year'].min()} – {india_long['year'].max()}")


# ============================================================
# STEP 4: MERGE — THREE-WAY JOIN (Inflation + Metadata + Oil)
# ============================================================

print("\n" + "=" * 60)
print("STEP 4: Three-Way Join — Building Master Dataset")
print("=" * 60)

# Join India inflation with Country Metadata
meta_clean = metadata_country[['Country Code', 'Region', 'IncomeGroup']].copy()
india_with_meta = india_long.merge(meta_clean, on='Country Code', how='left')

# Join with aggregated Oil Price data
master = india_with_meta.merge(oil_yearly, on='year', how='inner')
master = master.sort_values('year').reset_index(drop=True)

# Standardize column names
master.rename(columns={
    'Country Name': 'country_name',
    'Country Code': 'country_code'
}, inplace=True)

# Final column ordering
final_cols = [
    'year', 'country_name', 'country_code', 'Region', 'IncomeGroup',
    'inflation_pct', 'avg_oil_price', 'oil_volatility', 'oil_price_shock_pct'
]
master = master[final_cols]

print(f"  Master dataset: {master.shape[0]} rows × {master.shape[1]} columns")
print(f"  Year range in master: {master['year'].min()} – {master['year'].max()}")
print(f"  Columns: {master.columns.tolist()}")


# ============================================================
# STEP 5: DATA VALIDATION
# ============================================================

print("\n" + "=" * 60)
print("STEP 5: Data Validation")
print("=" * 60)

print(f"  Null values per column:\n{master.isnull().sum()}")
print(f"\n  Descriptive Statistics:")
print(master[['inflation_pct', 'avg_oil_price', 'oil_volatility', 'oil_price_shock_pct']].describe().round(2).to_string())


# ============================================================
# STEP 6: EXPORT CLEAN DATASET
# ============================================================

print("\n" + "=" * 60)
print("STEP 6: Exporting Clean Dataset")
print("=" * 60)

output_file = "india_geopolitics_analysis_master.csv"
master.to_csv(output_file, index=False)
print(f"  ✅ Clean dataset saved: {output_file}")
print(f"  File size: {os.path.getsize(output_file):,} bytes")

print("\n" + "=" * 60)
print("ETL PIPELINE COMPLETE")
print("=" * 60)
print("Next step: Load 'india_geopolitics_analysis_master.csv' into Power BI")
