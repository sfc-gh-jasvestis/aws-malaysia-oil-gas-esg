# Demo Script: ESG & Carbon Emissions Monitoring
## ~4-Minute Recorded Walkthrough
**Format**: Screen recording with voiceover
**Target**: Customer meeting / booth loop / social share
**Narrative**: "Snowflake consolidates emissions data from 30 facilities — AI_PARSE_DOCUMENT extracts figures from ESG reports, Dynamic Tables compute carbon intensity metrics, and Iceberg export gives BURSA Malaysia and regulators governed access to verified emissions data"
**Demo Mode**: Open app with `?demo=true` for presenter notes

---

## Two Personas

| Persona | Role | Tool | What they care about |
|---|---|---|---|
| **Puan Fatimah binti Othman** | Chief Sustainability Officer | React App (SPCS) | Net-zero pathway, BURSA ESG rating, board reporting, regulatory compliance |
| **Dr. Chen Wei** | ESG Analyst | Amazon QuickSight | Scope 1/2/3 accounting, data quality, carbon intensity benchmarking, report extraction accuracy |

---

## What's Built

| Layer | Component | Detail |
|---|---|---|
| **RAW** | 6 tables | EMISSION_RECORDS (50000), FACILITIES (30), ESG_REPORTS (100), UTILITY_BILLS (12000), REGULATORY_SUBMISSIONS (200), CLIMATE_BENCHMARKS (20) |
| **CURATED** | 4 Dynamic Tables | FACILITY_EMISSIONS_SUMMARY, EMISSIONS_TIMESERIES, SCOPE2_CALCULATION, REDUCTION_PROGRESS |
| **ML** |  | Forecasting + anomaly detection |
| **AI** | AI_PARSE_DOCUMENT, AI_EXTRACT, SUMMARIZE | Classification + extraction |
| **Search** | Cortex Search | 100 documents indexed |
| **Agent** | ESG_INTELLIGENCE_AGENT | Semantic View + Search tools |


---

## The Story

Malaysia committed to net-zero by 2050, and BURSA Malaysia now mandates sustainability reporting for all listed companies. A major O&G operator with 30 facilities struggles to consolidate emissions data from disparate sources — PDF reports, utility bills, operational meters — while demonstrating auditable reduction progress to regulators.

---

## Script

### [0:00–0:45] EMISSIONS OVERVIEW

**Show**: Emissions Overview tab

> "2.4 million tonnes CO2e annual emissions across 30 facilities — Scope 1 dominant at 78%."

**Action**: Point at 2.4M tonnes KPI card

### [0:45–1:30] FACILITY BREAKDOWN

**Show**: Facility Breakdown tab

> "Top 5 facilities account for 68% of total emissions — led by Pengerang refinery."

**Action**: Click the facility ranking chart

### [1:30–2:15] DOCUMENT INTELLIGENCE

**Show**: Document Intelligence tab

> "One hundred ESG reports parsed by AI_PARSE_DOCUMENT — targets, KPIs, commitments extracted automatically."

**Action**: Show parsed document example with extracted fields

### [2:15–3:00] ASK AI

**Show**: Ask AI tab

> "Puan Fatimah asks: 'Are we on track for 2030 reduction targets?'"

**Action**: Type: 'Are we on track for 2030 targets?'

### [3:00–3:45] ARCHITECTURE & DATA

**Show**: Architecture & Data tab

> "Six Snowflake capabilities, seven AWS services."

**Action**: Walk through architecture diagram


---

## Key Demo Differentiators

1. **AI_PARSE_DOCUMENT for ESG report extraction** — Only demo using AI_PARSE_DOCUMENT to extract emissions data from sustainability reports
2. **AI_EXTRACT for utility bill processing** — Only demo automating Scope 2 calculation from scanned utility bills
3. **Iceberg export for regulator access** — Only demo showing governed regulator access via open table format for ESG data
4. **Malaysian ESG regulatory context** — BURSA Malaysia framework, MyCarbon, MGTC compliance, Malaysia NDC targets
5. **Scope 1/2/3 consolidated analytics** — Full greenhouse gas protocol scope accounting with facility-level drill-down
6. **AWS Textract + Iceberg + QuickSight** — Only demo combining document OCR with open table export for regulatory reporting


---

## Demo Prep Checklist

### Data Verification
- [ ] `SELECT COUNT(*) FROM OIL_GAS_ESG.RAW.EMISSION_RECORDS` → 50000
- [ ] `SELECT COUNT(*) FROM OIL_GAS_ESG.RAW.FACILITIES` → 30
- [ ] `SELECT SUM(CO2E_TONNES) FROM OIL_GAS_ESG.CURATED.FACILITY_EMISSIONS_SUMMARY` → ~2400000
- [ ] `SELECT REDUCTION_PCT FROM OIL_GAS_ESG.CURATED.REDUCTION_PROGRESS WHERE TARGET_YEAR = 2030` → ~12

### ML Model Verification

### AI/Agent Verification
- [ ] `SELECT COUNT(*) FROM OIL_GAS_ESG.AI.PARSED_ESG_REPORTS` → 100
- [ ] `SELECT COUNT(*) FROM OIL_GAS_ESG.AI.EXTRACTED_UTILITY_DATA` → 12000

