from HTMLPrinter import *
from typing import Type, Union
import uuid
import urllib.parse


class Item:
    pass


class Variavel:
    def __init__(
        self, tipo: str, id: str, valor=None
    ) -> None:
        self.tipo = tipo
        self.id = id
        self.valor: Valor | None = valor
        self.nDeclarada = 1
        self.nInicializada = 0
        self.atributos = {}

    def declara(self) -> None:
        self.nDeclarada += 1

    def inicializa(self) -> None:
        self.nInicializada += 1

    def addAtributo(self, key: str, value) -> None:
        # value é uma Variavel
        self.atributos[key] = value


errorLocals = {
    "Param": "nos parâmetros",
    "Inside": "no corpo da Função",
    "Global": "globalmente",
}


def errorTXT(type: str, where=None) -> str:
    if type == "notInit":
        return "Variável não inicializada"
    if type == "notDecl":
        return "Variável não declarada"
    if type == "Decl":
        return f"""Variável já declarada {errorLocals[where]}"""
    if type == "funcNotDecl":
        return "Função não declarada"


class Erro:
    def __init__(self, tipo: str, local=None) -> None:
        self.tipo = tipo
        self.local = local

    def html(self, txtUnderlined) -> str:
        txtBox = errorTXT(self.tipo, self.local)
        return error("err" + self.tipo, txtUnderlined, txtBox)


class Funcao(Item):
    def __init__(
        self, id: str, params: dict = {}, items: list[Item] = [], ret=None
    ) -> None:
        self.id = id
        self.params = params
        self.items = items
        self.ret = ret
        self.vars = {}
        self.mcCabe = 0
        self.mcCabeDependency = []

    def __str__(self) -> str:
        return f"""{self.id}({self.params})"""

    def html(self, _) -> str:
        params = ", ".join([f"{variableName(id)}" for id, _ in self.params.items()])
        items = "\n".join([item.html(1) for item in self.items])

        ans = f"""<span id="funcao{self.id}">{keyword(self.id)} {{ {params}}}\n"""
        ans += items
        ans += (
            f"""\n<span id="retorno{self.id}">{keyword("RET")}"""
            + self.ret.html()
            + "</span>\n"
        )
        return ans
    
    def cfg(self) -> str:
        ans = f"subgraph {{\n"
        if len(self.items) == 0:
            return ans + f'"inicio{self.id}" -> "fim{self.id}"\n}}'
        
        first, cfg, last = self.items[0].cfg()
        ans += f'inicio{self.id} -> {first}\n'
        ans += cfg

        for i in range(len(self.items)-1):
            first2, cfg, last2 = self.items[i+1].cfg()
            
            ans += cfg
            for l in last:
                ans += f'{l} -> {first2}\n'
            
            first = first2
            last = last2
        
        for l in last:
            ans += f'{l} -> fim{self.id}\n'
        return ans + "}"
    
    def sdg(self) -> str:
        ans = f"subgraph {{\n"
        first = f"inicio{self.id}"
        fim = f"fim{self.id}"
        nodos = 1
        arestas = 0
        
        for i in range(len(self.items)):
            first2, sdg, mcCabe2, dependency = self.items[i].sdg()            
            ans += sdg
            ans += f'{first} -> {first2}\n'
            arestas += mcCabe2
            arestas += 1
            self.mcCabeDependency += dependency
        
        ans += f'{first} -> {fim}\n'
        nodos += 1
        arestas += 1
        self.mcCabe = arestas-nodos+2
        return ans + "}"

        

