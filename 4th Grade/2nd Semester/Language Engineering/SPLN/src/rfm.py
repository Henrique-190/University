import re
from datetime import datetime

import requests
from bs4 import BeautifulSoup

import program
import radio

site = 'https://rfm.sapo.pt/'

dias = ["SEG", "TER", "QUA", "QUI", "SEX", "SAB", "DOM"]


def fds(tabela):
    # find a div in tabela with class = "row topSpace"
    dia = []
    mudouDia = 0
    programacao = []
    programa = program.Program(None, None, None, None, None, "", "")

    for row in tabela.find_all('div', class_='row topSpace'):
        a = row.find('li', class_="pTxtRed").find('a')
        img = row.find_all('img')
        info = row.find_all("li", class_="pTxtLightGrey")
        prox = row.find('span')
        if a:
            programa.link = site + a['href']
            programa.title = a.text.strip()
        if img:
            programa.img = []
            for i in img:
                programa.img.append(i['src'])

        if info:
            for elem in info:
                elem = elem.text.split('-')
                if len(elem) == 2:
                    programa.start = datetime.strptime(elem[0][:2], '%H').time().strftime('%H:%M')
                    if elem[1][1:3] == '24':
                        programa.end = datetime.strptime('00', '%H').time().strftime('%H:%M')
                    else:
                        programa.end = datetime.strptime(elem[1][1:3], '%H').time().strftime('%H:%M')

        if prox:
            mudouDia = 1
            programacao += dia
            dia = []

        if programa.isComplete(day=True):
            if mudouDia == 1:
                programa.day = ["DOM"]
            else:
                programa.day = ["SAB"]
            dia.append(programa)
            programa = program.Program(None, None, None, None, None, "", "")

    programacao += dia
    return programacao


def trataINFO(info):
    aux = []
    match = re.match(r'(.*)(\d{2}:\d{2}) - (\d{2}:\d{2})', info)
    match2 = re.match(r'(\d{2}:\d{2}) - (\d{2}:\d{2})', info)
    if "|" in info:
        info = info.split("|")
        for i in info:
            match = re.match(r'(.*)(\d{2}:\d{2}) - (\d{2}:\d{2})', i)
            aux.append((match.group(1).strip(), match.group(2).strip(), match.group(3).strip()))
        tipo = 1
    elif match:
        aux.append((match.group(1).strip(), match.group(2).strip(), match.group(3).strip()))
        tipo = 2
    elif match2:
        aux.append((match2.group(1).strip(), match2.group(2).strip()))
        tipo = 3
    else:
        aux.append(info)
        tipo = 4

    return aux, tipo


def semana(tabela):
    # find a div in tabela with class = "row topSpace"
    dia = []
    programa = program.Program(None, None, None, None, None, "", "")

    for row in tabela.find_all('div', class_='row topSpace'):
        a = row.find('li', class_="pTxtRed").find('a')
        img = row.find_all('img')
        info = row.find_all("li", class_="pTxtLightGrey")
        if a:
            programa.link = site + a['href']
            programa.title = a.text.strip()

        if img:
            programa.img = []
            for i in img:
                programa.img.append(i['src'])

        if info:
            for elem in info:
                elem = elem.text
                res, tipo = trataINFO(elem)

                if tipo == 1:
                    programa.start = datetime.strptime(res[0][1], '%H:%M').time().strftime('%H:%M')
                    if res[0][2] == '24:00':
                        programa.end = datetime.strptime('00:00', '%H:%M').time().strftime('%H:%M')
                    else:
                        programa.end = datetime.strptime(res[0][2], '%H:%M').time().strftime('%H:%M')

                    programa.day += res[0][0]
                    programa.details += " ".join(res[1])
                elif tipo == 2:
                    if programa.start is None:
                        programa.start = datetime.strptime(res[0][1], '%H:%M').time().strftime('%H:%M')
                        if res[0][2] == '24:00':
                            programa.end = datetime.strptime('00:00', '%H:%M').time().strftime('%H:%M')
                        else:
                            programa.end = datetime.strptime(res[0][2], '%H:%M').time().strftime('%H:%M')

                        programa.day += res[0][0]
                    else:
                        programa.details += " ".join(res[0])

                elif tipo == 3:
                    programa.start = datetime.strptime(res[0][0], '%H:%M').time().strftime('%H:%M')
                    if res[0][1] == '24:00':
                        programa.end = datetime.strptime('00:00', '%H:%M').time().strftime('%H:%M')
                    else:
                        programa.end = datetime.strptime(res[0][1], '%H:%M').time().strftime('%H:%M')

                    programa.day += res[0]

                else:
                    programa.day += res[0]

        if programa.isComplete():
            dia.append(programa)
            programa = program.Program(None, None, None, None, None, "", "")

    return dia


def rfm(headers):
    url = site + 'programas'

    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.text, "lxml")
    global i
    i = 0

    programacao = semana(soup.find("div", {"id": "week"}))
    programacao += fds(soup.find("div", {"id": "weekend"}))

    radio_ = radio.Radio('RFM', 'https://images.rfm.sapo.pt/logo_rfm_r6285e5bd.png', site, programacao)

    return radio_
