# Architecture Notes

## Current Recommendation

Use a web architecture with a typed frontend, a thin API layer, Azure SQL as the operational database, and Microsoft Entra ID for authentication.

## Candidate Stack

### Frontend

- Next.js with TypeScript
- Component library to be decided after UX direction
- Dashboard pages consuming API endpoints, not direct database connections

### Backend

- FastAPI with Python or .NET Web API
- API endpoints for dashboards, invoices, vendors, automation runs, and users
- Database access through parameterized queries or an ORM

### Data

- Azure SQL database: `finance`
- Existing table: `dbo.invoices`
- Additional core tables still to define in OFH-24
- SQL views should feed dashboard-ready summaries

### Identity

- Microsoft Entra ID
- Portal roles mapped from Entra groups where possible
- Application roles documented in the access matrix

### Environments

- Local development
- Test or staging
- Production

## Open Decisions

- Choose final frontend framework.
- Choose backend framework.
- Decide if API and frontend live in one repo or split later.
- Decide hosting target: Azure App Service, Static Web Apps plus API, or Container Apps.
- Define CI/CD and secret management.