class Declaracao(Item):
    def __init__(self, tipo: str, id: str, valor=Union["EXP",None], erro: Erro|None =None):
        self.tipo = tipo
        self.id = id
        self.valor = valor
        self.erro = erro
    
    def __str__(self) -> str:
        if self.valor:
            return f'{self.tipo} {self.id} {str(self.valor)}'
        return f'{self.tipo} {self.id}'

    def html(self, indent: int) -> str:
        if self.erro:
            idValueSTR = self.id + " " + str(self.valor) if self.valor else self.id
            return "\t" * indent + f'<span id="declaracao{self.tipo}{self.id}">{typeHTML(self.tipo)}{self.erro.html(idValueSTR)}</span>'
        
        if self.valor:
            return "\t" * indent + f'<span id="declaracao{self.tipo}{self.id}">{typeHTML(self.tipo)}{variableName(self.id)}{self.valor.html()}</span>'
        
        return "\t" * indent + f'<span id="declaracao{self.tipo}{self.id}">{typeHTML(self.tipo)}{variableName(self.id)}</span>'
    
    def cfg(self) -> tuple[str, str, list[str]]:
        ans = ""
        id = f'"{str(uuid.uuid4())[:8]}"'
        if self.valor:
            ans = f'{id}[label="{self.tipo} {self.id} {str(self.valor)}"];\n'
        else: 
            ans = f'{id}[label="{self.tipo} {self.id}"];\n'
        return (id, ans, [id])
    
    def sdg(self) -> tuple[str, str, int, list[str]]:
        ans = ""
        id = f'"{str(uuid.uuid4())[:8]}"'
        if self.valor:
            ans = f'{id}[label="{self.tipo} {self.id} {str(self.valor)}"];\n'
        else: 
            ans = f'{id}[label="{self.tipo} {self.id}"];\n'
        return (id, ans, -1, [])



class Selecao(Item):
    def __init__(self, condicao: Type["EXP"], corpo: list) -> None:
        self.condicao = condicao
        self.corpo = corpo  # Lista de Elementos
        self.aninhado = False
        self.merged = False

    def html(self, indent: int) -> str:
        elems = "\n".join([element.html(indent+1) for element in self.corpo])
        id = f"selecao{self.condicao}"
        condicao = self.condicao.html()
        if self.merged:
            id = "merged" + id 
            condicao = suggestion(str(self.condicao), condicao, "Seleção poderia ser aninhada com a Seleção de cima")
        if self.aninhado:
            id = "aninhado" + id

        
        ans = '\t'*indent + f"""<span id="{id}">{keyword("SE")}{condicao}
    <span id="selecaoCorpo{self.condicao}">{elems}</span>\n"""

        return ans + '\t'*indent + f"""{keyword("ES")}</span>"""
    
    def cfg(self) -> tuple[str, str, list[str]]:
        ans = ""
        idF = f'"{str(uuid.uuid4())[:8]}"'
        first = f'{idF}[label="SE {str(self.condicao)}"] [shape=diamond];\n'
        ans += first
        last = [idF]

        for item in self.corpo:
            first2, cfg, last2 = item.cfg()
            for l in last:
                ans += f'{l} -> {first2}\n'
            ans += cfg
            last = last2
        
        return (idF, ans, [idF] + last)
    
    def sdg(self) -> tuple[str, str, int, list[str]]:
        ans = ""
        idF = f'"{str(uuid.uuid4())[:8]}"'
        first = f'{idF}[label="SE {str(self.condicao)}"] [shape=diamond];\n'
        ans += first
        nodos = 1
        arestas = 0
        dep = []

        for item in self.corpo:
            first2, sdg, mcCabe, dependencies = item.sdg()
            ans += sdg
            ans += f'{idF} -> {first2}\n'

            arestas += mcCabe
            arestas += 1
            dep += dependencies
        
        return (idF, ans, arestas-nodos, dep)
            
        

class Caso(Item):
    def __init__(self, condicao: Type["EXP2"], corpo: list[tuple[str, Item]], erro: Erro|None = None) -> None:
        self.condicao = condicao
        self.corpo = corpo
        self.aninhado = False

    def html(self, indent: int) -> str:
        indent += 1
        elems = f'<span id="casoCorpo{self.condicao}">\n'
        for item in self.corpo:
            elems += "\t" * indent + item[0].html() + ":\n"
            indent += 1
            for item2 in item[1]:
                elems += item2.html(indent) + "\n"
            indent -= 1
        indent -= 1
        
        return f'<span id="caso{self.condicao}">' + "\t" * indent + f'{keyword("CASO")}{self.condicao.html()}{elems}</span>' + "\t" * indent + keyword("OSAC") + "</span>\n"
    
    def cfg(self) -> tuple[str, str, list[str]]:
        idF = f'"{str(uuid.uuid4())[:8]}"'
        ans = f'{idF}[label="CASO {str(self.condicao)}"][shape=diamond];\n'
        last = []

        for item in self.corpo:
            idVal = f'"{str(uuid.uuid4())[:8]}"'
            ans += f'{idVal}[label="{item[0]}"];\n'
            ans += f'{idF} -> {idVal}\n'
            lastItem = [idVal]
            for item2 in item[1]:
                first2, cfg, last2 = item2.cfg()
                ans += cfg
                for l in lastItem:
                    ans += f'{l} -> {first2}\n'
                lastItem = last2
            last += lastItem
        
        return (idF, ans, last)
    
    def sdg(self) -> tuple[str, str, int, list[str]]:
        idF = f'"{str(uuid.uuid4())[:8]}"'
        ans = f'{idF}[label="CASO {str(self.condicao)}"][shape=diamond];\n'

        nodos = 1
        arestas = 0
        dep = []

        for item in self.corpo: 
            idVal = f'"{str(uuid.uuid4())[:8]}"'
            ans += f'{idVal}[label="{item[0]}"];\n'
            nodos += 1
            ans += f'{idF} -> {idVal}\n'
            arestas += 1
            for item2 in item[1]:
                first2, sdg, mcCabe, dependencies = item2.sdg()
                ans += sdg
                ans += f'{idVal} -> {first2}\n'
                arestas += mcCabe
                arestas += 1 
                dep += dependencies   
        return (idF, ans, arestas-nodos, dep)


