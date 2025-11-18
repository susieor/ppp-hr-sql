"""
Script 04: T-test comparing performance by employment status (Active vs Inactive)

Used in a Power BI Python visual.
Assumes `dataset` includes:
- hr_data performance.performance_rating
- hr_data employees.employment_status
"""

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from scipy.stats import ttest_ind

# Rename columns
df = dataset.rename(columns={
    'hr_data performance.performance_rating': 'performance_rating',
    'hr_data employees.employment_status': 'employment_status'
})

# Drop missing values
df = df.dropna(subset=['performance_rating', 'employment_status'])

# T-test calculation
active = df[df['employment_status'] == 'Active']['performance_rating']
inactive = df[df['employment_status'] == 'Inactive']['performance_rating']
t_stat, p_val = ttest_ind(active, inactive, equal_var=False)

# Plot
plt.figure(figsize=(8, 6))
sns.boxplot(x='employment_status', y='performance_rating', data=df)
plt.title(f'Performance Rating by Employment Status\nT = {t_stat:.2f}, P = {p_val:.4f}', fontsize=13)
plt.xlabel('Employment Status')
plt.ylabel('Performance Rating')
plt.tight_layout()
plt.show()
