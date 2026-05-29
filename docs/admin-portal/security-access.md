# Security And Access

## Authentication

Use Microsoft Entra ID for sign-in. The portal should not manage passwords.

## Authorization

Define application roles before building sensitive workflows.

Candidate roles:

- Admin
- Finance Manager
- Finance Operator
- Operations Manager
- Viewer
- External Accountant

## Access Rules To Define

- Who can view invoices
- Who can edit extracted invoice fields
- Who can approve vendor records
- Who can manage users and roles
- Who can access legal documents
- Who can view automation logs and errors
- Who can export financial data

## Audit Requirements

Audit these actions at minimum:

- Invoice field edits
- Invoice status changes
- Vendor create or update
- Role or permission changes
- File upload or deletion
- Manual data imports
- Report exports

## Data Retention

Retention policies must be defined for:

- Invoice PDFs
- Parsed JSON payloads
- Audit events
- Automation logs
- Legal documents
- Temporary staging files