class Repeticao(Item):
    def __init__(self, exp: Type["EXP"] | int, corpo: list[Item], tipo: str) -> None:
        self.exp = exp
        self.corpo = corpo
        self.tipo = tipo # ENQUANTO | PARA | REPETIR
        self.aninhado = False

    def html(self, indent: int) -> str:
        tipoHTML = f"""<span id="repeticao{self.exp}">"""
        if self.tipo == "ENQUANTO":
            tipoHTML += "\t" * indent + keyword("ENQ") + self.exp.html() + "\n"
            tipoHTML += "\t" * indent + keyword("FAZER") + "{\n%s\n}" + "</span>\n"
        elif self.tipo == "PARA":
            tipoHTML += "\t" * indent + keyword("PARA") + self.exp.html() + "\n"
            tipoHTML += "\t" * indent + keyword("FAZER") + "{\n%s\n}" + "</span>\n"
        elif self.tipo == "REPETIR":
            tipoHTML += "\t" * indent + keyword("REPETIR") + "{\n%s\n}"
            tipoHTML += "  " + keyword("ATE") + self.exp.html() + "</span>\n"
        
        indent += 1
        elems = "\n".join([element.html(indent) for element in self.corpo])
        indent -= 1
        

        return tipoHTML % elems
    
    def cfg(self) -> tuple[str, str, list[str]]:
        if self.tipo == "REPETIR":
            idCondition = f'"{str(uuid.uuid4())[:8]}"'
            ans = f'{idCondition}[label="REPETIR ATÉ {str(self.exp)}"];\n'
            
            first, cfg, last = self.corpo[0].cfg()
            ans += f'{first}[label="{str(self.corpo[0])}"];\n'
            
            for item in self.corpo[1:]:
                first2, cfg, last2 = item.cfg()
                for l in last:
                    ans += f'{l} -> {first2}\n'
                ans += cfg
                last = last2

            for l in last:
                ans += f'{l} -> {idCondition}\n'
            
            ans += f'{idCondition} -> {first}\n'

            return (first, ans, [idCondition])
        else:
            idCondition = f'"{str(uuid.uuid4())[:8]}"'
            ans = f'{idCondition}[label="{self.tipo} {str(self.exp)}"];\n'
            
            last = [idCondition]
            
            for item in self.corpo:
                first2, cfg, last2 = item.cfg()
                for l in last:
                    ans += f'{l} -> {first2}\n'
                ans += cfg
                last = last2

            for l in last:
                ans += f'{l} -> {idCondition}\n'
            
            return (idCondition, ans, [idCondition])
    
    def sdg(self) -> tuple[str, str, int, list[str]]:
        if self.tipo == "REPETIR":
            idCondition = f'"{str(uuid.uuid4())[:8]}"'
            ans = f'{idCondition}[label="REPETIR ATÉ {str(self.exp)}"];\n'
            nodos = 1
            arestas = 0
            dep = self.exp.dependencies()
            
            for item in self.corpo:
                first2, sdg, mcCabe, dependencies = item.sdg()
                ans += sdg
                ans += f'{idCondition} -> {first2}\n'
                arestas += mcCabe
                arestas += 1
                dep += dependencies
            return (idCondition, ans, arestas-nodos, dep)
        else:
            idCondition = f'"{str(uuid.uuid4())[:8]}"'
            dep = self.exp.dependencies() if type(self.exp) == EXP else []
            ans = f'{idCondition}[label="{self.tipo} {str(self.exp)}"];\n'

            nodos = 1
            arestas = 0

            for item in self.corpo:
                first2, sdg, mcCabe, dependencies = item.sdg()
                ans += sdg
                ans += f'{idCondition} -> {first2}\n'
                arestas += mcCabe
                arestas += 1
                dep += dependencies
            return (idCondition, ans, arestas-nodos, dep)




