\# Query Optimization Evidence



\## Query 1 — Tenant Audit History



\### 1. QUERY



Retrieve audit events for a specific tenant, ordered from newest to oldest.



```sql

SELECT

&#x20;   id,

&#x20;   tenant\_id,

&#x20;   user\_id,

&#x20;   action,

&#x20;   entity\_type,

&#x20;   entity\_id,

&#x20;   created\_at

FROM audit\_logs

WHERE tenant\_id = '66c2ba28-b29c-439b-88e1-0c9c932ebf34'

ORDER BY created\_at DESC;

```



\### 2. BEFORE PLAN



The query was tested using:



```sql

EXPLAIN (ANALYZE, BUFFERS)

```



The database contains an existing composite index:



```text

idx\_audit\_logs\_tenant\_created\_at

(tenant\_id, created\_at DESC)

```



The execution plan uses an Index Scan on this index.



\### 3. CHANGE



No additional index was added.



The existing V2 migration already provides an appropriate composite index for this workload:



```text

CREATE INDEX idx\_audit\_logs\_tenant\_created\_at

ON public.audit\_logs (tenant\_id, created\_at DESC);

```



This index supports both the tenant filtering condition and the requested descending timestamp order.



Adding another index would be redundant and would increase storage and write-maintenance overhead without providing a clear benefit.



\### 4. AFTER PLAN



The query was executed with:



```sql

EXPLAIN (ANALYZE, BUFFERS)

```



PostgreSQL selected:



```text

Index Scan using idx\_audit\_logs\_tenant\_created\_at

```



The actual execution time observed in the test should be recorded from the PostgreSQL output.



\### 5. RESULT



The optimization is provided by the existing composite index rather than by adding a duplicate index.



The important evidence is:



```text

Index Scan using idx\_audit\_logs\_tenant\_created\_at

Index Cond: (tenant\_id = ...)

```



This demonstrates that PostgreSQL can use the composite index to efficiently locate a tenant's audit records while maintaining the requested timestamp ordering.



Because the demonstration database contains only a small number of rows, the measured execution time is expected to be very small. Therefore, no artificial performance improvement claim is made.



\## Conclusion



The query optimization process was evidence-based.



Rather than adding unnecessary indexes, the existing index from the schema migration was tested with `EXPLAIN (ANALYZE, BUFFERS)`.



The result demonstrates that the schema already contains an appropriate index for tenant-specific audit-history queries.



