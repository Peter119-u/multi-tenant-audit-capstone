-- V4__row_level_security.sql
-- Row-Level Security for multi-tenant data isolation

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY users_tenant_isolation
ON users
FOR ALL
USING (
tenant_id = NULLIF(
current_setting('app.current_tenant_id', true),
''
)::UUID
)
WITH CHECK (
tenant_id = NULLIF(
current_setting('app.current_tenant_id', true),
''
)::UUID
);

CREATE POLICY categories_tenant_isolation
ON categories
FOR ALL
USING (
tenant_id = NULLIF(
current_setting('app.current_tenant_id', true),
''
)::UUID
)
WITH CHECK (
tenant_id = NULLIF(
current_setting('app.current_tenant_id', true),
''
)::UUID
);

CREATE POLICY audit_logs_tenant_isolation
ON audit_logs
FOR ALL
USING (
tenant_id = NULLIF(
current_setting('app.current_tenant_id', true),
''
)::UUID
)
WITH CHECK (
tenant_id = NULLIF(
current_setting('app.current_tenant_id', true),
''
)::UUID
);