class Valor:
    def __init__(self, valor: list | tuple | str | int) -> None:
        self.valor = valor
    
    def __str__(self) -> str:
        if type(self.valor) in [list, tuple]:
            symbolInit = "(" if type(self.valor) == tuple else "["
            symbolEnd = ")" if type(self.valor) == tuple else "]"
            return f'{symbolInit} ' + ", ".join([f'{str(val)}' for val in self.valor]) + f' {symbolEnd}'
        return str(self.valor).replace('"', '')

    def html(self) -> str:
        if type(self.valor) in [list, tuple]:
            symbolInit = "(" if type(self.valor) == tuple else "["
            symbolEnd = ")" if type(self.valor) == tuple else "]"
            ans = f'<span id="valor{str(self.valor)}">{symbolInit} '
            ans += ", ".join([f'{val.html()}' for val in self.valor])
            return ans + f'{symbolEnd}</span>'
        return f'<span id="valor{str(self.valor)}">{value(self.valor)}</span>'


class ID:
    def __init__(self, id: str | list[str]) -> None:
        self.id = id
    
    def __str__(self) -> str:
        return self.id

    def html(self) -> str:
        return f'<span id="id{self.id}">{variableName(self.id)}</span>'


class EXP2:
    def __init__(self, op1: ID, erro=Erro | None) -> None:
        self.op1 = op1
        self.erro = erro
    
    def __str__(self) -> str:
        return str(self.op1)

    def html(self) -> str:
        if self.erro:
            return self.erro.html(str(self.op1))
        return self.op1.html()


class Atribuicao(Item):
    def __init__(self, id: EXP2, valor: Type["EXP"]) -> None:
        self.id = id
        self.valor = valor
    
    def __str__(self) -> str:
        return f'ATRIB {self.id} {str(self.valor)}'

    def html(self, indent: int) -> str:
        return "\t" * indent + f'<span id="atribuicao{str(self.id)}">{function("ATRIB")}{self.id.html()}{self.valor.html()}</span>'
    
    def cfg(self) -> tuple[str, str, list[str]]:
        id = f'"{str(uuid.uuid4())[:8]}"'
        ans = f'{id}[label="ATRIB {self.id} {str(self.valor)}"];\n'
        return (id, ans, [id])
    
    def sdg(self) -> tuple[str, str, int, list[str]]:
        id = f'"{str(uuid.uuid4())[:8]}"'
        ans = f'{id}[label="ATRIB {self.id} {str(self.valor)}"];\n'
        dependencies = self.valor.dependencies()
        return (id, ans, -1, dependencies)

class FuncaoChamada(Item):
    def __init__(self, id: str, params: list, erro=None) -> None:
        self.id = id
        self.params = params
        self.erro = erro
    
    def __str__(self) -> str:
        return f'{self.id}({", ".join([str(param) for param in self.params])})'

    def html(self) -> str:
        ans = f'<span id="funcaoChamada{self.id}">{variableName(self.id)}({", ".join([value(param) for param in self.params])[:-2]})</span>'
        if self.erro:
            return self.erro.html(ans)
        return ans
    
    def cfg(self) -> tuple[str, str, list[str]]:
        id = f'"{str(uuid.uuid4())[:8]}"'
        ans = f'{id}[label={self.id}( {", ".join([str(param) for param in self.params])} )];\n'
        return (id, ans, [id])
    
    def sdg(self) -> tuple[str, str, int, list[str]]:
        id = f'"{str(uuid.uuid4())[:8]}"'
        ans = f'{id}[label={self.id}( {", ".join([str(param) for param in self.params])} )];\n'
        return (id, ans, -1, [self.id])


