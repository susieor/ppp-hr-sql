"""
Script 01: Average performance rating by training completion year

Used in a Power BI Python visual.
Assumes `dataset` is the DataFrame provided by Power BI, with:
- completion_date
- hr_data performance.performance_rating
"""

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Rename and clean
df = dataset.rename(columns={
    'completion_date': 'completion_date',
    'hr_data performance.performance_rating': 'performance_rating'
})
df = df.dropna(subset=['completion_date', 'performance_rating'])

# Convert to datetime and extract year
df['completion_date'] = pd.to_datetime(df['completion_date'], errors='coerce')
df['year'] = df['completion_date'].dt.year

# Group by year and calculate average performance
yearly_avg = df.groupby('year')['performance_rating'].mean().reset_index()

# Plot
plt.figure(figsize=(8, 6))
sns.lineplot(
    x='year',
    y='performance_rating',
    data=yearly_avg,
    marker='o',
    markersize=8,
    linewidth=2
)

# Add labels below each point
for i in range(len(yearly_avg)):
    plt.text(
        x=yearly_avg['year'][i],
        y=yearly_avg['performance_rating'][i] - 0.01,
        s=f"{yearly_avg['performance_rating'][i]:.2f}",
        ha='center',
        fontsize=10
    )

plt.title('Average Performance Rating by Training Completion Year', fontsize=14, weight='bold')
plt.xlabel('Training Completion Year', fontsize=12)
plt.ylabel('Average Performance Rating', fontsize=12)
plt.xticks(yearly_avg['year'], fontsize=10)
plt.yticks(fontsize=10)
plt.grid(True, linestyle='--', alpha=0.6)
plt.tight_layout()
plt.show()
