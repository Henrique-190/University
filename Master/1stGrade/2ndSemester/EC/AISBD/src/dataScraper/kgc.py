import pandas as pd

from kgcPy import *
from scipy.spatial.distance import cdist


weather = pd.read_csv('data/originals/weather.csv')

#only get latitude, longitude and location
weather = weather[['latitude', 'longitude', 'location']]

#lowercase location
weather['location'] = weather['location'].apply(lambda x: x.lower())

#drop duplicates
weather.drop_duplicates(inplace=True)

for index, row in weather.iterrows():
    lat = row['latitude']
    lon = row['longitude']
    kg_zone = lookupCZ(lat, lon)
    weather.at[index, 'kg_zone'] = kg_zone


# descobrir quais os climas que só têm 1 cidade
kg_zone_count = weather['kg_zone'].value_counts()
single_city_climates = kg_zone_count[kg_zone_count == 1].index

def find_nearest(row, df):
    if row['kg_zone'] in single_city_climates:
        print(f'Finding nearest for {row["location"]}')
        temp_df = df.drop(row.name)
        distances = cdist([[row['latitude'], row['longitude']]], temp_df[['latitude', 'longitude']], metric='euclidean')
        temp_df['distance'] = distances[0]
        
        nearest_row = temp_df[temp_df['kg_zone'].isin(single_city_climates) == False].nsmallest(1, 'distance')
        
        print(f'Nearest is {nearest_row["location"].values[0]}')
        return nearest_row['kg_zone'].values[0]
    else:
        return row['kg_zone']

weather['kg_zone'] = weather.apply(find_nearest, df=weather, axis=1)


weather.to_csv('data/originals/KG_zone.csv', index=False)