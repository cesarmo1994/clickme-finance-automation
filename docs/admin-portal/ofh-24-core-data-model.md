# OFH-24 - Core Data Model And Azure SQL Tables

## Goal

Define the first Admin Portal data model on top of the existing `finance` Azure SQL database so dashboards and portal modules can read consistent purchasing data.

## Current Status

The Azure SQL database is ready for the next portal workstream.

## Purchase Invoice Table

`dbo.purch_invoices` is the source of processed purchase invoice records. It stores document identity, parser metadata, invoice header fields, vendor/customer text from source documents, amounts, payment fields, line JSON, raw JSON, and duplicate prevention keys.

## Core Tables In Scope

- `dbo.companies`
- `dbo.vendors`
- `dbo.expense_categories`
- `dbo.invoice_line_items`
- `dbo.invoice_expense_classifications`
- `dbo.payments`
- `dbo.documents`
- `dbo.approval_workflows`
- `dbo.approval_requests`
- `dbo.automation_runs`
- `dbo.portal_users`
- `dbo.portal_roles`
- `dbo.portal_user_roles`
- `dbo.audit_events`

## Initial Dashboard Views

- `dbo.invoice_fact`
- `dbo.vendor_dim`
- `dbo.date_dim`

## Design Principles

- Keep purchase invoices in `dbo.purch_invoices`.
- Model sales later in a separate table such as `dbo.sales_invoices` if needed.
- Use a small star model first for dashboards.
- Keep raw parser JSON available for traceability.
- Avoid duplicate purchase invoices through existing `sha256` and `dedup_key` constraints.
- Keep Microsoft Entra ID as the source of identity, with portal tables storing application metadata only.

## Script Location

`sql/admin-portal/001_core_schema_and_views.sql`

## Execution Status

Created successfully in Azure SQL and pushed to GitHub.
