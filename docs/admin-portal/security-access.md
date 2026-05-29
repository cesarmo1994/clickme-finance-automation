# Security And Access

## Authentication

Use Microsoft Entra ID for sign-in. The portal should not manage passwords.

## Initial Roles

- `Admin`: full portal administration and configuration.
- `Finance Manager`: finance oversight, approvals, exports, and invoice corrections.
- `Finance Operator`: invoice review, vendor review, and operational finance work.
- `Operations Manager`: operational visibility and vendor/process follow-up.
- `Viewer`: read-only dashboard and invoice visibility.
- `External Accountant`: controlled read/export access for accounting support.

## Permission Matrix

| Module / Action | Admin | Finance Manager | Finance Operator | Operations Manager | Viewer | External Accountant |
|---|---:|---:|---:|---:|---:|---:|
| View dashboard | Yes | Yes | Yes | Yes | Yes | Yes |
| View purchase invoices | Yes | Yes | Yes | Yes | Yes | Yes |
| Edit parsed invoice fields | Yes | Yes | Yes | No | No | No |
| Change invoice review status | Yes | Yes | Yes | No | No | No |
| Manage vendors | Yes | Yes | Limited | Limited | No | No |
| Approve vendor changes | Yes | Yes | No | No | No | No |
| View automation runs | Yes | Yes | Yes | Yes | No | No |
| Retry or trigger automation | Yes | Yes | Limited | No | No | No |
| Export financial data | Yes | Yes | No | No | No | Yes |
| Manage users and roles | Yes | No | No | No | No | No |
| View audit events | Yes | Yes | No | No | No | No |
| Manage system configuration | Yes | No | No | No | No | No |

## Entra ID Mapping

Recommended Microsoft Entra groups:

- `clickme-admin-portal-admins`
- `clickme-admin-portal-finance-managers`
- `clickme-admin-portal-finance-operators`
- `clickme-admin-portal-operations-managers`
- `clickme-admin-portal-viewers`
- `clickme-admin-portal-external-accountants`

Portal roles should map from these groups at login. `dbo.portal_users`, `dbo.portal_roles`, and `dbo.portal_user_roles` store app-level metadata and assignments needed by the portal, but Entra ID remains the identity source.

## Approval Rules

- Vendor creation or vendor critical field changes require Finance Manager or Admin approval.
- Invoice amount, currency, vendor, invoice number, or invoice date changes require audit logging.
- User role changes require Admin.
- Manual data imports require Finance Manager or Admin.
- Financial exports should be logged with actor, timestamp, filters, and export type.

## Audit Requirements

Audit these actions at minimum:

- Invoice field edits
- Invoice review status changes
- Vendor create or update
- Vendor approval or rejection
- Role or permission changes
- File upload or deletion
- Manual data imports
- Automation retry or manual trigger
- Report exports

## Data Retention

Retention policies must be defined for:

- Invoice PDFs
- Parsed JSON payloads
- Audit events
- Automation logs
- Legal documents
- Temporary staging files
