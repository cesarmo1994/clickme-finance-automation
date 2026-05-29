# ADR 0001 - Admin Portal Technical Stack

## Status

Proposed

## Context

The ClickMe Admin Portal needs to support finance dashboards, invoice review, vendor administration, automation monitoring, and future administrative modules. The system must integrate with Azure SQL and Microsoft Entra ID while staying simple enough to build incrementally.

## Decision

Use a monorepo for the MVP:

- `apps/web`: Next.js with TypeScript for the portal UI.
- `apps/api`: FastAPI with Python for backend endpoints and Azure SQL access.
- `docs`: product, architecture, data model, and Jira traceability.
- `infra`: deployment and environment scripts once Azure hosting is selected.

Core platform choices:

- Database: Azure SQL, database `finance`.
- Identity: Microsoft Entra ID.
- Dashboard data: SQL views exposed through API endpoints.
- Automation source: existing invoice parser pipeline from `InvoicesStorage`.

## Rationale

Next.js gives a strong dashboard and admin UI foundation with TypeScript. FastAPI fits the existing Python automation work and allows reuse of parser/database knowledge. Azure SQL is already configured and tested. Microsoft Entra ID aligns with the Microsoft 365 environment already in use.

## Consequences

- Frontend and backend can evolve independently while living in one repository.
- API endpoints become the contract between the portal and Azure SQL.
- Authentication and authorization must be designed before exposing sensitive finance data.
- OFH-24 must define the remaining tables and dashboard views before major dashboard implementation.

## Open Items

- Confirm Azure hosting target.
- Define CI/CD workflow.
- Define secret management.
- Confirm Entra app registration requirements.
- Create initial local development setup.