class FuncaoSTD(Item):
    def __init__(self, id: str, exp2: EXP2, erro:Erro|None = None) -> None:
        self.id = id
        self.exp2 = exp2
        self.erro = erro

    def html(self, indent: int) -> str:
        ans = f'<span id="funcaoSTD{self.id}">{function(self.id)}{self.exp2.html()}</span>'
        if self.erro:
            return self.erro.html(ans)
        return "\t" * indent + ans
    
    def cfg(self) -> tuple[str, str, list[str]]:
        id = f'"{str(uuid.uuid4())[:8]}"'
        ans = f'{id}[label="{self.id} {str(self.exp2)}"];\n'
        return (id, ans, [id])
    
    def sdg(self) -> tuple[str, str, int, list[str]]:
        id = f'"{str(uuid.uuid4())[:8]}"'
        ans = f'{id}[label="{self.id} {str(self.exp2)}"];\n'
        return (id, ans, -1, [])

class ABS:
    def __init__(
        self, valor: Valor | FuncaoChamada | Type["Array"] | ID, false: bool = False
    ):
        self.valor = valor
        self.false = false
    
    def __str__(self) -> str:
        excl = "!" if self.false else ""
        return f'{excl}{str(self.valor)}'

    def html(self) -> str:
        excl = "!" if self.false else ""
        return f'<span id="abs{str(self.valor)}">{excl}{self.valor.html()}</span>'
    
    def dependencies(self) -> list[str]:
        if isinstance(self.valor, FuncaoChamada):
            return [self.valor.id]
        elif isinstance(self.valor, Array):
            return self.valor.dependencies()
        return []


class EXP:
    def __init__(self, op1: ABS, resto: list[str | ABS] = []) -> None:
        self.op1 = op1
        self.resto = resto
    
    def __str__(self) -> str:
        ans = str(self.op1)
        i = 0

        while i < len(self.resto):
            ans += " " + self.resto[i] + " "
            i += 1
            ans += str(self.resto[i])
            i += 1

        return ans

    def html(self) -> str:
        ans = self.op1.html()
        i = 0

        while i < len(self.resto):
            ans += self.resto[i] + " "
            i += 1
            ans += self.resto[i].html()
            i += 1

        return ans
    
    def dependencies(self) -> list[str]:
        ans = []
        for resto in self.resto:
            if isinstance(resto, ABS):
                ans += resto.dependencies()
        if isinstance(self.op1, ABS):
            ans += self.op1.dependencies()
        return ans


class Array:
    def __init__(self, id: str, index: EXP, erro=None) -> None:
        self.id = id
        self.index = index
        self.erro = erro
    
    def __str__(self) -> str:
        return f'{self.id}[{str(self.index)}]'

    def html(self) -> str:
        ans = f'<span id="array{self.id}">{variableName(self.id)}[ {self.index.html()}] </span>'
        if self.erro:
            return self.erro.html(ans)
        return ans
    
    def dependencies(self) -> list[str]:
        return self.index.dependencies()


class Escrita(Item):
    def __init__(self, valor: EXP, erro: Erro = None) -> None:
        self.valor = valor
        self.erro = erro

    def html(self, indent: int) -> str:
        ans = f'<span id="escrita{self.valor}">{function("ESCREVER")}{self.valor.html()}</span>'

        if self.erro:
            return self.erro.html(ans)
        return "\t" * indent + ans
    
    def __str__(self) -> str:
        return f'ESCREVER {str(self.valor)}'
    
    def cfg(self) -> tuple[str, str, list[str]]:
        id = f'"{str(uuid.uuid4())[:8]}"'
        ans = f'{id}[label="ESCREVER {str(self.valor)}"];\n'
        return (id, ans, [id])
    
    def sdg(self) -> tuple[str, str, int, list[str]]:
        id = f'"{str(uuid.uuid4())[:8]}"'
        ans = f'{id}[label="ESCREVER {str(self.valor)}"];\n'
        return (id, ans, -1, self.valor.dependencies())

