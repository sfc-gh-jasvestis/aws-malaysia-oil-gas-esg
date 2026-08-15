-- ============================================================================
-- 07_SEMANTIC_VIEW.SQL — Semantic View for ESG & Carbon Emissions Monitoring
-- ============================================================================
USE DATABASE OIL_GAS_ESG;
USE SCHEMA APP;

CREATE OR REPLACE SEMANTIC VIEW APP.ESG_ANALYTICS
  COMMENT = 'Carbon emissions, ESG scoring, and sustainability analytics'
AS
  TABLES (
    CURATED.FACILITY_EMISSIONS_SUMMARY AS facility_emissions_summary,CURATED.EMISSIONS_TIMESERIES AS emissions_timeseries,CURATED.SCOPE2_CALCULATION AS scope2_calculation,CURATED.REDUCTION_PROGRESS AS reduction_progress
  );
