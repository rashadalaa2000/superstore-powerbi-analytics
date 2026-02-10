# 📊 Superstore Sales Analytics – Power BI Project

## 🔍 Project Overview
This project is an end-to-end Business Intelligence analysis built using **Power BI** and **SQL Server**.
The workflow covers raw data ingestion, data cleaning, star schema modeling, and executive-level insights.

The dataset contains **51,290 records** and over **25 columns**, originally provided as a flat CSV file.

---

## 📁 Repository Contents
This repository includes the following files:

- **superstore_analytics.pbix**  
  Power BI report containing the data model, DAX measures, and dashboards.

- **star_schema.png**  
  Star Schema design created in SQL Server, showing the fact and dimension tables.

- **superstore_dataset.zip**  
  Zipped dataset used for this analysis (originally sourced from Kaggle).

- **README.md**  
  Project documentation and explanation.

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

This modeling approach improves query performance, scalability, and analytical clarity.

---

## 🧹 Data Cleaning & Preparation
Key data preparation steps included:
- Removal of redundant columns
- Resolving data type issues affecting **12,000+ profit values**
- Standardizing numeric and date fields
- Ensuring referential integrity between fact and dimension tables

---

## 📈 Dashboards
The Power BI report includes three analytical dashboards:

1. **Overview**
2. **Profitability & Discount Analysis**
3. **Customer Behavior Analysis**

Additionally, an **Executive Insights** page summarizes key findings and business recommendations.

---

## 🧠 Executive Insights Highlights

### 1. Strategic Pricing & Profitability Optimization
- Peak profitability (11.95%) aligned with the lowest average discount (14.03%)
- Recommendation: Cap discounts at 14% for high-performing categories

### 2. Customer Loyalty vs Discount Efficiency
- High purchase frequency does not directly translate to higher profitability
- Recommendation: Shift to a tiered loyalty program based on net profitability

### 3. Category Performance & Risk Assessment
- Identified sub-categories with high discounts and low profit
- Recommendation: Re-evaluate pricing strategies for underperforming categories

---

## ⚠ Data Connection Note
The Power BI report is connected to a local SQL Server instance used for data modeling.
Since the database is not publicly hosted, data refresh may not work on other machines.
All dashboards, relationships, and measures remain fully accessible for review.

---

## 🔗 Dataset Source
Original dataset available on Kaggle:  
*(https://www.kaggle.com/datasets/fatihilhan/global-superstore-dataset)*

---

## 🚀 Key Takeaway
This project demonstrates the ability to transform raw sales data into actionable business insights using industry-standard BI tools and dimensional modeling techniques.
