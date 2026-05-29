# OFH-28 - Audit, Security, And Data Retention

## Goal

Define security, audit, and retention rules for the ClickMe Admin Portal before implementation of finance workflows.

## Security Principles

- Microsoft Entra ID is the identity provider.
- Portal authorization is role-based.
- Sensitive operations must be audited.
- The frontend must never connect directly to Azure SQL.
- API endpoints enforce permissions server-side.
- Secrets must not be committed to GitHub.

## Sensitive Actions

Audit these actions:

- Purchase invoice field edits
- Purchase invoice review status changes
- Vendor creation
- Vendor sensitive field changes
- Approval decisions
- Automation retry requests
- Manual imports
- Financial exports
- Role assignments
- User access changes
- System configuration changes

## Audit Event Model

`dbo.audit_events` should capture:

- `event_at_utc`
- `actor_portal_user_id`
- `actor_email`
- `action_key`
- `entity_type`
- `entity_id`
- `before_json`
- `after_json`
- `request_id`
- `source_ip`

## Retention Rules

| Data | Recommended retention | Notes |
|---|---:|---|
| Purchase invoice PDFs | 7 years | Confirm local compliance needs |
| Parsed invoice JSON | 7 years | Needed for traceability |
| Raw parser text | 2 years minimum | Can be heavy; revisit after storage strategy |
| Audit events | 7 years | Append-only |
| Automation run logs | 1-2 years | Keep failures longer if needed |
| Temporary files | 30-90 days | Delete after successful processing |
| Dashboard exports | 30 days | Prefer regeneration over storage |

## Data Classification

- Finance data: confidential.
- Invoice documents: confidential.
- Vendor payment details: restricted.
- Role and audit data: restricted.
- Dashboard summaries: internal.

## Implementation Requirements

- Use parameterized SQL queries.
- Validate role permissions in API handlers.
- Log every failed authorization attempt at least at application log level.
- Do not expose raw JSON or raw text by default in dashboard responses.
- Use least-privilege database users for the portal API.
- Keep write permissions separate from read-only dashboard permissions.

## Open Questions

- Should invoice PDFs move to Azure Blob Storage with retention policies?
- Should audit events be immutable at the database permission level?
- Which compliance retention period applies in Costa Rica for supplier invoices?
