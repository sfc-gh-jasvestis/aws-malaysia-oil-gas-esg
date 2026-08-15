-- ============================================================================
-- 04_DYNAMIC_TABLES.SQL — Curated layer for ESG & Carbon Emissions Monitoring
-- ============================================================================
USE DATABASE OIL_GAS_ESG;
USE SCHEMA CURATED;

-- FACILITY_EMISSIONS_SUMMARY: Facility-level total emissions by scope with carbon intensity
-- Source: FACILITIES, EMISSION_RECORDS
CREATE OR REPLACE DYNAMIC TABLE CURATED.FACILITY_EMISSIONS_SUMMARY
  TARGET_LAG = '5 minutes'
  WAREHOUSE = OG_ESG_WH
AS
SELECT * FROM RAW.FACILITIES;
-- TODO: Replace with actual join/aggregation logic per demo

-- EMISSIONS_TIMESERIES: Monthly emissions trend for baseline comparison and forecasting
-- Source: EMISSION_RECORDS
CREATE OR REPLACE DYNAMIC TABLE CURATED.EMISSIONS_TIMESERIES
  TARGET_LAG = '5 minutes'
  WAREHOUSE = OG_ESG_WH
AS
SELECT * FROM RAW.EMISSION_RECORDS;
-- TODO: Replace with actual join/aggregation logic per demo

-- SCOPE2_CALCULATION: Scope 2 emissions computed from utility consumption and grid factors
-- Source: UTILITY_BILLS, FACILITIES
CREATE OR REPLACE DYNAMIC TABLE CURATED.SCOPE2_CALCULATION
  TARGET_LAG = '5 minutes'
  WAREHOUSE = OG_ESG_WH
AS
SELECT * FROM RAW.UTILITY_BILLS;
-- TODO: Replace with actual join/aggregation logic per demo

-- REDUCTION_PROGRESS: Progress against 2020 baseline and 2030/2050 targets
-- Source: EMISSION_RECORDS, FACILITIES
CREATE OR REPLACE DYNAMIC TABLE CURATED.REDUCTION_PROGRESS
  TARGET_LAG = '5 minutes'
  WAREHOUSE = OG_ESG_WH
AS
SELECT * FROM RAW.EMISSION_RECORDS;
-- TODO: Replace with actual join/aggregation logic per demo

