# Migration Verification

## Objective

Verify that the complete database schema can be created successfully from an empty PostgreSQL database using the Flyway migrations.

## Migration Order

The migrations are executed in the following order:

1. V1__core_tables.sql
2. V2__indexes.sql
3. V3__audit_and_triggers.sql
4. V4__row_level_security.sql
5. V5__seed_demo_data.sql

## Required Test

The database should be empty before migration.

The expected command is:

```bash
flyway clean migrate
# Migration Verification

## Objective

Verify that the complete database schema can be created successfully from an empty PostgreSQL database using the Flyway migrations.

## Migration Order

The migrations are executed in the following order:

1. V1__core_tables.sql
2. V2__indexes.sql
3. V3__audit_and_triggers.sql
4. V4__row_level_security.sql
5. V5__seed_demo_data.sql
