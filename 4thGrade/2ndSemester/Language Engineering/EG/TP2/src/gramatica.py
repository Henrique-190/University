from lark import Discard
from lark import Lark,Token,Tree
from lark.visitors import Interpreter
import htmlOut

gramatica = open("data/gic.txt", "r").read() 

class Gramatica(Interpreter):
    vars = {} # corpo principal  
    #self.vars[id] = {
    #            "tipo": None,
    #            "val": val,
    #            "dec": 0,
    #            "init": 1
    #        }

    #self.funcoes[self.func_id]["vars"][id] = {
    #            "tipo": None,
    #            "val": val,
    #            "dec": 0,
    #            "init": 1
    #        }
    # self.funcoes[self.func_id] ={
    #        "params" : {},
    #        "ret" : val,
    #        "vars" : {},
    #    }

    html = htmlOut.initHTML()
    funcoes = {}
    merge = 0
    indent = 0
    se_aninhado = 0
    SE_simples = None
    aninhado = 0
    func_id = None
    instrucoes = {
        "total" : 0,
        "atrib" : 0,
        "escrita": 0,
        "leitura": 0,
        "selecao": 0,
        "repeticao": 0,
        "aninhado": 0,
        "merge": 0,
    }

    def programa(self, args):
        self.visit_children(args)
        self.html += htmlOut.endHTML()
        self.stats()
        return {"vars":self.vars,
                "funcs":self.funcoes, 
                "html":self.html,
                "instrucoes":self.instrucoes,
                }
    
    def funcao(self, args):
        id = str(args.children[0])
        params = self.visit(args.children[1])
        self.new_func(id, params)
        
        paramsHTML = ""
        for _, key in enumerate(params):
            paramsHTML += htmlOut.variable_name(key) + ", "
        paramsHTML = paramsHTML[:-2]
        self.html += htmlOut.keyword(id, self.indent) + " { " + paramsHTML + "}"
        self.html += "<br>"
        self.indent += 1

        for child in args.children[1:-1]:
            self.visit(child)
        
        self.indent -= 1
        self.html += htmlOut.keyword("RET", self.indent)
        for _, html in self.visit(args.children[-1]):
            self.html += html
        
        self.html += "<br>"
        self.func_id = None
    
    def item(self, args):
        self.visit_children(args)

    def declaracao(self, args):
        tipo = str(args.children[0])
        id = str(args.children[1])
        valor = None
        dec = 1
        init = 0
        if len(args.children) > 2:
            valor = self.visit(args.children[2])
            init = 1

        self.html += htmlOut.keyword(tipo, self.indent)

        erro, html = self.checkID(id)
        
        if erro == -1: #Não declarada
            self.new_var(id, tipo, valor, dec, init, self.func_id)
            self.html += htmlOut.variable_name(id)
        else: #Variavel já declarada
            self.html += html

        if valor:
            self.html += htmlOut.value(str(valor))
        
        self.html += "<br>"


    def instrucao(self, args):
        self.instrucoes["total"] += 1 
        self.visit_children(args)
    
    def atrib(self, args):
        self.instrucoes["atrib"] += 1
        self.html += htmlOut.keyword("ATRIB", self.indent)

        id = self.visit(args.children[0])
        main_id = id[0] if type(id) == list else id
        ans = self.visit(args.children[1])
        valor = "".join([str(x[0]) for x in ans])
        valHTML = "".join([x[1] for x in ans])
        
        err, errHTML = self.checkID(id)
        if err == -1: #Não declarada
            self.html += errHTML + (".".join(id[1:]) if type(id) == list else "")
        else:
            if err == -2 or err == 2 or err == 0: 
                #Pode ou não ter sido inicializada (não importa). Pode ser variável local ou global
                if self.func_id == None: # Variável global
                    self.vars[main_id]["init"] += 1
                    self.vars[main_id]["val"] = valor
                else: # Variável local
                    self.funcoes[self.func_id]["vars"][main_id]["init"] += 1
                    self.funcoes[self.func_id]["vars"][main_id]["val"] = valor
                self.html += htmlOut.variable_name(main_id + ".".join(id[1:]))
                
            else: # Variável de um parâmetro. Ver se esse parâmetro existe
                if main_id in self.funcoes[self.func_id]["params"]:
                    self.new_var(main_id, None, valor, 0, 1, self.func_id)
                    self.funcoes[self.func_id]["vars"][main_id]["extra"] = True
                    self.funcoes[self.func_id]["vars"][main_id]["init"] += 1
                    self.funcoes[self.func_id]["vars"][main_id]["val"] = valor
                    self.html += htmlOut.variable_name(main_id + ".".join(id[1:]))

                else:
                    self.html += htmlOut.error("notDecl", main_id, "Variável nula")
        
        self.html += valHTML
        self.html += "<br>"

    def leitura(self, args):
        self.instrucoes["leitura"] += 1

        self.html += htmlOut.keyword("LER", self.indent)

        id = self.visit(args.children[0])
        main_id = id[0] if type(id) == list else id        
        err, errHTML = self.checkID(id)

        if err == -1: #Não declarada
            self.html += errHTML + (".".join(id[1:]) if type(id) == list else "")
        else:
            if err == -2 or err == 2 or err == 0: 
                #Pode ou não ter sido inicializada (não importa). Pode ser variável local ou global
                if self.func_id == None: # Variável global
                    self.vars[main_id]["init"] += 1
                    self.vars[main_id]["val"] = "read_value"
                else: # Variável local
                    self.funcoes[self.func_id]["vars"][main_id]["init"] += 1
                    self.funcoes[self.func_id]["vars"][main_id]["val"] = "read_value"
                self.html += htmlOut.variable_name(main_id + ".".join(id[1:]))
                
            else: # Variável de um parâmetro. Ver se esse parâmetro existe
                if self.funcoes[self.func_id]["params"][main_id] != None:
                    self.funcoes[self.func_id]["params"][main_id]["init"] += 1
                    self.funcoes[self.func_id]["params"][main_id]["val"] = "read_value"
                    self.html += htmlOut.variable_name(main_id + ".".join(id[1:]))

                else:
                    self.html += htmlOut.error("notDecl", main_id, "Variável nula")
        
        self.html += "<br>"
              
    
    def escrita(self, args):
        self.instrucoes["escrita"] += 1
        self.html += htmlOut.keyword("ESCREVER", self.indent)
        val, valHTML = self.visit(args.children[0])[0]
        if val == None:
            self.html += valHTML
        else :
            self.html += htmlOut.variable_name(str(val))
        self.html += "<br>"

    def exp2(self, args):
        if isinstance(args.children[0], Tree):
            return [str(child) for child in args.children]
        return str(args.children[0])

    def exp(self, args):
        return self.visit_children(args)
    
    def abs(self, args):
        if isinstance(args.children[0], Tree):
            return self.visit(args.children[0])
        else:
            self.html += "!"
            return self.visit(args.children[1])
    
    def op(self, args):
        return None, str(args.children[0]) + " "

    # verifica ID quando faz parte de uma expressão 
    def checkID(self, child):
        id = str(child)
        if self.func_id != None:
            if id in self.funcoes[self.func_id]["vars"]:
                if self.funcoes[self.func_id]["vars"][id]["init"] == 0:
                    return -2, htmlOut.error("notInit", id, "Variável já declarada mas não inicializada")
                else:
                    return 2, htmlOut.error("Init", id, "Variável já declarada e inicializada")
            elif id in self.funcoes[self.func_id]["params"]:
                return 1, htmlOut.error("Decl", id, "Variável já declarada mas não inicializada")
            else:
                return -1, htmlOut.error("notDecl", id, "Variável não declarada nem inicializada")
        if id in self.vars:
            if self.vars[id]["init"] == 0:
                return -2, htmlOut.error("notInit", id, "Variável já declarada mas não inicializada")
            else:
                return 0, htmlOut.error("Init", id, "Variável já declarada e inicializada")
        return -1, htmlOut.error("notDecl", id, "Variável não declarada nem inicializada")


    def valor(self, args):
        fst_children = args.children[0]
        typedata = fst_children.data if isinstance(fst_children, Tree) else fst_children.type
        if typedata == "ID":
            err, errHTML = self.checkID(fst_children)
            if err < 0:
                return None, errHTML
            else:
                id = str(fst_children)
                return id, htmlOut.variable_name(id)

        elif typedata == "ELEM":
            exp2 = self.visit(fst_children)
            return str(fst_children) + exp2, htmlOut.keyword(str(fst_children)) + htmlOut.variable_name(exp2)

        elif typedata == "funcao_chamada":
            funcHTML = self.visit(fst_children)
            return [-6, funcHTML]
        
        elif typedata == "val":
            value = self.visit(fst_children)
            return [value, htmlOut.value(str(value))]
        
        else:
            id = self.visit(fst_children)
            cID = self.checkID(id)
            if cID[0] < 0:
                return None, cID[1] + (self.visit(args.children[1:]) if len(args.children) > 1 else "")
            else:
                return id, htmlOut.variable_name(id)
        
    
    def params(self, args):
        params = {}
        for child in args.children:
            params[str(child)] = self.vars[str(child)] if str(child) in self.vars else {}
        return params

    def selecaoSE(self, args):
        self.html += htmlOut.keyword("SE", self.indent)

        expressaoHTML = ""
        exp = self.visit(args.children[0])
        for _, html in exp:
            expressaoHTML += html

        self.html += expressaoHTML + "\n"

        self.indent += 1

        for child in args.children[1:]:
            self.visit(child)

        self.indent -= 1

        if self.SE_simples == None:
            # Último SE
            self.SE_simples = True
        elif len(args.children) == 2 and self.SE_simples == True:
            # Restante dos SEs. Só podem ter um filho que é um SE
            self.merge += 1
            self.SE_simples = True
        elif len(args.children) > 2 and self.SE_simples == True:
            # SE com mais de um filho, já não pode ser aninhado
            self.SE_simples = False
        

        self.html += htmlOut.keyword("ES", self.indent)
        self.html += "<br>"


    def selecaoCASO(self,args):
        # fora de funcoes
        id = self.visit(args.children[0])
        
        self.html += htmlOut.keyword("CASO", self.indent)
        err, errHTML = self.checkID(id)
        if err < 0:
            self.html += errHTML
        else:
            self.html += htmlOut.variable_name(id)
        
        self.html += "<br>"
        self.indent += 1
        
        exps = iter(args.children[1:])
        for child in exps:
            # val
            self.html += "\t"*self.indent + str(self.visit(child)) + " :\n"
            # item
            self.indent += 1
            self.visit(next(exps))
            self.indent -= 1

        self.indent -= 1

        self.html += htmlOut.keyword("OSAC", self.indent)
        self.html += "<br>"

        
    def selecao(self, args):
        if self.aninhado > 0:
            self.instrucoes["aninhado"] += 1
        self.aninhado += 1
        self.se_aninhado += 1
        self.instrucoes["selecao"] += 1
        if args.children[0].data == "exp":
            self.selecaoSE(args)
        else:
            self.selecaoCASO(args)

        self.aninhado -= 1
        self.se_aninhado -= 1
        if self.se_aninhado == 0:
            self.SE_simples = None

    def repeticao(self, args):
        if self.aninhado > 0:
            self.instrucoes["aninhado"] += 1
        self.aninhado += 1

        if isinstance(args.children[0], Tree):
            if args.children[0].data == "exp":
                self.html += htmlOut.keyword("ENQ", self.indent)
                a = self.visit(args.children[0])
                for _, html in a:
                    self.html += html

                self.html += htmlOut.keyword("FAZER", self.indent)
                self.html += "{"
                self.html += "<br>"
                self.indent += 1

                for child in args.children[1:]:
                    self.visit(child)

                self.indent -= 1
                self.html += "}"
                self.html += "<br>"
            elif args.children[0].data == "item":
                self.html += htmlOut.keyword("REPETIR", self.indent)
                self.indent += 1
                self.html += "<br>"
                for child in args.children[:-1]:
                    self.visit(child)

                self.indent -= 1
                self.html += htmlOut.keyword("ATE", self.indent)
                a = self.visit(args.children[-1])
                for _, html in a:
                    self.html += html
                self.html += "<br>"
        else:
            self.html += htmlOut.keyword("PARA", self.indent)
            self.html += htmlOut.value(str(args.children[0]))
            self.html += htmlOut.keyword("FAZER", self.indent)
            self.html += "<br>"
            self.html += "{"
            self.html += "<br>"
            self.indent += 1

            for child in args.children[1:]:
                self.visit(child)
            
            self.indent -= 1
            self.html += "}"
            self.html += "<br>"
        
        self.instrucoes["repeticao"] += 1
        self.aninhado -= 1

    def funcao_chamada(self, args):
        func_id = str(args.children[0])
        func_html = ""
        if func_id in self.funcoes:
            func_html += htmlOut.keyword(str(func_id), self.indent)
        else:
            func_html += htmlOut.error(func_id, "Função não declarada")
        
        params = ""

        for param in self.visit(args.children[1]):
            err, errHTML = self.checkID(param)
            if err < 0:
                params += errHTML
            else:
                params += htmlOut.variable_name(str(param))
            params += ", "

        return func_html + " { " + params + " } "


    ##### TIPOS DE DADOS ######

    def val(self, args):
        args = args.children[0]
        val = None
        # conjunto (lista | tuplo)
        if isinstance(args, Tree):
            val = self.visit(args)
        else:
            if args.type == "NUM":
                val = int(args)

            elif args.type == "BOOL":
                if (args == "True"):
                    val = True
                else:
                    val = False

            elif args.type == "STRING":
                val = str(args)
        
        return val
    
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
            params.append(str(child))
        return params
    
    def new_func(self, id, params):
        self.func_id = id
        self.funcoes[self.func_id] = {
            "params" : params,
            "vars" : {},
        }
    
    def new_var(self, id, tipo, valor, dec, init, func_id):
        if func_id != None: #Variável dentro de função
            self.funcoes[func_id]["vars"][id] = {
                "tipo" : tipo,
                "valor" : valor,
                "dec" : dec,
                "init" : init,
            }
        else: #Variável fora de função
            self.vars[id] = {
                "tipo" : tipo,
                "valor" : valor,
                "dec" : dec,
                "init" : init,
            }  

    def stats(self):
        self.html += htmlOut.stats(self.instrucoes, self.vars, self.funcoes, self.merge)


    
p = Lark(gramatica, start="programa") 

tree = p.parse(open("data/testes.txt", "r").read())

data = Gramatica().visit(tree) # chamar o transformer para obter

with open("out/output.html", "w") as f:
    f.write(data["html"])
    f.close()