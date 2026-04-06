-- 1.Get dataset  

-- Tasks => import flat file (superstore)
-- Profit => Decimal
------------------------------------------------------------------------------


-- Insert dim_product
INSERT INTO dim_product (Product_ID, Product_Name, Category, Sub_Category)
SELECT DISTINCT 
CONCAT([Product_ID], '-', LEFT([Product_Name], 50)) AS Product_ID
, Product_Name, Category, Sub_Category
FROM superstore;


-- Insert dim_customer
INSERT INTO dim_customer (Customer_ID, Customer_Name, Segment)
SELECT DISTINCT Customer_ID, Customer_Name, Segment
FROM superstore;


-- Insert dim_location
INSERT INTO dim_location (City, State, Country, Region, Market)
SELECT DISTINCT City, State, Country, Region, Market
FROM superstore;


-- Insert dim_date (Based on Order_Date)
INSERT INTO dim_date (
    date_key, full_date, [year], quarter, month_num, month_name,
    week_num, day_of_month, day_of_week, day_name, is_weekend
)
SELECT DISTINCT
    CAST(FORMAT(d.dt, 'yyyyMMdd') AS INT) AS date_key,
    d.dt                    AS full_date,
    YEAR(d.dt)              AS [year],
    DATEPART(QUARTER, d.dt)  AS quarter,
    MONTH(d.dt)               AS month_num,
    DATENAME(MONTH, d.dt)   AS month_name,
    DATEPART(WEEK, d.dt)     AS week_num,
    DAY(d.dt)                 AS day_of_month,
    DATEPART(WEEKDAY, d.dt)   AS day_of_week,
    DATENAME(WEEKDAY, d.dt)      AS day_name,
    CASE WHEN DATEPART(WEEKDAY, d.dt) IN (1,7)
         THEN 1 ELSE 0 END     AS is_weekend
FROM (
    SELECT CAST([Order_Date] AS DATE) AS dt FROM [dbo].superstore
) d;



-- Insert Fact Sales
INSERT INTO fact_sales (
    Row_ID, Order_ID, Customer_ID, Product_ID, Location_ID, 
    order_date, ship_date, Ship_Mode, Order_Priority, 
    Sales, Quantity, Discount, Shipping_Cost, order_key, Profit
)
SELECT 
    s.Row_ID,
    s.Order_ID,
    s.Customer_ID,
CONCAT([Product_ID], '-', LEFT([Product_Name], 50)) AS Product_ID,
    l.Location_ID,
    s.Order_Date,
    s.Ship_Date,
    s.Ship_Mode,
    s.Order_Priority,
    s.Sales,
    s.Quantity,
    s.Discount,
    s.Shipping_Cost,
    s.Order_ID as order_key, 
    s.Profit
FROM superstore s
JOIN dim_location l ON 
    s.City = l.City AND 
    s.State = l.State AND 
    s.Country = l.Country AND 
    s.Region = l.Region AND 
    s.Market = l.Market;