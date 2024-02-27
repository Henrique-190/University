from datetime import datetime

import requests
from bs4 import BeautifulSoup

import program
import radio

url = 'https://observador.pt'

translate = {
    0: 'SEG',
    1: 'TER',
    2: 'QUA',
    3: 'QUI',
    4: 'SEX',
    5: 'SAB',
    6: 'DOM'
}


def uteis(tabelas):
    programacao = {}
    for horas in tabelas.find_all('table', class_='day-schedule-hours'):
        cadaHora = horas.find('th', class_='day-schedule-hours-mark')
        if cadaHora:
            # Primeiro programa de cada hora (sempre as notícias)
            titulo = cadaHora.contents[2].strip()
            try:
                inicio = datetime.strptime(cadaHora.find('div').text.strip(), '%Hh').strftime('%H:%M')
            except (Exception, ):
                inicio = datetime.strptime(cadaHora.find('div').text.strip(), '%H').strftime('%H:%M')
            programacao[titulo + inicio + str([]) + str([translate[i] for i in range(5)])] = \
                program.Program(titulo, "", inicio, "", [], [translate[i] for i in range(5)], "")

            for programas in horas.find_all('tr', class_='day-schedule-hours-program'):
                inicio = datetime.strptime(programas.find('td', class_='day-schedule-hours-program-hour').text.strip(),
                                           '%Hh%M').strftime('%H:%M')
                programa = programas.find('td', class_='day-schedule-hours-program-name')
                if programa:
                    lista = programa.find('ul')

                    if lista:
                        for p in lista.find_all('li'):
                            titulo = p.find('a').contents[0].strip() if p.find('a') else programa.find('a').text.strip()
                            repetition = p.find('span', class_="repetition").text.strip() \
                                if p.find('span', class_="repetition") else ""
                            details = p.find('span', class_='extra-info').text.strip() + " " + repetition
                            link = url + p.find('a')['href'] if p.find('a') else url + programa.find('a')['href']
                            day = p.find('div', class_="day-schedule-hours-program-week-days-day").text.strip()

                            if day == "SEG a QUI":
                                programacao[titulo + inicio + str([]) + str(
                                    [translate[i] for i in range(4)])] = \
                                    program.Program(titulo, link, inicio, "", [], [translate[i] for i in range(4)],
                                                    details.upper() + details[1:])
                            else:
                                programacao[titulo + inicio + str([]) + str([day[:3]])] = \
                                    program.Program(titulo, link, inicio, "", [], [day[:3]], details.upper() +
                                                    details[1:])
                    else:
                        titulo = programa.find('a').contents[0].strip()
                        repetition = programa.find('span', class_="repetition").text.strip() \
                            if programa.find('span', class_="repetition") else ""
                        details = programa.find('span', class_='extra-info').text.strip() + " " + repetition
                        link = url + programa.find('a')['href']
                        programacao[titulo + inicio + str([]) + str([translate[i] for i in range(5)])] = \
                            program.Program(titulo, link, inicio, "", [], [translate[i] for i in range(5)],
                                            details.upper() + details[1:])

    return programacao


def observador(headers):
    link = url + '/radio/programacao/'
    response = requests.get(link, headers=headers)
    soup = BeautifulSoup(response.text, "html.parser")
    programacao = list(uteis(soup.find('div', id='monday-to-sunday-schedule')).values())
    programacao += list(uteis(soup.find('div', id='saturday-schedule')).values())
    programacao += list(uteis(soup.find('div', id='sunday-schedule')).values())

    return radio.Radio('Observador', 'https://upload.wikimedia.org/wikipedia/commons/9/97/Logo_observador_pequeno.png',
                       link, programacao)
