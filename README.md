PPP HR SQL (Appendix)

This repository contains the SQL and Python scripts used in my Professional Practice Project.
No company data is included. Only table structures, cleaning logic, enrichment steps, analysis queries and Power BI Python scripts.

Project Overview

This appendix supports the HR data analysis completed for the project.
The scripts here replicate the database schema, data enrichment workflow and analytical queries used to produce the Power BI dashboard and report findings.
All processes are fully reproducible and contain no confidential information.

Files
SQL

sql/01_schema.sql
Creates the hr_data database and all core tables used in the project.

sql/02_data_enrichment.sql
Includes staging table creation, data cleaning and enrichment steps for:
salary bands, tenure, exit information, wellbeing scores and net promoter scores.

sql/03_analysis.sql
Contains all analysis queries used to generate descriptive statistics, departmental summaries, training insights and engagement metrics.

sql/data_dictionary.md
Defines every field across all tables in the database.

Python

python/01_perf_by_completion_year.py
Line chart of average performance rating by training completion year.

python/02_training_high_vs_low_ttest.py
T-test and boxplot comparing performance for high vs low training hours.

python/03_training_vs_performance_regression.py
Linear regression and correlation analysis between training hours and performance.

python/04_perf_by_employment_status_ttest.py
T-test and boxplot comparing performance between Active and Inactive employees.

Each script mirrors the visual analysis implemented inside Power BI Python visuals.

Usage

Open MySQL Workbench or your SQL environment.

Run sql/01_schema.sql to create the full database structure.

Run sql/02_data_enrichment.sql to apply cleaning and enrichment steps.

Run any queries from sql/03_analysis.sql to reproduce the analytical outputs.

Python scripts can be run inside Power BI or a Python environment using the dataset exported from SQL.

Notes for Reviewers

This repository contains only the SQL and Python logic used for the analysis.
All scripts are structured to run independently, and the enrichment steps in 02_data_enrichment.sql match those described in the methodology section of the written report.
The queries in 03_analysis.sql and the Python scripts reflect the metrics and visuals presented in the final dashboard.
