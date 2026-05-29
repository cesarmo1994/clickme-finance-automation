import { AppShell } from "./components/AppShell";
import { fetchApi, formatAmount, type InvoiceRow } from "./lib/api";

function statusLabel(invoice: InvoiceRow) {
  if (invoice.needs_review) return "Needs review";
  if (invoice.processing_status) return invoice.processing_status;
  return "Clear";
}

function statusTone(invoice: InvoiceRow) {
  if (invoice.needs_review) return "warning";
  if (invoice.is_overdue) return "danger";
  return "success";
}

export default async function DashboardPage() {
  const invoices = await fetchApi<InvoiceRow[]>("/api/dashboard/invoices", []);
  const totalAmount = invoices.reduce((sum, row) => sum + Number(row.recognized_amount ?? 0), 0);
  const openAmount = invoices.reduce((sum, row) => sum + Number(row.open_amount ?? 0), 0);
  const needsReview = invoices.filter((row) => row.needs_review).length;
  const overdue = invoices.filter((row) => row.is_overdue).length;
  const clearCount = Math.max(invoices.length - needsReview - overdue, 0);

  return (
    <AppShell active="Dashboard" title="Finance Dashboard">
      <div className="page-heading">
        <div>
          <p className="eyebrow">Executive overview</p>
          <h1>Purchase operations</h1>
          <p>KPIs, invoice exceptions and automation health from the finance database.</p>
        </div>
        <div className="toolbar">
          <span>Month to date</span>
          <a href="/purchase-invoices">Review queue</a>
        </div>
      </div>

      <div className="metric-grid">
        <div className="metric">
          <div className="metric-label">Purchase invoices</div>
          <div className="metric-value">{invoices.length}</div>
          <div className="metric-note">Loaded from invoice_fact</div>
        </div>
        <div className="metric">
          <div className="metric-label">Recognized amount</div>
          <div className="metric-value">{formatAmount(totalAmount)}</div>
          <div className="metric-note">Total parsed amount</div>
        </div>
        <div className="metric">
          <div className="metric-label">Open amount</div>
          <div className="metric-value">{formatAmount(openAmount)}</div>
          <div className="metric-note">Pending payment signal</div>
        </div>
        <div className="metric">
          <div className="metric-label">Needs review</div>
          <div className="metric-value">{needsReview}</div>
          <div className="metric-note">Parser or business review</div>
        </div>
      </div>

      <div className="dashboard-grid">
        <section className="section">
          <div className="section-header">
            <div>
              <h2>Recent purchase invoices</h2>
              <p>Latest records available through the dashboard API.</p>
            </div>
            <a href="/purchase-invoices">Open list</a>
          </div>
          <div className="table-wrap">
            <table>
              <thead>
                <tr>
                  <th>Invoice</th>
                  <th>Vendor key</th>
                  <th>Currency</th>
                  <th>Amount</th>
                  <th>Open</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                {invoices.slice(0, 12).map((invoice) => (
                  <tr key={invoice.invoice_key}>
                    <td>{invoice.invoice_number ?? invoice.invoice_key}</td>
                    <td>{invoice.vendor_key}</td>
                    <td>{invoice.currency_code ?? "N/A"}</td>
                    <td>{formatAmount(invoice.recognized_amount)}</td>
                    <td>{formatAmount(invoice.open_amount)}</td>
                    <td>
                      <span className={`status-pill ${statusTone(invoice)}`}>{statusLabel(invoice)}</span>
                    </td>
                  </tr>
                ))}
                {invoices.length === 0 ? (
                  <tr>
                    <td colSpan={6}>No invoice records returned by the API yet.</td>
                  </tr>
                ) : null}
              </tbody>
            </table>
          </div>
        </section>

        <aside className="insight-panel">
          <section>
            <h2>Processing health</h2>
            <div className="health-list">
              <div>
                <span className="health-dot success" />
                <strong>{clearCount}</strong>
                <small>Clear invoices</small>
              </div>
              <div>
                <span className="health-dot warning" />
                <strong>{needsReview}</strong>
                <small>Need review</small>
              </div>
              <div>
                <span className="health-dot danger" />
                <strong>{overdue}</strong>
                <small>Overdue</small>
              </div>
            </div>
          </section>

          <section>
            <h2>Quick links</h2>
            <div className="quick-links">
              <a href="/vendors">Vendor directory</a>
              <a href="/automations">Automation monitor</a>
              <a href="/reports">BI views</a>
              <a href="/admin">Access matrix</a>
            </div>
          </section>

          <section>
            <h2>Data sources</h2>
            <ul className="source-list">
              <li>dbo.invoice_fact</li>
              <li>dbo.vendor_dim</li>
              <li>dbo.date_dim</li>
            </ul>
          </section>
        </aside>
      </div>

      <section className="section">
        <div className="section-header">
          <div>
            <h2>Operational alerts</h2>
            <p>Initial signals for finance follow-up.</p>
          </div>
        </div>
        <div className="table-wrap">
          <table>
            <thead>
              <tr>
                <th>Signal</th>
                <th>Count</th>
                <th>Owner</th>
                <th>Next action</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Invoices requiring review</td>
                <td>{needsReview}</td>
                <td>Finance</td>
                <td>Open purchase invoice queue</td>
              </tr>
              <tr>
                <td>Overdue invoices</td>
                <td>{overdue}</td>
                <td>Finance</td>
                <td>Validate payment status</td>
              </tr>
              <tr>
                <td>Dashboard API fallback</td>
                <td>{invoices.length === 0 ? 1 : 0}</td>
                <td>Engineering</td>
                <td>Start API and verify Azure SQL connection</td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>
    </AppShell>
  );
}
