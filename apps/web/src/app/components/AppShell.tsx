import type { ReactNode } from "react";

const navItems = [
  { href: "/", label: "Dashboard" },
  { href: "/purchase-invoices", label: "Purchase Invoices" },
  { href: "/vendors", label: "Vendors" },
  { href: "/automations", label: "Automations" },
  { href: "/reports", label: "Reports" },
  { href: "/admin", label: "Admin" },
];

export function AppShell({
  active = "Dashboard",
  children,
  title,
}: {
  active?: string;
  children: ReactNode;
  title: string;
}) {
  return (
    <div className="app-shell">
      <aside className="sidebar">
        <div className="brand">
          <span>ClickMe</span>
          <small>Admin Portal</small>
        </div>
        <nav className="nav">
          {navItems.map((item) => (
            <a aria-current={active === item.label ? "page" : undefined} href={item.href} key={item.label}>
              {item.label}
            </a>
          ))}
        </nav>
        <div className="workspace-card">
          <strong>Operations & Finance</strong>
          <span>finance.database.windows.net</span>
        </div>
      </aside>
      <main className="main">
        <header className="topbar">
          <strong>{title}</strong>
          <span>Azure SQL finance</span>
        </header>
        <div className="content">{children}</div>
      </main>
    </div>
  );
}
