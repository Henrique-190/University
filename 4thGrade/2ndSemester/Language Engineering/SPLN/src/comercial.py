from bs4 import BeautifulSoup
from datetime import datetime
import radio, program
import requests
import re

site = 'https://radiocomercial.pt/'

dias = ["SEG", "TER", "QUA", "QUI", "SEX", "SAB", "DOM"]

user_agent_list = [
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.1 '
    'Safari/605.1.15',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:77.0) Gecko/20100101 Firefox/77.0',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 '
    'Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:77.0) Gecko/20100101 Firefox/77.0',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 '
    'Safari/537.36',
]


def trataDias(dias):
    dias = dias.replace("SEGUNDA", "SEG")
    dias = dias.replace("TERÇA", "TER")
    dias = dias.replace("QUARTA", "QUA")
    dias = dias.replace("QUINTA", "QUI")
    dias = dias.replace("SEXTA", "SEX")
    dias = dias.replace("SÁBADO", "SAB")
    dias = dias.replace("DOMINGO", "DOM")

    return dias.strip()


def trataHoras(horas):
    match1 = re.match(r'(.+?)(\d+)H - (\d+)H', horas)
    match2 = re.match(r'(.+?)(\d+)H', horas)
    match3 = re.match(r'(.+?)(\d+)H - (\d+)H(.*)', horas)
    match4 = re.match(r'(.+?)(\d+)H(.*)', horas)

    days = ""
    start = ""
    end = ""
    details = ""

    if match1:
        days = match1.group(1)
        start = match1.group(2)
        end = match1.group(3)


    elif match2:
        days = match2.group(1)
        start = match2.group(2)


    elif match3:
        days = match3.group(1)
        start = match3.group(2)
        end = match3.group(3)
        details = match3.group(4)


    elif match4:
        days = match4.group(1)
        start = match4.group(2)
        details = match4.group(3)

    else:
        print("Não foi possível encontrar o horário")
        return None, None, None, None

    days = trataDias(days)
    start = datetime.strptime(start, '%H').time().strftime('%H:%M')
    if end:
        end = datetime.strptime(end, '%H').time().strftime('%H:%M')

    return start, end, days, details


def getDetails(url, tnt=False):
    response = requests.get(url)
    soup = BeautifulSoup(response.text, "lxml")

    if tnt:
        details = "\nMúsicas do Todos No Top: "
        nomes = soup.find_all("div", {"class": "song-name"})
        autores = soup.find_all("div", {"class": "song-artists"})
        aux = []
        for autor in autores:
            aux.append(autor.text)

        for item, autor in zip(nomes, aux):
            details += item.text + f"({autor})" + "; "
        return details

    details = "\nProgramas: "
    for item in soup.find_all("div", {"class": "program-title"}):
        details += item.text + ", "
    return details


def programas(programas):
    progs = []
    for programa in programas:
        # programa.find("a").get("href")
        title = programa.find("div", {"class": "title"}).text
        link = site + programa.find("a").get("href")
        hours = programa.find("div", {"class": "hours"}).text

        start, end, days, details = trataHoras(hours.upper())

        img = ""
        for item in programa.find_all("source"):
            if item.get("type") == "image/jpeg" or item.get("type") == "image/png":
                img = site + item.get("srcset")[1:]
                break

        if "TNT" in title.upper():
            details += getDetails(link, tnt=True)
        else:
            details += getDetails(link)

        if len(days.strip()) != 3:
            programa = program.Program(title, link, start, end, [img], days, details)
            programa.formatDay()
        else:
            days = [days]
            programa = program.Program(title, link, start, end, [img], days, details)

        progs.append(programa)

    return progs


def comercial(headers):
    url = site + 'programas'
    programacao = []

    response = requests.get(url, headers=headers)

    soup = BeautifulSoup(response.text, "lxml")
    global i
    i = 0

    programacao = programas(soup.find_all("div", {"class": "programa"}))

    radio_ = radio.Radio('Rádio Comercial', 'https://radiocomercial.pt/images/svg/logoRC_black.svg', site, programacao)

    return radio_
