-- ============================================================================
-- 11_TASK_PIPELINE.SQL — Task DAG for ESG & Carbon Emissions Monitoring
-- ============================================================================
USE DATABASE OIL_GAS_ESG;
USE SCHEMA APP;

CREATE OR REPLACE TASK APP.TASK_PARSE_ESG_REPORTS
  WAREHOUSE = OG_ESG_WH
  SCHEDULE = 'USING CRON 0 2 * * 1 UTC'
  COMMENT = 'Parse new ESG reports with AI_PARSE_DOCUMENT'
AS
  SELECT 1; -- Replace with actual refresh logic

CREATE OR REPLACE TASK APP.TASK_COMPUTE_SCOPE2
  WAREHOUSE = OG_ESG_WH
  AFTER APP.TASK_PARSE_ESG_REPORTS
  COMMENT = 'Recalculate Scope 2 from utility consumption'
AS
  SELECT 1; -- Replace with actual refresh logic

CREATE OR REPLACE TASK APP.TASK_REFRESH_ICEBERG
  WAREHOUSE = OG_ESG_WH
  AFTER APP.TASK_COMPUTE_SCOPE2
  COMMENT = 'Refresh Iceberg export for regulator access'
AS
  SELECT 1; -- Replace with actual refresh logic

ALTER TASK APP.TASK_REFRESH_ICEBERG RESUME;
ALTER TASK APP.TASK_COMPUTE_SCOPE2 RESUME;
ALTER TASK APP.TASK_PARSE_ESG_REPORTS RESUME;
