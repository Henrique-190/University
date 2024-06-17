import pandas as pd
import psutil
import os


process = psutil.Process(os.getpid())

print(f'Memory Usage Before: {process.memory_info().rss / 1024 / 1024} MB')

music = pd.read_csv('data/treated/weekly_music.csv', encoding='utf-8')
weather = pd.read_csv('data/treated/weekly_weather.csv', encoding='utf-8')
kgc = pd.read_csv('data/originals/KG_zone.csv', encoding='utf-8')

merged = pd.merge(music, weather, on=['week', 'location'])
merged = pd.merge(merged, kgc[['location','kg_zone']], on='location')

print(f'Memory Usage After: {process.memory_info().rss / 1024 / 1024} MB')

merged.to_parquet('data/merged_parquet/merged.parquet', engine='pyarrow', compression='snappy')
merged.to_csv('data/merged_parquet/merged.csv', index=False)

"""
Output:
Memory Usage Before: 78.375 MB
Memory Usage After: 85.02734375 MB
"""