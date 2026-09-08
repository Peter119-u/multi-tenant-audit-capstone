Redis Integration
1. Purpose

Redis is integrated into the Multi-Tenant Audit Logging and Category Tree Management System as a caching layer for frequently accessed category-tree information.

PostgreSQL remains the primary database and system of record. Redis does not replace PostgreSQL.

The purpose of Redis is to reduce repeated database queries for category information that is frequently requested but does not need to be permanently stored in Redis.

2. Why Redis Was Chosen

Redis was chosen because it provides very fast in-memory access to frequently requested data.

Category trees are a good caching candidate because:

Category information is read frequently.
Category trees may be requested repeatedly by users.
The same category-tree data can be reused for multiple requests.
Cached data can expire and be rebuilt from PostgreSQL when necessary.
Redis provides simple key-value access suitable for this use case.
3. Why PostgreSQL Remains the System of Record

PostgreSQL remains responsible for permanent storage and data integrity.

PostgreSQL is used for:

Tenant management
User management
Category storage
Parent-child category relationships
Audit logging
Foreign-key constraints
Transactions
Row-Level Security
Durable storage
Relational queries

Redis is not used as the authoritative source of this information.

If Redis is unavailable, the application can retrieve the category tree directly from PostgreSQL and rebuild the cache.

4. Redis Cache Design

Category trees are stored using tenant-specific cache keys.

Example key:

tenant:{tenant_id}:categories

Example:

tenant:550e8400-e29b-41d4-a716-446655440000:categories

The tenant identifier is included in the key to prevent cached data from being accidentally shared between tenants.

5. Cache-Aside Strategy

The application uses a cache-aside pattern.

The process is:

The application receives a category-tree request.
The application checks Redis.
If the data exists in Redis, the cached category tree is returned.
If the data does not exist, the application queries PostgreSQL.
The application stores the result in Redis.
Future requests can be served from Redis.
When categories are changed, the affected tenant's cache entry is invalidated.

Conceptually:

Application → Redis

If cache miss:

Application → PostgreSQL → Redis → Application

6. Cache Invalidation

Redis contains temporary copies of PostgreSQL data.

When a tenant's categories are created, updated, or deleted, the corresponding tenant category cache should be invalidated.

Example:

DEL tenant:{tenant_id}:categories

The next category-tree request will query PostgreSQL and repopulate the cache.

This prevents stale category information from remaining in Redis after a database modification.

7. PostgreSQL vs Redis
Requirement	PostgreSQL	Redis
Permanent storage	Yes	No
Foreign keys	Yes	No
Transactions	Yes	Limited/different model
Row-Level Security	Yes	No
Relational queries	Yes	No
Very fast key lookup	Good	Excellent
Temporary cache	Possible	Excellent
System of record	Yes	No
Category-tree cache	Source	Cache
8. Failure Handling

Redis is an optional performance layer rather than a dependency for data correctness.

If Redis becomes unavailable:

The application continues using PostgreSQL.
Category information is retrieved from PostgreSQL.
The application can attempt to reconnect to Redis.
The cache can be rebuilt after Redis becomes available.

This design ensures that Redis failure does not result in permanent data loss.

9. Security Considerations

Tenant identifiers are included in Redis cache keys.

The application must ensure that users can only request cache keys belonging to their authorized tenant.

Redis should also be protected using appropriate network access controls and authentication in a production deployment.

10. Conclusion

Redis provides a genuine performance benefit for this project because category trees are read-heavy data that can be reused across requests.

PostgreSQL remains the authoritative database because it provides the relational integrity, transactions, security policies, audit logging, and durable storage required by the system.

The architecture therefore uses:

PostgreSQL = durable system of record

Redis = fast temporary cache
