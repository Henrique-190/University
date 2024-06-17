import pandas as pd
from unidecode import unidecode
import numpy as np
from sklearn.preprocessing import MinMaxScaler
columns_of_interest = ['danceability', 'energy', 'valence', 'instrumentalness', 'tempo']

scaler = MinMaxScaler()

# Faz a média dos primeiros 15 registros de cada cidade e semana
def media_primeiros_15(x):
    return x.head(15).mean().round(2)

music = pd.read_csv('data/originals/CityCharts.csv')

# Converte a coluna week para datetime
music['week'] = pd.to_datetime(music['week'])
music.set_index('week', inplace=True)

# Converte a coluna location para lowercase
music['location'] = music['location'].apply(lambda x: unidecode(x).lower())

# Tratamento de valores nulos
music.fillna(0.0, inplace=True)

# Tratamento de valores vazios
music.replace('', 0.0, inplace=True)

weekly_avg_music = music.groupby(['location', pd.Grouper(freq='W')])[columns_of_interest].apply(media_primeiros_15)

# Normalização dos dados
for column in columns_of_interest:
    weekly_avg_music[column] = scaler.fit_transform(weekly_avg_music[[column]])* 30
    weekly_avg_music[column] = weekly_avg_music[column].round(2)


weekly_avg_music.to_csv('data/treated/weekly_music.csv')