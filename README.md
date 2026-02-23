# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository!

Usually, data projects start with a perfectly clean CSV file downloaded from the internet. But in the real world, data is messy and scattered across different systems. I built this project to simulate a real business environment: taking raw, disconnected data from two different systems (a CRM and an ERP), building a data warehouse from scratch, cleaning it, and finally extracting business insights.

---
## Data Architecture
The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:
<img width="2816" height="1536" alt="Gemini_Generated_Image_epz92xepz92xepz9" src="https://github.com/user-attachments/assets/83a30eea-8c20-4a59-a802-d93b5208c345" />

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into PostgreSQL Database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.


---
## Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.

---
## Project Requirements

### Building the Data Warehouse



