Backup and Restore
1. Objective

The database must be recoverable after accidental deletion, corruption, or infrastructure failure.

PostgreSQL custom-format backups are used for the capstone database.

The backup format is created using pg_dump -Fc.

2. Backup Script

The repository contains:

scripts/backup.sh


The script creates a dated backup inside the backups directory.

The resulting filename follows this pattern:

capstone_YYYY-MM-DD.dump


Example:

backups/capstone_2026-09-08.dump

3. Creating a Backup

Run:

chmod +x scripts/backup.sh
./scripts/backup.sh


The script uses the DB_NAME environment variable when provided.

Default:

DB_NAME=capstone


Example:

DB_NAME=capstone ./scripts/backup.sh

4. Restore Script

The repository contains:

scripts/restore.sh


The restore script accepts a PostgreSQL custom-format dump as its argument.

Example:

./scripts/restore.sh backups/capstone_2026-09-08.dump


The script uses pg_restore with:

--clean
--if-exists


to replace existing database objects during the test restore.

5. Restore Verification

A backup is not considered successfully tested until it can be restored into a database.

The restore test should verify:

PostgreSQL accepts the backup.
All migrations/schema objects are restored.
Tables exist.
Constraints exist.
Indexes exist.
RLS policies exist.
Audit data is present.
Demo data is present.
6. Test Restore Procedure

Create a separate test database before restoring.

Example:

createdb capstone_restore_test


Then restore:

pg_restore \
  --clean \
  --if-exists \
  --dbname=capstone_restore_test \
  backups/capstone_YYYY-MM-DD.dump


Verify the restored database:

SELECT COUNT(*) FROM tenants;
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM categories;
SELECT COUNT(*) FROM audit_logs;


Also verify the database objects:

SELECT tablename
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

7. Backup Test Result

Complete this section after performing the real test.

Backup date:
[DATE]

Backup file:
[FILE NAME]

Backup command:
PASS / FAIL

Backup created:
PASS / FAIL

Restore test:
PASS / FAIL

Restored tenants:
[NUMBER]

Restored users:
[NUMBER]

Restored categories:
[NUMBER]

Restored audit logs:
[NUMBER]

Overall backup/restore result:
PASS / FAIL


Only record PASS after the operation has actually been performed.

8. Recovery Strategy

The recovery process is:

PostgreSQL failure
       |
       v
Locate latest valid backup
       |
       v
Create/recover PostgreSQL database
       |
       v
Run pg_restore
       |
       v
Verify tables and data
       |
       v
Return application to service


Regular backup testing is important because a backup that has never been restored cannot be assumed to be reliable.

9. Security

Backup files may contain sensitive tenant and user information.

Therefore:

Backup files must not be committed to GitHub.
Backup files should be stored in protected storage.
Access should be limited to authorized administrators.
Production backups should be encrypted at rest.
Retention policies should be defined for production deployments.

The repository contains the backup and restore procedures, not production database dumps.
