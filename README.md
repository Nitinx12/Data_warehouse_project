# Data Warehouse and Analytics Project

## Overview

Hi, I'm Nitin 👋

Welcome to the **Data Warehouse and Analytics Project** repository!

This is a complete end-to-end data engineering and analytics solution. I built a modern data warehouse from scratch to process raw, disconnected CSV files into an actionable, interactive Business Intelligence dashboard..

---
## Problem Statement
In the real world, data rarely lives in one perfect table. For this project, the simulated business was struggling with siloed data. Customer and sales transaction details were locked in a CRM system, while product categories, location data, and demographics were stuck in an ERP system. I needed to bridge this gap, clean the messy data, and create a single "source of truth" to answer critical business questions regarding customer retention, VIP segmentation, and product performance.

---
## Architecture
To keep the data pipeline organized, robust, and scalable, I designed the backend using the **Medallion Architecture**.
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



