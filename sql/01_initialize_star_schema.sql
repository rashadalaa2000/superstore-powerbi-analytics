-- ==============================================================================
-- 1. CREATE DATABASE SAFEGUARD
-- ==============================================================================
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'superstore')
BEGIN
    CREATE DATABASE superstore;
END;
GO

USE superstore;
GO

-- ==============================================================================
-- 2. DIMENSION TABLES
-- ==============================================================================

-- Product Dimension
-- The raw source Product_ID is NOT unique (same ID reused for different
-- products across markets). product_id is a plain surrogate IDENTITY.
-- Matching during ETL uses (source_product_id, product_name) together,
-- since that combination is what actually identifies a distinct product.
IF OBJECT_ID('dbo.dim_product', 'U') IS NULL
CREATE TABLE dbo.dim_product (
    product_id         INT IDENTITY(1,1) NOT NULL,
    source_product_id  VARCHAR(100)       NOT NULL,  -- original raw Product_ID from source (not unique alone)
    product_name        VARCHAR(255)      NOT NULL,
    category              VARCHAR(50)       NOT NULL,
    sub_category            VARCHAR(100)      NOT NULL,
    CONSTRAINT PK_dim_product PRIMARY KEY CLUSTERED (product_id),
    CONSTRAINT UQ_dim_product_natural UNIQUE (source_product_id, product_name)
);

-- Customer Dimension
IF OBJECT_ID('dbo.dim_customer', 'U') IS NULL
CREATE TABLE dbo.dim_customer (
    customer_id   VARCHAR(50)  NOT NULL,  -- natural key, already unique in source
    customer_name VARCHAR(255) NOT NULL,
    segment       VARCHAR(50)  NULL,
    CONSTRAINT PK_dim_customer PRIMARY KEY CLUSTERED (customer_id)
);

-- Location Dimension
-- No natural id in the source, so location_id is an IDENTITY.
-- market2 was dropped: it's just a coarser continent-level rollup of
-- market (e.g. US and Canada both collapse to "North America").
-- Unique constraint stops the same city/state/country being inserted twice.
IF OBJECT_ID('dbo.dim_location', 'U') IS NULL
CREATE TABLE dbo.dim_location (
    location_id INT IDENTITY(1,1) NOT NULL,
    city        VARCHAR(100)      NOT NULL,
    state       VARCHAR(100)      NOT NULL,
    country     VARCHAR(100)      NOT NULL,
    region      VARCHAR(50)       NULL,
    market      VARCHAR(50)       NULL,
    CONSTRAINT PK_dim_location PRIMARY KEY CLUSTERED (location_id),
    CONSTRAINT UQ_dim_location UNIQUE (city, state, country)
);

-- Shipping Junk Dimension
-- Ship_Mode x Order_Priority has very low cardinality, so instead of
-- storing both as raw text on every fact row, they're combined into
-- one small junk dimension.
IF OBJECT_ID('dbo.dim_shipping', 'U') IS NULL
CREATE TABLE dbo.dim_shipping (
    shipping_id    INT IDENTITY(1,1) NOT NULL,
    ship_mode      VARCHAR(50)       NULL,
    order_priority VARCHAR(50)       NULL,
    CONSTRAINT PK_dim_shipping PRIMARY KEY CLUSTERED (shipping_id),
    CONSTRAINT UQ_dim_shipping UNIQUE (ship_mode, order_priority)
);

-- Date Dimension
IF OBJECT_ID('dbo.dim_date', 'U') IS NULL
CREATE TABLE dbo.dim_date (
    date_key     INT         NOT NULL, -- YYYYMMDD
    full_date    DATE        NOT NULL,
    year         INT         NOT NULL,
    quarter      TINYINT     NOT NULL,
    month_num    TINYINT     NOT NULL,
    month_name   VARCHAR(15) NOT NULL,
    week_num     TINYINT     NOT NULL,
    day_of_month TINYINT     NOT NULL,
    day_of_week  TINYINT     NOT NULL,
    day_name     VARCHAR(15) NOT NULL,
    is_weekend   BIT         NOT NULL,
    CONSTRAINT PK_dim_date PRIMARY KEY CLUSTERED (date_key)
);

-- ==============================================================================
-- 3. FACT TABLE
-- ==============================================================================
-- row_id is the source's own Row_ID: it's already unique, so it's used
-- directly as the primary key (no extra surrogate identity needed).
-- '记录数' (record count, always = 1 in the source) is intentionally
-- dropped — it adds nothing that COUNT(*) doesn't already give you.

IF OBJECT_ID('dbo.fact_sales', 'U') IS NULL
CREATE TABLE dbo.fact_sales (
    row_id          INT               NOT NULL,
    order_id        VARCHAR(50)       NOT NULL,   -- degenerate dimension
    customer_id     VARCHAR(50)       NOT NULL,
    product_id      INT               NOT NULL,
    location_id     INT               NOT NULL,
    shipping_id     INT               NOT NULL,
    order_date_key  INT               NOT NULL,
    ship_date_key   INT               NOT NULL,

    -- Monetary & Quantity values fixed to DECIMAL
    sales           DECIMAL(12,2)     NOT NULL DEFAULT 0.00,
    quantity        INT               NOT NULL DEFAULT 1,
    discount        DECIMAL(4,2)      NOT NULL DEFAULT 0.00,
    shipping_cost   DECIMAL(12,2)     NOT NULL DEFAULT 0.00,
    profit          DECIMAL(12,2)     NOT NULL DEFAULT 0.00,

    CONSTRAINT PK_fact_sales PRIMARY KEY CLUSTERED (row_id),
    CONSTRAINT FK_fact_sales_customer FOREIGN KEY (customer_id) REFERENCES dbo.dim_customer(customer_id),
    CONSTRAINT FK_fact_sales_product  FOREIGN KEY (product_id)  REFERENCES dbo.dim_product(product_id),
    CONSTRAINT FK_fact_sales_location FOREIGN KEY (location_id) REFERENCES dbo.dim_location(location_id),
    CONSTRAINT FK_fact_sales_shipping FOREIGN KEY (shipping_id) REFERENCES dbo.dim_shipping(shipping_id),
    CONSTRAINT FK_fact_sales_order_date FOREIGN KEY (order_date_key) REFERENCES dbo.dim_date(date_key),
    CONSTRAINT FK_fact_sales_ship_date  FOREIGN KEY (ship_date_key)  REFERENCES dbo.dim_date(date_key)
);

-- ==============================================================================
-- 4. PERFORMANCE INDEXES
-- ==============================================================================
CREATE INDEX IX_fact_sales_order_date ON dbo.fact_sales(order_date_key);
CREATE INDEX IX_fact_sales_ship_date  ON dbo.fact_sales(ship_date_key);
CREATE INDEX IX_fact_sales_customer   ON dbo.fact_sales(customer_id);
CREATE INDEX IX_fact_sales_product    ON dbo.fact_sales(product_id);
CREATE INDEX IX_fact_sales_location   ON dbo.fact_sales(location_id);
CREATE INDEX IX_fact_sales_shipping   ON dbo.fact_sales(shipping_id);
