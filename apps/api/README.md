# API

FastAPI backend for the ClickMe Admin Portal.

## Local Run

```powershell
cd apps/api
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

## Initial Endpoints

- `GET /health`
- `GET /api/dashboard/invoices`
- `GET /api/dashboard/vendors`
- `GET /api/dashboard/dates`
