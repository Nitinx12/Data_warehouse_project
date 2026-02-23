# Data Warehouse and Analytics Project

## Overview

Hi, I'm Nitin 👋

Welcome to the **Data Warehouse and Analytics Project** repository!

This is a complete end-to-end data engineering and analytics solution. I built a modern data warehouse from scratch to process raw, disconnected CSV files into an actionable, interactive Business Intelligence dashboard..

---
## Problem Statement
In the real world, data rarely lives in one perfect table. For this project, the simulated business was struggling with siloed data. Customer and sales transaction details were locked in a CRM system, while product categories, location data, and demographics were stuck in an ERP system. I needed to bridge this gap, clean the messy data, and create a single "source of truth" to answer critical business questions regarding customer retention, VIP segmentation, and product performance.

---
## How I Built the Data Warehouse
Instead of just dumping data into tables, I structured the database using the **Medallion Architecture**. This kept my pipeline organized and optimized for reporting.

1. **Bronze Layer (Raw Ingestion)**: I wrote stored procedures `(proc_load_bronze.sql)` to bulk-insert raw CSV files directly into the database. I included `TRUNCATE` commands so the pipeline can be rerun safely without duplicating data.

2. **Silver Layer (Cleaning)**: Here, I standardized the data types, handled missing values, and added a `dwh_create_date` timestamp so I could track exactly when the ETL job ran.

3. **Gold Layer (The Star Schema)**:This is where the magic happens. I joined the scattered CRM customer data with the ERP product data to create a clean, business-ready Star Schema `(ddl_gold.sql)`. I used `ROW_NUMBER()` to generate clean surrogate keys for my Fact and Dimension views..

<img width="2816" height="1536" alt="Gemini_Generated_Image_epz92xepz92xepz9" src="https://github.com/user-attachments/assets/b859cdf3-8180-4975-b2b2-9793c1beff18" />

---
## Data Sources
The pipeline ingests CSV data from two distinct simulated operational systems:
1. CRM System: `crm_cust_info`, `crm_prd_info`, `crm_sales_details`
2. ERP System: `erp_cust_az12` (Demographics), `erp_loc_a101` (Location), `erp_px_cat_g1v2` (Product Categories)

---
## Built With
* Python
* SQL (PostgreSQL)
* Pandas
* Jupyter Notebook
* Matplotlib & Seaborn
* Duckdb

## Our Data-Driven Solution
To resolve operational inefficiencies, I designed and implemented a **Centralized Relational Database System** using PostgreSQL. This solution transformed raw transactional data into actionable strategic insights.

### Key Technical Implementations & Insights

#### 1. Solved Revenue Blindness

1. **Problem:** Bikes account for 96.46% of total sales, while Accessories (2.38%) and Clothing (1.16%) barely make a dent in the overall revenue, exposing the business to a high single-category risk and leaving high-margin add-on sales on the table.

<img width="630" height="470" alt="image" src="https://github.com/user-attachments/assets/aeec622c-89d2-431a-b257-eac4d2b58556" />

2. **Action:** Implement a mandatory "Frequently Bought Together" bundling feature at checkout that offers customers a 10-15% discount on relevant accessories and clothing when purchased alongside a bike.

#### 2. Poor Customer Retention

1. **Problem:** We lose almost all our new customers right away. Out of 1,164 people who bought something in March, only 44 (3%) came back to buy again the next month.

2. **Action:** Send a follow-up email with a special discount three weeks after their first purchase to encourage them to come back and shop again.

#### 3. High Customer Churn & At-Risk Base

1. **Problem:** In our largest segments are "Lost Customers" (3,497) and "At Risk" customers (2,441). This means thousands of past buyers have either already stopped shopping with you or are right on the verge of leaving.

### Customer Segmentation Summary (RFM Analysis)

| Customer Segment | Total Customers |
| :--- | :--- |
| Others | 4,313 |
| Lost Customers | 3,497 |
| Loyal Customers | 3,213 |
| New Customers | 2,512 |
| At Risk | 2,441 |
| Champions | 1,739 |
| Potential Loyalists | 769 |
| **Total** | **18,484** |

3. **Action:** Launch an automated "We Miss You" email campaign specifically targeting the 2,441 "At Risk" customers, offering a strong 'Comeback Discount' (like 15% off) to win them back before they fall into the "Lost" category forever.




