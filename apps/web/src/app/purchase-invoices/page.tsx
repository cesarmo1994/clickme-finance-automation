import { AppShell } from "../components/AppShell";
import { fetchApi, formatAmount, type InvoiceRow } from "../lib/api";

export default async function PurchaseInvoicesPage() {
  const invoices = await fetchApi<InvoiceRow[]>("/api/purchase-invoices", []);

  return (
    <AppShell active="Purchase Invoices" title="Purchase Invoices">
      <section className="section">
        <div className="table-wrap">
          <table>
            <thead>
              <tr>
                <th>Invoice</th>
                <th>Vendor key</th>
                <th>Status</th>
                <th>Currency</th>
                <th>Total</th>
                <th>Open</th>
                <th>Overdue</th>
                <th>Review</th>
              </tr>
            </thead>
            <tbody>
              {invoices.map((invoice) => (
                <tr key={invoice.invoice_key}>
                  <td>{invoice.invoice_number ?? invoice.invoice_key}</td>
                  <td>{invoice.vendor_key}</td>
                  <td>{invoice.processing_status ?? "N/A"}</td>
                  <td>{invoice.currency_code ?? "N/A"}</td>
                  <td>{formatAmount(invoice.total_amount ?? invoice.recognized_amount)}</td>
                  <td>{formatAmount(invoice.open_amount)}</td>
                  <td>{invoice.is_overdue ? "Yes" : "No"}</td>
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
