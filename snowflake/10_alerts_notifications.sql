-- ============================================================================
-- 10_ALERTS_NOTIFICATIONS.SQL — Alerts for ESG & Carbon Emissions Monitoring
-- ============================================================================
USE DATABASE OIL_GAS_ESG;
USE SCHEMA APP;

-- Notification integration (email)
CREATE OR REPLACE NOTIFICATION INTEGRATION aws_malaysia_oil_gas_esg_EMAIL_INT
  TYPE = EMAIL
  ENABLED = TRUE
  ALLOWED_RECIPIENTS = ('jonathan.asvestis@snowflake.com');

-- Alert: EMISSION_THRESHOLD_ALERT
CREATE OR REPLACE ALERT APP.EMISSION_THRESHOLD_ALERT
  WAREHOUSE = OG_ESG_WH
  SCHEDULE = '5 MINUTE'
  COMMENT = 'Facility emissions exceeding allocated budget'
IF (EXISTS (
  SELECT 1 FROM CURATED.FACILITY_EMISSIONS_SUMMARY
  WHERE 1=1 -- Condition: Monthly emissions exceed facility allocation by >10%
))
THEN
  CALL SYSTEM$SEND_EMAIL(
    'aws_malaysia_oil_gas_esg_EMAIL_INT',
    'jonathan.asvestis@snowflake.com',
    '[ALERT] ESG & Carbon Emissions Monitoring: Facility emissions exceeding allocated budget',
    'Facility emissions exceeding allocated budget'
  );

ALTER ALERT APP.EMISSION_THRESHOLD_ALERT RESUME;

-- Alert: REPORTING_DEADLINE_ALERT
CREATE OR REPLACE ALERT APP.REPORTING_DEADLINE_ALERT
  WAREHOUSE = OG_ESG_WH
  SCHEDULE = '5 MINUTE'
  COMMENT = 'Regulatory submission deadline approaching'
IF (EXISTS (
  SELECT 1 FROM CURATED.FACILITY_EMISSIONS_SUMMARY
  WHERE 1=1 -- Condition: BURSA submission due within 14 days
))
THEN
  CALL SYSTEM$SEND_EMAIL(
    'aws_malaysia_oil_gas_esg_EMAIL_INT',
    'jonathan.asvestis@snowflake.com',
    '[ALERT] ESG & Carbon Emissions Monitoring: Regulatory submission deadline approaching',
    'Regulatory submission deadline approaching'
  );

ALTER ALERT APP.REPORTING_DEADLINE_ALERT RESUME;

