# Malaysia Oil and Gas ESG Monitoring

**Malaysia - Oil and Gas Facilities and Terminals**
Use case: Facility environmental performance and exceedance risk

> ESG monitoring for a fictional oil and gas operator with 30 synthetic facilities across 4 Malaysian regions: dynamic tables, a holdout-evaluated exceedance-risk classifier, a CO2e emissions forecast and grounded AI answers. Thresholds are internal demo thresholds, not regulatory limits.

## Why Snowflake

- **Dynamic tables** reconcile effluent within threshold, exceedances, emissions intensity and treatment uptime from RAW facility data, with checks in `run_core.py`
- **Exceedance-risk classification** gives a holdout-evaluated next-7-day exceedance probability per facility
- **Emissions forecast** projects 14 days of operator-wide t CO2e with prediction intervals
- **Grounded AI**: the Cortex Agent (Analyst over a semantic view, plus Search over SOPs) shows its SQL and SOP citations
- **Live telemetry**: a native simulator (Snowflake only) or IoT Core, S3 and Snowpipe (AWS build), then an alert and email

## What is built

| | |
|---|---|
| Dimension table | `RAW.FACILITIES` (30 rows) |
| Fact table | `RAW.FACILITY_DAILY` (2,700 facility-days, 90 days) |
| Curated layer | `CURATED.KPI_SUMMARY`, `PERFORMANCE_SUMMARY`, `EXCEEDANCE_CAUSES`, `TREND_ANALYSIS` |
| ML | `ML.EXCEEDANCE_RISK_SCORES`, `ML.EXCEEDANCE_RISK_HOLDOUT_METRICS`, `ML.EMISSIONS_FORECAST`, `ML.OIW_ANOMALIES` |

Regions (city labels only): Bintulu, Kuantan, Miri, Kota Kinabalu.
Facility types: Offshore Platform, Gas Processing Plant, Refinery, LNG Terminal, Oil Terminal.

## KPI cards (live from `CURATED.KPI_SUMMARY`; no fallback values)

| Card | Value from the seeded data |
|---|---|
| Effluent Within Threshold | 88.2% |
| Environmental Exceedances | 353 |
| Emissions Intensity | 166.7 kg CO2e/t |
| Total Emissions (t CO2e) | 3,490,739 |
| Effluent Treatment Uptime | 98.0% |
| Facilities Monitored | 30 |
| Methane Leaks Closed | 74.7% |
| Community Grievances | 87 |

Values are synthetic. A rebuild reproduces them because the data is HASH-seeded; dates are relative to the build day.

## Demo flow

1. Executive Cockpit: KPIs, daily effluent within threshold, samples over threshold by exceedance cause, facility table
2. Predictive: holdout metrics, risk bands, 14-day emissions forecast, oil-in-water anomalies
3. Facility Health: effluent treatment uptime, methane leaks closed, inspection completion against effluent within threshold, then generate the action memo
4. Live IoT: run `CALL APP.SIMULATE_TELEMETRY(20)` (Snowflake only) or `python aws/publish_telemetry.py --count 20` (AWS build). Then run `EXECUTE ALERT APP.LIVE_ALARM_ALERT` and show the alert log and email.
5. Ask AI: the Cortex Agent answers metric questions through the semantic view and cites SOPs from Cortex Search. The SQL is shown.
6. QuickSight (AWS build): the same Snowflake tables through DIRECT_QUERY
7. Architecture: both builds side by side

## Talking points

- Per-facility effluent within threshold ranges from 83.9% to 91.2%. Kota Kinabalu is the lowest region, at 87.2%.
- Boil-off gas flaring puts the most samples over the threshold of the 13 exceedance causes.
- LNG terminals carry the highest emissions intensity (313.7 kg CO2e/t in the synthetic factors); oil terminals are around 5 kg CO2e/t.
- The risk model is evaluated on a time-based holdout: precision 0.60 and recall 0.705 at 0.5, against a 0.44 base rate. Present it as triage, not a guarantee.
- The Kuantan monsoon stormwater surge and Miri rainfall runoff events are excluded from exceedance labels, because they are regional events, not facility-driven.
- No figure is a compliance finding against any regulation; all thresholds are internal to the demo.

## Business impact

Use only the sourced references in `README.md` (Business Impact).
