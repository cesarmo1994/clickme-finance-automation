# Data Model Plan

## Existing Database

- Server: `ckmecr-admin-server.database.windows.net`
- Database: `finance`
- Existing purchase invoice table: `dbo.purch_invoices`

## Core Entities To Define

### Companies

Legal and operating entities managed by the portal.

Candidate table: `dbo.companies`

### Vendors

Supplier master data used by invoices, purchases, contracts, and compliance.

Candidate table: `dbo.vendors`

### Purchase Invoices

Exists as `dbo.purch_invoices`. This table stores supplier invoices and accounts payable data.

### Invoice Line Items

Detailed invoice lines extracted from PDFs or entered manually.

Candidate table: `dbo.invoice_line_items`

### Payments

Payment status, payment date, method, references, and reconciliation metadata.

Candidate table: `dbo.payments`

### Purchase Requests

Internal purchase requests or approvals before invoice receipt.

Candidate table: `dbo.purchase_requests`

### Documents

Shared metadata for PDFs, contracts, legal documents, and uploaded attachments.

Candidate table: `dbo.documents`

### Automation Runs

Execution log for parsers, watchers, integrations, and recurring jobs.

Candidate table: `dbo.automation_runs`

### Users And Roles

Portal user profiles and role assignments. Identity should remain in Microsoft Entra ID, while the portal stores application-level metadata.

Candidate tables:

- `dbo.portal_users`
- `dbo.portal_roles`
- `dbo.portal_user_roles`

### Audit Events

Append-only record of sensitive actions.

Candidate table: `dbo.audit_events`

## Dashboard Views

- `dbo.invoice_fact`
- `dbo.vendor_dim`
- `dbo.date_dim`

## Deduplication Principles

- Keep `sha256` uniqueness for file-level duplicates.
- Keep `dedup_key` uniqueness for invoice-level duplicates when vendor, invoice number, date, and amount are available.
- Store raw parser output in JSON for traceability.
- Never insert dashboard aggregates directly; generate them from fact and dimension views.
