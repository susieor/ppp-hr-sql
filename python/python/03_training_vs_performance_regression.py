"""
Script 03: Linear regression and correlation between training hours and performance

Used in a Power BI Python visual.
Assumes `dataset` includes:
- hr_data performance.performance_rating
- training_hours
"""

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score
from scipy.stats import pearsonr

# Rename columns
df = dataset.rename(columns={
    'hr_data performance.performance_rating': 'performance_rating',
    'training_hours': 'training_hours'
})

# Drop missing values
df = df.dropna(subset=['performance_rating', 'training_hours'])

# Reshape for sklearn
X = df['training_hours'].values.reshape(-1, 1)
y = df['performance_rating'].values

# Linear regression
model = LinearRegression()
model.fit(X, y)
y_pred = model.predict(X)
r2 = r2_score(y, y_pred)

# Pearson correlation
corr, _ = pearsonr(df['training_hours'], df['performance_rating'])

# Plot
plt.figure(figsize=(8, 6))
sns.scatterplot(
    x='training_hours',
    y='performance_rating',
    data=df,
    edgecolor='black'
)
plt.plot(
    df['training_hours'],
    y_pred,
    linestyle='--',
    label=f'Regression Line\n$R^2$ = {r2:.2f}, r = {corr:.2f}'
)
plt.title('Training Hours vs Performance Rating', fontsize=13)
plt.xlabel('Training Hours')
plt.ylabel('Performance Rating')
plt.legend()
plt.tight_layout()
plt.show()
