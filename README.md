# 📊 End-to-End Sales Analysis Using Power BI & SQL Server

## 🔍 Project Overview
This project demonstrates a complete **Business Intelligence workflow** starting from raw data to actionable insights.

The solution covers:
- Raw CSV data ingestion
- Data cleaning & transformation
- Star Schema modeling in SQL Server
- Data loading using SQL scripts
- Interactive dashboards in Power BI
- Business insights and analysis

The dataset contains **51,290 records** and more than **25 columns**, sourced from Kaggle.

---

## 🗂 Project Structure

    Global-Superstore-Analysis/
    │
    ├── mapping.png                   # Star Schema diagram
    ├── Initialize_Star_Schema.sql    # Create fact & dimension tables
    ├── Load_Star_Schema.sql          # Load data into schema
    ├── superstore analytics.pbix     # Power BI dashboards (3 pages)
    ├── superstore.zip                # Raw dataset (CSV)
    ├── insight.md                    # Business insights & findings
    └── README.md                     # Project documentation


---

## 🛠 Tools & Technologies
- SQL Server  
- Power BI  
- Power Query  
- Star Schema Data Modeling  

---

## 🧱 Data Modeling

The original flat CSV file was transformed into a **Star Schema** to improve performance and analytical capabilities.

### ⭐ Fact Table
- `fact_sales`

### 📐 Dimension Tables
- `dim_date`
- `dim_product`
- `dim_customer`
- `dim_location`

## 📊 Key Insights  
*(See full details in insight.md)*

- Higher discount levels are associated with lower profit margins, though this relationship may be influenced by other factors.

- A small percentage of customers contribute disproportionately to total profit, indicating strong customer concentration.

- Certain product categories consistently show lower profitability, suggesting potential pricing or cost inefficiencies.

- Regional variations appear to impact sales and profitability, highlighting the importance of localized strategies.

---

## ⚙️ Data Pipeline

1. Extract data from CSV file  
2. Clean and transform data using Power Query / SQL  
3. Create Star Schema using:
   - `Initialize_Star_Schema.sql`  
4. Load data into tables using:
   - `Load_Star_Schema.sql`  
5. Connect Power BI to SQL Server  
6. Build dashboards and visuals  

---

## 📈 Power BI Dashboards

Three analytical dashboards were developed:

### 1. Overview Dashboard
- Total Sales, Profit, Quantity  
- Sales trends over time  
- Regional performance  

### 2. Profitability & Discount Analysis
- Impact of discounts on profit  
- Loss-making products  
- Category-level profitability  

### 3. Customer Behavior Analysis
- Top vs Bottom customers  
- Customer segmentation  
- Purchase patterns  

---

## 📊 Key Insights
(See full details in `insight.md`)

- High discounts often lead to **negative profit**
- A small percentage of customers generate a large portion of revenue
- Certain product categories consistently underperform
- Regional differences significantly impact sales performance

---

## 🚀 How to Run the Project

### 1. Database Setup
- Open SQL Server
- Run:
  - `Initialize_Star_Schema.sql`
  - `Load_Star_Schema.sql`

### 2. Power BI
- Open `superstore analytics.pbix`
- Update data source if needed
- Refresh data

---

## 🎯 Project Objective
The goal of this project is to simulate a **real-world BI solution** by:
- Designing a scalable data model   
- Creating business-ready dashboards  
- Extracting meaningful insights for decision-making  

---

## 👨‍💻 Author
**Rashad Alaa**  
Data Analyst 
