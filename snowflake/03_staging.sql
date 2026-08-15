-- ============================================================================
-- 03_STAGING.SQL — Generate synthetic data for ESG & Carbon Emissions Monitoring
-- Country: MALAYSIA | Currency: MYR
-- ============================================================================
USE DATABASE OIL_GAS_ESG;
USE SCHEMA RAW;

-- Data generation scripts are demo-specific.
-- See the handcrafted SQL in the aws-malaysia-semiconductor-yield demo for
-- the full pattern: GENERATOR + UNIFORM + LATERAL for distribution,
-- Cortex Complete for text generation, engineered key demo numbers.

-- Target row counts:
-- EMISSION_RECORDS: 50,000 rows — Monthly Scope 1/2/3 emissions by facility and source category
-- FACILITIES: 30 rows — O&G facilities — refineries, gas plants, terminals, offshore platforms
-- ESG_REPORTS: 100 rows — Sustainability reports, TCFD disclosures, CDP submissions (PDF/DOCX)
-- UTILITY_BILLS: 12,000 rows — Monthly electricity, gas, and water consumption by facility (Scope 2 input)
-- REGULATORY_SUBMISSIONS: 200 rows — BURSA Malaysia, MyCarbon, MGTC submissions and compliance records
-- CLIMATE_BENCHMARKS: 20 rows — Industry carbon intensity benchmarks and Malaysia's NDC targets
