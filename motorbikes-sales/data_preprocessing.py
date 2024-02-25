import pandas as pd
import numpy as np

data = pd.read_csv('europe-motorbikes-zenrows.csv')

data = data.drop_duplicates()
data = data.drop('version', axis=1)
data = data.drop('link', axis=1)

data['date'] = data['date'].replace({r'\d{1,2}\/':''}, regex=True)
data = data.rename(columns={'date': 'year'})

data['power'] = pd.to_numeric(data['power'])

mean_price = np.mean(data['price'])
std_dev_price = np.std(data['price'])
mean_power = np.mean(data['power'])
std_dev_power = np.std(data['power'])
mean_mileage = np.mean(data['mileage'])
std_dev_mileage = np.std(data['mileage'])

threshold_pr = 0.5
threshold_pow = 1
threshold_mile = 5
outliers_price = data.index[abs(data['price'] - mean_price) > threshold_pr * std_dev_price]
outliers_power = data.index[abs(data['power'] - mean_power) > threshold_pow * std_dev_power]
outliers_mileage = data.index[abs(data['mileage'] - mean_mileage) > threshold_mile * std_dev_mileage]

price_out = data['price'].loc[outliers_price]
power_out = data['power'].loc[outliers_power]
mileage_out = data['mileage'].loc[outliers_mileage]

print(f"Mean Price: {round(mean_price)}, Mean Power: {round(mean_power)}, Mean Mileage: {round(mean_mileage)}.",
      f"Price Standard Deviation: {round(std_dev_price)}, Power Standard Deviation: {round(std_dev_power)}, Mileage Standard Deviation: {round(std_dev_mileage)}.",
      f"Price Outliers: {price_out.count()}\n{price_out}",
      f"Power Outliers: {power_out.count()}\n{power_out}",
      f"Mileage Outliers: {mileage_out.count()}\n{mileage_out}",
      sep = '\n\n')

outliers_indices = outliers_price.union(outliers_power).union(outliers_mileage)
cleaned_data = data.drop(outliers_indices)

cleaned_data.fillna('NULL', inplace=True)

cleaned_data.to_csv('motorbikes-sales.csv', index = True)