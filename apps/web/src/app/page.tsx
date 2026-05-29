type InvoiceRow = {
  invoice_key: number;
  invoice_number: string | null;
  vendor_key: number;
  currency_code: string | null;
  recognized_amount: number | null;
  open_amount: number | null;
  needs_review: boolean;
};

async function getInvoices(): Promise<InvoiceRow[]> {
  const baseUrl = process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://localhost:8000";

  try {
    const response = await fetch(`${baseUrl}/api/dashboard/invoices`, {
      cache: "no-store",
    });

    if (!response.ok) {
      return [];
    }

    return response.json();
  } catch {
    return [];
  }
}

function formatAmount(value: number | null) {
  return new Intl.NumberFormat("en-US", {
    maximumFractionDigits: 2,
    minimumFractionDigits: 2,
  }).format(value ?? 0);
}

export default async function DashboardPage() {
  const invoices = await getInvoices();
  const totalAmount = invoices.reduce((sum, row) => sum + Number(row.recognized_amount ?? 0), 0);
  const openAmount = invoices.reduce((sum, row) => sum + Number(row.open_amount ?? 0), 0);
  const needsReview = invoices.filter((row) => row.needs_review).length;

  return (
    <div className="app-shell">
      <aside className="sidebar">
        <div className="brand">ClickMe Admin</div>
        <nav className="nav">
          <a href="#">Dashboard</a>
          <a href="#">Purchase Invoices</a>
          <a href="#">Vendors</a>
          <a href="#">Automations</a>
          <a href="#">Reports</a>
          <a href="#">Admin</a>
        </nav>
      </aside>
      <main className="main">
        <header className="topbar">
          <strong>Finance Dashboard</strong>
          <span>Azure SQL finance</span>
        </header>
        <div className="content">
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
        </div>
      </main>
    </div>
  );
}
