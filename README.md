# DATA-WAREHOUSE-PROJECT

# Modern Data Warehouse & Analytics Project

A hands-on **Data Engineering project** focused on building a modern data warehouse using **SQL Server** and implementing an end-to-end **ETL pipeline**.

The project demonstrates how raw data can be extracted, cleaned, transformed, integrated, and converted into business-ready data for analytics and reporting.

---

## 🎯 Project Overview

The main objective of this project is to build a modern data warehouse using the **Medallion Architecture**.

The architecture consists of three main layers:

- 🥉 **Bronze Layer** – Raw data
- 🥈 **Silver Layer** – Cleaned and transformed data
- 🥇 **Gold Layer** – Business-ready analytical data

The project covers the complete data engineering workflow, starting from raw CSV files and ending with structured analytical datasets.

---

## 🏗️ Data Architecture

This project follows the **Medallion Architecture** approach.

### 🥉 Bronze Layer

The Bronze layer stores the raw data as it is received from the source systems.

Main responsibilities:

- Loading raw CSV files
- Preserving source data
- Minimal transformation
- Storing raw data in SQL Server

The Bronze layer acts as the initial landing zone for the data.

---

### 🥈 Silver Layer

The Silver layer prepares the raw data for analysis.

Main transformations include:

- Data cleaning
- Removing duplicate records
- Handling NULL values
- Correcting data types
- Standardizing values
- Resolving inconsistencies
- Data validation
- Integrating data from different sources

The goal of this layer is to produce clean and reliable data.

---

### 🥇 Gold Layer

The Gold layer contains **business-ready data** designed for analytics and reporting.

This layer includes:

- Fact tables
- Dimension tables
- Star schema
- Business-ready datasets
- Analytical queries

The Gold layer provides a clean and structured interface for analysts and reporting systems.

---

## 🔄 ETL Pipeline

The project follows an end-to-end ETL process:

**Extract → Transform → Load**

### 1. Extract

Raw data is collected from different source systems in the form of CSV files.

### 2. Transform

The raw data is cleaned and transformed using SQL.

Transformation activities include:

- Removing duplicates
- Handling missing values
- Standardizing data
- Correcting data types
- Validating records
- Resolving data inconsistencies
- Integrating multiple sources

### 3. Load

The transformed data is loaded into the appropriate data warehouse layers.

```text
Source Systems
      │
      ▼
CSV Files
      │
      ▼
Bronze Layer
      │
      ▼
Silver Layer
      │
      ▼
Gold Layer
      │
      ▼
Analytics & Reporting
```
## 🔗 Connect With Me
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/abhay-shahu/)
