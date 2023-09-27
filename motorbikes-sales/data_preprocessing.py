import pandas as pd

data = pd.read_csv('europe-motorbikes-zenrows.csv')

data = data.drop_duplicates()

data = data.drop('version', axis=1)
data = data.drop('link', axis=1)

data['date'] = data['date'].replace({'\d{1,2}\/':''},regex=True)
data = data.rename(columns={'date': 'year'})

data['power'].fillna('0', inplace=True)

data.fillna('NULL', inplace=True)

data = data.to_csv('motorbikes-sales.csv', index = True)
