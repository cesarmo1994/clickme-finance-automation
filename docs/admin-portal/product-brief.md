# Product Brief

## Objective

Build the ClickMe Admin Portal as a single internal web application for managing the company's administrative operations. The portal should reduce fragmented work across folders, spreadsheets, email, Jira, and manual database checks.

## Primary Users

- Finance and accounting operators
- Administrative leadership
- Operations users
- Future controlled access for external accounting or compliance support

## MVP Outcomes

- Users can see invoice and expense health from Azure SQL-backed dashboards.
- Users can review processed invoices, validate extracted fields, and detect duplicates.
- Users can manage vendors and connect purchase or invoice activity to vendor records.
- Users can monitor automation runs and parsing errors.
- Users can access operational views without manually opening SQL tools.

## Out of Scope for First Release

- Customer-facing features
- Full ERP replacement
- Payroll execution
- Banking integrations
- Automated payment approvals

## Success Criteria

- Core tables are defined in Azure SQL.
- Dashboard views are available and documented.
- Invoice processing data can be queried from the portal.
- Role-based access is defined before sensitive modules are exposed.
- The portal has a clear path from MVP to future administrative modules.
