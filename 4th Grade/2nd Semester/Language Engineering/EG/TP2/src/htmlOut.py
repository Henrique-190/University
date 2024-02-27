

def initHTML():
    
    return """
<!DOCTYPE html>
    <html>
        <head>
            <meta charset="utf-8">
            <title>Análise do ficheiro</title>
        </head>
        <style>
            html {
              background-color: #000000;
            }
            .error {
                position: relative;
                display: inline-block;
                border-bottom: 1px dotted black;
                color: red;
            }
            .code {
                position: relative;
                display: inline-block;
            }
            .error .errortext {
                visibility: hidden;
                width: 500px;
                background-color: #555;
                color: #fff;
                text-align: center;
                border-radius: 6px;
                padding: 5px 0;
                position: absolute;
                z-index: 1;
                bottom: 125%;
                left: 50%;
                margin-left: -100px;
                opacity: 0;
                transition: opacity 0.3s;
            }
            .error .errortext::after {
                content: "";
                position: absolute;
                top: 100%;
                left: 20%;
                margin-left: -5px;
                border-width: 5px;
                border-style: solid;
                border-color: #555 transparent transparent transparent;
            }
            .error:hover .errortext {
                visibility: visible;
                opacity: 1;
            }

            pre {
                background-color: #2D2D2D;
                color: #F8F8F2;
                padding: 20px;
                font-family: "Consolas", "Courier New", monospace;
                font-size: 14px;
                line-height: 1.5;
                overflow-x: auto;
                border-radius: 5px;
            }

            .keyword {
              color: #C586C0;
              font-weight: bold;
            }

            .value {
              color: #B5CEA8;
            }

            .function-name {
              color: #DCDCAA;
            }
            
            .type {
                color: #4EC9B0;
                font-style: italic;
            }

            thead {
              background-color: #2c313c;
              color: #fff; /* para definir a cor do texto dentro do cabeçalho como branco */
            }

            .variable-name {
              color: #9CDCFE;
            }

            .highlight {
              background-color: #3B3B3B;
              color: #D4D4D4;
            }

            .table {
              font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
              color: #abb2bf;
              border-collapse: collapse;
            }

            .table th {
              color: #dcdfe4;
              text-align: left;
              font-weight: 600;
              border-bottom: 2px solid #3f4451;
              padding: 12px 15px;
            }

            .table td {
              border-bottom: 1px solid #2c313c;
              padding: 10px 15px;
            }

            .table tr:last-child td {
              border-bottom: none;
            }

            .table tr:nth-child(even) td {
              background-color: #2c313c;
            }

            .table tr:hover td {
              background-color: #3e4452;
            }

        </style>
        <body>
            <pre><code>"""

def endHTML():
    return """
            </code></pre>
        </body>
    </html>"""

def error(id, txt, errortxt):
    return f"""<span id="{id}" class="error">{txt}<span class="errortext">{errortxt}</span></span> """

def function_name(txt, indent):
    return "<span class='function-name'>" + "\t"*indent + f"""{txt} </span>"""

def variable_name(txt):
    return "<span class='variable-name'>" + f"""{txt} </span>"""

def type(txt, indent):
    return "<span class='type'>" + "\t"*indent + f"""{txt} </span>"""

def keyword(txt, indent):
    return "<span class='keyword'>" + "\t"*indent + f"""{txt} </span>"""

def value(txt):
    return "<span class='value'>" + f"""{txt} </span>"""

def highlight(txt):
    return f"""<span class="highlight">{txt}</span>"""

def listToTxt(l : list):
    txt = ""
    if len(l) > 0:
        return str(l[0])
    for i in l[1:]:
        txt += ", " + str(i) 
    return txt


def stats(instrucoes, vars, funcoes, nmerge):
    not_repetidas = [funcoes[key]["vars"] for _, key in enumerate(funcoes)]
    not_repetidas = list(filter(lambda x: "extra" not in x, not_repetidas))
    n_vars = len(vars) + len(not_repetidas)

    tipos = set()

    for _, key1 in enumerate(funcoes):
        for _, key2 in enumerate(funcoes[key1]["vars"]):
            if funcoes[key1]["vars"][key2]["dec"] != 0:
                tipos.add(funcoes[key1]["vars"][key2]["tipo"])

            if "extra" in funcoes[key1]["vars"][key2] and funcoes[key1]["vars"][key2]["dec"] == 1:
                n_vars -= 1
    
    for _, key in enumerate(vars):
        tipos.add(vars[key]["tipo"])

    n_Func_varLocais = 0
    for _, key1 in enumerate(funcoes):
        for _, key2 in enumerate(funcoes[key1]["vars"]):
            if "extra" not in funcoes[key1]["vars"][key2]:
                n_Func_varLocais += 1
    n_tipos = len(tipos)

    return f"""
    <div style="display: flex; justify-content: center; padding: 0 30px;">
        <div style="justify-content: center; padding: 0 30px;">
            <table class="table">
                <thead>
                    <tr>
                        <th>Total</th>
                        <th>Valor</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Variáveis declaradas</td>
                        <td>{n_vars}</td>
                    </tr>
                    <tr>
                        <td>Tipos de dados</td>
                        <td>{n_tipos}</td>
                    </tr>
                    <tr>
                        <td>Funções</td>
                        <td>{len(funcoes)}</td>
                    </tr>
                    <tr>
                        <td>Funções com parâmetros</td>
                        <td>{len([key for _, key in enumerate(funcoes) if len(funcoes[key]["params"]) > 0])}</td>
                    </tr>
                    <tr>
                        <td>Funções com variáveis locais</td>
                        <td>{n_Func_varLocais}</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div style="justify-content: center; padding: 0 30px;">
            <table class="table">
                <thead>
                    <tr>
                        <th>Total</th>
                        <th>Valor</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Instruções</td>
                        <td>{instrucoes["total"]}</td>
                    </tr>
                    <tr>
                        <td>Atribuições</td>
                        <td>{instrucoes["atrib"]}</td>
                    </tr>
                    <tr>
                        <td>Escrita</td>
                        <td>{instrucoes["escrita"]}</td>
                    </tr>
                    <tr>
                        <td>Leitura</td>
                        <td>{instrucoes["leitura"]}</td>
                    </tr>
                    <tr>
                        <td>Seleção</td>
                        <td>{instrucoes["selecao"]}</td>
                    </tr>
                    <tr>
                        <td>Repetição</td>
                        <td>{instrucoes["repeticao"]}</td>
                    </tr>
                    <tr>
                        <td>Controlo aninhado</td>
                        <td>{instrucoes["aninhado"]}</td>
                    </tr>
                    <tr>
                        <td>Substuição por um SE</td>
                        <td>{nmerge}</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    """