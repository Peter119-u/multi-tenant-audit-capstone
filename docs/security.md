Security and RLS Verification
1. Security Objective

The system uses PostgreSQL security controls to protect tenant data and maintain an audit trail of important changes.

The main security objective is to ensure that one tenant cannot access another tenant's data through the application database.

The security design uses:

Least-privilege database roles
Row-Level Security (RLS)
Tenant-aware policies
Password hashing
Audit logging
Foreign-key constraints
Parameterized queries
Protected backups
2. Least-Privilege Database Roles

The application must not connect to PostgreSQL using a superuser account.

The application database role should only have the permissions required by the application.

The PostgreSQL administrator role is reserved for:

Database administration
Migrations
Backup and restore
Security configuration

The application role should not have unrestricted administrative privileges.

Verification

Run:

SELECT
    rolname,
    rolsuper,
    rolcreaterole,
    rolcreatedb
FROM pg_roles
WHERE rolname NOT LIKE 'pg_%'
ORDER BY rolname;


Expected result:

The application role has:
rolsuper = false
rolcreaterole = false
rolcreatedb = false


Record the actual result after testing.

3. Row-Level Security

Row-Level Security is used to enforce tenant isolation at the PostgreSQL database level.

RLS is defined in:

migrations/V4__row_level_security.sql


The purpose of RLS is to ensure that the database itself restricts access to rows belonging to the current tenant.

This provides protection even if an application query accidentally omits a tenant filter.

4. Tenant Isolation Test

The tenant-isolation test should use two separate tenants.

Example:

Tenant A
Tenant ID = TENANT_A_UUID

Tenant B
Tenant ID = TENANT_B_UUID


Set the current tenant before querying:

SET app.current_tenant = 'TENANT_A_UUID';


Then query tenant-specific data:

SELECT *
FROM users;


The result should contain only records belonging to Tenant A.

Repeat for Tenant B:

SET app.current_tenant = 'TENANT_B_UUID';

SELECT *
FROM users;


The result should contain only records belonging to Tenant B.

5. Cross-Tenant Access Test

The following test attempts to access another tenant's data.

SET app.current_tenant = 'TENANT_A_UUID';

SELECT *
FROM users
WHERE tenant_id = 'TENANT_B_UUID';


Expected behavior:

Tenant B rows are not returned.


This demonstrates that database-level tenant isolation is active.

Record the actual test result:

Tenant A can access Tenant B data:
PASS / FAIL


The expected secure result is:

PASS — Tenant B data is not accessible.

6. Sensitive Data

User passwords must never be stored as plaintext.

The database should store a password hash rather than the original password.

The application is responsible for using a secure password-hashing algorithm such as Argon2id or bcrypt.

Example representation:

password_hash


rather than:

password


The database should never contain the user's original password.

7. Audit Logging

Critical database changes are recorded in the audit log.

The audit implementation is defined in:

migrations/V3__audit_and_triggers.sql


Audit records should capture information such as:

Tenant
User
Action
Entity type
Entity identifier
Timestamp
Relevant change information

Example query:

SELECT
    tenant_id,
    user_id,
    action,
    entity_type,
    entity_id,
    created_at
FROM audit_logs
ORDER BY created_at DESC
LIMIT 20;


Audit records provide traceability for important changes.

8. Parameterized Queries

Application database queries must use parameterized statements.

Unsafe example:

SELECT * FROM users WHERE email = '"
+ userInput +
"';


The application must not construct SQL by concatenating user-provided values into SQL statements.

Instead, the application should use parameters supplied separately from the SQL statement.

This reduces SQL injection risk.

9. Backup Security

Database backups may contain sensitive tenant information.

Backup files must therefore:

Not be committed to GitHub
Be stored in protected storage
Have restricted access
Be encrypted in production
Have appropriate retention controls

The repository .gitignore excludes:

backups/
*.dump
*.backup

10. Security Checklist
Security Requirement	Status
Least-privilege roles	VERIFY
Application is not superuser	VERIFY
RLS enabled	VERIFY
Tenant isolation tested	VERIFY
Cross-tenant access blocked	VERIFY
Passwords hashed	VERIFY
Audit logging enabled	VERIFY
Parameterized queries	VERIFY
Backup files protected	VERIFY
Restore tested	VERIFY
11. Final Verification Results

Complete this section after performing the tests.

Least-privilege role:
PASS / FAIL

Application superuser:
PASS / FAIL

RLS:
PASS / FAIL

Tenant isolation:
PASS / FAIL

Cross-tenant access:
PASS / FAIL

Password hashing:
PASS / FAIL

Audit logging:
PASS / FAIL

Parameterized queries:
PASS / FAIL

Backup protection:
PASS / FAIL

Restore:
PASS / FAIL


The final submission should only report PASS after the corresponding test has actually been performed.

12. Security Conclusion

The capstone uses defense-in-depth security.

PostgreSQL constraints protect data integrity.

Row-Level Security protects tenant isolation.

Audit logging provides accountability.

Password hashing protects user credentials.

Least-privilege roles reduce the impact of compromised credentials.

Parameterized queries reduce SQL injection risk.

Protected backups provide recoverability without exposing database dumps publicly.
