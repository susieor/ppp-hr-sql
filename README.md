## PPP HR SQL (Appendix)

This repository contains the SQL scripts used in my Professional Practice Project.
No company data is included. Only table structures, staging scripts and read-only analysis queries are provided.

## Files

sql/schema.sql
Creates the hr_data database and all base tables used in the project.

sql/analysis.sql
Full set of analysis queries used to generate metrics, descriptive statistics and department level insights.

sql/data_enrichment.sql
SQL script showing how additional fields (salary band, tenure, exit data and wellbeing metrics) were added, validated and cleaned using staging tables.

sql/data_dictionary.md
Data dictionary outlining all fields across the tables.

## Usage

Open MySQL.

Run sql/schema.sql to create the full database structure.

Run sql/data_enrichment.sql if you want to replicate the cleaning and enrichment steps shown in the report.

Run queries from sql/analysis.sql to reproduce the analytical outputs.
