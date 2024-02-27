from lark import Lark, Token, Tree
from lark.visitors import Interpreter
from Elements import *
from HTMLPrinter import *


class Gramatica(Interpreter):
    vars = {}
    funcoes = {}
    instrucoes = []
    estatisticas = Estatistica()
    func_id = None
    erros = []
    mcCabeFunction = ""
    mcCabeValue = 0

    def programa(self, args):
        self.instrucoes = self.visit_children(args)

        cfg= "{"
        sdg="{"
        i = 0
        while (isinstance(self.instrucoes[i], Funcao)):
            cfg += self.instrucoes[i].cfg()
            sdg += self.instrucoes[i].sdg()
            i += 1
        script = Funcao("_main", {}, self.instrucoes[i:])
        cfg += script.cfg()
        sdg += script.sdg()
        cfg += "}"
        sdg += "}"
        self.funcoes["_main"] = script

        self.estatisticas.mcCabe = (self.mcCabeFunction, self.mcCabeCalc(self.mcCabeFunction))

        html = initHTML()
        for instrucao in self.instrucoes:
            html += "\n" + instrucao.html(0)
        html+=endHTMLCode()
        html += self.estatisticas.html(cfg, sdg)
        html += endHTML()        

        return html
    def funcao(self, args):
        # Vai buscar o id da função
        self.func_id = str(args.children[0])

        # Vai buscar os parâmetros, cria uma função e adiciona ao dicionário de funções
        self.funcoes[self.func_id] = Funcao(self.func_id, self.visit(args.children[1]))

        # Vai buscar os items e adiciona à função
        for child in args.children[2:-1]:
            self.funcoes[self.func_id].items.append(self.visit(child))

        # Vai buscar o return e adiciona à função
        self.funcoes[self.func_id].ret = self.visit(args.children[-1])

        funcao = self.funcoes[self.func_id]
        self.func_id = None
        return funcao

    def item(self, args):
        return self.visit(args.children[0])

    def declaracao(self, args) -> Declaracao:
        self.estatisticas.incDecl()

        tipo = str(args.children[0])
        self.estatisticas.incTipo(tipo)
        self.erros = ["notDecl", "Decl"]
        exp2: EXP2 = self.visit(args.children[1])
        var = Variavel(tipo, exp2.op1.id)

        if len(args.children) > 2:  # Tem valor
            self.erros = ["notDecl", "notInit"]
            var.valor = self.visit(args.children[2])
            var.inicializa()

        if exp2.erro is None:
            return Declaracao(tipo, var.id, var.valor, None)

        if exp2.erro.tipo == "Decl":  # Redeclaração -- ERRO
            return Declaracao(tipo, var.id, var.valor, exp2.erro)

        if exp2.erro.tipo == "notDecl":  # Não declarada
            self.estatisticas.naoDeclarado -= 1
            if "." in var.id:
                try:
                    idSplit = var.id.split(".")
                    varAux: Variavel = self.vars[idSplit[0]]

                    for i in range(1, len(idSplit)-1):
                        varAux = varAux.atributos[idSplit[i]]
                    
                    varAux.atributos[idSplit[-1]] = var
                    return Declaracao(tipo, var.id, var.valor, None)
                except: # Algum elemento antes do último não existe. Ex: a.b.c.d, mas a.b não existe
                    return Declaracao(tipo, var.id, var.valor, exp2.erro)
            else:
                if self.func_id is not None:
                    self.funcoes[self.func_id].vars[var.id] = var
                else:
                    self.vars[var.id] = var
                return Declaracao(tipo, var.id, var.valor, None)

    def instrucao(self, args):
        return self.visit(args.children[0])

    def atrib(self, args) -> Atribuicao:
        self.estatisticas.incAtrib()

        self.erros = ["notDecl", "notInit", "Decl"]
        exp2 = self.visit(args.children[0])
        
        self.erros = ["notDecl", "notInit"]
        ans = self.visit(args.children[1])

        if exp2.erro is None:
            return Atribuicao(exp2, ans)
        if exp2.erro.tipo == "notDecl":  # Não declarada -- ERRO
            return Atribuicao(exp2, ans)
        else:  # Variável declarada ou não inicializada
            if exp2.erro.tipo == "Decl":
                self.estatisticas.redeclaracao -= 1
            elif exp2.erro.tipo == "notInit":
                self.estatisticas.naoInicializado -= 1
            if exp2.erro.local == "Inside":
                self.funcoes[self.func_id].vars[exp2.op1.id].inicializa()
                self.funcoes[self.func_id].vars[exp2.op1.id].valor = ans
            elif exp2.erro.local == "Param":
                self.funcoes[self.func_id].params[exp2.op1.id].inicializa()
                self.funcoes[self.func_id].params[exp2.op1.id].valor = ans
            else:
                self.vars[exp2.op1.id].inicializa()
                self.vars[exp2.op1.id].valor = ans
            exp2.erro = None
            return Atribuicao(exp2, ans)

    def leitura(self, args):
        self.estatisticas.incLeitura()

        self.erros = ["notDecl"]
        exp2: EXP2 = self.visit(args.children[0])

        return FuncaoSTD("LER", exp2)

    def escrita(self, args):
        self.estatisticas.incEscrita()
        
        self.erros = ["notDecl"]
        val: EXP = self.visit(args.children[0])

        return Escrita(val)

    def exp2(self, args):
        if len(args.children) > 1:  # Do tipo a.b.c.d
            varSTR = ".".join(args.children)
            erro = self.checkID([str(x) for x in args.children])
            if erro.tipo in self.erros:
                if erro.tipo == "notDecl":
                    self.estatisticas.incNaoDeclarado()
                elif erro.tipo == "Decl":
                    self.estatisticas.incRedeclaracao()
                elif erro.tipo == "notInit":
                    self.estatisticas.incNaoInicializado()
                return EXP2(ID(varSTR), erro)
            return EXP2(ID(varSTR), None)

        # Do tipo a
        erro = self.checkID(args.children[0])

        if erro is not None and erro.tipo in self.erros:
            if erro.tipo == "notDecl":
                self.estatisticas.incNaoDeclarado()
            elif erro.tipo == "Decl":
                self.estatisticas.incRedeclaracao()
            elif erro.tipo == "notInit":
                self.estatisticas.incNaoInicializado()
            return EXP2(ID(str(args.children[0])), erro)
        return EXP2(ID(str(args.children[0])), None)

    def exp(self, args):
        visited = self.visit_children(args)
        return EXP(visited[0], visited[1:])

    def abs(self, args):
        if isinstance(args.children[0], Tree):  # Valor positivo
            return ABS(self.visit(args.children[0]))
        else:  # Quando tem um ! (valor negativo)
            return ABS(self.visit(args.children[1]), True)

    def op(self, args):
        return str(args.children[0])

    # verifica ID quando faz parte de uma expressão
    def checkID(self, child: str|list[str]) -> Erro:
        if self.func_id is not None:  # Dentro de uma função
            if type(child) == list:
                var = self.funcoes[self.func_id].vars.get(child[0], None)

                if var is not None:  # Variável possivelmente criada dentro da função
                    try:
                        for id in child[1:]:
                            var = var.atributos.get(id)
                    except:  # Variável não declarada dentro da função
                        return Erro("notDecl", "Inside")
                    
                    if var is None:
                        return Erro("notDecl", "Global")

                    if (
                        var.nInicializada == 0
                    ):  # Variável não inicializada dentro da função
                        return Erro("notInit", "Inside")
                    return Erro("Decl", "Inside")

                else:  # Variável possível de um parâmetro
                    var = self.funcoes[self.func_id].params.get(child[0], None)

                    if var is not None:  # Variável possivelmente declarada nos parâmetros
                        try:
                            for id in child[1:]:
                                var = var.atributos.get(id)
                        except:  # Variável não declarada nos parâmetros
                            return Erro("notDecl", "Param")
                        
                        if var is None:
                            return Erro("notDecl", "Global")

                        if (
                            var.nInicializada == 0
                        ):  # Variável não inicializada nos parâmetros
                            return Erro("notInit", "Param")
                        return Erro("Decl", "Param")
                    else:  # Variável não declarada nos parâmetros
                        return Erro("notDecl", "Inside")

            else:  # Variável é uma String
                if (
                    child in self.funcoes[self.func_id].vars
                ):  # Variável criada dentro da função
                    if (
                        self.funcoes[self.func_id].vars[child].nInicializada == 0
                    ):  # Variável não inicializada dentro da função
                        return Erro("notInit", "Inside")
                    return Erro("Decl", "Inside")
                elif (
                    child not in self.funcoes[self.func_id].params
                ):  # Variável criada nos parâmetros (não importa se está inicializada ou não)
                    return Erro(
                        "notDecl", "Inside"
                    )  # Variável não declarada dentro da função
                else:
                    return Erro("Decl", "Param")

        else:  # Fora de uma função
            if type(child) == list:
                var = self.vars.get(child[0], None)
                try:
                    for id in child[1:]:
                        var = var.atributos.get(id)
                except:
                    return Erro("notDecl", "Global")
                
                if var is None:
                    return Erro("notDecl", "Global")

                if var.nInicializada == 0:
                    return Erro("notInit", "Global")
                return Erro("Decl", "Global")
            else:  # Variável é uma String
                if child in self.vars:
                    if self.vars[child].nInicializada == 0:  
                        return Erro("notInit", "Global") # Variável não inicializada globalmente
                    return Erro("Decl", "Global")
                else:  
                    return Erro("notDecl", "Global") # Variável não declarada globalmente

    def valor(self, args):
        fst_children = args.children[0]
        typedata = (
            fst_children.data if isinstance(fst_children, Tree) else fst_children.type
        )

        if typedata == "ID":  # ID [ exp ]
            self.erros = ["notDecl", "notInit"]
            
            erro: Erro = self.checkID(fst_children)
            resto: EXP = self.visit(args.children[1])

            self.erros = []
            return Array(fst_children, resto, erro)

        elif typedata == "ELEM":
            exp2: EXP2 = self.visit(args.children[1])
            return FuncaoSTD(str(fst_children), exp2)

        elif typedata == "funcao_chamada":
            return self.visit(fst_children)

        elif typedata == "val":
            return self.visit(fst_children)

        else:  # exp2
            return self.visit(fst_children)

    def params(self, args):
        params = {}
        for child in args.children:
            params[str(child)] = (self.vars[str(child)] if str(child) in self.vars else Variavel("", str(child)))
            
        return params

    def selecaoSE(self, args):
        self.estatisticas.incSelecao()

        # Vai buscar a condição do SE
        cond = self.visit(args.children[0])
        corpo = []

        i = 1
        while i < len(args.children):
            corpo.append(self.visit(args.children[i]))
            
            i -= 1
            if (type(corpo[i]) in [Selecao, Caso, Repeticao]):
                corpo[i].aninhado = True
                self.estatisticas.incAninhado()

            i += 2

        if len(corpo) == 1 and isinstance(corpo[0], Selecao):
            corpo[0].merged = True
            self.estatisticas.incMerge()

        return Selecao(cond, corpo)

    def selecaoCASO(self, args):
        exp2:EXP2 = self.visit(args.children[0])

        corpo = []
        x = 1
        while x < len(args.children):
            val = self.visit(args.children[x])
            x += 1
            corpoItem = []
            while x < len(args.children) and args.children[x].data == "item":
                visited = self.visit(args.children[x])
                if (type(visited) in [Selecao, Caso, Repeticao]):
                    visited.aninhado = True
                    self.estatisticas.incAninhado()
                corpoItem.append(visited)
                x += 1

            corpo.append((val, corpoItem))

        return Caso(exp2, corpo)

    def selecao(self, args):
        if args.children[0].data == "exp":
            return self.selecaoSE(args)
        else:
            return self.selecaoCASO(args)

    def repeticao(self, args):
        self.estatisticas.incRepeticao()
        if isinstance(args.children[0], Tree):
            if args.children[0].data == "exp":  # ENQUANTO
                exp = self.visit(args.children[0])
                corpo = []
                for child in args.children[1:]:
                    visited = self.visit(child)
                    if (
                        isinstance(visited, Selecao)
                        or isinstance(visited, Caso)
                        or isinstance(visited, Repeticao)
                    ):
                        visited.aninhado = True
                        self.estatisticas.incAninhado()
                    corpo.append(visited)

                return Repeticao(exp, corpo, "ENQUANTO")

            elif args.children[0].data == "item":  # REPETIR
                corpo = []

                for child in args.children[:-1]:
                    visited = self.visit(child)
                    if (
                        isinstance(visited, Selecao)
                        or isinstance(visited, Caso)
                        or isinstance(visited, Repeticao)
                    ):
                        visited.aninhado = True
                        self.estatisticas.incAninhado()
                    corpo.append(visited)

                exp = self.visit(args.children[-1])
                return Repeticao(exp, corpo, "REPETIR")
        else:  # PARA
            exp = EXP(Valor(int(args.children[0])))
            corpo = []
            for child in args.children[1:]:
                visited = self.visit(child)
                if (
                    isinstance(visited, Selecao)
                    or isinstance(visited, Caso)
                    or isinstance(visited, Repeticao)
                ):
                    visited.aninhado = True
                    self.estatisticas.incAninhado()
                corpo.append(visited)

            return Repeticao(exp, corpo, "PARA")

    def funcao_chamada(self, args):
        func_id = str(args.children[0])

        erro = None
        if func_id not in self.funcoes:
            erro = Erro("funcNotDeclared")

        params = []
        for param in args.children[1:]:
            params += self.visit(param)
        return FuncaoChamada(func_id, params, erro)

    ##### TIPOS DE DADOS ######

    def val(self, args):
        child = args.children[0]
        if isinstance(child, Tree):
            return Valor(self.visit(child)) 
        else:
            if child.type == "NUM":
                return Valor(int(child))

            elif child.type == "BOOL":
                return Valor(child == "True")

            return Valor(str(child))  # STRING

    def conjunto(self, args):
        return self.visit(args.children[0])

    def tuplo(self, args):
        val = ()
        for child in args.children:
            val += (self.visit(child),)
        return val

    def lista(self, args):
        val = []
        for child in args.children:
            val.append(self.visit(child))
        return val

    def args(self, args):
        params = []
        for child in args.children:
            if isinstance(child, Tree):
                params.append(self.visit(child))
            else:
                params.append(str(child))
        return params
    
    def mcCabeCalc(self, function: str) -> int:
        if function not in self.funcoes:
            return 0
        
        f = self.funcoes[function]
        total = 0

        for dep in f.mcCabeDependency:
            total += self.mcCabeCalc(dep) - 2
        
        return total + f.mcCabe
        


def Parse(input, outputHTML, outputGraph, mcCabeFunc):
    gramatica = open("TP3/data/gic.txt", "r").read()
    p = Lark(gramatica, start="programa")


    f = open(input, "r")
    text = f.read()
    f.close()

    tree = p.parse(text)
    g = Gramatica()
    g.mcCabeFunction = mcCabeFunc if mcCabeFunc is not None else "_main"

    html = g.visit(tree)

    if outputHTML:
        f = open(outputHTML, "w")
        f.write(html)
        f.close()
    else:
        f = open(f"""TP3/out/{input.split("/")[-1].split(".")[0]}.html""", "w")
        f.write(html)
        f.close()
