-- ============================================================================
-- ESG & Carbon Emissions Monitoring
-- Track Scope 1/2/3 emissions across Malaysia's O&G operations — AI_PARSE_DOCUMENT extracts ESG report data, Dynamic Tables compute carbon intensity, and Iceberg export enables regulator access.
-- ============================================================================
USE ROLE ACCOUNTADMIN;
CREATE DATABASE IF NOT EXISTS OIL_GAS_ESG;
CREATE WAREHOUSE IF NOT EXISTS OG_ESG_WH WAREHOUSE_SIZE = 'MEDIUM' AUTO_SUSPEND = 120 AUTO_RESUME = TRUE;
USE DATABASE OIL_GAS_ESG;
CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS CURATED;
CREATE SCHEMA IF NOT EXISTS ML;
CREATE SCHEMA IF NOT EXISTS AI;
CREATE SCHEMA IF NOT EXISTS SEARCH;
CREATE SCHEMA IF NOT EXISTS APP;

USE WAREHOUSE OG_ESG_WH;
