# OFH-22 - Technical Base, Navigation, And Layout

## Goal

Prepare the repository for implementation of the ClickMe Admin Portal with a simple monorepo structure, clear app boundaries, and first build order.

## Repository Structure

```text
apps/
  api/
  web/
docs/
  admin-portal/
infra/
sql/
  admin-portal/
```

## Web App Direction

- Next.js with TypeScript.
- App shell with persistent sidebar navigation.
- Dashboard first.
- Tables for invoices and vendors.
- Auth integration through Microsoft Entra ID when manual setup is ready.

## API Direction

- FastAPI with Python.
- API owns Azure SQL access.
- Frontend reads only from API.
- Initial dashboard endpoints read SQL views:
  - `dbo.invoice_fact`
  - `dbo.vendor_dim`
  - `dbo.date_dim`

## First API Endpoints

- `GET /health`
- `GET /api/dashboard/invoices`
- `GET /api/dashboard/vendors`
- `GET /api/dashboard/dates`
- `GET /api/purchase-invoices`
- `GET /api/vendors`

## Local Development Target

Frontend:

```text
apps/web
```

Backend:

```text
apps/api
```

Environment template:

```text
.env.example
```

## Build Order

1. API health endpoint.
2. API database connection helper.
3. Dashboard read endpoints.
4. Web app shell.
5. Dashboard page.
6. Purchase invoice table.
7. Vendor table.
8. Entra ID authentication.

## Manual Blockers

- Entra app registration.
- Entra groups.
- Production hosting decision.
