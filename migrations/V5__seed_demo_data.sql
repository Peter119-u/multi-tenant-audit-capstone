
-- V5__seed_demo_data.sql
-- Demo data for testing the capstone system

INSERT INTO tenants (name, slug)
VALUES
    ('Acme Corporation', 'acme'),
    ('Global Retail Ltd', 'global-retail');

-- Demo users
-- Password hashes are demonstration values only.
INSERT INTO users (
    tenant_id,
    email,
    password_hash,
    role
)
SELECT
    id,
    'admin@acme.example',
    crypt('DemoPassword123!', gen_salt('bf')),
    'admin'
FROM tenants
WHERE slug = 'acme';

INSERT INTO users (
    tenant_id,
    email,
    password_hash,
    role
)
SELECT
    id,
    'manager@acme.example',
    crypt('DemoPassword123!', gen_salt('bf')),
    'manager'
FROM tenants
WHERE slug = 'acme';

INSERT INTO users (
    tenant_id,
    email,
    password_hash,
    role
)
SELECT
    id,
    'admin@global.example',
    crypt('DemoPassword123!', gen_salt('bf')),
    'admin'
FROM tenants
WHERE slug = 'global-retail';

-- Root categories for Acme
INSERT INTO categories (
    tenant_id,
    name,
    description
)
SELECT
    id,
    'Electronics',
    'Electronic products'
FROM tenants
WHERE slug = 'acme';

INSERT INTO categories (
    tenant_id,
    name,
    description
)
SELECT
    id,
    'Furniture',
    'Furniture products'
FROM tenants
WHERE slug = 'acme';

-- Child categories for Acme
INSERT INTO categories (
    tenant_id,
    parent_id,
    name,
    description
)
SELECT
    t.id,
    c.id,
    'Computers',
    'Desktop and laptop computers'
FROM tenants t
JOIN categories c
    ON c.tenant_id = t.id
WHERE t.slug = 'acme'
  AND c.name = 'Electronics';

INSERT INTO categories (
    tenant_id,
    parent_id,
    name,
    description
)
SELECT
    t.id,
    c.id,
    'Mobile Phones',
    'Smartphones and mobile devices'
FROM tenants t
JOIN categories c
    ON c.tenant_id = t.id
WHERE t.slug = 'acme'
  AND c.name = 'Electronics';

INSERT INTO categories (
    tenant_id,
    parent_id,
    name,
    description
)
SELECT
    t.id,
    c.id,
    'Office Furniture',
    'Desks and office chairs'
FROM tenants t
JOIN categories c
    ON c.tenant_id = t.id
WHERE t.slug = 'acme'
  AND c.name = 'Furniture';

-- Root category for Global Retail
INSERT INTO categories (
    tenant_id,
    name,
    description
)
SELECT
    id,
    'Home Appliances',
    'Home appliance products'
FROM tenants
WHERE slug = 'global-retail';

-- Child category for Global Retail
INSERT INTO categories (
    tenant_id,
    parent_id,
    name,
    description
)
SELECT
    t.id,
    c.id,
    'Kitchen Appliances',
    'Appliances for kitchens'
FROM tenants t
JOIN categories c
    ON c.tenant_id = t.id
WHERE t.slug = 'global-retail'
  AND c.name = 'Home Appliances';
