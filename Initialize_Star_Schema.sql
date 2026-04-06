-- 1. Create Product Dimension
CREATE TABLE dim_product (
    Product_ID VARCHAR(255) PRIMARY KEY,
    Product_Name VARCHAR(255),
    Category VARCHAR(25),
    Sub_Category VARCHAR(150)
);

-- 2. Create Customer Dimension
CREATE TABLE dim_customer (
    Customer_ID VARCHAR(255) PRIMARY KEY,
    Customer_Name VARCHAR(255),
    Segment VARCHAR(50)
);

-- 3. Create Location Dimension
CREATE TABLE dim_location (
    Location_ID INT IDENTITY(1,1) PRIMARY KEY,
    City VARCHAR(150),
    State VARCHAR(150),
    Country VARCHAR(150),
    Region VARCHAR(255),
    Market VARCHAR(50)
);

-- 4. Create Date Dimension
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE,
    year INT,
    quarter INT,
    month_num INT,
    month_name VARCHAR(20),
    week_num INT,
    day_of_month INT,
    day_of_week INT,
    day_name VARCHAR(20),
    is_weekend BIT
);


-- 5. Create Sales Fact
CREATE TABLE fact_sales (
    Row_ID INT PRIMARY KEY,
    Order_ID VARCHAR(255),
    Customer_ID VARCHAR(255) REFERENCES dim_customer(Customer_ID),
    Product_ID VARCHAR(255) REFERENCES dim_product(Product_ID),
    Location_ID INT REFERENCES dim_location(Location_ID),
    order_date DATETIME ,
    ship_date DATETIME,
    date_key INT ,
    Ship_Mode VARCHAR(100),
    Order_Priority VARCHAR(100),
    Sales FLOAT,
    Quantity INT,
    Discount FLOAT,
    Shipping_Cost FLOAT,
    order_key VARCHAR(255),
    Profit DECIMAL(10,2),
    CONSTRAINT FK_fact_date_order  FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);