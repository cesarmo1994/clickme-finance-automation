import { AppShell } from "./components/AppShell";
import { fetchApi, formatAmount, type InvoiceRow } from "./lib/api";

export default async function DashboardPage() {
  const invoices = await fetchApi<InvoiceRow[]>("/api/dashboard/invoices", []);
  const totalAmount = invoices.reduce((sum, row) => sum + Number(row.recognized_amount ?? 0), 0);
  const openAmount = invoices.reduce((sum, row) => sum + Number(row.open_amount ?? 0), 0);
  const needsReview = invoices.filter((row) => row.needs_review).length;

  return (
    <AppShell title="Finance Dashboard">
      <div className="metric-grid">
        <div className="metric">
          <div className="metric-label">Purchase invoices</div>
          <div className="metric-value">{invoices.length}</div>
        </div>
        <div className="metric">
          <div className="metric-label">Recognized amount</div>
          <div className="metric-value">{formatAmount(totalAmount)}</div>
        </div>
        <div className="metric">
          <div className="metric-label">Open amount</div>
          <div className="metric-value">{formatAmount(openAmount)}</div>
        </div>
        <div className="metric">
          <div className="metric-label">Needs review</div>
          <div className="metric-value">{needsReview}</div>
        </div>
      </div>

      <section className="section">
        <h1>Purchase Invoices</h1>
        <div className="table-wrap">
          <table>
            <thead>
              <tr>
                <th>Invoice</th>
                <th>Vendor key</th>
                <th>Currency</th>
                <th>Amount</th>
                <th>Open</th>
                <th>Review</th>
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
                  <td>{invoice.needs_review ? "Required" : "Clear"}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
    </AppShell>
  );
}
