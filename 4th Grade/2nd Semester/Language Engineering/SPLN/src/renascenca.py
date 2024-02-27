import re
from datetime import datetime, timedelta

import requests
from bs4 import BeautifulSoup

import program
import radio

url = 'https://rr.sapo.pt'

dias = {
    '#seg': 'SEG',
    '#ter': 'TER',
    '#qua': 'QUA',
    '#qui': 'QUI',
    '#sex': 'SEX',
    '#sab': 'SAB',
    '#dom': 'DOM'
}
programas = {}


def diario(soup, day):
    programacao = []
    ps = soup.find('div', id=day.lower())
    for programa in ps.\
            findAll('li', class_='all-100 column-group no-margin half-top-padding push-bottom quarter-vertical-padding'):
        for p in programa.findAll('tr'):
            if p.find('td', class_='txtGrey fw-500 quarter-right-padding') is not None:
                inicio = datetime.strptime(programa.find('td', class_='txtGrey fw-500 quarter-right-padding').text,
                                           '%Hh%M').time().strftime('%H:%M')
            else:
                hora = re.match(r'(\d{2}h\d{2})', p.find('a', class_='lnkBlack').text)
                if hora:
                    inicio = datetime.strptime(hora.group(1), '%Hh%M').time().strftime('%H:%M')
                else:
                    inicio = (datetime.strptime(programacao[-1].start, '%H:%M') + timedelta(
                        minutes=30)).time().strftime('%H:%M')
            link = None
            if p.find('td', class_='extralarge slab-400 lnkBlack'):
                titulo = p.find('td', class_='extralarge slab-400 lnkBlack').text
            else:
                if p.find('a', class_='slab-400 lnkBlack'):
                    titulo = p.find('a', class_='slab-400 lnkBlack').text
                    link = url + "/" + p.find('a', class_='slab-400 lnkBlack')['href']
                else:
                    try:
                        titulo = p.find('a', class_='lnkBlack').text
                        link = url + "/" + p.find('a', class_='lnkBlack')['href']
                    except (Exception, ):
                        titulo = p.find('td', class_='extralarge').text
            details = programas[titulo] if titulo in programas else ""
            programacao.append(program.Program(titulo, link, inicio, "", [], [day], details))

    return programacao


def renascenca(headers):
    link = url + '/audios'
    global programas

    programacao = []
    response = requests.get(link, headers=headers)
    soup = BeautifulSoup(response.text, "lxml")
    ps = soup.find('div', id='prog')
    for p in ps.findAll('li',
                        class_='all-100 column-group no-margin half-top-padding push-bottom quarter-vertical-padding'):
        title = p.find('div', class_='extralarge all-100').text
        details = p.find('div', class_='fw-300 all-100').text
        programas[title] = details

    for dia in dias:
        programacao += diario(soup, dias[dia])
    return radio.Radio('Rádio Renascença', 'https://play-lh.googleusercontent.com/iCc40z5xTZaSlAsCUvpdtYIxGB3BYKtTRXw-nAaxBWsbQeDQludhRCwmaYcfLRJIaA',
                       'https://rr.sapo.pt', programacao)
