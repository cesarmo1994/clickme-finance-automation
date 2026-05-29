# API

FastAPI workspace for the ClickMe Admin Portal backend.

## Planned Responsibilities

- Dashboard API endpoints
- Invoice and vendor API endpoints
- Azure SQL access layer
- Microsoft Entra ID token validation
- Role and permission checks
- Automation run health endpoints

## Initial Decision

The API is the only application layer that should read from or write to Azure SQL.
