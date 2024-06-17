import json
import pandas
import requests
import time

from datetime import datetime
from meteostat import Point, Daily, Stations
from unidecode import unidecode


global CITIES_SEARCHED
CITIES_SEARCHED: list[str] = []

global CITIES_TO_SEARCH
CITIES_TO_SEARCH: list[str] = []

global CITIES_REAL_NAME
CITIES_REAL_NAME: dict[str, str] = {}

FROM = datetime(2021, 10, 14)
TO = datetime(2024, 5, 30)

def get_cities_to_search():
    with open('data/originals/country_code.json', 'r', encoding='utf-8') as f:
        codes = json.load(f)

        with open('data/originals/country_cities.json', 'r', encoding='utf-8') as f:
            cities_dict = json.load(f)
            for country, cities in cities_dict.items():
                for city in cities:
                    city_sanitized = unidecode(city.lower())
                    CITIES_TO_SEARCH.append([city_sanitized, codes[country]])
                    CITIES_REAL_NAME[city_sanitized] = city

def get_country_code(code: str):
    with open('data/originals/country_code.json', 'r', encoding='utf-8') as f:
        for k, v in json.load(f).items():
            if v.upper() == code:
                return k.lower()

def main():
    stations = Stations()
    get_cities_to_search()

    with open('data/originals/weather.csv', 'w', encoding='utf-8') as f:
        f.write('date,temperature_average,temperature_minimum,temperature_maximum,precipitation,wind_speed,location,latitude,longitude\n')

    req = requests.get(
        'http://mesonet.agron.iastate.edu/geojson/network/AZOS.geojson',
        timeout=60,
    )
    geojson = req.json()
    for feature in geojson['features']:
        props = feature['properties']
        city = props['sname'].lower()
        country = props['country']

        latitude, longitude = feature['geometry']['coordinates']
        
        if (city,country) in CITIES_SEARCHED or [city.lower(), country.lower()] not in CITIES_TO_SEARCH:
            continue
        time.sleep(1)
        CITIES_SEARCHED.append((city, country))


        try:
            longitude, latitude = feature['geometry']['coordinates']
        except:
            print(f'Could not find coordinates for {city} - {country}')
            continue
        stations = stations.nearby(float(latitude), float(longitude))
        station = stations.fetch(1)

        if station.empty:
            print(f'Could not find station for {city} - {country}')
            continue

        try:
            location = Point(station.latitude.iloc[0], station.longitude.iloc[0])
        except Exception as e:
            print(f'Could not put coordinates for {city} - {country}')
            print(e)
            continue

        data = Daily(location, FROM, TO)
        data = data.fetch()
        dt = pandas.DataFrame(data)
        dt.drop(columns=['wdir', 'wpgt', 'pres', 'tsun', 'snow'], inplace=True)
        
        dt['location'] = f'{city}, {get_country_code(country)}'
        dt['latitude'] = latitude
        dt['longitude'] = longitude

        dt.to_csv('data/originals/weather.csv', header=False, mode='a', encoding='utf-8')

        print(f'Weather data for {city}, {get_country_code(country)} has been saved')
        time.sleep(1)


if __name__ == '__main__':
    main()