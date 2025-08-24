USE hr_data;

## Count of Employees by Employment Status
SELECT 
    employment_status,
    COUNT(DISTINCT employee_id) AS total_employees
FROM employees
GROUP BY employment_status;

## Top/Bottom 5 Employees by Engagement Score & Years at the Company
SELECT 
    e.employee_id,
    TIMESTAMPDIFF(YEAR, STR_TO_DATE(e.date_hired, '%d/%m/%Y'), CURDATE()) AS years_at_company, 
    s.engagement_score
FROM employees e
JOIN surveys s ON e.employee_id = s.employee_id
ORDER BY s.engagement_score DESC;

WITH ranked_engagement AS (
    SELECT 
        e.employee_id,
        e.department,
        TIMESTAMPDIFF(YEAR, STR_TO_DATE(e.date_hired, '%d/%m/%Y'), CURDATE()) AS years_at_company,
        s.engagement_score,
        ROW_NUMBER() OVER (ORDER BY s.engagement_score DESC) AS rank_desc,
        ROW_NUMBER() OVER (ORDER BY s.engagement_score ASC)  AS rank_asc
    FROM employees e
    JOIN surveys s ON e.employee_id = s.employee_id
)
SELECT employee_id, department, years_at_company, engagement_score, 'Top 5' AS group_label
FROM ranked_engagement
WHERE rank_desc <= 5
UNION ALL
SELECT employee_id, department, years_at_company, engagement_score, 'Bottom 5' AS group_label
FROM ranked_engagement
WHERE rank_asc <= 5;

## Department Summary: Avg Training, Performance, and Engagement
SELECT 
    e.department,
    e.employment_status,
    COUNT(DISTINCT e.employee_id) AS total_employees,
    ROUND(AVG(t.training_hours), 2) AS avg_training_hours,
    ROUND(AVG(p.performance_rating), 2) AS avg_performance_rating,
    ROUND(AVG(s.engagement_score), 2) AS avg_engagement
FROM employees e
LEFT JOIN training   t ON e.employee_id = t.employee_id
LEFT JOIN performance p ON e.employee_id = p.employee_id
LEFT JOIN surveys     s ON e.employee_id = s.employee_id
WHERE e.employment_status <> 'Inactive'
GROUP BY e.department, e.employment_status
ORDER BY avg_training_hours DESC;

## Count of Employees by Years at the Company
SELECT 
    TIMESTAMPDIFF(YEAR, STR_TO_DATE(date_hired, '%d/%m/%Y'), CURDATE()) AS years_at_company,
    COUNT(*) AS num_employees
FROM employees
WHERE employment_status = 'Active'
GROUP BY years_at_company
ORDER BY years_at_company;

## Employees with ≤2 and >2 Trainings by Department
SELECT 
    e.department,
    COUNT(DISTINCT CASE WHEN t.training_count > 2 THEN e.employee_id END) AS employees_with_more_than_2_trainings,
    COUNT(DISTINCT CASE WHEN t.training_count <= 2 THEN e.employee_id END) AS employees_with_2_or_less_trainings
FROM employees e
LEFT JOIN (
    SELECT employee_id, COUNT(*) AS training_count
    FROM training
    GROUP BY employee_id
) t ON e.employee_id = t.employee_id
GROUP BY e.department;

## Training Hours vs Performance: Highest Trained
SELECT 
    e.employee_id,
    ROUND(SUM(t.training_hours), 0) AS total_training,
    ROUND(AVG(p.performance_rating), 0) AS avg_performance
FROM employees e
JOIN training   t ON e.employee_id = t.employee_id
JOIN performance p ON e.employee_id = p.employee_id
GROUP BY e.employee_id
ORDER BY total_training DESC
LIMIT 10;

## Training Hours vs Performance: Lowest Trained
SELECT 
    e.employee_id,
    ROUND(SUM(t.training_hours), 0) AS total_training,
    ROUND(AVG(p.performance_rating), 0) AS avg_performance
FROM employees e
JOIN training   t ON e.employee_id = t.employee_id
JOIN performance p ON e.employee_id = p.employee_id
GROUP BY e.employee_id
ORDER BY total_training ASC
LIMIT 10;

## Engagement & Team Culture Scores by Department
SELECT 
    e.department,
    ROUND(AVG(s.engagement_score), 1)    AS avg_engagement,
    ROUND(AVG(s.career_growth_score), 1) AS avg_career_growth,
    ROUND(AVG(s.team_support_score), 1)  AS avg_support
FROM employees e
JOIN surveys s ON e.employee_id = s.employee_id
GROUP BY e.department
ORDER BY avg_support ASC;

## List of Active and Inactive Employees by Hire Year
SELECT 
    employment_status,
    YEAR(STR_TO_DATE(date_hired, '%d/%m/%Y')) AS hire_year,
    COUNT(*) AS total
FROM employees
GROUP BY employment_status, hire_year
ORDER BY hire_year, employment_status;

## Cost of training vs performance
SELECT 
    e.department,
    ROUND(SUM(t.training_cost), 2) AS total_training_spend,
    ROUND(AVG(p.performance_rating), 2) AS avg_performance
FROM employees e
JOIN training t ON e.employee_id = t.employee_id
JOIN performance p ON e.employee_id = p.employee_id
GROUP BY e.department
ORDER BY total_training_spend DESC;

## Cross-tab training by department status
SELECT 
    department,
    employment_status,
    SUM(training_hours) AS total_training_hours,
    AVG(performance_rating) AS avg_performance
FROM employees e
LEFT JOIN training t ON e.employee_id = t.employee_id
LEFT JOIN performance p ON e.employee_id = p.employee_id
GROUP BY department, employment_status;

-- Final sanity check
SELECT COUNT(*) FROM employees;
