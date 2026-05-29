from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .routes.dashboard import router as dashboard_router
from .routes.purchase_invoices import router as purchase_invoices_router
from .routes.vendors import router as vendors_router

app = FastAPI(title="ClickMe Admin Portal API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(dashboard_router)
app.include_router(purchase_invoices_router)
app.include_router(vendors_router)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}
