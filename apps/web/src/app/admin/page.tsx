import { AppShell } from "../components/AppShell";

export default function AdminPage() {
  return (
    <AppShell active="Admin" title="Admin">
      <section className="section">
        <div className="table-wrap">
          <table>
            <thead>
              <tr>
                <th>Area</th>
                <th>Status</th>
                <th>Dependency</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Users and roles</td>
                <td>Planned</td>
                <td>Microsoft Entra ID groups</td>
              </tr>
              <tr>
                <td>Audit events</td>
                <td>Planned</td>
                <td>API write workflows</td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>
    </AppShell>
  );
}
