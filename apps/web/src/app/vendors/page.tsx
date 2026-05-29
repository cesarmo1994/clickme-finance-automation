import { AppShell } from "../components/AppShell";
import { fetchApi, type VendorRow } from "../lib/api";

export default async function VendorsPage() {
  const vendors = await fetchApi<VendorRow[]>("/api/vendors", []);

  return (
    <AppShell active="Vendors" title="Vendors">
      <section className="section">
        <div className="table-wrap">
          <table>
            <thead>
              <tr>
                <th>Vendor</th>
                <th>Status</th>
                <th>Country</th>
                <th>Currency</th>
                <th>Risk</th>
                <th>Email</th>
                <th>Tax ID</th>
              </tr>
            </thead>
            <tbody>
              {vendors.map((vendor) => (
                <tr key={vendor.vendor_key}>
                  <td>{vendor.vendor_name}</td>
                  <td>{vendor.procurement_status ?? "N/A"}</td>
                  <td>{vendor.country_code ?? "N/A"}</td>
                  <td>{vendor.default_currency_code ?? "N/A"}</td>
                  <td>{vendor.risk_level ?? "N/A"}</td>
                  <td>{vendor.primary_email ?? "N/A"}</td>
                  <td>{vendor.tax_id ?? "N/A"}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
    </AppShell>
  );
}
