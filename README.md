# 📊 End-to-End Sales Analysis Using Power BI & SQL Server

## 🔍 Project Overview
This project demonstrates a full Business Intelligence workflow:
- Raw CSV data ingestion
- Data cleaning and transformation
- Star Schema modeling in SQL Server
- Power BI integration
- Advanced analytics and executive-level insights

The dataset contains **51,290 records** and over **25 columns**, sourced from Kaggle.

---

## 🧱 Data Modeling
The original flat CSV file was transformed into a **Star Schema** consisting of:

### Fact Table
- fact_sales

### Dimension Tables
- dim_date
- dim_product
- dim_customer
- dim_location

This design improves query performance, scalability, and analytical clarity.

📌 *See Data_Modeling/star_schema_sql_server.png*

---

## 🧹 Data Cleaning & Challenges
- Removed redundant columns
- Fixed data type issues affecting **12,000+ profit values**
- Standardized date and numeric fields
- Ensured referential integrity across dimensions

---

## 📈 Power BI Dashboards
Three analytical dashboards were developed:

1. **Overview Dashboard**
2. **Profitability & Discount Analysis**
3. **Customer Behavior Analysis**

Additionally, an **Executive Insights** page was created to translate analytics into business decisions.

---

## 🧠 Executive Insights Summary

### 1. Strategic Pricing & Profitability Optimization
- Peak profitability (11.95%) aligned with lowest average discount (14.03%)
- Recommendation: Cap discounts at 14% for high-performing categories

### 2. Customer Loyalty vs Discount Efficiency
- High purchase frequency does not guarantee profitability
- Recommendation: Tiered loyalty program based on net profit

### 3. Category Performance & Risk Assessment
- Identified sub-categories with high discounts and low profit
- Recommendation: Immediate pricing strategy review

---

## 🛠 Tools & Technologies
- SQL Server
- Power BI
- Power Query
- Star Schema Data Modeling

---

## 🔗 Dataset Source
[Kaggle Dataset Link](https://www.kaggle.com/datasets/fatihilhan/global-superstore-dataset)

---

## 🚀 Key Takeaway
This project highlights the ability to convert raw data into actionable business insights using industry-standard BI tools.
