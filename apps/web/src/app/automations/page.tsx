import { AppShell } from "../components/AppShell";

export default function AutomationsPage() {
  return (
    <AppShell title="Automations">
      <section className="section">
        <div className="table-wrap">
          <table>
            <thead>
              <tr>
                <th>Automation</th>
                <th>Status</th>
                <th>Last run</th>
                <th>Processed</th>
                <th>Errors</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Invoice parser</td>
                <td>Pending API connection</td>
                <td>N/A</td>
                <td>N/A</td>
                <td>N/A</td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>
    </AppShell>
  );
}
