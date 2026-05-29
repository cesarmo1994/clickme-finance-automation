# OFH-15 - Executive Dashboard

## Objective

Create the first operational dashboard for the ClickMe Admin Portal so internal users can review purchase invoice health, financial exposure, and automation signals from one entry point.

## Delivered

- Dashboard page at `/` in the web app.
- KPI cards for purchase invoices, recognized amount, open amount, and records needing review.
- Recent purchase invoice table powered by `/api/dashboard/invoices`.
- Processing health panel with clear, review, and overdue counts.
- Quick links to purchase invoices, vendors, automations, reports, and admin.
- Operational alerts for review queue, overdue invoices, and API fallback state.
- Active sidebar navigation across all current portal pages.

## Data Sources

- `dbo.invoice_fact` through `/api/dashboard/invoices`
- `dbo.vendor_dim` and `dbo.date_dim` are listed as dashboard model dependencies for the next reporting layer.

## Current Limitations

- Filters are represented in the UI but not yet interactive.
- API fallback returns an empty dashboard when the backend is not running.
- Validation against live Azure SQL still depends on running the API locally with the configured connection.

## Next Build Step

Add interactive filters by date, vendor, and status, then validate the dashboard against live Azure SQL data.
