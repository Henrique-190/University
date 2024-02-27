from datetime import datetime

import requests
from bs4 import BeautifulSoup

import program
import radio

translate = {
    0: 'SEG',
    1: 'TER',
    2: 'QUA',
    3: 'QUI',
    4: 'SEX',
    5: 'SAB',
    6: 'DOM'
}

site = 'https://megahits.sapo.pt/'
i = 0


def diario(tabela: list):
    programas = []
    for row in tabela:
        titulo = row.find('a')['title']
        link = site + row.find('a')['href']
        horas = row.find('td', 'pg-gr-li-dt1').text  # 0007 - 00 é a hora inicial e 07 é a hora final
        try:
            inicial = datetime.strptime(horas[:2], '%H').time().strftime('%H:%M')
            final = datetime.strptime(horas[2:], '%H').time().strftime('%H:%M')
        except ValueError:
            inicial = "-"
            final = "-"
        days = translate[i]
        detalhes = row.find('td', class_='pg-gr-li-tx2').text
        imagem = row.find('a').find('img', class_='img-fluid')['src']

        programa = program.Program(titulo, link, inicial, final, [imagem], [days], detalhes)
        programas.append(programa)
    return programas


def megahits(headers):
    url = site + 'ajax/programacao/getgrelha.aspx'
    dia = '0'
    data = {'dia': dia, 'randval': 0.1234}
    programacao = []

    global i
    response = requests.post(url, data=data, headers=headers)
    soup = BeautifulSoup(response.text, "html.parser")

    while i < 5:
        programacao += (diario(soup.find_all('li', class_='pg-gr-li1')))
        i += 1

    while i < 7:
        dia = str(i)
        data['dia'] = dia
        response = requests.post(url, data=data)
        soup = BeautifulSoup(response.text, "html.parser")
        programacao += (diario(soup.find_all('li', class_='pg-gr-li1')))
        i += 1

    radio_ = radio.Radio('Mega Hits', 'https://images.megahits.sapo.pt/mega7141b648_app_square.png', site, programacao)
    i = 0
    return radio_
