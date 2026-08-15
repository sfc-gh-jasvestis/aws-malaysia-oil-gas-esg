-- ============================================================================
-- 01_MARKETPLACE_INSTALL.SQL — Install marketplace data for ESG & Carbon Emissions Monitoring
-- ============================================================================
USE DATABASE OIL_GAS_ESG;
USE SCHEMA RAW;

-- Free listings to install from Snowflake Marketplace:
-- Install: Snowflake Public Data (Free)
--   https://app.snowflake.com/marketplace/listing/GZTSZ290BV255

-- Paid listing (mock): S&P Global ESG Scores
--   Real data: https://app.snowflake.com/marketplace/listing/GZT0Z5I4XY0
--   Using mock table: CLIMATE_BENCHMARKS
CREATE TABLE IF NOT EXISTS RAW.CLIMATE_BENCHMARKS (
  ID INT AUTOINCREMENT, DATA VARIANT, LOADED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

