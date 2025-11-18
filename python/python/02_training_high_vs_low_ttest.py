"""
Script 02: T-test comparing performance for high vs low training hours

Used in a Power BI Python visual.
Assumes `dataset` includes:
- hr_data performance.performance_rating
- hr_data employees.training_hours
"""

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from scipy.stats import ttest_ind

# Rename and clean
df = dataset.rename(columns={
    'hr_data performance.performance_rating': 'performance_rating',
    'hr_data employees.training_hours': 'training_hours'
})
df = df.dropna(subset=['performance_rating', 'training_hours'])

# Create binary group based on median training hours
median_hours = df['training_hours'].median()
df['training_group'] = df['training_hours'].apply(
    lambda x: 'Low' if x <= median_hours else 'High'
)

# T-test
low = df[df['training_group'] == 'Low']['performance_rating']
high = df[df['training_group'] == 'High']['performance_rating']
t_stat, p_val = ttest_ind(high, low, equal_var=False)

# Plot
plt.figure(figsize=(8, 6))
sns.boxplot(x='training_group', y='performance_rating', data=df)
plt.title(f'Performance Rating: High vs Low Training\nT = {t_stat:.2f}, P = {p_val:.4f}')
plt.xlabel('Training Hours Group')
plt.ylabel('Performance Rating')
plt.tight_layout()
plt.show()
