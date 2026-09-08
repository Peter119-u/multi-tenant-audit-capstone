-- V3__audit_and_triggers.sql
-- Automatic audit logging for important category operations

CREATE OR REPLACE FUNCTION audit_category_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    current_tenant UUID;
    current_user_id UUID;
BEGIN
    current_tenant := COALESCE(
        NULLIF(current_setting('app.current_tenant_id', true), ''),
        CASE
            WHEN TG_OP = 'DELETE' THEN OLD.tenant_id
            ELSE NEW.tenant_id
        END
    )::UUID;

    current_user_id := NULLIF(
        current_setting('app.current_user_id', true),
        ''
    )::UUID;

    IF TG_OP = 'INSERT' THEN

        INSERT INTO audit_logs (
            tenant_id,
            user_id,
            action,
            entity_type,
            entity_id,
            details
        )
        VALUES (
            current_tenant,
            current_user_id,
            'CREATE',
            'category',
            NEW.id,
            jsonb_build_object(
                'name', NEW.name,
                'parent_id', NEW.parent_id
            )
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

        INSERT INTO audit_logs (
            tenant_id,
            user_id,
            action,
            entity_type,
            entity_id,
            details
        )
        VALUES (
            current_tenant,
            current_user_id,
            'UPDATE',
            'category',
            NEW.id,
            jsonb_build_object(
                'old_name', OLD.name,
                'new_name', NEW.name,
                'old_parent_id', OLD.parent_id,
                'new_parent_id', NEW.parent_id
            )
        );

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN

        INSERT INTO audit_logs (
            tenant_id,
            user_id,
            action,
            entity_type,
            entity_id,
            details
        )
        VALUES (
            current_tenant,
            current_user_id,
            'DELETE',
            'category',
            OLD.id,
            jsonb_build_object(
                'name', OLD.name,
                'parent_id', OLD.parent_id
            )
        );

        RETURN OLD;

    END IF;

    RETURN NULL;
END;
$$;

CREATE TRIGGER trg_categories_audit
AFTER INSERT OR UPDATE OR DELETE
ON categories
FOR EACH ROW
EXECUTE FUNCTION audit_category_changes();
