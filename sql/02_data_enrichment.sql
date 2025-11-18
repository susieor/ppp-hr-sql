-- ===============================================================
-- Project : Enrich HR data with additional survey and employee info
-- Purpose : Create staging tables, validate joins, update live tables,
--           verify results, then tidy up
-- Schema  : hr_data
-- ===============================================================

USE hr_data;

-- ---------------------------------------------------------------
-- 0) Session safety
-- ---------------------------------------------------------------
SET SESSION SQL_SAFE_UPDATES = 0;

-- ---------------------------------------------------------------
-- 1) Create staging tables for CSV imports
--    Safe to re-run: drops and recreates
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS employees_additional;
CREATE TABLE employees_additional (
  employee_id        INT          NOT NULL,
  salary_band        VARCHAR(20)  NULL,
  tenure_years       DECIMAL(6,2) NULL,
  exit_reason        VARCHAR(40)  NULL,
  exit_reason_notes  VARCHAR(255) NULL,
  PRIMARY KEY (employee_id)
);

DROP TABLE IF EXISTS surveys_additional;
CREATE TABLE surveys_additional (
  employee_id         INT      NOT NULL,
  wellbeing_score     TINYINT  NULL,   -- 0-10
  net_promoter_score  TINYINT  NULL,   -- 0-10
  survey_date         DATE,
  INDEX (employee_id)
);

-- Import your CSVs into employees_additional and surveys_additional here
-- using the Table Data Import Wizard or LOAD DATA INFILE

-- ---------------------------------------------------------------
-- 2) Add the new columns to live tables
--    These statements assume the columns do not already exist
-- ---------------------------------------------------------------

ALTER TABLE employees
  ADD COLUMN salary_band        VARCHAR(20)  NULL,
  ADD COLUMN tenure_years       DECIMAL(6,2) NULL,
  ADD COLUMN exit_reason        VARCHAR(40)  NULL,
  ADD COLUMN exit_reason_notes  VARCHAR(255) NULL;

ALTER TABLE surveys
  ADD COLUMN survey_date         DATE        NULL,
  ADD COLUMN wellbeing_score     TINYINT     NULL,
  ADD COLUMN net_promoter_score  TINYINT     NULL;

-- ---------------------------------------------------------------
-- 3) Validate joins before updating anything
-- ---------------------------------------------------------------

-- 3a. Employees alignment check by employee_id
SELECT 
    e.employee_id,
    e.date_hired,
    e.termination_date,
    ea.salary_band,
    ea.tenure_years,
    ea.exit_reason,
    ea.exit_reason_notes
FROM employees e
JOIN employees_additional ea 
  ON ea.employee_id = e.employee_id
LIMIT 50;

-- 3b. Surveys alignment check by employee_id + survey_date
SELECT 
  m.employee_id,
  m.survey_date   AS main_date,
  a.survey_date   AS addl_date,
  a.net_promoter_score,
  a.wellbeing_score
FROM surveys m
JOIN surveys_additional a
  ON a.employee_id = m.employee_id
 AND a.survey_date = m.survey_date
ORDER BY m.employee_id, m.survey_date
LIMIT 50;

-- ---------------------------------------------------------------
-- 4) Update live tables inside a transaction
-- ---------------------------------------------------------------

START TRANSACTION;

-- 4a. Update employees with enrichment fields from staging
UPDATE employees e
JOIN employees_additional ea 
  ON ea.employee_id = e.employee_id
SET 
  e.salary_band        = ea.salary_band,
  e.tenure_years       = ea.tenure_years,
  e.exit_reason        = ea.exit_reason,
  e.exit_reason_notes  = ea.exit_reason_notes;

-- 4b. Update surveys scores from surveys_additional using exact date match
UPDATE surveys m
JOIN surveys_additional a
  ON a.employee_id = m.employee_id
 AND a.survey_date = m.survey_date
SET 
  m.net_promoter_score = a.net_promoter_score,
  m.wellbeing_score    = a.wellbeing_score
WHERE m.net_promoter_score IS NULL 
   OR m.wellbeing_score  IS NULL;

COMMIT;

-- Spot check after updates
SELECT 
    employee_id, survey_date, net_promoter_score, wellbeing_score
FROM surveys
ORDER BY employee_id, survey_date
LIMIT 50;

-- ---------------------------------------------------------------
-- 5) Simple verification for the assignment
-- ---------------------------------------------------------------

-- How many surveys now have both scores populated
SELECT 
  COUNT(*) AS surveys_with_both_scores
FROM surveys
WHERE net_promoter_score IS NOT NULL 
  AND wellbeing_score    IS NOT NULL;

-- Sanity check the score ranges
SELECT 
  MIN(net_promoter_score) AS nps_min, 
  AVG(net_promoter_score) AS nps_avg, 
  MAX(net_promoter_score) AS nps_max,
  MIN(wellbeing_score)    AS wb_min, 
  AVG(wellbeing_score)    AS wb_avg, 
  MAX(wellbeing_score)    AS wb_max
FROM surveys;

-- ---------------------------------------------------------------
-- 6) Tidy up: drop staging once verified
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS employees_additional, surveys_additional;

-- ---------------------------------------------------------------
-- 7) Data cleaning for termination and exit fields
-- ---------------------------------------------------------------

START TRANSACTION;

-- 7.1 Set termination_date to NULL for active employees with blank dates
UPDATE employees
SET termination_date = NULL
WHERE (termination_date = '' OR termination_date IS NULL)
  AND employment_status = 'Active';

-- 7.2 Set exit_reason and exit_reason_notes to NULL for active employees
UPDATE employees
SET 
    exit_reason       = NULL,
    exit_reason_notes = NULL
WHERE employment_status = 'Active'
  AND (exit_reason = '' OR exit_reason IS NULL)
  AND (exit_reason_notes = '' OR exit_reason_notes IS NULL);

COMMIT;

-- ---------------------------------------------------------------
-- 8) Restore safe updates if your environment expects it
-- ---------------------------------------------------------------

SET SESSION SQL_SAFE_UPDATES = 1;
