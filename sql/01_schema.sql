CREATE DATABASE IF NOT EXISTS hr_data;
USE hr_data;

-- Employees
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    department VARCHAR(100),
    role VARCHAR(100),
    date_hired VARCHAR(50),
    employment_status VARCHAR(50),
    termination_date VARCHAR(50)
);

-- Performance
CREATE TABLE performance (
    employee_id INT,
    review_date VARCHAR(50),
    performance_rating DECIMAL(4,2),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Surveys
CREATE TABLE surveys (
    employee_id INT,
    survey_date VARCHAR(50),
    engagement_score INT,
    career_growth_score INT,
    team_support_score INT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Training
CREATE TABLE training (
    employee_id INT,
    training_program VARCHAR(100),
    training_hours INT,
