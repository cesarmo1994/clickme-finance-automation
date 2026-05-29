/*
  ClickMe Admin Portal role seed.

  Target database: finance
  Purpose: seed MVP portal roles and Entra group mappings after the core schema
  exists. The script is idempotent.
*/

SET NOCOUNT ON;

IF OBJECT_ID(N'dbo.portal_roles', N'U') IS NULL
BEGIN
    THROW 51010, 'dbo.portal_roles was not found. Run 001_core_schema_and_views.sql first.', 1;
END;
GO

IF OBJECT_ID(N'dbo.portal_role_group_mappings', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.portal_role_group_mappings
    (
        portal_role_group_mapping_id BIGINT IDENTITY(1,1) NOT NULL,
        portal_role_id BIGINT NOT NULL,
        entra_group_name NVARCHAR(255) NOT NULL,
        is_direct_login_enabled BIT NOT NULL CONSTRAINT DF_portal_role_group_mappings_login DEFAULT 1,
        notes NVARCHAR(1000) NULL,
        created_at_utc DATETIMEOFFSET(0) NOT NULL CONSTRAINT DF_portal_role_group_mappings_created DEFAULT SYSUTCDATETIME(),
        CONSTRAINT PK_portal_role_group_mappings PRIMARY KEY CLUSTERED (portal_role_group_mapping_id),
        CONSTRAINT FK_portal_role_group_mappings_roles FOREIGN KEY (portal_role_id) REFERENCES dbo.portal_roles(portal_role_id),
        CONSTRAINT UQ_portal_role_group_mappings_group UNIQUE (entra_group_name)
    );
END;
GO

MERGE dbo.portal_roles AS target
USING (
    VALUES
        (N'admin', N'Admin', N'Full portal administration, roles, configuration, automation controls.'),
        (N'finance_manager', N'Finance Manager', N'Finance oversight, approvals, corrections, exports, and automation retry.'),
        (N'finance_operator', N'Finance Operator', N'Invoice review, non-financial corrections, and vendor review support.'),
        (N'operations_manager', N'Operations Manager', N'Operational and vendor/process visibility without financial amount exposure by default.'),
        (N'viewer', N'Viewer', N'Read-only dashboards and non-sensitive invoice/vendor visibility.'),
        (N'external_accountant', N'External Accountant', N'Export recipient role for accounting support; no direct login in MVP.')
) AS source(role_key, role_name, role_description)
    ON target.role_key = source.role_key
WHEN MATCHED THEN
    UPDATE SET
        role_name = source.role_name,
        role_description = source.role_description
WHEN NOT MATCHED THEN
    INSERT (role_key, role_name, role_description)
    VALUES (source.role_key, source.role_name, source.role_description);
GO

MERGE dbo.portal_role_group_mappings AS target
USING (
    SELECT
        roles.portal_role_id,
        source.entra_group_name,
        source.is_direct_login_enabled,
        source.notes
    FROM (
        VALUES
            (N'admin', N'clickme-admin-portal-admins', 1, N'Full app administration.'),
            (N'finance_manager', N'clickme-admin-portal-finance-managers', 1, N'Finance approvals, corrections, exports, and automation retry.'),
            (N'finance_operator', N'clickme-admin-portal-finance-operators', 1, N'Invoice review and non-financial corrections.'),
            (N'operations_manager', N'clickme-admin-portal-operations-managers', 1, N'Operational visibility without invoice amount exposure by default.'),
            (N'viewer', N'clickme-admin-portal-viewers', 1, N'Read-only portal visibility.'),
            (N'external_accountant', N'clickme-admin-portal-external-accountants', 0, N'Export-only in MVP; direct portal login disabled.')
    ) AS source(role_key, entra_group_name, is_direct_login_enabled, notes)
    INNER JOIN dbo.portal_roles AS roles
        ON roles.role_key = source.role_key
) AS source
    ON target.entra_group_name = source.entra_group_name
WHEN MATCHED THEN
    UPDATE SET
        portal_role_id = source.portal_role_id,
        is_direct_login_enabled = source.is_direct_login_enabled,
        notes = source.notes
WHEN NOT MATCHED THEN
    INSERT (portal_role_id, entra_group_name, is_direct_login_enabled, notes)
    VALUES (source.portal_role_id, source.entra_group_name, source.is_direct_login_enabled, source.notes);
GO

SELECT
    roles.role_key,
    roles.role_name,
    mappings.entra_group_name,
    mappings.is_direct_login_enabled,
    mappings.notes
FROM dbo.portal_roles AS roles
LEFT JOIN dbo.portal_role_group_mappings AS mappings
    ON mappings.portal_role_id = roles.portal_role_id
ORDER BY roles.role_key;
