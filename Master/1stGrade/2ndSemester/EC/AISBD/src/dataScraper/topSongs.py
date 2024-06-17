import csv
import datetime
import dotenv
import json
import os
import spotipy
import time

from bs4 import BeautifulSoup
from selenium import webdriver
from spotipy.oauth2 import SpotifyClientCredentials
from unidecode import unidecode

dotenv.load_dotenv()

spotify = spotipy.Spotify(
                auth_manager=SpotifyClientCredentials(
                    client_id=os.getenv("SPOTIFY_CLIENT_ID"),
                    client_secret=os.getenv("SPOTIFY_CLIENT_SECRET")
                )
            )


class Song():
    artist : str
    title : str

    def __init__(self, artist: str, title: str, id: str):
        self.artist = artist
        self.title = title
        self.id = id

    def toList(self):
        return [self.danceability, self.energy, self.loudness, self.speechiness, self.accousticness, self.instrumentalness, self.valence, self.tempo]
    
    def addDetails(
            self, danceability: str, energy: str, loudness: str, speechiness: str, accousticness: str,
            instrumentalness: str, valence: str, tempo: str
            ):
        self.danceability = danceability
        self.energy = energy
        self.loudness = loudness
        self.speechiness = speechiness
        self.accousticness = accousticness
        self.instrumentalness = instrumentalness
        self.valence = valence
        self.tempo = tempo


ids_set: set[str] = set() # Set de ids de músicas
songs_dict: dict[str, Song] = {} # Dicionário de músicas
citytopweek: dict[str, list[Song]] = {} # Dicionário de semanas com lista de músicas
city_country: dict[str, str] = {} # Dicionário de cidades com país

def spotifySearch() -> dict:
    for id_songs in [list(ids_set)[i:i+100] for i in range(0, len(ids_set), 100)]:
        details_songs = spotify.audio_features(id_songs)
        for i in range(len(details_songs)):
            try:
                songs_dict[id_songs[i]].addDetails(
                    details_songs[i].get("danceability", "0.0"), details_songs[i].get("energy", "0.0"), details_songs[i].get("loudness", "0.0"), 
                    details_songs[i].get("speechiness", "0.0"), details_songs[i].get("acousticness", "0.0"), details_songs[i].get("instrumentalness", "0.0"), 
                    details_songs[i].get("valence", "0.0"), details_songs[i].get("tempo", "0.0")
                    )
            except Exception as e:
                print("\n\nNot possible to add details to song:")
                print(e)
                print(songs_dict[id_songs[i]])
                continue

    ids_set.clear()


def spotifyChart(city: str, driver: webdriver):
    url: str = f"https://charts.spotify.com/charts/view/citytoptrack-{city}-weekly/"
    
    week : datetime.datetime = datetime.datetime.strptime("2021-10-21", "%Y-%m-%d")
    now : datetime.datetime = datetime.datetime.now()

    
    while week < now:
        week_str = week.strftime("%Y-%m-%d")
        driver.get(url + week_str)
        time.sleep(0.5)
        content: BeautifulSoup = BeautifulSoup(driver.page_source, "html.parser")
        songs_week: list[Song] = []
        for song_details in content.find_all("div", class_="styled__StyledThumbnail-sc-135veyd-13 jaRpim"):
            params = song_details.find("div", class_="styled__Wrapper-sc-135veyd-14 gPJpnT")
            uri = params.find("a")["href"]
            if uri not in songs_dict or not hasattr(songs_dict[uri], "danceability"):
                title, artists = params.find_all("div", class_="styled__PopoverContainer-sc-135veyd-11 dDwVGB")
                songs_dict[uri] = Song(artists.text, title.text.strip(), uri)
                ids_set.add(uri)

            songs_week.append(songs_dict[uri])

        citytopweek[week_str] = songs_week
        week += datetime.timedelta(days=7)


def fill_city():
    for week in citytopweek:
        for i in range(len(citytopweek[week])):
            citytopweek[week][i] = songs_dict[citytopweek[week][i].id]


def writeCSV(location: str):
    with open("data/originals/CityCharts.csv", mode="a", newline='', encoding="utf-8") as file:
        csvwriter = csv.writer(file)

        for week in citytopweek:
            for song in citytopweek[week]:
                try:
                    song_csv = song.toList()
                    csvwriter.writerow([week, location] + song_csv)
                except Exception as e:
                    print("\n\nNot possible to write song to csv:")
                    print(e)
                    print(song)


def sanitize(city: str) -> str:
    return unidecode(city.replace(" ", "")).lower()


def main():
    options = webdriver.ChromeOptions()
    options.add_argument("start-maximized")
    options.add_argument("disable-infobars")
    options.add_argument("--disable-extensions")
    driver: webdriver = webdriver.Chrome(options=options)
    driver.get("https://accounts.spotify.com/en/login")
    time.sleep(1)
    driver.find_element("id","login-username").send_keys(os.getenv("SPOTIFY_EMAIL"))
    driver.find_element("id","login-password").send_keys(os.getenv("SPOTIFY_PASSWORD"))
    driver.find_element("id","login-button").click()
    time.sleep(30)
    
    with open("data/originals/CityCharts2.csv", mode="w", newline='', encoding="utf-8") as file:
        csvwriter = csv.writer(file)
        csvwriter.writerow(["week", "location", "danceability", "energy", "loudness", "speechiness", "accousticness", "instrumentalness", "valence", "tempo"])
    
    with open("data/originals/country_cities.json", "r", encoding="utf-8") as file:
        city_country = json.load(file)

    for country, cities in city_country.items():
        for city in cities:
            print(f"Getting data from {city}, {country}")
            spotifyChart(sanitize(city), driver)

            city = unidecode(city).lower()            
            spotifySearch()
            fill_city()
            
            writeCSV(f'{(city)}, {country}')
            citytopweek.clear()

if __name__ == "__main__":
    main()