import type { ReactNode } from "react";

const navItems = [
  { href: "/", label: "Dashboard" },
  { href: "/purchase-invoices", label: "Purchase Invoices" },
  { href: "/vendors", label: "Vendors" },
  { href: "/automations", label: "Automations" },
  { href: "/reports", label: "Reports" },
  { href: "/admin", label: "Admin" },
];

export function AppShell({ children, title }: { children: ReactNode; title: string }) {
  return (
    <div className="app-shell">
      <aside className="sidebar">
        <div className="brand">ClickMe Admin</div>
        <nav className="nav">
          {navItems.map((item) => (
            <a href={item.href} key={item.label}>
              {item.label}
            </a>
          ))}
        </nav>
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
