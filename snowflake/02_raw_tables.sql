-- Synthetic facility-day ESG observations for a fictional oil and gas operator
-- in Malaysia. Nothing is seeded as a prediction. Randomness is HASH-seeded, so
-- every rebuild is reproducible: per-facility throughput, asset age and
-- exceedance propensity, weekly throughput seasonality and a throughput peak,
-- wear between environmental-control inspections, category-weighted exceedance
-- causes, and two regional rainfall events.
-- Thresholds are internal demo thresholds, not regulatory limits.
USE DATABASE IDENTIFIER($DEMO_DB);
USE SCHEMA RAW;
USE WAREHOUSE IDENTIFIER($DEMO_WH);

CREATE TABLE RAW.FACILITIES AS
WITH sites AS (
  SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1 AS SITE_INDEX
  FROM TABLE(GENERATOR(ROWCOUNT => 30))
), draws AS (
  SELECT SITE_INDEX,
         MOD(ABS(HASH(SITE_INDEX, 'age')), 1000000) / 1e6 AS U_AGE,
         MOD(ABS(HASH(SITE_INDEX, 'rate')), 1000000) / 1e6 AS U_RATE,
         MOD(ABS(HASH(SITE_INDEX, 'insp')), 1000000) / 1e6 AS U_INSP,
         MOD(ABS(HASH(SITE_INDEX, 'discipline')), 1000000) / 1e6 AS U_DISCIPLINE,
         MOD(ABS(HASH(SITE_INDEX, 'capacity')), 1000000) / 1e6 AS U_CAPACITY
  FROM sites
)
SELECT 'FC-' || LPAD(SITE_INDEX::VARCHAR, 4, '0') AS ID,
       'Synthetic facility ' || LPAD(SITE_INDEX::VARCHAR, 4, '0') AS NAME,
       -- Deterministic spread (7 and 5 are coprime): every region and facility
       -- type is present, with Bintulu and Kuantan largest. Cities are labels only.
       CASE MOD(SITE_INDEX, 7) WHEN 0 THEN 'Bintulu' WHEN 1 THEN 'Bintulu'
            WHEN 2 THEN 'Kuantan' WHEN 3 THEN 'Kuantan'
            WHEN 4 THEN 'Miri' ELSE 'Kota Kinabalu' END AS REGION,
       CASE MOD(SITE_INDEX, 5) WHEN 0 THEN 'Offshore Platform' WHEN 1 THEN 'Gas Processing Plant'
            WHEN 2 THEN 'Refinery' WHEN 3 THEN 'LNG Terminal'
            ELSE 'Oil Terminal' END AS CATEGORY,
       SITE_INDEX,
       ROUND(1 + U_AGE * 24, 1) AS AGE_YEARS,
       -- Base daily exceedance probability 0.5%-3.5%; ~15% of facilities are chronic (x3).
       (0.005 + U_RATE * 0.03) * IFF(U_RATE > 0.85, 3, 1) AS BASE_EXCEEDANCE_RATE,
       7 * (1 + FLOOR(U_INSP * 3)) AS INSPECTION_INTERVAL_DAYS,
       0.55 + U_DISCIPLINE * 0.45 AS INSPECTION_COMPLETION_PROB,
       -- Hydrocarbons processed or handled per day (tonnes).
       ROUND(CASE MOD(SITE_INDEX, 5) WHEN 0 THEN 3000 WHEN 1 THEN 8000 WHEN 2 THEN 12000
                  WHEN 3 THEN 15000 ELSE 10000 END * (0.8 + U_CAPACITY * 0.4)) AS DAILY_CAPACITY,
       -- Emissions factor (t CO2e per tonne processed), synthetic and by facility type.
       CASE MOD(SITE_INDEX, 5) WHEN 0 THEN 0.06 WHEN 1 THEN 0.05 WHEN 2 THEN 0.20
            WHEN 3 THEN 0.30 ELSE 0.005 END * (0.9 + U_AGE * 0.2) AS EMISSION_FACTOR,
       'Active' AS STATUS
FROM draws;

