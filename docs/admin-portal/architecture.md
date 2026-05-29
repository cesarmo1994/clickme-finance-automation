# Architecture Notes

## Initial Decision

Use a monorepo with a typed frontend, a Python API layer, Azure SQL as the operational database, and Microsoft Entra ID for authentication.

Repository structure:

- `apps/web`: Next.js with TypeScript for the portal UI.
- `apps/api`: FastAPI with Python for backend endpoints and Azure SQL access.
- `docs`: product, architecture, data model, ADRs, and Jira traceability.
- `infra`: deployment and environment scripts once Azure hosting is selected.

## Selected Stack

### Frontend

- Next.js with TypeScript
- Dashboard pages consuming API endpoints, not direct database connections
- Component library to be selected after the UX baseline in OFH-29

### Backend

- FastAPI with Python
- API endpoints for dashboards, invoices, vendors, automation runs, and users
- Azure SQL access through parameterized queries or a small data access layer
- Microsoft Entra ID token validation before exposing finance data

### Data

- Azure SQL database: `finance`
- Existing table: `dbo.invoices`
- Additional core tables to define in OFH-24
- SQL views should feed dashboard-ready summaries

### Identity

- Microsoft Entra ID
- Portal roles mapped from Entra groups where possible
- Application roles documented in the access matrix from OFH-25

### Environments

- Local development
- Test or staging
- Production

## Hosting Candidates

The final hosting model is still open. Candidate options:

- Azure App Service for API and web
- Azure Static Web Apps plus API
- Azure Container Apps

## Open Decisions

- Choose final hosting target.
- Define CI/CD workflow.
- Define secret management.
- Confirm Entra app registration requirements.
- Confirm database migration workflow.
