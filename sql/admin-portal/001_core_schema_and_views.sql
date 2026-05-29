/*
  ClickMe Admin Portal core schema and dashboard views.

  Target database: finance
  Run after dbo.invoices exists.

  This script creates the core tables needed by the Admin Portal and read-only
  views for dashboards. It complements dbo.invoices; it does not replace the
  current invoice parser storage table.
*/

/* Core master data */

IF OBJECT_ID(N'dbo.companies', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.companies
    (
        company_id BIGINT IDENTITY(1,1) NOT NULL,
        company_guid UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_companies_company_guid DEFAULT NEWID(),
        company_name NVARCHAR(255) NOT NULL,
        legal_name NVARCHAR(255) NULL,
        tax_id NVARCHAR(120) NULL,
        country_code CHAR(2) NULL,
        currency_code CHAR(3) NULL,
        status NVARCHAR(40) NOT NULL CONSTRAINT DF_companies_status DEFAULT N'active',
        created_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_companies_created_at_utc DEFAULT SYSUTCDATETIME(),
        updated_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_companies_updated_at_utc DEFAULT SYSUTCDATETIME(),
        CONSTRAINT PK_companies PRIMARY KEY CLUSTERED (company_id),
        CONSTRAINT UQ_companies_company_name UNIQUE (company_name),
        CONSTRAINT CK_companies_country_code CHECK (country_code IS NULL OR country_code LIKE '[A-Z][A-Z]'),
        CONSTRAINT CK_companies_currency_code CHECK (currency_code IS NULL OR currency_code LIKE '[A-Z][A-Z][A-Z]')
    );
END;
GO

IF OBJECT_ID(N'dbo.vendors', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.vendors
    (
        vendor_id BIGINT IDENTITY(1,1) NOT NULL,
        vendor_guid UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_vendors_vendor_guid DEFAULT NEWID(),
        vendor_name NVARCHAR(255) NOT NULL,
        normalized_vendor_name AS UPPER(LTRIM(RTRIM(vendor_name))) PERSISTED,
        tax_id NVARCHAR(120) NULL,
        primary_email NVARCHAR(320) NULL,
        primary_phone NVARCHAR(80) NULL,
        website_url NVARCHAR(500) NULL,
        country_code CHAR(2) NULL,
        default_currency_code CHAR(3) NULL,
        procurement_status NVARCHAR(40) NOT NULL CONSTRAINT DF_vendors_procurement_status DEFAULT N'active',
        risk_level NVARCHAR(40) NULL,
        notes NVARCHAR(MAX) NULL,
        created_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_vendors_created_at_utc DEFAULT SYSUTCDATETIME(),
        updated_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_vendors_updated_at_utc DEFAULT SYSUTCDATETIME(),
        CONSTRAINT PK_vendors PRIMARY KEY CLUSTERED (vendor_id),
        CONSTRAINT UQ_vendors_normalized_vendor_name UNIQUE (normalized_vendor_name),
        CONSTRAINT CK_vendors_country_code CHECK (country_code IS NULL OR country_code LIKE '[A-Z][A-Z]'),
        CONSTRAINT CK_vendors_default_currency_code CHECK (default_currency_code IS NULL OR default_currency_code LIKE '[A-Z][A-Z][A-Z]')
    );
END;
GO

IF OBJECT_ID(N'dbo.expense_categories', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.expense_categories
    (
        expense_category_id BIGINT IDENTITY(1,1) NOT NULL,
        category_key NVARCHAR(80) NOT NULL,
        category_name NVARCHAR(160) NOT NULL,
        parent_expense_category_id BIGINT NULL,
        is_active BIT NOT NULL CONSTRAINT DF_expense_categories_is_active DEFAULT 1,
        created_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_expense_categories_created_at_utc DEFAULT SYSUTCDATETIME(),
        CONSTRAINT PK_expense_categories PRIMARY KEY CLUSTERED (expense_category_id),
        CONSTRAINT UQ_expense_categories_category_key UNIQUE (category_key),
        CONSTRAINT FK_expense_categories_parent FOREIGN KEY (parent_expense_category_id) REFERENCES dbo.expense_categories(expense_category_id)
    );
END;
GO

/* Invoice related detail tables */

IF OBJECT_ID(N'dbo.invoice_line_items', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.invoice_line_items
    (
        invoice_line_item_id BIGINT IDENTITY(1,1) NOT NULL,
        invoice_id BIGINT NOT NULL,
        line_number INT NOT NULL,
        expense_category_id BIGINT NULL,
        description NVARCHAR(1000) NULL,
        service_period_start DATE NULL,
        service_period_end DATE NULL,
        quantity DECIMAL(19,4) NULL,
        unit_price_amount DECIMAL(19,4) NULL,
        subtotal_amount DECIMAL(19,4) NULL,
        tax_amount DECIMAL(19,4) NULL,
        total_amount DECIMAL(19,4) NULL,
        currency_code CHAR(3) NULL,
        raw_line_json NVARCHAR(MAX) NULL,
        created_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_invoice_line_items_created_at_utc DEFAULT SYSUTCDATETIME(),
        CONSTRAINT PK_invoice_line_items PRIMARY KEY CLUSTERED (invoice_line_item_id),
        CONSTRAINT FK_invoice_line_items_invoices FOREIGN KEY (invoice_id) REFERENCES dbo.invoices(invoice_id),
        CONSTRAINT FK_invoice_line_items_expense_categories FOREIGN KEY (expense_category_id) REFERENCES dbo.expense_categories(expense_category_id),
        CONSTRAINT UQ_invoice_line_items_invoice_line UNIQUE (invoice_id, line_number),
        CONSTRAINT CK_invoice_line_items_currency_code CHECK (currency_code IS NULL OR currency_code LIKE '[A-Z][A-Z][A-Z]'),
        CONSTRAINT CK_invoice_line_items_raw_line_json CHECK (raw_line_json IS NULL OR ISJSON(raw_line_json) = 1)
    );
END;
GO

IF OBJECT_ID(N'dbo.invoice_expense_classifications', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.invoice_expense_classifications
    (
        invoice_expense_classification_id BIGINT IDENTITY(1,1) NOT NULL,
        invoice_id BIGINT NOT NULL,
        expense_category_id BIGINT NOT NULL,
        classification_source NVARCHAR(40) NOT NULL CONSTRAINT DF_invoice_expense_classifications_source DEFAULT N'manual',
        confidence_score DECIMAL(5,4) NULL,
        notes NVARCHAR(1000) NULL,
        created_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_invoice_expense_classifications_created_at_utc DEFAULT SYSUTCDATETIME(),
        CONSTRAINT PK_invoice_expense_classifications PRIMARY KEY CLUSTERED (invoice_expense_classification_id),
        CONSTRAINT FK_invoice_expense_classifications_invoices FOREIGN KEY (invoice_id) REFERENCES dbo.invoices(invoice_id),
        CONSTRAINT FK_invoice_expense_classifications_categories FOREIGN KEY (expense_category_id) REFERENCES dbo.expense_categories(expense_category_id),
        CONSTRAINT UQ_invoice_expense_classifications_invoice_category UNIQUE (invoice_id, expense_category_id),
        CONSTRAINT CK_invoice_expense_classifications_confidence CHECK (confidence_score IS NULL OR confidence_score BETWEEN 0 AND 1)
    );
END;
GO

IF OBJECT_ID(N'dbo.payments', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.payments
    (
        payment_id BIGINT IDENTITY(1,1) NOT NULL,
        payment_guid UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_payments_payment_guid DEFAULT NEWID(),
        invoice_id BIGINT NULL,
        vendor_id BIGINT NULL,
        payment_status NVARCHAR(40) NOT NULL CONSTRAINT DF_payments_payment_status DEFAULT N'planned',
        payment_date DATE NULL,
        due_date DATE NULL,
        currency_code CHAR(3) NULL,
        payment_amount DECIMAL(19,4) NOT NULL,
        payment_method NVARCHAR(80) NULL,
        payment_reference NVARCHAR(255) NULL,
        reconciliation_status NVARCHAR(40) NULL,
        notes NVARCHAR(MAX) NULL,
        created_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_payments_created_at_utc DEFAULT SYSUTCDATETIME(),
        updated_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_payments_updated_at_utc DEFAULT SYSUTCDATETIME(),
        CONSTRAINT PK_payments PRIMARY KEY CLUSTERED (payment_id),
        CONSTRAINT FK_payments_invoices FOREIGN KEY (invoice_id) REFERENCES dbo.invoices(invoice_id),
        CONSTRAINT FK_payments_vendors FOREIGN KEY (vendor_id) REFERENCES dbo.vendors(vendor_id),
        CONSTRAINT CK_payments_currency_code CHECK (currency_code IS NULL OR currency_code LIKE '[A-Z][A-Z][A-Z]')
    );
END;
GO

IF OBJECT_ID(N'dbo.documents', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.documents
    (
        document_id BIGINT IDENTITY(1,1) NOT NULL,
        document_guid UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_documents_document_guid DEFAULT NEWID(),
        invoice_id BIGINT NULL,
        vendor_id BIGINT NULL,
        document_type NVARCHAR(80) NOT NULL,
        file_name NVARCHAR(260) NOT NULL,
        file_path NVARCHAR(2048) NULL,
        sha256 CHAR(64) NULL,
        mime_type NVARCHAR(120) NULL,
        source_system NVARCHAR(120) NULL,
        retention_status NVARCHAR(40) NULL,
        created_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_documents_created_at_utc DEFAULT SYSUTCDATETIME(),
        CONSTRAINT PK_documents PRIMARY KEY CLUSTERED (document_id),
        CONSTRAINT FK_documents_invoices FOREIGN KEY (invoice_id) REFERENCES dbo.invoices(invoice_id),
        CONSTRAINT FK_documents_vendors FOREIGN KEY (vendor_id) REFERENCES dbo.vendors(vendor_id)
    );
END;
GO

/* Operations and portal governance */

IF OBJECT_ID(N'dbo.approval_workflows', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.approval_workflows
    (
        approval_workflow_id BIGINT IDENTITY(1,1) NOT NULL,
        workflow_key NVARCHAR(80) NOT NULL,
        workflow_name NVARCHAR(160) NOT NULL,
        entity_type NVARCHAR(120) NOT NULL,
        is_active BIT NOT NULL CONSTRAINT DF_approval_workflows_is_active DEFAULT 1,
        workflow_json NVARCHAR(MAX) NULL,
        created_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_approval_workflows_created_at_utc DEFAULT SYSUTCDATETIME(),
        updated_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_approval_workflows_updated_at_utc DEFAULT SYSUTCDATETIME(),
        CONSTRAINT PK_approval_workflows PRIMARY KEY CLUSTERED (approval_workflow_id),
        CONSTRAINT UQ_approval_workflows_workflow_key UNIQUE (workflow_key),
        CONSTRAINT CK_approval_workflows_json CHECK (workflow_json IS NULL OR ISJSON(workflow_json) = 1)
    );
END;
GO

IF OBJECT_ID(N'dbo.approval_requests', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.approval_requests
    (
        approval_request_id BIGINT IDENTITY(1,1) NOT NULL,
        approval_workflow_id BIGINT NOT NULL,
        entity_type NVARCHAR(120) NOT NULL,
        entity_id NVARCHAR(120) NOT NULL,
        approval_status NVARCHAR(40) NOT NULL CONSTRAINT DF_approval_requests_status DEFAULT N'pending',
        requested_by_portal_user_id BIGINT NULL,
        requested_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_approval_requests_requested_at_utc DEFAULT SYSUTCDATETIME(),
        resolved_by_portal_user_id BIGINT NULL,
        resolved_at_utc DATETIMEOFFSET(0) NULL,
        notes NVARCHAR(MAX) NULL,
        CONSTRAINT PK_approval_requests PRIMARY KEY CLUSTERED (approval_request_id),
        CONSTRAINT FK_approval_requests_workflows FOREIGN KEY (approval_workflow_id) REFERENCES dbo.approval_workflows(approval_workflow_id)
    );
END;
GO

IF OBJECT_ID(N'dbo.automation_runs', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.automation_runs
    (
        automation_run_id BIGINT IDENTITY(1,1) NOT NULL,
        automation_name NVARCHAR(160) NOT NULL,
        run_status NVARCHAR(40) NOT NULL,
        started_at_utc DATETIMEOFFSET(0) NOT NULL,
        completed_at_utc DATETIMEOFFSET(0) NULL,
        scanned_count INT NULL,
        processed_count INT NULL,
        error_count INT NULL,
        summary_json NVARCHAR(MAX) NULL,
        log_path NVARCHAR(2048) NULL,
        created_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_automation_runs_created_at_utc DEFAULT SYSUTCDATETIME(),
        CONSTRAINT PK_automation_runs PRIMARY KEY CLUSTERED (automation_run_id),
        CONSTRAINT CK_automation_runs_summary_json CHECK (summary_json IS NULL OR ISJSON(summary_json) = 1)
    );
END;
GO

IF OBJECT_ID(N'dbo.portal_users', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.portal_users
    (
        portal_user_id BIGINT IDENTITY(1,1) NOT NULL,
        entra_object_id UNIQUEIDENTIFIER NULL,
        email NVARCHAR(320) NOT NULL,
        display_name NVARCHAR(255) NULL,
        user_status NVARCHAR(40) NOT NULL CONSTRAINT DF_portal_users_user_status DEFAULT N'active',
        last_login_utc DATETIMEOFFSET(0) NULL,
        created_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_portal_users_created_at_utc DEFAULT SYSUTCDATETIME(),
        updated_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_portal_users_updated_at_utc DEFAULT SYSUTCDATETIME(),
        CONSTRAINT PK_portal_users PRIMARY KEY CLUSTERED (portal_user_id),
        CONSTRAINT UQ_portal_users_email UNIQUE (email)
    );
END;
GO

IF OBJECT_ID(N'dbo.portal_roles', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.portal_roles
    (
        portal_role_id BIGINT IDENTITY(1,1) NOT NULL,
        role_key NVARCHAR(80) NOT NULL,
        role_name NVARCHAR(160) NOT NULL,
        role_description NVARCHAR(1000) NULL,
        created_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_portal_roles_created_at_utc DEFAULT SYSUTCDATETIME(),
        CONSTRAINT PK_portal_roles PRIMARY KEY CLUSTERED (portal_role_id),
        CONSTRAINT UQ_portal_roles_role_key UNIQUE (role_key)
    );
END;
GO

IF OBJECT_ID(N'dbo.portal_user_roles', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.portal_user_roles
    (
        portal_user_role_id BIGINT IDENTITY(1,1) NOT NULL,
        portal_user_id BIGINT NOT NULL,
        portal_role_id BIGINT NOT NULL,
        assigned_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_portal_user_roles_assigned_at_utc DEFAULT SYSUTCDATETIME(),
        assigned_by_portal_user_id BIGINT NULL,
        CONSTRAINT PK_portal_user_roles PRIMARY KEY CLUSTERED (portal_user_role_id),
        CONSTRAINT FK_portal_user_roles_users FOREIGN KEY (portal_user_id) REFERENCES dbo.portal_users(portal_user_id),
        CONSTRAINT FK_portal_user_roles_roles FOREIGN KEY (portal_role_id) REFERENCES dbo.portal_roles(portal_role_id),
        CONSTRAINT FK_portal_user_roles_assigned_by FOREIGN KEY (assigned_by_portal_user_id) REFERENCES dbo.portal_users(portal_user_id),
        CONSTRAINT UQ_portal_user_roles_user_role UNIQUE (portal_user_id, portal_role_id)
    );
END;
GO

IF OBJECT_ID(N'dbo.audit_events', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.audit_events
    (
        audit_event_id BIGINT IDENTITY(1,1) NOT NULL,
        event_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_audit_events_event_at_utc DEFAULT SYSUTCDATETIME(),
        actor_portal_user_id BIGINT NULL,
        actor_email NVARCHAR(320) NULL,
        action_key NVARCHAR(160) NOT NULL,
        entity_type NVARCHAR(120) NOT NULL,
        entity_id NVARCHAR(120) NULL,
        before_json NVARCHAR(MAX) NULL,
        after_json NVARCHAR(MAX) NULL,
        request_id NVARCHAR(120) NULL,
        source_ip NVARCHAR(80) NULL,
        CONSTRAINT PK_audit_events PRIMARY KEY CLUSTERED (audit_event_id),
        CONSTRAINT FK_audit_events_actor FOREIGN KEY (actor_portal_user_id) REFERENCES dbo.portal_users(portal_user_id),
        CONSTRAINT CK_audit_events_before_json CHECK (before_json IS NULL OR ISJSON(before_json) = 1),
        CONSTRAINT CK_audit_events_after_json CHECK (after_json IS NULL OR ISJSON(after_json) = 1)
    );
END;
GO

/* Helpful indexes */

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UQ_documents_sha256_not_null' AND object_id = OBJECT_ID(N'dbo.documents'))
    CREATE UNIQUE INDEX UQ_documents_sha256_not_null ON dbo.documents(sha256) WHERE sha256 IS NOT NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UQ_portal_users_entra_object_id_not_null' AND object_id = OBJECT_ID(N'dbo.portal_users'))
    CREATE UNIQUE INDEX UQ_portal_users_entra_object_id_not_null ON dbo.portal_users(entra_object_id) WHERE entra_object_id IS NOT NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_invoice_line_items_invoice_id' AND object_id = OBJECT_ID(N'dbo.invoice_line_items'))
    CREATE INDEX IX_invoice_line_items_invoice_id ON dbo.invoice_line_items(invoice_id);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_payments_invoice_status' AND object_id = OBJECT_ID(N'dbo.payments'))
    CREATE INDEX IX_payments_invoice_status ON dbo.payments(invoice_id, payment_status, payment_date);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_automation_runs_name_started' AND object_id = OBJECT_ID(N'dbo.automation_runs'))
    CREATE INDEX IX_automation_runs_name_started ON dbo.automation_runs(automation_name, started_at_utc DESC);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_audit_events_entity' AND object_id = OBJECT_ID(N'dbo.audit_events'))
    CREATE INDEX IX_audit_events_entity ON dbo.audit_events(entity_type, entity_id, event_at_utc DESC);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_approval_requests_entity' AND object_id = OBJECT_ID(N'dbo.approval_requests'))
    CREATE INDEX IX_approval_requests_entity ON dbo.approval_requests(entity_type, entity_id, approval_status);
GO

/* Dashboard views */

CREATE OR ALTER VIEW dbo.vw_invoice_summary AS
SELECT
    COUNT_BIG(*) AS invoice_count,
    SUM(CASE WHEN needs_review = 1 THEN 1 ELSE 0 END) AS needs_review_count,
    SUM(CASE WHEN processing_status = N'parsed' THEN 1 ELSE 0 END) AS parsed_count,
    SUM(CASE WHEN processing_status <> N'parsed' THEN 1 ELSE 0 END) AS not_parsed_count,
    SUM(COALESCE(total_amount, amount_due, amount_paid, 0)) AS total_amount,
    MIN(invoice_date) AS earliest_invoice_date,
    MAX(invoice_date) AS latest_invoice_date
FROM dbo.invoices;
GO

CREATE OR ALTER VIEW dbo.vw_invoice_vendor_spend AS
SELECT
    COALESCE(v.vendor_id, 0) AS vendor_id,
    COALESCE(v.vendor_name, i.vendor_name, N'Unknown') AS vendor_name,
    i.currency_code,
    COUNT_BIG(*) AS invoice_count,
    SUM(COALESCE(i.total_amount, i.amount_due, i.amount_paid, 0)) AS total_amount,
    MAX(i.invoice_date) AS latest_invoice_date,
    SUM(CASE WHEN i.needs_review = 1 THEN 1 ELSE 0 END) AS needs_review_count
FROM dbo.invoices AS i
LEFT JOIN dbo.vendors AS v
    ON v.normalized_vendor_name = UPPER(LTRIM(RTRIM(i.vendor_name)))
GROUP BY COALESCE(v.vendor_id, 0), COALESCE(v.vendor_name, i.vendor_name, N'Unknown'), i.currency_code;
GO

CREATE OR ALTER VIEW dbo.vw_invoice_monthly_trend AS
SELECT
    DATEFROMPARTS(YEAR(COALESCE(invoice_date, document_date, CAST(created_at_utc AS date))), MONTH(COALESCE(invoice_date, document_date, CAST(created_at_utc AS date))), 1) AS invoice_month,
    currency_code,
    COUNT_BIG(*) AS invoice_count,
    SUM(COALESCE(total_amount, amount_due, amount_paid, 0)) AS total_amount,
    SUM(CASE WHEN needs_review = 1 THEN 1 ELSE 0 END) AS needs_review_count
FROM dbo.invoices
GROUP BY
    DATEFROMPARTS(YEAR(COALESCE(invoice_date, document_date, CAST(created_at_utc AS date))), MONTH(COALESCE(invoice_date, document_date, CAST(created_at_utc AS date))), 1),
    currency_code;
GO

CREATE OR ALTER VIEW dbo.vw_invoice_processing_quality AS
SELECT
    parser_name,
    parser_version,
    processing_status,
    COUNT_BIG(*) AS invoice_count,
    SUM(CASE WHEN needs_review = 1 THEN 1 ELSE 0 END) AS needs_review_count,
    AVG(CAST(confidence_score AS DECIMAL(9,4))) AS avg_confidence_score
FROM dbo.invoices
GROUP BY parser_name, parser_version, processing_status;
GO

CREATE OR ALTER VIEW dbo.vw_invoice_category_spend AS
SELECT
    c.category_key,
    c.category_name,
    i.currency_code,
    COUNT_BIG(DISTINCT i.invoice_id) AS invoice_count,
    SUM(COALESCE(i.total_amount, i.amount_due, i.amount_paid, 0)) AS total_amount
FROM dbo.invoices AS i
INNER JOIN dbo.invoice_expense_classifications AS x
    ON x.invoice_id = i.invoice_id
INNER JOIN dbo.expense_categories AS c
    ON c.expense_category_id = x.expense_category_id
GROUP BY c.category_key, c.category_name, i.currency_code;
GO

CREATE OR ALTER VIEW dbo.vw_automation_run_health AS
SELECT
    automation_name,
    MAX(started_at_utc) AS last_started_at_utc,
    MAX(completed_at_utc) AS last_completed_at_utc,
    SUM(CASE WHEN run_status = N'succeeded' THEN 1 ELSE 0 END) AS succeeded_runs,
    SUM(CASE WHEN run_status <> N'succeeded' THEN 1 ELSE 0 END) AS non_succeeded_runs,
    SUM(COALESCE(scanned_count, 0)) AS scanned_count,
    SUM(COALESCE(processed_count, 0)) AS processed_count,
    SUM(COALESCE(error_count, 0)) AS error_count
FROM dbo.automation_runs
GROUP BY automation_name;
GO

CREATE OR ALTER VIEW dbo.vw_accounts_payable_status AS
SELECT
    COALESCE(v.vendor_name, i.vendor_name, N'Unknown') AS vendor_name,
    i.currency_code,
    COUNT_BIG(*) AS invoice_count,
    SUM(COALESCE(i.amount_due, i.total_amount, 0) - COALESCE(i.amount_paid, 0)) AS open_amount,
    SUM(CASE WHEN i.due_date IS NOT NULL AND i.due_date < CONVERT(date, SYSUTCDATETIME()) THEN 1 ELSE 0 END) AS overdue_invoice_count,
    MIN(i.due_date) AS next_due_date
FROM dbo.invoices AS i
LEFT JOIN dbo.vendors AS v
    ON v.normalized_vendor_name = UPPER(LTRIM(RTRIM(i.vendor_name)))
WHERE COALESCE(i.amount_due, i.total_amount, 0) - COALESCE(i.amount_paid, 0) <> 0
GROUP BY COALESCE(v.vendor_name, i.vendor_name, N'Unknown'), i.currency_code;
GO
