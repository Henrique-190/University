from ply import lex

tokens = ["LEX", "YACC", "LITERALS", "LEXIGNORE", "TOKENS", "STRING", "FSTRING", "ERROR", "REGEX", "VARIAVEL",
          "PRECEDENCE", "COMENTARIO", "GRAM", "TODO", "PYCODE",  "INITCODE", "EXP", "OPENPARENTESES", "CLOSEPARENTESES"]
literals = ["(", ")", "[", "]", ":", "=", ",", "{", "}", "%", "\n"]
states = [("GRAMATICA", "exclusive"), ("TODOTHINGS", "exclusive"), ("CODE", "exclusive"), ("RETURN", "exclusive")]

t_ANY_ignore = ' \n\r\t'
t_CODE_ignore = '\n\r'


def t_INITIAL_LEX(t):
    r"""LEX"""
    return t


def t_INITIAL_YACC(t):
    r"""YACC"""
    return t


def t_INITIAL_LITERALS(t):
    r"""literals\ *\="""
    return t


def t_INITIAL_LEXIGNORE(t):
    r"""ignore\ *\="""
    return t


def t_INITIAL_TOKENS(t):
    r"""tokens\ *\="""
    return t


def t_INITIAL_RETURN_FSTRING(t):
    r"""(f\'[^\']*\')|(f\"[^\"]*\")"""
    return t


def t_INITIAL_RETURN_STRING(t):
    r"""(\'[^\']*\')|(\"[^\"]*\")"""
    return t


def t_INITIAL_REGEX(t):
    r""".*\ return"""
    t.lexer.begin("RETURN")
    t.lexer.level = 0
    return t


def t_RETURN_PYCODE(t):
    r"""[^(^)]+"""
    return t


def t_RETURN_OPENPARENTESES(t):
    r"""\("""
    t.lexer.level += 1
    return t


def t_RETURN_CLOSEPARENTESES(t):
    r"""\)"""
    t.lexer.level -= 1
    if t.lexer.level == 0:
        t.lexer.begin("INITIAL")

    return t


def t_INITIAL_ERROR(t):
    r"""\.\ *error"""
    t.lexer.begin("RETURN")
    return t


def t_INITIAL_EXP(t):
    r"""\w+\ *\:"""
    t.lexer.begin("GRAMATICA")
    return t


def t_INITIAL_PRECEDENCE(t):
    r"""precedence\ *\="""
    return t


def t_INITIAL_VARIAVEL(t):
    r"""[\w\d]+"""
    return t


def t_INITIAL_COMENTARIO(t):
    r"""\#.*"""
    return t


def t_GRAMATICA_GRAM(t):
    r"""[^\{]*\{"""
    t.lexer.begin("TODOTHINGS")
    return t


def t_TODOTHINGS_TODO(t):
    r"""[^\}]*\}"""
    t.lexer.begin("INITIAL")
    return t


def t_INITCODE(t):
    r"""\%\%\n"""
    t.lexer.begin("CODE")
    return t


def t_CODE_PYCODE(t):
    r""".+"""
    return t


def t_ANY_error(t):
    print(f"Illegal character '{t.value[0]}'")
    t.lexer.skip(1)


lexer = lex.lex()
lexer.level = 0
lexer.begin("INITIAL")
