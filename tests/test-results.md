Final Test Results
Multi-Tenant Audit Logging & Category Tree Management

This document records the verification performed for the capstone project.

The results below are based on actual database and application testing.

1. Flyway Migration Test
Objective

Verify that the complete database can be created from an empty database using the ordered Flyway migrations.

Command
flyway clean migrate

Expected Result

All migrations execute successfully in order:

V1__core_tables.sql
V2__indexes.sql
V3__audit_and_triggers.sql
V4__row_level_security.sql
V5__seed_demo_data.sql

Result
Status: PASS / FAIL

Notes:
[Record the actual result here]

2. Database Schema Test
Objective

Verify that all required tables exist.

Tables
tenants
users
categories
audit_logs

Result
Status: PASS / FAIL

Notes:
[Record the actual result here]

3. Tenant Isolation Test
Objective

Verify that users from one tenant cannot access another tenant's rows.

Test

Tenant A:

SET app.current_tenant_id = 'TENANT_A_UUID';

SELECT *
FROM users;


Tenant B:

SET app.current_tenant_id = 'TENANT_B_UUID';

SELECT *
FROM users;

Expected Result

Each tenant sees only its own rows.

Result
Status: PASS / FAIL

Tenant A isolation:
PASS / FAIL

Tenant B isolation:
PASS / FAIL

Cross-tenant access blocked:
PASS / FAIL

Notes:
[Record the actual result here]

4. Audit Logging Test
Objective

Verify that critical changes create audit-log records.

Test

Perform a change to a protected entity and then query:

SELECT
    id,
    tenant_id,
    user_id,
    action,
    entity_type,
    entity_id,
    created_at
FROM audit_logs
ORDER BY created_at DESC
LIMIT 20;

Expected Result

The corresponding operation appears in the audit log.

Result
Status: PASS / FAIL

Notes:
[Record the actual result here]

5. Redis Test
Objective

Verify that Redis is used as a cache and PostgreSQL remains the system of record.

Test
Request a tenant's category tree.
Verify the first request obtains the data from PostgreSQL.
Verify the category tree is stored in Redis.
Repeat the request.
Verify the cached value can be returned.
Modify the category data.
Invalidate the affected tenant cache.
Verify the next request retrieves fresh data.
Expected Result

Redis improves repeated category-tree reads without replacing PostgreSQL.

Result
Status: PASS / FAIL

Cache hit:
PASS / FAIL

Cache invalidation:
PASS / FAIL

PostgreSQL remains source of truth:
PASS / FAIL

Notes:
[Record the actual result here]

6. Query Optimization Test
Objective

Compare query execution before and after indexing.

Query
EXPLAIN ANALYZE
SELECT
    id,
    tenant_id,
    user_id,
    action,
    entity_type,
    entity_id,
    created_at
FROM audit_logs
WHERE tenant_id = 'TENANT_UUID'
ORDER BY created_at DESC
LIMIT 50;

Before
PASTE REAL BEFORE EXPLAIN ANALYZE OUTPUT HERE

After
PASTE REAL AFTER EXPLAIN ANALYZE OUTPUT HERE

Result
Before execution time:
[REAL VALUE]

After execution time:
[REAL VALUE]

Performance change:
[CALCULATE ACTUAL CHANGE]

Plan change:
[DESCRIBE ACTUAL PLAN CHANGE]

7. Backup Test
Objective

Verify that the PostgreSQL database can be backed up.

Backup
./scripts/backup.sh

Expected Result

A custom-format PostgreSQL dump is created.

Result
Status: PASS / FAIL

Backup file:
[FILE NAME]

Backup size:
[SIZE]

Notes:
[Record the actual result here]

8. Restore Test
Objective

Verify that the backup can be restored successfully.

Test

Restore the backup into a separate test database.

Verify:

SELECT COUNT(*) FROM tenants;
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM categories;
SELECT COUNT(*) FROM audit_logs;

Result
Status: PASS / FAIL

Tenants restored:
[NUMBER]

Users restored:
[NUMBER]

Categories restored:
[NUMBER]

Audit logs restored:
[NUMBER]

Notes:
[Record the actual result here]

9. Security Checklist
Requirement	Result
Least-privilege roles	PASS / FAIL
Application is not superuser	PASS / FAIL
RLS enabled	PASS / FAIL
Tenant isolation tested	PASS / FAIL
Cross-tenant access blocked	PASS / FAIL
Password hashes used	PASS / FAIL
Audit logging enabled	PASS / FAIL
Parameterized queries	PASS / FAIL
Backup files protected	PASS / FAIL
Restore successfully tested	PASS / FAIL
10. Final Assessment

The capstone is considered complete when all required tests have been performed and the corresponding results recorded.

The project demonstrates:

Relational database design
Versioned Flyway migrations
Multi-tenant data isolation
Row-Level Security
Audit logging
Redis caching
Query optimization
Backup and recovery
Database security
Performance measurement

All final PASS results must be supported by actual test evidence.
