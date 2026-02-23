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



