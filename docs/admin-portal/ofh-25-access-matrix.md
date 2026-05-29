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

- Should external accountants have direct portal access or scheduled exports only?
- Should Finance Operators be allowed to edit invoice amounts, or only non-financial metadata?
- Should Operations Managers see invoice amounts or only vendor/process status?
- Which role should own automation retry permissions?
