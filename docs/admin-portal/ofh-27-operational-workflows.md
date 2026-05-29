# OFH-27 - Operational States And Workflows

## Goal

Define the first operational workflows for the Admin Portal so purchase invoices, vendors, automations, and approvals have explicit states and transitions.

## Purchase Invoice Workflow

States:

- `received`: PDF was received in the inbox folder.
- `parsed`: PDF was parsed and inserted into `dbo.purch_invoices`.
- `needs_review`: Parsed data is incomplete, low-confidence, or requires human review.
- `validated`: Finance confirmed the extracted fields.
- `approved`: Invoice is approved for payment or accounting processing.
- `paid`: Invoice has been paid or matched to payment evidence.
- `archived`: Document and JSON are retained in final storage.
- `voided`: Invoice should not be processed.

Recommended transitions:

- `received` -> `parsed`
- `parsed` -> `validated`
- `parsed` -> `needs_review`
- `needs_review` -> `validated`
- `validated` -> `approved`
- `approved` -> `paid`
- `paid` -> `archived`
- any active state -> `voided`

## Vendor Workflow

States:

- `draft`: Vendor was detected or entered but not reviewed.
- `active`: Vendor is approved for normal use.
- `needs_review`: Vendor requires finance review.
- `blocked`: Vendor should not be used.
- `inactive`: Vendor is no longer active.

Sensitive vendor changes:

- Vendor legal name
- Tax ID
- Payment details
- Country
- Risk level
- Procurement status

Sensitive changes should create an approval request or audit event.

## Automation Workflow

States:

- `scheduled`
- `running`
- `succeeded`
- `succeeded_with_warnings`
- `failed`
- `retry_requested`
- `retrying`

Retry rules:

- Retry should be visible in `dbo.automation_runs`.
- Manual retry requires Admin, Finance Manager, or a delegated automation operator.
- Failed runs should retain summary JSON and log path.

## Approval Workflow

Entities that may require approval:

- Vendor creation
- Vendor sensitive field changes
- Invoice financial field corrections
- Manual data imports
- Financial exports for external parties

Approval states:

- `pending`
- `approved`
- `rejected`
- `cancelled`

## Audit Events

Every state transition that changes financial or access-sensitive data should write to `dbo.audit_events`.

Minimum audit payload:

- actor
- action key
- entity type
- entity ID
- timestamp
- before JSON
- after JSON
- request ID when available

## First API Workflow Endpoints

- `PATCH /api/purchase-invoices/{id}/review-status`
- `PATCH /api/vendors/{id}/status`
- `POST /api/approvals`
- `PATCH /api/approvals/{id}`
- `POST /api/automations/{name}/retry`

## Open Questions

- Which roles can approve invoices?
- Does payment status come from manual entry, bank reconciliation, or accounting system sync?
- Should exports require approval before download?
