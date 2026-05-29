# ClickMe Finance Automation

Automation and planning repository for ClickMe finance operations, invoice processing, Azure SQL reporting, and the future ClickMe Admin Portal.

## Current Scope

This repository documents and will host the technical work for:

- Invoice PDF processing automation
- JSON extraction and validation
- Azure SQL persistence in the `finance` database
- Duplicate prevention for processed invoices
- Dashboard-ready SQL views
- ClickMe Admin Portal planning and implementation

## Related Work

- Jira epic: OFH-14 - ClickMe Admin Portal
- First definition story: OFH-23 - Admin Portal: definir stack tecnico, arquitectura y ambientes
- Core data story: OFH-24 - Admin Portal: definir modelo de datos core y tablas Azure SQL
- Figma dashboard mockup: https://www.figma.com/design/LQELCwZ54V33zRnEGA5Eue

## Repository Structure

```text
docs/
  admin-portal/
    product-brief.md
    architecture.md
    data-model.md
    backlog-map.md
    security-access.md
    first-story-ofh-23.md
```

## Status

The invoice processing automation is already running locally from the `InvoicesStorage` workspace. This repository starts as the documented home for finance automation and the Admin Portal roadmap. Application code will be added as the technical stack is confirmed.
