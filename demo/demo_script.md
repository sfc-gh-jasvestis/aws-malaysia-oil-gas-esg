# ESG & Carbon Emissions Monitoring

**Malaysia - Oil & Gas — ESG & Sustainability**
Use case: Carbon Emissions Monitoring

> Track Scope 1/2/3 emissions across Malaysia's O&G operations — AI_PARSE_DOCUMENT extracts ESG report data, Dynamic Tables compute carbon intensity, and Iceberg export enables regulator access.

## Why Snowflake

Snowflake consolidates emissions data from 30 facilities — AI_PARSE_DOCUMENT extracts figures from ESG reports, Dynamic Tables compute carbon intensity metrics, and Iceberg export gives BURSA Malaysia and regulators governed access to verified emissions data

- **AI_PARSE_DOCUMENT for ESG report extraction** - Only demo using AI_PARSE_DOCUMENT to extract emissions data from sustainability reports
- **AI_EXTRACT for utility bill processing** - Only demo automating Scope 2 calculation from scanned utility bills
- **Iceberg export for regulator access** - Only demo showing governed regulator access via open table format for ESG data
- **Malaysian ESG regulatory context** - BURSA Malaysia framework, MyCarbon, MGTC compliance, Malaysia NDC targets
- **Scope 1/2/3 consolidated analytics** - Full greenhouse gas protocol scope accounting with facility-level drill-down
- **AWS Textract + Iceberg + QuickSight** - Only demo combining document OCR with open table export for regulatory reporting

## What is deployed

| | |
|---|---|
| Database | `MY_OIL_GAS_ESG` |
| Service | `MY_OIL_GAS_ESG_APP` |
| Compute pool | `SEA_DEMOS_MALAYSIA_POOL` |
| Dimension table | `RAW.CLIMATE_BENCHMARKS` (20 rows) |
| Fact table | `RAW.EMISSION_RECORDS` (250,000 rows, 90 days) |
| Curated layer | `CURATED.PERFORMANCE_SUMMARY`, `CURATED.TREND_ANALYSIS`, `CURATED.KPI_SUMMARY` |
| Currency | MYR (RM) |

Regions in play: Selangor, Johor, Penang, Sabah, Sarawak
Segments: Scope 1 Combustion, Scope 1 Flaring, Scope 2 Power, Fugitive Methane

Dynamic tables are created suspended and refreshed on demand:

```bash
./refresh_demo_data.sh MY_OIL_GAS_ESG
```

## KPI cards

Every card below is served live from `CURATED.KPI_SUMMARY`. The app keeps the
original literal as a fallback, so it still renders if Snowflake is unreachable.

| Card | Value | Backed by |
|---|---|---|
| Carbon Intensity | `18.2 kgCO2e/boe` | average per event |
| Methane Leaks | `3` | average per event |
| Flaring Reduction | `-24%` | average per event |
| Platforms | `42` | average per event |
| Scope 1+2 | `1.4M tCO2e` | total across Climate Benchmarks |
| CCS Capacity | `2.4 MT/yr` | total across Climate Benchmarks |
| Net Zero Gap | `-42%` | average per event |


## Demo flow

1. Emissions Overview
2. Facility Breakdown
3. Document Intelligence
4. Ask AI
5. Architecture & Data

## Talking points

- **2.4M tonnes CO2e** - annual emissions across 30 facilities (Scope 1+2+3)
- **30 facilities** - tracked — refineries, gas plants, terminals, platforms
- **12% reduction** - from 2020 baseline (target: 25% by 2030)
- **100 ESG docs** - parsed by AI_PARSE_DOCUMENT
- **BURSA ESG score: B+** - up from B — improved data quality and disclosure
- **12,000 utility bills** - processed by AI_EXTRACT for Scope 2 calculation
- **200 regulatory submissions** - to BURSA, MyCarbon, and MGTC

## Business impact

- Malaysia committed to reduce carbon intensity of GDP by 45% by 2030 (vs 2005) under its updated NDC (UNFCCC)
- BURSA Malaysia mandates enhanced sustainability reporting for all Main Market listed issuers from 2024 (BURSA Malaysia)
- PETRONAS targets net-zero carbon emissions by 2050 with 25% reduction by 2030 (PETRONAS)
- Automated ESG data extraction reduces reporting time by 60-80% and improves accuracy (EY Climate Change)

---
Generated from `generator/demo_specs/aws-malaysia-oil-gas-esg.json`. Do not hand-edit: run
`python3 generator/gen_repo_docs.py aws-malaysia-oil-gas-esg` instead.
