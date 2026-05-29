# OFH-30 - Manual Validation Checklist

## Goal

Track the manual validation needed before the ClickMe Admin Portal can be treated as connected to the real finance environment.

## Azure SQL Validation

Before testing from Python or the portal API, set your Entra ID username in the same PowerShell session:

```powershell
$env:AZURE_SQL_USERNAME = "cesar@ckmecr.com"
```

Then run the current connection smoke test:

```powershell
cd "C:\Users\cmuri\CLICK ME\ClickMe Admin Center - Documents\Automations\InvoicesStorage"
python .\test_azure_sql_connection.py
```

Expected result:

```text
Connected database: finance
Table exists: dbo.purch_invoices
Azure SQL connection test passed.
```

Run this script in the `finance` database:

```text
sql/admin-portal/002_validate_core_schema.sql
```

Expected result:

- All required tables and views return `ok`.
- `dbo.purch_invoices` has `company_id` and `vendor_id`.
- Foreign keys from `dbo.purch_invoices` to `dbo.companies` and `dbo.vendors` exist and are not disabled.
- `dbo.invoice_fact`, `dbo.vendor_dim`, and `dbo.date_dim` return rows when source invoice data exists.
- Vendor duplicate query returns either no rows or a small list that can be reviewed manually.
- Data quality signals show counts for missing invoice number, vendor, date, currency, total amount, and review-required invoices.

## Manual Decisions Still Needed

- Confirm Microsoft Entra ID groups exist:
  - `clickme-admin-portal-admins`
  - `clickme-admin-portal-finance-managers`
  - `clickme-admin-portal-finance-operators`
  - `clickme-admin-portal-operations-managers`
  - `clickme-admin-portal-viewers`
  - `clickme-admin-portal-external-accountants`
- Decide whether `External Accountant` gets direct portal access or scheduled exports only.
- Decide whether `Finance Operator` can edit financial fields such as amount, currency, vendor, and invoice dates.
- Decide whether `Operations Manager` can view invoice amounts.
- Decide who can retry or disable automations.

## Role Seed

After the schema validation passes, run:

```text
sql/admin-portal/003_seed_portal_roles.sql
```

Expected result:

- `dbo.portal_roles` contains:
  - `admin`
  - `finance_manager`
  - `finance_operator`
  - `operations_manager`
  - `viewer`
  - `external_accountant`
- `dbo.portal_role_group_mappings` maps each role to its Microsoft Entra group.
- `external_accountant` has `is_direct_login_enabled = 0` for MVP export-only access.

Recommended MVP decisions:

- External Accountant: exports only, no direct portal login.
- Finance Operator: can edit review metadata, not financial fields.
- Operations Manager: no invoice amount visibility by default.
- Automation retry: Admin and Finance Manager.
- Automation disable: Admin only.

## Evidence To Capture

- Screenshot or copied output from validation sections 1 through 7.
- Any duplicate vendor names identified.
- Any high missing-field counts from the data-quality section.
- Confirmation of Entra groups and group owners.

## Current Local Finding

The connection smoke test could not run in this environment because `AZURE_SQL_USERNAME` was not set in the active shell session. No database connection attempt was made.

## Validation Result

Status: passed.

The Azure SQL core schema validation ran successfully in the `finance` database. The purchasing schema, dashboard views, relationship columns, and validation queries are ready for the next implementation steps.
