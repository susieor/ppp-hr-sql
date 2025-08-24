# Data Dictionary

### employees
- **employee_id**: Unique identifier (Primary Key).
- **department**: Department name.
- **role**: Job title/position.
- **date_hired**: Date employee was hired (string format).
- **employment_status**: Current status (Active, Inactive).
- **termination_date**: Date of termination (if applicable).

### performance
- **employee_id**: Foreign Key → employees.
- **review_date**: Date of performance review.
- **performance_rating**: Numeric rating (e.g. 3.50).

### surveys
- **employee_id**: Foreign Key → employees.
- **survey_date**: Date of survey.
- **engagement_score**: Overall engagement.
- **career_growth_score**: Career progression score.
- **team_support_score**: Team support/culture score.

### training
- **employee_id**: Foreign Key → employees.
- **training_program**: Name of training program.
- **training_hours**: Hours spent in training.
- **training_cost**: Cost of training.
- **completion_date**: Date training completed.
