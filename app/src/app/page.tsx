'use client';

import { useEffect, useState } from 'react';
import { AppLayout } from '@/components/AppLayout';
import { KPICard } from '@/components/KPICard';
import { Chart } from '@/components/Chart';
import { DataTable } from '@/components/DataTable';
import { AskAI } from '@/components/AskAI';
import { ActionMemo } from '@/components/ActionMemo';
import { GeoMap } from '@/components/GeoMap';

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

  const title = narrative?.title || 'SEA AWS Demo';

  const executiveCockpit = (
    <div className="space-y-6">
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <KPICard title="Carbon Intensity" value="18.2 kgCO2e/boe" status="neutral" />
        <KPICard title="Methane Leaks" value="3" status="warning" />
        <KPICard title="Flaring Reduction" value="-24%" status="neutral" />
        <KPICard title="Platforms" value="42" status="neutral" />
      </div>
      <div className="grid grid-cols-1 gap-4 lg:grid-cols-3">
        <div className="lg:col-span-1">
          <GeoMap country="malaysia" markers={[{"label": "Penang", "value": "Fab: util 92%", "color": "green", "size": "lg"}, {"label": "Kuala Lumpur", "value": "HQ", "color": "blue", "size": "md"}, {"label": "Johor Bahru", "value": "Southern ops", "color": "green", "size": "md"}]} routes={[]} title="Geographic Overview" height={280} />
        </div>
        <div className="lg:col-span-2 grid grid-cols-1 gap-4">
          <Chart data={data?.timeseries || [{ period: 'Loading', value: 0 }]} type="line" xKey="period" yKeys={[{ key: 'value', name: 'tCO2e (K)' }]} title="Carbon Emissions Trend (Monthly)" />
          <Chart data={data?.categories || [{ category: 'Loading', count: 0 }]} type="bar" xKey="category" yKeys={[{ key: 'count', name: 'Score' }]} title="ESG Score by Asset" />
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
        <KPICard title="Scope 1+2" value="1.4M tCO2e" />
        <KPICard title="CCS Capacity" value="2.4 MT/yr" />
        <KPICard title="Net Zero Gap" value="-42%" />
      </div>
      <Chart data={data?.detail || [{ x: 'Loading', y: 0 }]} type="area" xKey="x" yKeys={[{ key: 'y', name: 'MtCO2e' }]} title="Pathway to Net Zero 2050" height={400} />
    </div>
  );

  const domainTab2 = (
    <div className="space-y-6">
      <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
        <Chart data={data?.breakdown || [{ label: 'A', value: 30 }, { label: 'B', value: 70 }]} type="pie" xKey="label" yKeys={[{ key: 'value', name: 'Score' }]} title="Regulatory Score by Region" />
        <ActionMemo persona={{ name: 'Dato Razali Ismail', role: 'VP Sustainability' }} context={{}} onGenerate={async () => ({ subject: 'Action Required', body: 'AI-generated recommendation based on current data.', urgency: 'HIGH', actions: ['Investigate methane leak at Platform Dulang-B', 'Submit MyCarbon report to BURSA', 'Accelerate Kasawari CCS project'] })} />
      </div>
    </div>
  );

  const askAiTab = (
    <div className="h-[600px]">
      <AskAI title="Ask AI" mode="both" sampleQuestions={['Which platforms have highest carbon intensity?', 'Show progress against 2030 targets', 'What is the CCS offset projection for 2025?']} onSubmit={async (question, mode) => ({ answer: `[Demo Mode] Response to: "${question}" (${mode} mode). Connect to Snowflake for live data.`, sql: mode === 'sql' ? 'SELECT * FROM CURATED.SUMMARY LIMIT 10;' : undefined })} />
    </div>
  );

  const architectureTab = (
    <div className="space-y-6">
      <div className="rounded-lg border border-slate-200 bg-white p-6">
        <h2 className="mb-4 text-lg font-bold text-slate-900">Architecture</h2>
        <p className="mb-4 text-sm text-slate-600">This demo runs on Snowflake with optional AWS integration.</p>
        <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
          <div className="rounded border border-blue-200 bg-blue-50 p-4">
            <h3 className="text-sm font-bold text-blue-800">Snowflake Features</h3>
            <ul className="mt-2 space-y-1 text-sm text-blue-700">
              <li>Dynamic Tables (5-min refresh)</li>
              <li>ML Functions (Forecast + Anomaly)</li>
              <li>Cortex Search + Agent</li>
              <li>Semantic View + Intelligence</li>
            </ul>
          </div>
          <div className="rounded border border-orange-200 bg-orange-50 p-4">
            <h3 className="text-sm font-bold text-orange-800">AWS Services</h3>
            <ul className="mt-2 space-y-1 text-sm text-orange-700">
              <li>Amazon S3 (Strategy Docs)</li>
              <li>Amazon S3 + Kinesis</li>
              <li>Amazon SNS</li>
              <li>Amazon QuickSight + Q</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );

  const tabs = [
    { id: 'executive-cockpit', label: 'Executive Cockpit', icon: '📊', content: executiveCockpit },
    { id: 'domain-1', label: 'Emissions Tracking', icon: '📈', content: domainTab1 },
    { id: 'domain-2', label: 'Compliance', icon: '⚡', content: domainTab2 },
    { id: 'ask-ai', label: 'Ask AI', icon: '🤖', content: askAiTab },
    { id: 'architecture', label: 'Architecture', icon: '🏗️', content: architectureTab },
  ];

  return <AppLayout title={title} subtitle="Powered by Snowflake + AWS" tabs={tabs} narrative={narrative} />;
}
