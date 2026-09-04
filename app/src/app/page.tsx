'use client';

import { useEffect, useState } from 'react';
import { AppLayout } from '@/components/AppLayout';
import { KPICard } from '@/components/KPICard';
import { Chart } from '@/components/Chart';
import { DataTable } from '@/components/DataTable';
import { AskAI } from '@/components/AskAI';
import { ActionMemo } from '@/components/ActionMemo';
import { GeoMap } from '@/components/GeoMap';
import { ArchitectureDiagram } from '@/components/ArchitectureDiagram';

interface DemoNarrative {
  title: string;
  duration: string;
  thesis: string;
  tabs: any[];
}

export default function HomePage() {
  const [narrative, setNarrative] = useState<DemoNarrative | null>(null);
  const [data, setData] = useState<any>(null);

  useEffect(() => {
    fetch('/demo_narrative.json')
      .then((r) => r.json())
      .then(setNarrative)
      .catch(() => {});
    fetch('/api/data')
      .then((r) => r.json())
      .then(setData)
      .catch(() => {});
  }, []);


  // Look up a KPI value returned by /api/data (sourced from CURATED.KPI_SUMMARY).
  // Falls back to the original literal so the card still renders if the API,
  // or KPI_SUMMARY, is unavailable.
  const kpiVal = (title: string, fallback: string): string =>
    (data?.kpiCards as { title: string; value: string }[] | undefined)
      ?.find((k) => k.title === title)?.value ?? fallback;

  const title = narrative?.title || 'SEA AWS Demo';

  const executiveCockpit = (
    <div className="space-y-6">
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <KPICard title="Carbon Intensity" value={kpiVal('Carbon Intensity', '18.2 kgCO2e/boe')} status="neutral" />
        <KPICard title="Methane Leaks" value={kpiVal('Methane Leaks', '3')} status="warning" />
        <KPICard title="Flaring Reduction" value={kpiVal('Flaring Reduction', '-24%')} status="neutral" />
        <KPICard title="Platforms" value={kpiVal('Platforms', '42')} status="neutral" />
      </div>
      <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
        <div className="lg:col-span-1">
          <GeoMap country="malaysia"
            regions={data?.regions} markers={[{"label": "Penang", "value": "Fab: util 92%", "color": "green", "size": "lg"}, {"label": "Kuala Lumpur", "value": "HQ", "color": "blue", "size": "md"}, {"label": "Johor Bahru", "value": "Southern ops", "color": "green", "size": "md"}]} routes={[]} title="Geographic Overview" height={400} />
        </div>
        <div className="lg:col-span-1 grid grid-cols-1 gap-4">
          <Chart data={data?.timeseries || [{ period: 'Jan', value: 112 }, { period: 'Feb', value: 118 }, { period: 'Mar', value: 135 }, { period: 'Apr', value: 148 }, { period: 'May', value: 156 }, { period: 'Jun', value: 142 }, { period: 'Jul', value: 138 }, { period: 'Aug', value: 151 }, { period: 'Sep', value: 144 }, { period: 'Oct', value: 132 }, { period: 'Nov', value: 121 }, { period: 'Dec', value: 115 }]} type="line" xKey="period" yKeys={[{ key: 'value', name: 'tCO2e (K)' }]} title="Carbon Emissions Trend (Monthly)" />
          <Chart data={data?.categories || [{ category: 'North', count: 82 }, { category: 'Central', count: 74 }, { category: 'South', count: 91 }, { category: 'Highland', count: 68 }, { category: 'Coastal', count: 77 }]} type="bar" xKey="category" yKeys={[{ key: 'count', name: 'Score' }]} title="ESG Score by Asset" />
        </div>
      </div>
      <DataTable columns={[
          { key: 'id', header: '#' },
          { key: 'name', header: 'Asset' },
          { key: 'status', header: 'Rating' },
          { key: 'value', header: 'Carbon Intensity' },
      ]} data={data?.entities || []} title="Asset ESG Dashboard" />
    </div>
  );

  const domainTab1 = (
    <div className="space-y-6">
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-3">
        <KPICard title="Scope 1+2" value={kpiVal('Scope 1+2', '1.4M tCO2e')} />
        <KPICard title="CCS Capacity" value={kpiVal('CCS Capacity', '2.4 MT/yr')} />
        <KPICard title="Net Zero Gap" value={kpiVal('Net Zero Gap', '-42%')} />
      </div>
      <Chart data={data?.detail || [{ x: 'Mon', y: 24 }, { x: 'Tue', y: 28 }, { x: 'Wed', y: 22 }, { x: 'Thu', y: 31 }, { x: 'Fri', y: 26 }, { x: 'Sat', y: 19 }, { x: 'Sun', y: 23 }]} type="area" xKey="x" yKeys={[{ key: 'y', name: 'MtCO2e' }]} title="Pathway to Net Zero 2050" height={400} />
    </div>
  );

  const domainTab2 = (
    <div className="space-y-6">
      <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
        <Chart data={data?.regionAlerts || [{ label: 'Zone North', value: 35 }, { label: 'Zone Central', value: 28 }, { label: 'Zone South', value: 22 }, { label: 'Zone East', value: 15 }]} type="pie" xKey="label" yKeys={[{ key: 'value', name: 'Score' }]} title="Regulatory Score by Region" />
        <ActionMemo persona={{ name: 'Dato Razali Ismail', role: 'VP Sustainability' }} context={{}} onGenerate={async () => ({ subject: 'Action Required', body: 'AI-generated recommendation based on current data.', urgency: 'HIGH', actions: ['Investigate methane leak at Platform Dulang-B', 'Submit MyCarbon report to BURSA', 'Accelerate Kasawari CCS project'] })} />
      </div>
    </div>
  );

  const askAiTab = (
    <div className="h-[600px]">
      <AskAI title="Ask AI" mode="sql" sampleQuestions={['Which platforms have highest carbon intensity?', 'Show progress against 2030 targets', 'What is the CCS offset projection for 2025?']} onSubmit={async (question, mode) => ({ answer: `[Demo Mode] Response to: "${question}" (${mode} mode). Connect to Snowflake for live data.`, sql: mode === 'sql' ? 'SELECT * FROM CURATED.SUMMARY LIMIT 10;' : undefined })} />
    </div>
  );

  const architectureTab = (
    <ArchitectureDiagram
      snowflakeFeatures={['Dynamic Tables (5-min refresh)', 'ML Functions (Forecast + Anomaly)', 'Cortex Search + Agent', 'Semantic View + Intelligence']}
      awsServices={[{ name: 'Amazon S3', role: 'Strategy Docs' }, { name: 'Amazon S3 + Kinesis', role: 'Integration' }, { name: 'Amazon SNS', role: 'Integration' }, { name: 'Amazon QuickSight + Q', role: 'Integration' }]}
    />
  );

  const tabs = [
    { id: 'executive-cockpit', label: 'Executive Cockpit', icon: '📊', content: executiveCockpit },
    { id: 'domain-1', label: 'Emissions Tracking', icon: '📈', content: domainTab1 },
    { id: 'domain-2', label: 'Compliance', icon: '⚡', content: domainTab2 },
    { id: 'ask-ai', label: 'Ask AI', icon: '🤖', content: askAiTab },
    { id: 'architecture', label: 'Architecture', icon: '🏗️', content: architectureTab },
  ];

  return <AppLayout title={title} tabs={tabs} narrative={narrative} />;
}
