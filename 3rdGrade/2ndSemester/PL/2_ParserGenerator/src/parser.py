import re
import ply.yacc as yacc
import sys
import os
from lexer import tokens, literals

f = None
dgram = {}

file = None
args = sys.argv[1:]

if len(args) == 2 and args[0] == "-i":
    try:
        file = open(f"input/{args[1]}", encoding="utf-8", mode="r")
        args[1] = args[1].replace(".txt", ".py")
        f = open(f"output/{args[1]}", "w")
    except FileNotFoundError:
        print("Ficheiro não encontrado")
        exit()
elif len(args) == 4 and args[0] == "-i" and args[2] == "-o":
    try:
        file = open(f"input/{args[1]}", encoding="utf-8", mode="r")
        f = open(f"output/{args[3]}", "w")
    except FileNotFoundError:
        print("Ficheiro não encontrado")
        exit()

data = file.read()
file.close()


def p_program(p):
    """program : empty
                | program exp"""
    if len(p) > 2:
        f.write(p[2])


def p_empty(p):
    """empty : """


def p_exp_comentario(p):
    """exp : COMENTARIO"""
    p[0] = p[1] + "\n"


def p_lista(p):
    """lista : '[' listcont
            | '[' ']'"""
    p[0] = p[1] + p[2]


def p_tuplo(p):
    """tuplo : '(' tupcont
            | '(' ')'"""
    p[0] = p[1] + p[2]


def p_dict(p):
    """dict : '{' dictcont
                | '{' '}'"""
    p[0] = p[1] + p[2]


def p_listcont(p):
    """listcont : STRING ']'
                | STRING ',' listcont
                | tuplo ']'
                | tuplo ',' listcont"""

    p[0] = p[1] + p[2] + p[3] if len(p) == 4 else p[1] + p[2]


def p_tupcont(p):
    """tupcont : STRING ')'
                | STRING ',' tupcont
                | tuplo ')'
                | tuplo ',' tupcont"""
    p[0] = p[1] + p[2] + p[3] if len(p) == 4 else p[1] + p[2]


def p_dictcont(p):
    """dictcont : STRING ':' STRING '}'
                | STRING ':' STRING ',' dictcont"""
    p[0] = p[1] + p[2] + p[3] + p[4] + p[5] if len(p) == 6 else p[1] + p[2] + p[3] + p[4]


def p_exp_yaccline(p):
    """exp : EXP GRAM TODO"""
    p[1] = p[1][:-2]
    global dgram
    if not p[1] in dgram.keys():
        dgram[p[1]] = 0
    else:
        dgram[p[1]] += 1
    p[2] = p[2][:-1]
    p[3] = p[3][:-1]
    p[0] = f"def p_{p[1]}_{dgram[p[1]]}(t):\n\tr\"{p[1]} : {p[2]}\"\n\t{p[3]}\n"


def p_exp_lex(p):
    """exp : '%' '%' LEX"""
    p[0] = "from ply import lex" + "\n"


def p_exp_yacc(p):
    """exp : '%' '%' YACC"""
    p[0] = "\nlex = lex.lex()\nfrom ply.yacc import yacc" + "\n"


def p_exp_initcode(p):
    """exp : INITCODE"""
    p[0] = "#code" + "\n"


def p_exp_pycode(p):
    """exp : PYCODE"""
    p[0] = p[1] + "\n"


def p_exp_lexvars(p):
    """exp : '%' LITERALS lista
            | '%' LITERALS STRING
            | '%' TOKENS lista
            | '%' TOKENS STRING
            | '%' LEXIGNORE STRING"""
    p[0] = p[2] + p[3] + "\n"


def p_exp_lexRules(p):
    """exp : REGEX OPENPARENTESES STRING codigo
            | REGEX OPENPARENTESES FSTRING codigo"""
    p[0] = f"def t_{p[3][1:-1]}(t):\n\tr\"{p[1][:-7]}\"\n\tt.value={p[4][2:-1]}\n\treturn t" + "\n"


def p_exp_lexError(p):
    """exp : ERROR OPENPARENTESES STRING codigo
            | ERROR OPENPARENTESES FSTRING codigo"""
    match = re.match(r"[^, ]*,(.+)\)", p[4])
    codigo = None
    if match:
        codigo = match.group(1)
    if codigo:
        p[0] = f"def t_error(t):\n\tprint({p[3]})\n\t{codigo}\n"
    else:
        p[0] = f"def t_error(t):\n\tprint({p[3]})\n"


def p_codigo(p):
    """codigo : PYCODE CLOSEPARENTESES
                | PYCODE OPENPARENTESES codigo CLOSEPARENTESES"""
    p[0] = p[1] + p[2] + p[3] + p[4] if len(p) == 5 else p[1] + p[2]


def p_exp_precedence(p):
    """exp : '%' PRECEDENCE lista"""
    p[0] = f"{p[2]} {p[3]}\n"


def p_exp_variavelAtrib(p):
    """exp : VARIAVEL '=' dict"""
    p[0] = f"{p[1]} {p[2]} {p[3]}\n"


# Error rule for syntax errors
def p_error(p):
    print("Erro de sintaxe: ", p)
    parser.success = False


# Build the parser
parser = yacc.yacc()
parser.success = True

res = parser.parse(data)

if parser.success:
    print("Conversão efetuada!")
f.close()

