import pandas as pd
import os

import psutil

process = psutil.Process(os.getpid())

print(f'Memory Usage Before: {process.memory_info().rss / 1024 / 1024} MB')

music = pd.read_csv('data/treated/weekly_music.csv', encoding='utf-8')
music.to_parquet('data/parquet_merged/music.parquet', engine='pyarrow', compression='snappy')

weather = pd.read_csv('data/treated/weekly_weather.csv', encoding='utf-8')
weather.to_parquet('data/parquet_merged/weather.parquet', engine='pyarrow', compression='snappy')

kgc = pd.read_csv('data/originals/KG_zone.csv', encoding='utf-8')
kgc.to_parquet('data/parquet_merged/kgc.parquet', engine='pyarrow', compression='snappy')

music = pd.read_parquet('data/parquet_merged/music.parquet')
weather = pd.read_parquet('data/parquet_merged/weather.parquet')
merged_df = pd.merge(music, weather, on=['location', 'week'])
merged_df = pd.merge(merged_df, kgc[['location', 'kg_zone']], on='location')

print(f'Memory Usage After: {process.memory_info().rss / 1024 / 1024} MB')

merged_df.to_parquet('data/parquet_merged/merged.parquet', engine='pyarrow', compression='snappy')

"""
Output:
Memory Usage Before: 78.578125 MB
Memory Usage After: 104.421875 MB
"""