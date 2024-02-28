import requests
from datetime import datetime
import radio, program
from bs4 import BeautifulSoup



url = 'https://cidade.fm'

dias = {
    '/programas/segunda': 'SEG',
    '/programas/terca': 'TER',
    '/programas/quarta': 'QUA',
    '/programas/quinta': 'QUI',
    '/programas/sexta': 'SEX',
    '/programas/sabado': 'SAB',
    '/programas/domingo': 'DOM'
}


def diario(soup, day):
    programacao = []
    for programa in soup.findAll('li', class_='row pt-3 pt-sm-0'):
        horasText = programa.find('div', class_='grelha-hora').text.strip()[:-1].split('h às ')
        inicio = datetime.strptime(horasText[0], '%H').time().strftime('%H:%M')
        if horasText[1] == '24':
            fim = datetime.strptime('00', '%H').time().strftime('%H:%M')
        else:
            fim = datetime.strptime(horasText[1], '%H').time().strftime('%H:%M')
        titulo = programa.find('div', class_='grelha-programa fs-4').text
        image = url + programa.find('div', class_='col-12 col-sm-6 nogutter imagem-programa p-5 pt-0 pt-sm-5').find('img')['src']
        detalhes = programa.find('div', class_='fs-8').text
        if programa.find('div', class_='grelha-animadores fs-5').text != "":
            detalhes += " Com: " + programa.find('div', class_='grelha-animadores fs-5').text
        
        programacao.append(program.Program(titulo, '', inicio, fim, [image], [day], detalhes))
    
    return programacao

        
def cidade(headers):
    programacao = []
    for day in dias:
        response = requests.get(url + day, headers=headers)
        soup = BeautifulSoup(response.text, "lxml")
        programacao += diario(soup, dias[day])
    return radio.Radio('Cidade FM', 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Log%C3%B3tipo_Cidade_FM_2018.png/250px-Log%C3%B3tipo_Cidade_FM_2018.png', url, programacao)
