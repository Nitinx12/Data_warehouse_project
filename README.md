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

---
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

Customer Segmentation Summary (RFM Analysis)

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

2. **Action:** Launch an automated "We Miss You" email campaign specifically targeting the 2,441 "At Risk" customers, offering a strong 'Comeback Discount' (like 15% off) to win them back before they fall into the "Lost" category forever.

## Power BI Dashboard & Visualizations

To bring these SQL insights to life, an interactive Power BI dashboard was developed.

<img width="1310" height="747" alt="image" src="https://github.com/user-attachments/assets/0f17fefa-8287-4056-a2f6-aa582108ad73" />

---
## Project Structure
```
Data Warehouse and Analytics Project/
│
├── README.md
│   └─ Project overview, architecture, setup steps, screenshots
│
├── docs/
│   └── data_catalog.md
│       └─ Business definitions, table descriptions, schema details
│
├── datasets/
│   ├── raw/
│   │   ├── crm/
│   │   │   └─ prd_info.csv
│   │   └── erp/
│   │       └─ PX_CAT_G1V2.csv
│   │
│   └── sample_output/
│       └─ Optional sample exports for demo purposes
│
├── database/
│   ├── init_database.sql
│   │   └─ Creates database and schemas (bronze/silver/gold)
│   │
│   └── ddl/
│       ├── bronze/
│       │   └─ ddl_bronze.sql
│       │       └─ Raw ingestion tables
│       │
│       ├── silver/
│       │   └─ ddl_silver.sql
│       │       └─ Cleaned & transformed tables
│       │
│       └── gold/
│           └─ ddl_gold.sql
│               └─ Business-ready dimensional tables
│
├── etl/
│   ├── bronze/
│   │   └─ proc_load_bronze.sql
│   │       └─ Load raw data into bronze layer
│   │
│   ├── silver/
│   │   └─ proc_load_silver.sql
│   │       └─ Transform bronze → silver
│   │
│   └── gold/
│       └─ proc_load_gold.sql (optional)
│           └─ Transform silver → gold
│
├── tests/
│   ├── quality_check_silver.sql
│   │   └─ Data validation rules for silver layer
│   │
│   └── quality_check_gold.sql
│       └─ Business-level validation checks
│
├── analytics/
│   ├── eda/
│   │   └── eda.sql
│   │       └─ Exploratory analysis queries
│   │
│   ├── advanced_sql/
│   │   ├── change_over_time.sql
│   │   ├── cohort_analysis.sql
│   │   ├── cumulative_analysis.sql
│   │   ├── data_segmentation.sql
│   │   ├── part_to_whole_analysis.sql
│   │   ├── performance_analysis.sql
│   │   └── rfm_analysis.sql
│   │       └─ Advanced analytical techniques
│   │
│   └── reports/
│       ├── customer_report.sql
│       └── product_report.sql
│           └─ Final business reporting queries
│
├── notebooks/
│   └─ Jupyter notebooks for analysis, prototyping, ML experiments
│
├── dashboards/
│   └── power_bi/
│       ├── Customer_Report.pbix
│       └── customer_report.sql
│           └─ BI dashboard files and query sources
│
└── assets/
    └─ Images, ERD diagrams, screenshots for README
```

---
## Installation & Usage
To replicate this data warehouse and analytics project, follow these steps:

1. **Clone the Repository:**
   ```Bash
   git clone git clone https://github.com/Nitinx12/Data_warehouse_project.gitcd Data_warehouse_project
   ```
2. **Set Up PostgreSQL Database:**
   * Ensure you have PostgreSQL installed.
   * Create the database and set up the Medallion Architecture schemas `(bronze, silver, gold)` by executing the initialization script:
   ```SQL
   -- Execute the script located at:
    database/init_database.sql
   ```
   * Create the necessary tables by running the DDL scripts located in the `database/ddl/` subdirectories `(bronze/, silver/, gold/)`.
3. **Load Data (ETL Pipeline):**
   * Ensure your raw `.csv` files from the CRM and ERP systems are placed in the `datasets/raw/` directory.
   * Run the stored procedures in the `etl/` directory to move data through the pipeline:
     * Execute `etl/bronze/proc_load_bronze.sql` to bulk-insert raw data.
     * Execute `etl/silver/proc_load_silver.sql` to clean and standardize.
     * Execute `etl/gold/proc_load_gold.sql` to generate the final Star Schema.
4. **Install Python Dependencies:**
   * Create a requirements.txt file with the following content to set up your environment for exploratory data analysis (EDA):
   ```text
   pandas
   sqlalchemy
   psycopg2-binary
   matplotlib
   seaborn
   jupyter
   duckdb
   ```
   * Then, run the installation command:
   ```Bash
   pip install -r requirements.txt
   ```
5. **Run Analysis & View Dashboards:**
   * SQL Analysis: Execute the queries inside the `analytics/` folder (such as `analytics/advanced_sql/rfm_analysis.sql` or                 `analytics/reports/customer_report.sql`) using a SQL client like DBeaver, pgAdmin4, or `psql`.
   * Notebooks: Launch Jupyter Notebook and explore the files in the `notebooks/` directory to see Python-based ML experiments or EDA.
   * Business Intelligence: Open `dashboards/power_bi/Customer_Report.pbix` in Power BI Desktop to interact with the final visualizations.
6. **Run Analysis:**
    * **For SQL Analysis:** Execute the queries in `customer_report.sql` using a SQL client like DBeaver, pgadmin4 or `psql`.
```sql
CREATE VIEW gold.customer_report AS
WITH Base_query AS(
	SELECT
		F.order_number,
		F.product_key,
		F.order_date,
		F.sales,
		F.quantity,
		C.customer_key,
		C.customer_number,
		CONCAT(C.first_name,' ',C.last_name) AS customer_name,
		EXTRACT(YEAR FROM AGE(C.birth_date)) AS age
	FROM gold.fact_sales AS F
	LEFT JOIN gold.dim_customers AS C
	ON C.customer_key = F.customer_key
	WHERE F.order_date IS NOT NULL
),
Metrics AS(
	SELECT
		customer_key,
		customer_number,
		customer_name,
		age,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT product_key) AS total_products,
		MAX(order_date) AS last_order_date,
		MIN(order_date) AS first_order_date,
		EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
   	 	EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS lifespan_months
	FROM Base_query
	GROUP BY
		customer_key,
		customer_number,
		customer_name,
		age		
)
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE
		WHEN age < 20
		THEN 'Under 20'
		WHEN age BETWEEN 20 AND 29
		THEN '20-29'
		WHEN age BETWEEN 30 AND 39
		THEN '30-39'
		WHEN age BETWEEN 40 AND 49
		THEN '40-49'
		ELSE '50 and above'
	END AS age_group,	
	CASE
		WHEN lifespan_months >= 12 AND total_sales > 5000
		THEN 'VIP'
		WHEN lifespan_months >= 12 AND total_sales <= 5000
		THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	last_order_date,
	CURRENT_DATE - last_order_date AS recency,
	first_order_date,
	lifespan_months,
	CASE
		WHEN total_orders = 0
		THEN 0
		ELSE ROUND(total_sales / total_orders,2)
	END AS avg_order_value,
	CASE
		WHEN lifespan_months = 0
		THEN total_sales
		ELSE ROUND(total_sales / lifespan_months,2)
	END AS avg_monthly_spend
FROM Metrics
```
