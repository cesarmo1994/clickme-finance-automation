import { AppShell } from "../components/AppShell";

export default function ReportsPage() {
  return (
    <AppShell title="Reports">
      <section className="section">
        <div className="metric-grid">
          <div className="metric">
            <div className="metric-label">Purchase invoice export</div>
            <div className="metric-value">Planned</div>
          </div>
          <div className="metric">
            <div className="metric-label">Vendor spend export</div>
            <div className="metric-value">Planned</div>
          </div>
          <div className="metric">
            <div className="metric-label">Open AP export</div>
            <div className="metric-value">Planned</div>
          </div>
        </div>
      </section>
    </AppShell>
  );
}