class Estatistica:
    def __init__(
        self,
        inst=0,
        decl=0,
        atrib=0,
        escrita=0,
        leitura=0,
        selecao=0,
        repeticao=0,
        aninhado=0,
        merge=0,
        redeclaracao=0,
        naoDeclarado=0,
        naoInicializado=0,
        tipos = set(),
        mccabe= ()
    ) -> None:
        self.inst = inst
        self.atrib = atrib
        self.decl = decl
        self.escrita = escrita
        self.leitura = leitura
        self.selecao = selecao
        self.repeticao = repeticao
        self.aninhado = aninhado
        self.merge = merge
        self.redeclaracao = redeclaracao
        self.naoDeclarado = naoDeclarado
        self.naoInicializado = naoInicializado
        self.tipos = tipos

    def incAtrib(self) -> None:
        self.atrib += 1
        self.inst += 1

    def incDecl(self) -> None:
        self.decl += 1
        self.inst += 1

    def incEscrita(self) -> None:
        self.escrita += 1
        self.inst += 1

    def incLeitura(self) -> None:
        self.leitura += 1
        self.inst += 1

    def incSelecao(self) -> None:
        self.selecao += 1
        self.inst += 1

    def incRepeticao(self) -> None:
        self.repeticao += 1
        self.inst += 1

    def incAninhado(self) -> None:
        self.aninhado += 1
        self.inst += 1

    def incMerge(self) -> None:
        self.merge += 1
        self.inst += 1

    def incInst(self) -> None:
        self.inst += 1
    
    def incRedeclaracao(self) -> None:
        self.redeclaracao += 1

    def incNaoDeclarado(self) -> None:
        self.naoDeclarado += 1

    def incNaoInicializado(self) -> None:
        self.naoInicializado += 1
    
    def incTipo(self, tipo: str) -> None:
        self.tipos.add(tipo)

    def html(self, cfg, sdg) -> str:
            return f'''
<table class="table">
  <tr>
    <th style="text-decoration: underline;" onclick="highlightSpansByIdPrefix('métrica')">Métrica</th>
    <th>Valor</th>
  </tr>
  <tr>
    <td>Instruções</td>
    <td>{self.inst}</td>
  </tr>
  <tr>
    <td>Tipos de Variáveis</td>
    <td>{len(self.tipos)}</td>
  </tr>
  <tr onclick="highlightSpansByIdPrefix('declaracao')">
    <td style="text-decoration: underline;">Declarações</td>
    <td>{self.decl}</td>
  </tr>
  <tr onclick="highlightSpansByIdPrefix('atribuicao')">
    <td style="text-decoration: underline;">Atribuições</td>
    <td>{self.atrib}</td>
  </tr>
  <tr onclick="highlightSpansByIdPrefix('escrita')">
    <td style="text-decoration: underline;">Escritas</td>
    <td>{self.escrita}</td>
  </tr>
  <tr onclick="highlightSpansByIdPrefix('funcaoSTDLER')">
    <td style="text-decoration: underline;">Leituras</td>
    <td>{self.leitura}</td>
  </tr>
  <tr onclick="highlightSpansByIdPrefix('selecao')">
    <td style="text-decoration: underline;">Seleções</td>
    <td>{self.selecao}</td>
  </tr>
  <tr onclick="highlightSpansByIdPrefix('repeticao')">
    <td style="text-decoration: underline;">Repetições</td>
    <td>{self.repeticao}</td>
  </tr>
  <tr onclick="highlightSpansByIdPrefix('aninhado')">
    <td style="text-decoration: underline;">Estruturas aninhadas</td>
    <td>{self.aninhado}</td>
  </tr>
  <tr onclick="highlightSpansByIdPrefix('merged')">
    <td style="text-decoration: underline;">Seleções possíveis de misturar</td>
    <td>{self.merge}</td>
  </tr>
  <tr onclick="highlightSpansByIdPrefix('errDecl')">
    <td style="text-decoration: underline;">Redeclarações</td>
    <td>{self.redeclaracao}</td>
  </tr>
  <tr onclick="highlightSpansByIdPrefix('errnotDecl')">
    <td style="text-decoration: underline;">Variáveis não declaradas</td>
    <td>{self.naoDeclarado}</td>
  </tr>
  <tr onclick="highlightSpansByIdPrefix('errnotInit')">
    <td style="text-decoration: underline;">Variáveis não inicializadas e usadas</td>
    <td>{self.naoInicializado}</td>
  </tr>
  <tr>
    <td>Complexidade Ciclomática de {self.mcCabe[0]}</td>
    <td>{self.mcCabe[1]}</td>
  </tr>
</table>

<button class="button-3" role="button" onclick=window.open("{"https://dreampuf.github.io/GraphvizOnline/#digraph%20f" + urllib.parse.quote(cfg)}")>Control Flow Graph</button><button class="button-3" role="button" onclick=window.open("{"https://dreampuf.github.io/GraphvizOnline/#digraph%20f" + urllib.parse.quote(sdg)}")>System Dependency Graph</button>
'''