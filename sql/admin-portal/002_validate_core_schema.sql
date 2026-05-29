/*
  ClickMe Admin Portal finance schema validation.

  Target database: finance
  Purpose: run after 001_core_schema_and_views.sql to confirm the purchasing
  model, dashboard views, and key data-quality signals are ready for the portal.
*/

SET NOCOUNT ON;

PRINT 'Validation 1 - Required tables and views';

SELECT
    required.object_name,
    required.object_type,
    CASE
        WHEN objects.object_id IS NULL THEN 'missing'
        ELSE 'ok'
    END AS validation_status
FROM (
    VALUES
        ('dbo.purch_invoices', 'table'),
        ('dbo.companies', 'table'),
        ('dbo.vendors', 'table'),
        ('dbo.expense_categories', 'table'),
        ('dbo.invoice_line_items', 'table'),
        ('dbo.invoice_expense_classifications', 'table'),
        ('dbo.payments', 'table'),
        ('dbo.documents', 'table'),
        ('dbo.approval_workflows', 'table'),
        ('dbo.approval_requests', 'table'),
        ('dbo.automation_runs', 'table'),
        ('dbo.portal_users', 'table'),
        ('dbo.portal_roles', 'table'),
        ('dbo.portal_user_roles', 'table'),
        ('dbo.audit_events', 'table'),
        ('dbo.invoice_fact', 'view'),
        ('dbo.vendor_dim', 'view'),
        ('dbo.date_dim', 'view')
) AS required(object_name, object_type)
LEFT JOIN sys.objects AS objects
    ON objects.object_id = OBJECT_ID(required.object_name)
ORDER BY required.object_type, required.object_name;

PRINT 'Validation 2 - Required invoice relationship columns';

SELECT
    columns.name AS column_name,
    types.name AS data_type,
    columns.is_nullable
FROM sys.columns AS columns
INNER JOIN sys.types AS types
    ON types.user_type_id = columns.user_type_id
WHERE columns.object_id = OBJECT_ID(N'dbo.purch_invoices')
  AND columns.name IN (N'company_id', N'vendor_id')
ORDER BY columns.name;

PRINT 'Validation 3 - Foreign keys from purch_invoices';

SELECT
    foreign_keys.name AS foreign_key_name,
    OBJECT_NAME(foreign_keys.parent_object_id) AS source_table,
    OBJECT_NAME(foreign_keys.referenced_object_id) AS referenced_table,
    foreign_keys.is_disabled
FROM sys.foreign_keys AS foreign_keys
WHERE foreign_keys.parent_object_id = OBJECT_ID(N'dbo.purch_invoices')
ORDER BY foreign_keys.name;

PRINT 'Validation 4 - Row counts';

SELECT 'dbo.purch_invoices' AS object_name, COUNT_BIG(*) AS row_count FROM dbo.purch_invoices
UNION ALL
SELECT 'dbo.invoice_fact', COUNT_BIG(*) FROM dbo.invoice_fact
UNION ALL
SELECT 'dbo.vendor_dim', COUNT_BIG(*) FROM dbo.vendor_dim
UNION ALL
SELECT 'dbo.date_dim', COUNT_BIG(*) FROM dbo.date_dim
UNION ALL
SELECT 'dbo.vendors', COUNT_BIG(*) FROM dbo.vendors
UNION ALL
SELECT 'dbo.automation_runs', COUNT_BIG(*) FROM dbo.automation_runs;

PRINT 'Validation 5 - Dashboard view samples';

SELECT TOP (10) *
FROM dbo.invoice_fact
ORDER BY created_at_utc DESC;

SELECT TOP (10) *
FROM dbo.vendor_dim
ORDER BY vendor_name;

SELECT TOP (10) *
FROM dbo.date_dim
ORDER BY calendar_date DESC;

PRINT 'Validation 6 - Vendor normalization duplicates from source invoices';

SELECT
    UPPER(LTRIM(RTRIM(vendor_name))) AS normalized_vendor_name,
    COUNT_BIG(*) AS invoice_count,
    COUNT(DISTINCT vendor_name) AS distinct_source_names,
    STRING_AGG(CONVERT(NVARCHAR(MAX), vendor_name), N' | ') AS source_names_sample
FROM (
    SELECT DISTINCT TOP (1000)
        vendor_name
    FROM dbo.purch_invoices
    WHERE NULLIF(LTRIM(RTRIM(vendor_name)), N'') IS NOT NULL
) AS source_vendors
GROUP BY UPPER(LTRIM(RTRIM(vendor_name)))
HAVING COUNT(DISTINCT vendor_name) > 1
ORDER BY distinct_source_names DESC, normalized_vendor_name;

PRINT 'Validation 7 - Invoice data quality signals';

SELECT
    SUM(CASE WHEN invoice_number IS NULL OR LTRIM(RTRIM(invoice_number)) = N'' THEN 1 ELSE 0 END) AS missing_invoice_number,
    SUM(CASE WHEN vendor_name IS NULL OR LTRIM(RTRIM(vendor_name)) = N'' THEN 1 ELSE 0 END) AS missing_vendor_name,
    SUM(CASE WHEN invoice_date IS NULL THEN 1 ELSE 0 END) AS missing_invoice_date,
    SUM(CASE WHEN currency_code IS NULL OR LTRIM(RTRIM(currency_code)) = N'' THEN 1 ELSE 0 END) AS missing_currency_code,
    SUM(CASE WHEN total_amount IS NULL THEN 1 ELSE 0 END) AS missing_total_amount,
    SUM(CASE WHEN needs_review = 1 THEN 1 ELSE 0 END) AS needs_review_count
FROM dbo.purch_invoices;
