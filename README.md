# PPP HR SQL (Appendix)

This repository contains the SQL scripts used in my Professional Practice Project.  
No company data is included. Only table structures, staging logic, enrichment steps and read-only analysis queries.

## Project Overview

This SQL appendix supports the analysis completed for my Professional Practice Project.  
The scripts included here replicate the database structure, cleaning steps, enrichment logic and analytical queries used to develop the HR dashboard and statistical findings.  
All data operations are fully reproducible and contain no confidential company information.


## Files

**`sql/01_schema.sql`**  
Creates the `hr_data` database and all base tables used in the project.

**`sql/02_data_enrichment.sql`**  
SQL script showing how additional fields (salary band, tenure, exit information, wellbeing scores and net promoter scores) were added, validated and cleaned using staging tables.

**`sql/03_analysis.sql`**  
Full set of analysis queries used to generate descriptive statistics, department-level summaries, training comparisons and engagement insights.

**`sql/data_dictionary.md`**  
Data dictionary outlining all fields across the tables in the database.

## Usage

1. Open MySQL Workbench or your SQL environment.  
2. Run `sql/01_schema.sql` to create the database structure.  
3. Run `sql/02_data_enrichment.sql` to apply the cleaning and enrichment steps described in the report.  
4. Run queries from `sql/03_analysis.sql` to reproduce the analytical outputs.

## Notes for Reviewers

This repository contains only the SQL components of the project.  
All scripts are structured so they can be run independently, and the enrichment steps in `02_data_enrichment.sql` mirror those described in the methodology section of the written report.  
The queries in `03_analysis.sql` correspond directly to the findings and Power BI dashboard visuals presented in the final submission.

