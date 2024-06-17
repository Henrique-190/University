import dotenv
import os
import time
import json
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException

countries: dict[str, str] = {"ar": "Argentina", "au": "Australia", "at": "Austria", "by": "Belarus", "be": "Belgium", "bo": "Bolivia", "br": "Brazil", "bg": "Bulgaria", "ca": "Canada", "cl": "Chile", "co": "Colombia", "cr": "Costa Rica", "cy": "Cyprus", "cz": "Czech Republic", "dk": "Denmark", "do": "Dominican Republic", "ec": "Ecuador", "eg": "Egypt", "sv": "El Salvador", "ee": "Estonia", "fi": "Finland", "fr": "France", "de": "Germany", "gr": "Greece", "gt": "Guatemala", "hn": "Honduras", "hk": "Hong Kong", "hu": "Hungary", "is": "Iceland", "in": "India", "id": "Indonesia", "ie": "Ireland", "il": "Israel", "it": "Italy", "jp": "Japan", "kz": "Kazakhstan", "lv": "Latvia", "lt": "Lithuania", "lu": "Luxembourg", "my": "Malaysia", "mx": "Mexico", "ma": "Morocco", "nl": "Netherlands", "nz": "New Zealand", "ni": "Nicaragua", "ng": "Nigeria", "no": "Norway", "pk": "Pakistan", "pa": "Panama", "py": "Paraguay", "pe": "Peru", "ph": "Philippines", "pl": "Poland", "pt": "Portugal", "ro": "Romania", "sa": "Saudi Arabia", "sg": "Singapore", "sk": "Slovakia", "za": "South Africa", "kr": "South Korea", "es": "Spain", "se": "Sweden", "ch": "Switzerland", "tw": "Taiwan", "th": "Thailand", "tr": "Turkey", "ae": "UAE", "ua": "Ukraine", "gb": "United Kingdom", "uy": "Uruguay", "us": "USA", "ve": "Venezuela", "vn": "Vietnam",}
country_cities: dict[str, str] = {}
dotenv.load_dotenv()
driver = webdriver.Chrome()
driver.get("https://accounts.spotify.com/en/login")
time.sleep(1)
driver.find_element("id","login-username").send_keys(os.getenv("SPOTIFY_EMAIL"))
driver.find_element("id","login-password").send_keys(os.getenv("SPOTIFY_PASSWORD"))
driver.find_element("id","login-button").click()
time.sleep(2)
    
for region, country in countries.items():
    driver.get(f"https://charts.spotify.com/charts/overview/{region}")

    time.sleep(2)
    try:
        driver.find_element("id",value="onetrust-accept-btn-handler").click()
        time.sleep(0.5)
    except:
        pass

    try:
        driver.find_element("id",value="cityLink").click()
        time.sleep(1)

        cities: set = set()

        for city in driver.find_elements(By.TAG_NAME,"h1"):
            cities.add(city.text)
        
        cities.remove("")
        cities.remove("Local Pulse")
        country_cities[country] = list(cities)
    except NoSuchElementException:
        pass
    except Exception as e:
        print(f"Error in {country} - {type(e)}: {e}")

with open("data/originals/country_cities.json", "w", encoding="utf-8") as file:
    json.dump(country_cities, file, indent=4, ensure_ascii=False)

driver.close()
