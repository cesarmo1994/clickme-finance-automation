# OFH-29 - UX, Navigation, And MVP Modules

## Goal

Define the first Admin Portal navigation and MVP screens so implementation can start with a focused, usable internal app.

## MVP Navigation

Primary navigation:

- Dashboard
- Purchase Invoices
- Vendors
- Automations
- Reports
- Admin

Secondary Admin navigation:

- Users
- Roles
- Audit Events
- System Settings

## First Dashboard Screen

Data sources:

- `dbo.invoice_fact`
- `dbo.vendor_dim`
- `dbo.date_dim`

Core widgets:

- Total recognized purchase amount
- Open amount
- Overdue amount
- Invoice count
- Needs review count
- Spend by vendor
- Monthly purchase trend
- Parser quality indicators

## Purchase Invoices Screen

Primary table columns:

- Invoice number
- Vendor
- Invoice date
- Due date
- Currency
- Total amount
- Open amount
- Processing status
- Needs review

Expected actions:

- View invoice detail
- Open source document
- Open parsed JSON reference
- Mark as reviewed
- Edit metadata when permitted

## Vendor Screen

Primary table columns:

- Vendor name
- Status
- Country
- Default currency
- Risk level
- Invoice count
- Total spend

Expected actions:

- View vendor profile
- Edit vendor metadata when permitted
- Flag vendor for review

## Automations Screen

Primary table columns:

- Automation name
- Last run
- Status
- Processed count
- Error count
- Log reference

Expected actions:

- View run detail
- Retry if authorized

## Reports Screen

Initial reports:

- Purchase invoice export
- Vendor spend export
- Open AP export

Exports should be audited.

## UX Rules

- Start with an operational dashboard, not a marketing landing page.
- Use compact tables and clear filters.
- Prioritize scanning, review, and repeated finance workflows.
- Keep dashboard data read-only in the first implementation.
- Put sensitive edits behind explicit actions and permissions.

## First Implementation Slice

Recommended first build:

1. App shell with navigation.
2. Dashboard page backed by `invoice_fact`, `vendor_dim`, and `date_dim`.
3. Purchase invoice table.
4. Vendor table.
5. Basic auth placeholder until Entra setup is ready.

## Open Questions

- Should the first UI be English or Spanish?
- Should amounts default to USD only or support multi-currency filters from day one?
- Should Figma be updated before implementation or after first app shell?
