-- PostgreSQL initialization script for the price tracker system.
-- Includes core tables plus a seeded admin account with full permissions.
-- NOTE:
-- 1) Default seeded admin password is: Admin@123
-- 2) This script uses Spring Security's {noop} format for quick bootstrap/dev only.
-- 3) Replace it with a BCrypt/Argon2 hash before going to production.

CREATE TABLE IF NOT EXISTS roles (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255),
    full_name VARCHAR(150) NOT NULL,
    avatar_url VARCHAR(500),
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    auth_type VARCHAR(30) NOT NULL DEFAULT 'LOCAL',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_roles (
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id),
    CONSTRAINT fk_user_roles_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_role
        FOREIGN KEY (role_id)
        REFERENCES roles(id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS oauth_accounts (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    provider VARCHAR(30) NOT NULL,
    provider_user_id VARCHAR(255) NOT NULL,
    provider_email VARCHAR(255),
    access_token_hash VARCHAR(255),
    refresh_token_hash VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_oauth_provider_user UNIQUE (provider, provider_user_id),
    CONSTRAINT fk_oauth_accounts_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS data_sources (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    source_type VARCHAR(30) NOT NULL,
    endpoint_url VARCHAR(500),
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS gold_prices (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(50) NOT NULL,
    name VARCHAR(150) NOT NULL,
    buy_price NUMERIC(18, 2) NOT NULL,
    sell_price NUMERIC(18, 2) NOT NULL,
    currency VARCHAR(10) NOT NULL DEFAULT 'VND',
    source_id BIGINT,
    effective_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_gold_prices_source
        FOREIGN KEY (source_id)
        REFERENCES data_sources(id)
        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS fuel_prices (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(50) NOT NULL,
    name VARCHAR(150) NOT NULL,
    price NUMERIC(18, 2) NOT NULL,
    unit VARCHAR(20) NOT NULL DEFAULT 'VND/L',
    source_id BIGINT,
    effective_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_fuel_prices_source
        FOREIGN KEY (source_id)
        REFERENCES data_sources(id)
        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS gold_price_history (
    id BIGSERIAL PRIMARY KEY,
    gold_price_id BIGINT,
    code VARCHAR(50) NOT NULL,
    buy_price NUMERIC(18, 2) NOT NULL,
    sell_price NUMERIC(18, 2) NOT NULL,
    currency VARCHAR(10) NOT NULL DEFAULT 'VND',
    source_id BIGINT,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_gold_price_history_gold_price
        FOREIGN KEY (gold_price_id)
        REFERENCES gold_prices(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_gold_price_history_source
        FOREIGN KEY (source_id)
        REFERENCES data_sources(id)
        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS fuel_price_history (
    id BIGSERIAL PRIMARY KEY,
    fuel_price_id BIGINT,
    code VARCHAR(50) NOT NULL,
    price NUMERIC(18, 2) NOT NULL,
    unit VARCHAR(20) NOT NULL DEFAULT 'VND/L',
    source_id BIGINT,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_fuel_price_history_fuel_price
        FOREIGN KEY (fuel_price_id)
        REFERENCES fuel_prices(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_fuel_price_history_source
        FOREIGN KEY (source_id)
        REFERENCES data_sources(id)
        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS watchlists (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    item_type VARCHAR(30) NOT NULL,
    item_code VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_watchlists_user_item UNIQUE (user_id, item_type, item_code),
    CONSTRAINT fk_watchlists_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS import_logs (
    id BIGSERIAL PRIMARY KEY,
    job_name VARCHAR(100) NOT NULL,
    item_type VARCHAR(30) NOT NULL,
    source_id BIGINT,
    status VARCHAR(30) NOT NULL,
    total_records INTEGER NOT NULL DEFAULT 0,
    message TEXT,
    started_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    finished_at TIMESTAMP,
    CONSTRAINT fk_import_logs_source
        FOREIGN KEY (source_id)
        REFERENCES data_sources(id)
        ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_oauth_accounts_user_id
    ON oauth_accounts(user_id);

CREATE INDEX IF NOT EXISTS idx_gold_prices_code_effective_time
    ON gold_prices(code, effective_time DESC);

CREATE INDEX IF NOT EXISTS idx_fuel_prices_code_effective_time
    ON fuel_prices(code, effective_time DESC);

CREATE INDEX IF NOT EXISTS idx_gold_price_history_code_changed_at
    ON gold_price_history(code, changed_at DESC);

CREATE INDEX IF NOT EXISTS idx_fuel_price_history_code_changed_at
    ON fuel_price_history(code, changed_at DESC);

CREATE INDEX IF NOT EXISTS idx_watchlists_user_id
    ON watchlists(user_id);

CREATE INDEX IF NOT EXISTS idx_import_logs_job_name_started_at
    ON import_logs(job_name, started_at DESC);

INSERT INTO roles (code, name, description)
VALUES
    ('ROLE_ADMIN', 'Administrator', 'Full system permissions'),
    ('ROLE_USER', 'User', 'Standard authenticated user permissions')
ON CONFLICT (code) DO UPDATE
SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    updated_at = CURRENT_TIMESTAMP;

INSERT INTO users (
    email,
    password_hash,
    full_name,
    avatar_url,
    status,
    auth_type
)
VALUES (
    'admin@pricetracker.local',
    '{noop}Admin@123',
    'System Administrator',
    NULL,
    'ACTIVE',
    'LOCAL'
)
ON CONFLICT (email) DO UPDATE
SET
    password_hash = EXCLUDED.password_hash,
    full_name = EXCLUDED.full_name,
    status = EXCLUDED.status,
    auth_type = EXCLUDED.auth_type,
    updated_at = CURRENT_TIMESTAMP;

INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id
FROM users u
JOIN roles r ON r.code IN ('ROLE_ADMIN', 'ROLE_USER')
WHERE u.email = 'admin@pricetracker.local'
ON CONFLICT (user_id, role_id) DO NOTHING;

INSERT INTO data_sources (code, name, source_type, endpoint_url, status)
VALUES
    ('MANUAL_ADMIN', 'Manual Admin Input', 'MANUAL', NULL, 'ACTIVE'),
    ('EXTERNAL_SAMPLE', 'External Sample Source', 'API', 'https://example.com/api/prices', 'INACTIVE')
ON CONFLICT (code) DO UPDATE
SET
    name = EXCLUDED.name,
    source_type = EXCLUDED.source_type,
    endpoint_url = EXCLUDED.endpoint_url,
    status = EXCLUDED.status,
    updated_at = CURRENT_TIMESTAMP;