CREATE TABLE RAW.FACILITY_DAILY AS
WITH days AS (
  SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1 AS DAY_INDEX
  FROM TABLE(GENERATOR(ROWCOUNT => 90))
), regional_events AS (
  -- Two region-wide rainfall events in the window (synthetic).
  SELECT * FROM VALUES (27, 'Kuantan', 'Monsoon stormwater surge', 6.0),
                       (64, 'Miri', 'Extreme rainfall runoff', 9.0)
    AS o(DAY_INDEX, REGION, EVENT_CAUSE, HOURS)
), base AS (
  SELECT s.ID AS ENTITY_ID, s.SITE_INDEX, s.CATEGORY, s.REGION, s.AGE_YEARS,
         s.BASE_EXCEEDANCE_RATE, s.INSPECTION_INTERVAL_DAYS, s.INSPECTION_COMPLETION_PROB,
         s.DAILY_CAPACITY, s.EMISSION_FACTOR, d.DAY_INDEX,
         DATEADD('day', d.DAY_INDEX - 89, CURRENT_DATE()) AS EVENT_DATE,
         24.0 AS PLANNED_HOURS,
         MOD(d.DAY_INDEX + s.SITE_INDEX * 5, s.INSPECTION_INTERVAL_DAYS) AS DAYS_SINCE_INSPECTION,
         MOD(ABS(HASH(s.ID, d.DAY_INDEX, 'exc')), 1000000) / 1e6 AS U_EXC,
         MOD(ABS(HASH(s.ID, d.DAY_INDEX, 'down')), 1000000) / 1e6 + 1e-6 AS U_DOWN,
         MOD(ABS(HASH(s.ID, d.DAY_INDEX, 'cause')), 1000000) / 1e6 AS U_CAUSE,
         MOD(ABS(HASH(s.ID, d.DAY_INDEX, 'inspdone')), 1000000) / 1e6 AS U_INSPDONE,
         MOD(ABS(HASH(s.ID, d.DAY_INDEX, 'volume')), 1000000) / 1e6 AS U_VOLUME,
         MOD(ABS(HASH(s.ID, d.DAY_INDEX, 'noise')), 1000000) / 1e6 AS U_NOISE,
         MOD(ABS(HASH(s.ID, d.DAY_INDEX, 'hit')), 1000000) / 1e6 AS U_HIT,
         MOD(ABS(HASH(s.ID, d.DAY_INDEX, 'grv')), 1000000) / 1e6 AS U_GRV,
         e.EVENT_CAUSE, e.HOURS AS EVENT_HOURS
  FROM RAW.FACILITIES s CROSS JOIN days d
  LEFT JOIN regional_events e ON e.DAY_INDEX = d.DAY_INDEX AND e.REGION = s.REGION
), loaded AS (
  SELECT *,
         IFF(DAYS_SINCE_INSPECTION = 0, 1, 0) AS INSPECTION_DUE,
         IFF(DAYS_SINCE_INSPECTION = 0 AND U_INSPDONE < INSPECTION_COMPLETION_PROB, 1, 0) AS INSPECTION_DONE,
         -- Control wear rises between inspections; weak inspection discipline carries wear over.
         DAYS_SINCE_INSPECTION / INSPECTION_INTERVAL_DAYS + (1 - INSPECTION_COMPLETION_PROB) AS WEAR,
         -- Monsoon stress episode: 9 of every 28 days per facility (staggered).
         IFF(MOD(DAY_INDEX + SITE_INDEX * 11, 28) < 9, 1, 0) AS STRESS,
         -- Throughput: weekly low day and a throughput peak on day 45 (+60%) easing over 3 days.
         ROUND(DAILY_CAPACITY * (0.70 + 0.25 * U_VOLUME)
               * IFF(MOD(DAY_INDEX, 7) = 6, 0.75, 1.0)
               * CASE DAY_INDEX - 45 WHEN 0 THEN 1.6 WHEN 1 THEN 1.4 WHEN 2 THEN 1.2 ELSE 1.0 END) AS THROUGHPUT_TONNES
  FROM base
), exceedances AS (
  SELECT *, THROUGHPUT_TONNES / DAILY_CAPACITY AS LOAD_RATIO,
         LEAST(0.5, BASE_EXCEEDANCE_RATE * (0.4 + 1.6 * WEAR) * (0.3 + THROUGHPUT_TONNES / DAILY_CAPACITY)
                    * (1 + AGE_YEARS / 40) * (1 + 2.5 * STRESS)) AS P_EXC
  FROM loaded
), counted AS (
  SELECT *,
         CASE WHEN EVENT_HOURS IS NOT NULL THEN 1
              WHEN U_EXC < P_EXC / 4 THEN 2
              WHEN U_EXC < P_EXC THEN 1
              ELSE 0 END AS EXCEEDANCE_COUNT
  FROM exceedances
)
, timed AS (
  SELECT *,
         -- Effluent treatment offline hours: exponential, mean depends on facility type.
         CASE WHEN EXCEEDANCE_COUNT = 0 THEN 0.0
              WHEN EVENT_HOURS IS NOT NULL THEN EVENT_HOURS
              ELSE LEAST(20.0, ROUND(EXCEEDANCE_COUNT * (0.5 - LN(U_DOWN) *
                   CASE CATEGORY WHEN 'Offshore Platform' THEN 3.0 WHEN 'Gas Processing Plant' THEN 2.0
                                 WHEN 'Refinery' THEN 4.0 WHEN 'LNG Terminal' THEN 2.5 ELSE 3.5 END), 1))
         END AS DOWNTIME_HOURS,
         -- Share of effluent samples within the internal demo threshold.
         LEAST(0.995, GREATEST(0.50,
           CASE CATEGORY WHEN 'Offshore Platform' THEN 0.940 WHEN 'Gas Processing Plant' THEN 0.960
                         WHEN 'Refinery' THEN 0.935 WHEN 'LNG Terminal' THEN 0.955 ELSE 0.950 END
             - 0.025 * WEAR - 0.04 * GREATEST(0, LOAD_RATIO - 0.9) - 0.006 * U_NOISE
             - EXCEEDANCE_COUNT * (0.08 + 0.12 * U_HIT))) AS IN_LIMIT_RATE,
         12 + FLOOR(U_VOLUME * 13) AS WATER_SAMPLES
  FROM counted
)
SELECT ENTITY_ID || '-' || TO_CHAR(EVENT_DATE, 'YYYYMMDD') AS EVENT_ID,
       ENTITY_ID, EVENT_DATE, PLANNED_HOURS, DOWNTIME_HOURS,
       PLANNED_HOURS - DOWNTIME_HOURS AS OPERATING_HOURS,
       EXCEEDANCE_COUNT,
       CASE WHEN EXCEEDANCE_COUNT = 0 THEN 'None'
            WHEN EVENT_CAUSE IS NOT NULL THEN EVENT_CAUSE
            WHEN CATEGORY = 'Offshore Platform' THEN IFF(U_CAUSE < 0.5, 'Produced water separator upset', IFF(U_CAUSE < 0.8, 'Deck drainage overflow', 'Flare flameout'))
            WHEN CATEGORY = 'Gas Processing Plant' THEN IFF(U_CAUSE < 0.55, 'Acid gas flaring', 'Amine unit upset')
            WHEN CATEGORY = 'Refinery' THEN IFF(U_CAUSE < 0.6, 'Wastewater oil carryover', 'Stack opacity excursion')
            WHEN CATEGORY = 'LNG Terminal' THEN IFF(U_CAUSE < 0.6, 'Boil-off gas flaring', 'Cooling water temperature')
            ELSE IFF(U_CAUSE < 0.6, 'Tank farm runoff', 'Loading arm spill') END AS ROOT_CAUSE,
       INSPECTION_DUE, INSPECTION_DONE,
       WATER_SAMPLES,
       FLOOR(WATER_SAMPLES * IN_LIMIT_RATE) AS SAMPLES_IN_LIMIT,
       THROUGHPUT_TONNES,
       ROUND(THROUGHPUT_TONNES * EMISSION_FACTOR * (1 + 0.05 * U_NOISE + 0.03 * WEAR), 1) AS CO2E_TONNES,
       IFF(U_GRV < 0.02 + 0.04 * EXCEEDANCE_COUNT + 0.01 * STRESS, 1, 0) AS GRIEVANCES,
       -- Oil-in-water in treated effluent (mg/L) and flare load (% of design).
       ROUND(12 + 18 * WEAR + 25 * GREATEST(0, LOAD_RATIO - 0.8) + 10 * STRESS + 30 * EXCEEDANCE_COUNT + U_NOISE * 5, 1) AS OIL_IN_WATER_MGL,
       ROUND(LEAST(100, 100 * LOAD_RATIO * (0.75 + 0.1 * U_NOISE) + 7 * STRESS + 4 * EXCEEDANCE_COUNT), 1) AS FLARE_LOAD_PCT,
       CURRENT_TIMESTAMP() AS LOADED_AT
FROM timed;

-- Methane leak survey progress per facility (snapshot):
-- leaks found in the latest survey versus leaks closed.
CREATE TABLE RAW.LEAK_SURVEY AS
SELECT ID AS ENTITY_ID,
       CASE CATEGORY WHEN 'Offshore Platform' THEN 'Wellhead and topsides' WHEN 'Gas Processing Plant' THEN 'Compressor and amine area'
                     WHEN 'Refinery' THEN 'Process units' WHEN 'LNG Terminal' THEN 'Liquefaction trains'
                     ELSE 'Tank farm' END AS SURVEY_SCOPE,
       20 + MOD(ABS(HASH(ID, 'req')), 61) AS LEAKS_DETECTED,
       FLOOR((20 + MOD(ABS(HASH(ID, 'req')), 61)) * (0.55 + MOD(ABS(HASH(ID, 'avail')), 1000) / 1000 * 0.40)) AS LEAKS_CLOSED,
       MOD(ABS(HASH(ID, 'order')), 8) AS LEAKS_SCHEDULED,
       CURRENT_DATE() AS SNAPSHOT_DATE
FROM RAW.FACILITIES;
