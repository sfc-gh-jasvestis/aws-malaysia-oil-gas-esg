-- Generated from generator/demo_specs/aws-malaysia-oil-gas-esg.json
-- Regenerate with: python3 generator/gen_repo_docs.py aws-malaysia-oil-gas-esg
-- This is the schema that is actually deployed for MY_OIL_GAS_ESG.

-- MY_OIL_GAS_ESG  (ESG & Carbon Emissions Monitoring)
-- generated from generator/demo_specs/aws-malaysia-oil-gas-esg.json - do not hand-edit
CREATE DATABASE IF NOT EXISTS MY_OIL_GAS_ESG;
CREATE SCHEMA IF NOT EXISTS MY_OIL_GAS_ESG.RAW;
CREATE SCHEMA IF NOT EXISTS MY_OIL_GAS_ESG.CURATED;
CREATE SCHEMA IF NOT EXISTS MY_OIL_GAS_ESG.APP;
USE DATABASE MY_OIL_GAS_ESG;

-- 5 real regions; entity names carry their region so the two always agree
