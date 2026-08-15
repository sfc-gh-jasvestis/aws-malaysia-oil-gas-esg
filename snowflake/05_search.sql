-- ============================================================================
-- 05_SEARCH.SQL — Cortex Search for ESG & Carbon Emissions Monitoring
-- ============================================================================
USE DATABASE OIL_GAS_ESG;
USE SCHEMA SEARCH;

CREATE OR REPLACE CORTEX SEARCH SERVICE SEARCH.ESG_REPORTS_SEARCH
  ON CONTENT
  ATTRIBUTES REPORT_TYPE, YEAR, FRAMEWORK, AUTHOR
  WAREHOUSE = OG_ESG_WH
  TARGET_LAG = '1 hour'
AS (
  SELECT * FROM RAW.ESG_REPORTS
);
