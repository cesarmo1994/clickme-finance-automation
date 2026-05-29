# OFH-25 - Roles, Permissions, And Access Matrix

## Goal

Define the first RBAC model for the ClickMe Admin Portal so finance data, invoice operations, vendor management, exports, and admin actions are controlled from the start.

## Roles

- `Admin`
- `Finance Manager`
- `Finance Operator`
- `Operations Manager`
- `Viewer`
- `External Accountant`

## Implementation Direction

Use Microsoft Entra ID for authentication and group assignment. The portal should map Entra groups to application roles at login.

Application metadata remains in:

- `dbo.portal_users`
- `dbo.portal_roles`
- `dbo.portal_user_roles`

## First Permission Scope

The first version of access control should cover:

- Dashboards
- Purchase invoices
- Vendor management
- Automation monitoring
- Financial exports
- User and role management
- Audit event visibility

## Entra Groups To Create

- `clickme-admin-portal-admins`
- `clickme-admin-portal-finance-managers`
- `clickme-admin-portal-finance-operators`
- `clickme-admin-portal-operations-managers`
- `clickme-admin-portal-viewers`
- `clickme-admin-portal-external-accountants`

## Open Questions

Resolved MVP recommendations:

- `External Accountant` should receive scheduled or on-demand exports only. Direct portal access can be enabled later if needed.
- `Finance Operator` should edit review metadata only. Financial fields such as amount, currency, vendor, invoice number, invoice date, due date, and paid date require `Finance Manager` or `Admin`.
- `Operations Manager` should see vendor/process status, automation health, and operational queues without invoice amounts by default.
- Automation retry/disable permissions should belong to `Admin` and `Finance Manager`. `Finance Operator` can request retry but should not execute it in the MVP.

## Entra Group Mapping

| Entra group | Portal role | MVP access intent |
|---|---|---|
| `clickme-admin-portal-admins` | `admin` | Full app administration, roles, configuration, automation controls |
| `clickme-admin-portal-finance-managers` | `finance_manager` | Finance oversight, approvals, corrections, exports, retry automation |
| `clickme-admin-portal-finance-operators` | `finance_operator` | Invoice review, non-financial corrections, vendor review support |
| `clickme-admin-portal-operations-managers` | `operations_manager` | Vendor/process visibility without financial amount exposure |
| `clickme-admin-portal-viewers` | `viewer` | Read-only dashboards and non-sensitive invoice/vendor visibility |
| `clickme-admin-portal-external-accountants` | `external_accountant` | Export recipient role; no direct portal login in MVP |

## MVP Permission Decisions

| Decision | MVP rule |
|---|---|
| External accountant access | Exports only; no direct portal access until approved later |
| Finance Operator financial edits | Not allowed for amount, currency, vendor, invoice number, invoice date, due date, or paid date |
| Operations Manager financial visibility | No invoice amount visibility by default |
| Automation retry | Admin and Finance Manager only |
| Automation disable | Admin only |
| Financial exports | Admin and Finance Manager; External Accountant can receive exports |
| User/role management | Admin only |
| Audit log visibility | Admin and Finance Manager |
