def initHTML():
    return """<!DOCTYPE html>
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
            }
            .container {
              display: flex;
              height: 100%;
              background-color: #000000;
            }

            .first {
              flex: 4;
            }

            .second {
              flex: 1;
            }

            .code {
                position: relative;
                display: inline-block;
                flex: 4;
            }

            .stats {
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
              background-color: #7F7F7F;
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

            .lineNumber {
                color: blue;
            }

            .button-3 {
              appearance: none;
              background-color: #2ea44f;
              border: 1px solid rgba(27, 31, 35, .15);
              border-radius: 6px;
              box-shadow: rgba(27, 31, 35, .1) 0 1px 0;
              box-sizing: border-box;
              color: #fff;
              cursor: pointer;
              display: inline-block;
              font-family: -apple-system,system-ui,"Segoe UI",Helvetica,Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji";
              font-size: 14px;
              font-weight: 600;
              line-height: 20px;
              padding: 6px 16px;
              position: relative;
              text-align: center;
              text-decoration: none;
              user-select: none;
              -webkit-user-select: none;
              touch-action: manipulation;
              vertical-align: middle;
              white-space: nowrap;
            }

            .button-3:focus:not(:focus-visible):not(.focus-visible) {
              box-shadow: none;
              outline: none;
            }

            .button-3:hover {
              background-color: #2c974b;
            }

            .button-3:focus {
              box-shadow: rgba(46, 164, 79, .4) 0 0 0 3px;
              outline: none;
            }

            .button-3:disabled {
              background-color: #94d3a2;
              border-color: rgba(27, 31, 35, .1);
              color: rgba(255, 255, 255, .8);
              cursor: default;
            }

            .button-3:active {
              background-color: #298e46;
              box-shadow: rgba(20, 70, 32, .2) 0 1px 0 inset;
            }
        </style>
        <script>
            function highlightSpansByIdPrefix(idPrefix) {
              var spans = document.getElementsByTagName('span');
              var sum = 0;
              for (var i = 0; i < spans.length; i++) {
                var span = spans[i];

                if (span.id && span.id.includes(idPrefix)) {
                  span.classList.add('highlight');
                  sum += 1;
                } else {
                  span.classList.remove('highlight');
                }
              }
            }
        </script>
        <body>
        <div class="container">
                <div class="first">
            <pre><code>"""


def endHTMLCode():
    return """
            </code><pre></div>
        <div class="second">
            <pre style="background-color: #1F1F1F;"><div class="stats"><h2 style="text-align: center;">Estatísticas</h2>"""


def endHTML():
    return """</div></pre></div></div></body></html>"""


def error(id, txt, errortxt):
    return f"""<span id="{id}" class="error" style="color: red;">{txt}<span class="errortext">{errortxt}</span></span> """

def suggestion(id, txt, errortxt):
    return f"""<span id="{id}" class="error" style="border-bottom: 1px dotted blue;"">{txt}<span class="errortext">{errortxt}</span></span> """

def variableName(txt):
    return "<span class='variable-name'>" + f"""{txt} </span>"""


def typeHTML(txt):
    return "<span class='type'>" + f"""{txt} </span>"""


def keyword(txt):
    return "<span class='keyword'>" + f"""{txt} </span>"""

def function(txt):
    return "<span class='function-name'>" + f"""{txt} </span>"""


def value(txt):
    return f"""<span class='value'>{str(txt)} </span>"""


def highlight(txt):
    return f"""<span class="highlight">{txt}</span>"""


def listToTxt(l: list):
    txt = ""
    if len(l) > 0:
        return str(l[0])
    for i in l[1:]:
        txt += ", " + str(i)
    return txt


def newLinha(linha):
    if linha % 2 == 0:
        return (
            "<span class=linhaEven><span class='lineNumber'>" + f"""{linha}\t</span>"""
        )
    return "<span class=linhaOdd><span class='lineNumber'>" + f"""{linha}\t</span>"""


def endLinha():
    return "</span><br>"


def newFunc(id, params, indent):
    html = ""
    paramsHTML = ""
    for _, key in enumerate(params):
        paramsHTML += variableName(key) + ", "
    paramsHTML = paramsHTML[:-2]
    html += keyword(id, indent) + " { " + paramsHTML + "}"

    return html


def endFunc(visited, indent):
    html = keyword("RET", indent)
    for _, visitedHTML in visited:
        html += visitedHTML
    html += "<br>"
    return html


def newSE(visited, indent):
    html = keyword("SE", indent)
    for _, expHTML in visited:
        html += expHTML
    return html
