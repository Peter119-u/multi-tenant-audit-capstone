Query Optimization Evidence
1. Objective

The purpose of query optimization is to identify expensive PostgreSQL queries, measure their execution plans, apply an appropriate optimization, and compare the results.

Optimization decisions are based on EXPLAIN ANALYZE rather than assumptions.

The main optimization target is tenant-specific audit-log retrieval.

2. Query 1 — Recent Audit Logs for a Tenant
QUERY

Retrieve the most recent audit-log records for a specific tenant.

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


The query filters by tenant_id, sorts by created_at in descending order, and returns only the most recent records.

3. BEFORE PLAN

The query should first be tested before applying the optimization.

Run:

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


Record the actual PostgreSQL output below.

Before
PASTE THE REAL EXPLAIN ANALYZE OUTPUT HERE

Observations

Record:

Execution time
Planning time
Scan type
Rows examined
Whether a sort operation occurred
Whether the query used an index
4. CHANGE

A composite index was created for tenant-specific audit-log queries:

CREATE INDEX idx_audit_logs_tenant_created_at
ON audit_logs (tenant_id, created_at DESC);


This index supports both major operations performed by the query:

Filtering by tenant_id
Ordering by created_at DESC

The index is defined in:

migrations/V2__indexes.sql

5. AFTER PLAN

Run the same query again after the index exists:

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


Record the actual PostgreSQL output below.

After
PASTE THE REAL EXPLAIN ANALYZE OUTPUT HERE

Observations

Record:

Execution time
Planning time
Scan type
Rows examined
Whether the sort operation was removed
Whether the composite index was used
6. RESULT

Complete this section using the actual measured results.

Example format:

Before:
Execution Time = [REAL VALUE] ms
Plan = [REAL PLAN]

After:
Execution Time = [REAL VALUE] ms
Plan = [REAL PLAN]

Improvement:
[CALCULATE THE ACTUAL CHANGE]

Result:
The composite tenant/date index improved the audit-log query by allowing
PostgreSQL to efficiently locate records for a tenant in descending
creation-date order.


No performance claim should be made without an actual measurement.

7. Query 2 — Category Children by Parent
QUERY

Retrieve the child categories belonging to a particular parent category.

SELECT
    id,
    tenant_id,
    parent_id,
    name,
    description,
    created_at
FROM categories
WHERE tenant_id = 'TENANT_UUID'
  AND parent_id = 'PARENT_UUID'
ORDER BY name;

BEFORE PLAN

Run:

EXPLAIN ANALYZE
SELECT
    id,
    tenant_id,
    parent_id,
    name,
    description,
    created_at
FROM categories
WHERE tenant_id = 'TENANT_UUID'
  AND parent_id = 'PARENT_UUID'
ORDER BY name;


Record the actual output:

PASTE THE REAL EXPLAIN ANALYZE OUTPUT HERE

CHANGE

The category table uses an index supporting tenant and parent-category lookups.

The relevant index is defined in:

migrations/V2__indexes.sql


The purpose of this index is to reduce the amount of category data PostgreSQL must inspect when finding child categories for a tenant.

AFTER PLAN

Run the same query after the index exists:

EXPLAIN ANALYZE
SELECT
    id,
    tenant_id,
    parent_id,
    name,
    description,
    created_at
FROM categories
WHERE tenant_id = 'TENANT_UUID'
  AND parent_id = 'PARENT_UUID'
ORDER BY name;


Record the actual output:

PASTE THE REAL EXPLAIN ANALYZE OUTPUT HERE

RESULT

Complete using the measured results:

Before:
Execution Time = [REAL VALUE] ms
Plan = [REAL PLAN]

After:
Execution Time = [REAL VALUE] ms
Plan = [REAL PLAN]

Result:
[DESCRIBE THE ACTUAL IMPROVEMENT]

8. Optimization Principles Used

The optimization work follows these principles:

Measure first

EXPLAIN ANALYZE is used to observe actual execution behavior rather than assuming an index will improve performance.

Optimize the access pattern

Indexes are designed around the columns used by filtering and ordering operations.

Avoid unnecessary indexes

Indexes have a storage and write-performance cost. Only indexes supporting actual application queries should be added.

Verify after the change

The same query is executed after the optimization so that the change can be measured.

Report actual evidence

Execution times and execution plans must come from PostgreSQL.

9. Summary

The main performance optimization for the capstone is tenant-aware audit-log retrieval.

The composite index:

(tenant_id, created_at DESC)


is designed to support the application's common pattern of retrieving recent audit events belonging to a specific tenant.

The final performance claim will be based on the recorded EXPLAIN ANALYZE results rather than estimated or fabricated numbers.
