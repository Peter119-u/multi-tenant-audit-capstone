
-- V2__indexes.sql
-- Indexes for tenant isolation and common query patterns

CREATE INDEX idx_users_tenant_id
    ON users (tenant_id);

CREATE INDEX idx_categories_tenant_id
    ON categories (tenant_id);

CREATE INDEX idx_categories_parent_id
    ON categories (parent_id);

CREATE INDEX idx_categories_tenant_parent
    ON categories (tenant_id, parent_id);

CREATE INDEX idx_audit_logs_tenant_created_at
    ON audit_logs (tenant_id, created_at DESC);

CREATE INDEX idx_audit_logs_user_id
    ON audit_logs (user_id);

CREATE INDEX idx_audit_logs_entity
    ON audit_logs (entity_type, entity_id);
