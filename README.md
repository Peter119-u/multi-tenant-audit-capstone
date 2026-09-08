
# Multi-Tenant Audit Logging & Category Tree Management System

## Capstone Project

A complete database capstone project demonstrating PostgreSQL database design, versioned migrations, hierarchical category management, audit logging, row-level security, Redis caching, query optimization, backup and recovery, and database security.

---

# 1. Project Overview

The Multi-Tenant Audit Logging & Category Tree Management System is a database platform designed to allow multiple organizations (tenants) to independently manage hierarchical categories while recording important user and system activities.

PostgreSQL is the primary relational database and system of record. Redis will be integrated as a caching layer for frequently accessed category-tree information.

The project follows the complete database development lifecycle:

**Requirements → ER Design → Migrations → NoSQL → Optimization → Security → Backup & Recovery → Presentation**

---

# 2. Objectives

The system will:

* Support multiple independent tenants.
* Manage users belonging to individual tenants.
* Support user roles and permissions.
* Allow tenants to create hierarchical categories.
* Support parent-child category relationships.
* Record important user and system activities.
* Prevent cross-tenant data access.
* Use versioned Flyway migrations.
* Integrate Redis for caching where appropriate.
* Measure query performance before and after optimization.
* Provide secure database backups and tested restoration.
* Demonstrate database security best practices.

---

# 3. Functional Requirements

## Tenant Management

The system shall store tenant organizations and their basic information.

Each tenant represents an independent organization using the platform.

## User Management

The system shall store users and associate every user with a tenant.

Users shall have roles that determine their permissions within the system.

## Category Management

Each tenant shall be able to create and manage categories.

Categories shall support hierarchical relationships using a parent-child structure.

A category belongs to exactly one tenant.

## Audit Logging

The system shall record important system activities.

Audit records shall include:

* Tenant
* User
* Action
* Entity type
* Entity ID
* Additional details
* Timestamp

Examples of audited operations include:

* Category creation
* Category updates
* Category deletion
* User actions
* Security-sensitive operations

---

# 4. Security Requirements

The system shall implement PostgreSQL Row-Level Security (RLS) to isolate tenant data.

The application shall not use a PostgreSQL superuser account.

Sensitive user information shall be protected using appropriate hashing or encryption.

Application queries shall use parameterized statements.

No application query shall be constructed using unsafe string concatenation.

---

# 5. Performance Requirements

The project shall include indexes supporting common access patterns.

Important query patterns include:

* Filtering data by tenant
* Finding users by tenant
* Finding child categories
* Searching audit logs by tenant and timestamp

At least one important query shall be measured using:

```sql
EXPLAIN ANALYZE
```

Performance shall be documented using before-and-after evidence.

---

# 6. NoSQL Requirement

Redis will be used as the NoSQL component.

Redis will cache frequently accessed category-tree information.

PostgreSQL remains the system of record because it provides:

* Relational integrity
* Transactions
* Durable storage
* Foreign keys
* Row-Level Security
* Complex relational queries

Redis is appropriate for fast temporary access to frequently requested category information.

---

# 7. Database Design

The main entities are:

1. **Tenants**
2. **Users**
3. **Categories**
4. **Audit Logs**

### Relationships

* One tenant can have many users.
* One tenant can have many categories.
* One category can have many child categories.
* One tenant can have many audit logs.
* One user can generate many audit logs.
* A category can have zero or one parent category.

---

# 8. ER Diagram

The complete ER diagram will be stored in:

```text
docs/diagrams/er-diagram.png
```

The diagram will contain:

* Entities
* Attributes
* Relationships
* Cardinalities

---

# 9. Migration Plan

Database changes will be implemented as ordered Flyway migrations.

```text
V1__core_tables.sql
V2__indexes.sql
V3__audit_and_triggers.sql
V4__row_level_security.sql
V5__seed_demo_data.sql
```

The migrations must be capable of creating the database from an empty database.

Target command:

```text
flyway clean migrate
```

---

# 10. Query Optimization

For each optimized query, the following evidence will be documented:

### QUERY

The business question answered by the query.

### BEFORE PLAN

The original `EXPLAIN ANALYZE` output.

### CHANGE

The index or query modification and the reason for the change.

### AFTER PLAN

The optimized `EXPLAIN ANALYZE` output.

### RESULT

The measured improvement, such as:

```text
8.2 seconds → 40 milliseconds
```

or:

```text
Sequential Scan → Index Scan
```

---

# 11. Backup & Recovery

The project will include PostgreSQL backup and restore procedures.

Example backup:

```bash
pg_dump -Fc -f backups/capstone_YYYY-MM-DD.dump capstone
```

A test restoration will be performed to verify that the backup can actually be recovered.

---

# 12. Security Checklist

* [ ] Least-privilege database roles
* [ ] No application superuser
* [ ] RLS on multi-tenant/sensitive tables
* [ ] Sensitive fields protected
* [ ] Audit logging on critical tables
* [ ] Parameterized queries
* [ ] Backup created
* [ ] Test restore completed

---

# 13. Project Structure

```text
multi-tenant-audit-capstone/
│
├── README.md
│
├── docs/
│   ├── requirements.md
│   └── diagrams/
│       ├── er-diagram.png
│       └── er-diagram.dbml
│
├── migrations/
│   ├── V1__core_tables.sql
│   ├── V2__indexes.sql
│   ├── V3__audit_and_triggers.sql
│   ├── V4__row_level_security.sql
│   └── V5__seed_demo_data.sql
│
├── nosql/
│   └── redis.md
│
├── scripts/
│   ├── backup.sh
│   └── restore.sh
│
├── tests/
│   └── test-results.md
│
├── presentation/
│   └── capstone-presentation.md
│
└── docs/
    └── optimization.md
```

---

# 14. Project Timeline

| Day   | Deliverable                       |
| ----- | --------------------------------- |
| Day 1 | Requirements and ER Diagram       |
| Day 2 | PostgreSQL schema and migrations  |
| Day 3 | Redis integration                 |
| Day 4 | Query optimization and evidence   |
| Day 5 | Backup, security and presentation |

---

# 15. Success Criteria

The project will be considered complete when:

* The requirements are documented.
* The ER diagram is complete.
* The schema can be created from migrations.
* Flyway migrations succeed from an empty database.
* Tenant isolation is enforced.
* Audit logging works.
* Redis has a justified purpose.
* Query optimization has measurable evidence.
* Backups are created.
* A backup restore has been tested.
* Security requirements have been verified.
* A final presentation explains the architecture and design decisions.

---

# 16. Status

## Day 1 — Requirements & ER Diagram

* [x] Project selected
* [x] Requirements documented
* [ ] ER diagram completed
* [ ] Design reviewed

## Day 2 — Schema Migrations

* [ ] Core tables
* [ ] Indexes
* [ ] Audit triggers
* [ ] Row-Level Security
* [ ] Demo data
* [ ] Flyway clean migrate

## Day 3 — NoSQL

* [ ] Redis integration
* [ ] Redis justification
* [ ] PostgreSQL vs Redis explanation

## Day 4 — Optimization

* [ ] Analytical queries
* [ ] Before plans
* [ ] Index/query changes
* [ ] After plans
* [ ] Performance measurements

## Day 5 — Security & Presentation

* [ ] Backup
* [ ] Restore test
* [ ] Security checklist
* [ ] Final presentation

---

# Author

**Peter Ubaa**

Database Capstone Project
