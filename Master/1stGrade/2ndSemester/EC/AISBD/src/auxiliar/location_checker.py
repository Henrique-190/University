import pandas as pd

df1 = pd.read_csv('data/treated/weekly_music.csv', encoding='utf-8')
df2 = pd.read_csv('data/treated/weekly_weather.csv', encoding='utf-8')

unique_locations_df1 = set(df1['location'].unique())
unique_locations_df2 = set(df2['location'].unique())

common_locations = unique_locations_df1 & unique_locations_df2
locations_only_in_df1 = unique_locations_df1 - unique_locations_df2
locations_only_in_df2 = unique_locations_df2 - unique_locations_df1

print("Localizações comuns:", common_locations)
print("Localizações apenas no df1:", locations_only_in_df1)
print("Localizações apenas no df2:", locations_only_in_df2)