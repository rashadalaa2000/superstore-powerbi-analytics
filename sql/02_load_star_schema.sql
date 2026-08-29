-- ==============================================================================
-- 1. Get dataset
-- ==============================================================================
-- Tasks => import flat file (superstore)
-- Profit => Decimal
------------------------------------------------------------------------------

USE superstore;
GO

-- ==============================================================================
-- 0. SCHEMA PATCH (safe to re-run)
-- ==============================================================================
-- No patch needed for the current product schema (source_product_id was
-- already sized correctly). Kept as a placeholder in case you resize
-- dim_product columns later.
GO

-- ==============================================================================
-- 0b. RESET (makes this script safely re-runnable)
-- ==============================================================================
-- Delete in FK-safe order: fact table first, then dimensions.
DELETE FROM dbo.fact_sales;
DELETE FROM dbo.dim_product;
DELETE FROM dbo.dim_customer;
DELETE FROM dbo.dim_location;
DELETE FROM dbo.dim_shipping;
DELETE FROM dbo.dim_date;

DBCC CHECKIDENT ('dbo.dim_product',  RESEED, 0);
DBCC CHECKIDENT ('dbo.dim_location', RESEED, 0);
DBCC CHECKIDENT ('dbo.dim_shipping', RESEED, 0);
GO

-- ==============================================================================
-- 2. Insert dim_product
-- ==============================================================================
-- Natural key for dedupe/join is the pair (source_product_id, product_name)
-- itself, matching the UQ_dim_product_natural constraint on the table
-- (Product_ID alone isn't unique in the source). product_id (the real PK)
-- is auto-generated.
INSERT INTO dbo.dim_product (source_product_id, product_name, category, sub_category)
SELECT DISTINCT
    Product_ID   AS source_product_id,
    Product_Name,
    Category,
    Sub_Category
FROM dbo.superstore;
GO

-- ==============================================================================
-- 3. Insert dim_customer
-- ==============================================================================
INSERT INTO dbo.dim_customer (customer_id, customer_name, segment)
SELECT DISTINCT Customer_ID, Customer_Name, Segment
FROM dbo.superstore;
GO

-- ==============================================================================
-- 4. Insert dim_location
-- ==============================================================================
-- DATA QUALITY NOTE: the same (City, State, Country) sometimes appears with
-- inconsistent/NULL Region or Market values in the raw source
-- (e.g. Graz/Styria/Austria). Grouped by location and picking one
-- non-NULL value per attribute with MAX() instead of a plain DISTINCT.
INSERT INTO dbo.dim_location (city, state, country, region, market)
SELECT
    City,
    State,
    Country,
    MAX(Region) AS Region,
    MAX(Market) AS Market
FROM dbo.superstore
GROUP BY City, State, Country;
GO

-- ==============================================================================
-- 5. Insert dim_shipping (junk dimension)
-- ==============================================================================
INSERT INTO dbo.dim_shipping (ship_mode, order_priority)
SELECT DISTINCT Ship_Mode, Order_Priority
FROM dbo.superstore;
GO

-- ==============================================================================
-- 6. Insert dim_date
-- ==============================================================================
-- Built from BOTH Order_Date and Ship_Date so ship_date_key always finds
-- a match, even for ship dates outside the range of order dates.
INSERT INTO dbo.dim_date (
    date_key, full_date, [year], quarter, month_num, month_name,
    week_num, day_of_month, day_of_week, day_name, is_weekend
)
SELECT DISTINCT
    CAST(FORMAT(d.dt, 'yyyyMMdd') AS INT) AS date_key,
    d.dt                                  AS full_date,
    YEAR(d.dt)                            AS [year],
    DATEPART(QUARTER, d.dt)               AS quarter,
    MONTH(d.dt)                           AS month_num,
    DATENAME(MONTH, d.dt)                 AS month_name,
    DATEPART(WEEK, d.dt)                  AS week_num,
    DAY(d.dt)                             AS day_of_month,
    DATEPART(WEEKDAY, d.dt)               AS day_of_week,
    DATENAME(WEEKDAY, d.dt)               AS day_name,
    CASE WHEN DATEPART(WEEKDAY, d.dt) IN (1,7)
         THEN 1 ELSE 0 END                AS is_weekend
FROM (
    SELECT CAST(Order_Date AS DATE) AS dt FROM dbo.superstore
    UNION
    SELECT CAST(Ship_Date AS DATE)  AS dt FROM dbo.superstore
) d;
GO

-- ==============================================================================
-- 7. Insert fact_sales
-- ==============================================================================
INSERT INTO dbo.fact_sales (
    row_id, order_id, customer_id, product_id, location_id,
    shipping_id, order_date_key, ship_date_key,
    sales, quantity, discount, shipping_cost, profit
)
SELECT
    s.Row_ID,
    s.Order_ID,
    c.customer_id,
    p.product_id,
    l.location_id,
    sh.shipping_id,
    CAST(FORMAT(s.Order_Date, 'yyyyMMdd') AS INT) AS order_date_key,
    CAST(FORMAT(s.Ship_Date,  'yyyyMMdd') AS INT) AS ship_date_key,
    -- Source numeric columns are stored as text; TRY_CAST after stripping
    -- thousands-separator commas guards against silent conversion failures.
    -- ISNULL falls back to the fact table's own defaults so a single bad
    -- source value doesn't abort the whole load.
    ISNULL(TRY_CAST(REPLACE(s.Sales, ',', '')         AS DECIMAL(12,2)), 0.00) AS Sales,
    ISNULL(TRY_CAST(REPLACE(s.Quantity, ',', '')      AS INT),           1)    AS Quantity,
    ISNULL(TRY_CAST(REPLACE(s.Discount, ',', '')      AS DECIMAL(4,2)),  0.00) AS Discount,
    ISNULL(TRY_CAST(REPLACE(s.Shipping_Cost, ',', '') AS DECIMAL(12,2)), 0.00) AS Shipping_Cost,
    ISNULL(TRY_CAST(REPLACE(s.Profit, ',', '')        AS DECIMAL(12,2)), 0.00) AS Profit
FROM dbo.superstore s
JOIN dbo.dim_product p
    ON  p.source_product_id = s.Product_ID
    AND p.product_name      = s.Product_Name
JOIN dbo.dim_customer c
    ON c.customer_id = s.Customer_ID
JOIN dbo.dim_location l
    ON  l.city    = s.City
    AND l.state   = s.State
    AND l.country = s.Country
    -- joined on city/state/country only: Region/Market were deduplicated
    -- with MAX() per location in the dim_location insert step
JOIN dbo.dim_shipping sh
    ON  ISNULL(sh.ship_mode, '')      = ISNULL(s.Ship_Mode, '')
    AND ISNULL(sh.order_priority, '') = ISNULL(s.Order_Priority, '');
GO