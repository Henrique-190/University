import pandas as pd


meteorologia = pd.read_csv('data/originals/weather.csv')

meteorologia['week'] = pd.to_datetime(meteorologia['date'])
meteorologia.fillna(0.0, inplace=True)
meteorologia.replace('', 0.0, inplace=True)

meteorologia.set_index('week', inplace=True)
numeric_columns = ['tavg','tmin','tmax','prcp','wspd','latitude','longitude']
weekly_avg = meteorologia.groupby(['location', pd.Grouper(freq='W')])[numeric_columns].mean()

weekly_avg.to_csv('data/treated/weekly_weather.csv')
