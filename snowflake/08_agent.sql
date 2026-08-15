-- ============================================================================
-- 08_AGENT.SQL — Cortex Agent for ESG & Carbon Emissions Monitoring
-- ============================================================================
USE DATABASE OIL_GAS_ESG;
USE SCHEMA APP;

CREATE OR REPLACE CORTEX AGENT APP.ESG_INTELLIGENCE_AGENT
  COMMENT = 'ESG & Carbon Emissions Monitoring AI Assistant'
  MODEL = 'claude-opus-4-8'
  TOOLS = (
    SEMANTIC_VIEW_TOOL(SEMANTIC_VIEW => 'OIL_GAS_ESG.APP.ESG_ANALYTICS'),    CORTEX_SEARCH_TOOL(CORTEX_SEARCH_SERVICE => 'OIL_GAS_ESG.SEARCH.ESG_REPORTS_SEARCH', TOOL_DESCRIPTION => 'Search documents for Oil & Gas — ESG & Sustainability information')
  )
  SYSTEM_PROMPT = 'You are the ESG Intelligence Agent for a Malaysian O&G company tracking Scope 1/2/3 emissions across 30 facilities, reporting to BURSA Malaysia sustainability framework.';
