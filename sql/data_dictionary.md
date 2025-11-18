# Data Dictionary

### employees
- **employee_id**: Unique identifier (Primary Key).
- **department**: Department name.
- **role**: Job title/position.
- **date_hired**: Date employee was hired (string format).
- **employment_status**: Current status (Active, Inactive).
- **termination_date**: Date of termination (if applicable).
- **salary_band***: Categorised salary range to group employees into pay bands.
- **exit_reason**: Reason for an employee leaving, such as resignation, retirement, dismissal or contract end.
- **exit_reason_notes**: Additional notes or comments explaining the context behind the exit reason.
- **tenure_years**: Total length of service calculated from date_hired to either the termination date or the current date.

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
- **net_promoter_score**: Measure of employee loyalty and likelihood to recommend the organisation, typically scored from 0 to 10.

### training
- **employee_id**: Foreign Key → employees.
- **training_program**: Name of training program.
- **training_hours**: Hours spent in training.
- **training_cost**: Cost of training.
- **completion_date**: Date training completed.
