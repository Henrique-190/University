\documentclass[a4paper]{article}
\usepackage[a4paper,left=3cm,right=2cm,top=2.5cm,bottom=2.5cm]{geometry}
\usepackage{palatino}
\usepackage[colorlinks=true,linkcolor=blue,citecolor=blue]{hyperref}
\usepackage{graphicx}
\usepackage{cp2122t}
\usepackage{subcaption}
\usepackage{trees}
\usepackage{adjustbox}
\usepackage{color}
\definecolor{red}{RGB}{255,  0,  0}
\definecolor{blue}{RGB}{0,0,255}
\def\red{\color{red}}
\def\blue{\color{blue}}
%================= local x=====================================================%
\def\getGif#1{\includegraphics[width=0.3\textwidth]{cp2122t_media/#1.png}}
\let\uk=\emph
\def\aspas#1{``#1"}
%================= lhs2tex=====================================================%
%include polycode.fmt
%format (div (x)(y)) = x "\div " y
%format succ = "\succ "
%format ==> = "\Longrightarrow "
%format map = "\map "
%format length = "\length "
%format fst = "\p1"
%format p1  = "\p1"
%format snd = "\p2"
%format p2  = "\p2"
%format Left = "i_1"
%format Right = "i_2"
%format i1 = "i_1"
%format i2 = "i_2"
%format >< = "\times"
%format >|<  = "\bowtie "
%format |-> = "\mapsto"
%format . = "\comp "
%format .=?=. = "\mathbin{\stackrel{\mathrm{?}}{=}}"
%format (kcomp (f)(g)) = f "\kcomp " g
%format -|- = "+"
%format conc = "\mathsf{conc}"
%format summation = "{\sum}"
%format (either (a) (b)) = "\alt{" a "}{" b "}"
%format (frac (a) (b)) = "\frac{" a "}{" b "}"
%format (uncurry f) = "\uncurry{" f "}"
%format (const (f)) = "\underline{" f "}"
%format TLTree = "\mathsf{TLTree}"
%format (lcbr (x)(y)) = "\begin{lcbr}" x "\\" y "\end{lcbr}"
%format (split (x) (y)) = "\conj{" x "}{" y "}"
%format (for (f) (i)) = "\for{" f "}\ {" i "}"
%format B_tree = "\mathsf{B}\mbox{-}\mathsf{tree} "
\def\ana#1{\mathopen{[\!(}#1\mathclose{)\!]}}
%format <$> = "\mathbin{\mathopen{\langle}\$\mathclose{\rangle}}"
%format Either a b = a "+" b
%format fmap = "\mathsf{fmap}"
%format NA   = "\textsc{na}"
%format NB   = "\textsc{nb}"
%format inT = "\mathsf{in}"
%format outT = "\mathsf{out}"
%format outLTree = "\mathsf{out}"
%format inLTree = "\mathsf{in}"
%format inFTree = "\mathsf{in}"
%format outFTree = "\mathsf{out}"
%format Null = "1"
%format (Prod (a) (b)) = a >< b
%format fF = "\fun F "
%format k1 = "k_1 "
%format k2 = "k_2 "
%format h1 = "h_1 "
%format h2 = "h_2 "
%format f1 = "f_1 "
%format f2 = "f_2 "
%format l1 = "l_1 "
%format map1 = "map_1 "
%format map2 = "map_2 "
%format map3 = "map_3"
%format l2 = "l_2 "
%format Dist = "\fun{Dist}"
%format IO = "\fun{IO}"
%format LTree = "{\LTree}"
%format FTree = "{\FTree}"
%format inNat = "\mathsf{in}"
%format (cata (f)) = "\cata{" f "}"
%format (cataNat (g)) = "\cataNat{" g "}"
%format (cataList (g)) = "\cataList{" g "}"
%format (anaList (g)) = "\anaList{" g "}"
%format Nat0 = "\N_0"
%format Rational = "\Q "
%format toRational = " to_\Q "
%format fromRational = " from_\Q "
%format muB = "\mu "
%format (frac (n)(m)) = "\frac{" n "}{" m "}"
%format (fac (n)) = "{" n "!}"
%format (underbrace (t) (p)) = "\underbrace{" t "}_{" p "}"
%format matrix = "matrix"
%%format (bin (n) (k)) = "\Big(\vcenter{\xymatrix@R=1pt{" n "\\" k "}}\Big)"
%format `ominus` = "\mathbin{\ominus}"
%format % = "\mathbin{/}"
%format <-> = "{\,\leftrightarrow\,}"
%format <|> = "{\,\updownarrow\,}"
%format `minusNat`= "\mathbin{-}"
%format ==> = "\Rightarrow"
%format .==>. = "\Rightarrow"
%format .<==>. = "\Leftrightarrow"
%format .==. = "\equiv"
%format .<=. = "\leq"
%format .&&&. = "\wedge"
%format cdots = "\cdots "
%format pi = "\pi "
%format (curry (f)) = "\overline{" f "}"
%format (cataLTree (x)) = "\llparenthesis\, " x "\,\rrparenthesis"
%format (cataFTree (x)) = "\llparenthesis\, " x "\,\rrparenthesis"
%format (anaLTree (x)) = "\mathopen{[\!(}" x "\mathclose{)\!]}"
%format delta = "\Delta "
\newlabel{eq:fokkinga}{{3.93}{110}{The mutual-recursion law}{section.3.17}{}}
%format (plus (f)(g)) = "{" f "}\plus{" g "}"
%format ++ = "\mathbin{+\!\!\!+}"
%format Integer  = "\mathbb{Z}"
\def\plus{\mathbin{\dagger}}

%---------------------------------------------------------------------------

\title{
          Cálculo de Programas
\\
          Trabalho Prático
\\
          LEI+MiEI --- 2021/22
}

\author{
          \dium
\\
          Universidade do Minho
}


\date\mydate

\makeindex
\newcommand{\rn}[1]{\textcolor{red}{#1}}
\begin{document}

\maketitle

\begin{center}\large
\begin{tabular}{ll}
\textbf{Grupo} nr. 20
\\\hline
a93300 & Bohdan Malanka
\\
a93316 & Henrique Alvelos
\\
a93326 & João Moreira
\end{tabular}
\end{center}

\section{Preâmbulo}

\CP\ tem como objectivo principal ensinar
a progra\-mação de computadores como uma disciplina científica. Para isso
parte-se de um repertório de \emph{combinadores} que formam uma álgebra da
programação (conjunto de leis universais e seus corolários) e usam-se esses
combinadores para construir programas \emph{composicionalmente}, isto é,
agregando programas já existentes.

Na sequência pedagógica dos planos de estudo dos cursos que têm
esta disciplina, opta-se pela aplicação deste método à programação
em \Haskell\ (sem prejuízo da sua aplicação a outras linguagens
funcionais). Assim, o presente trabalho prático coloca os
alunos perante problemas concretos que deverão ser implementados em
\Haskell.  Há ainda um outro objectivo: o de ensinar a documentar
programas, a validá-los e a produzir textos técnico-científicos de
qualidade.

Antes de abodarem os problemas propostos no trabalho, os grupos devem ler
com atenção o anexo \ref{sec:documentacao} onde encontrarão as instruções
relativas ao sofware a instalar, etc.

%if False
\begin{code}
{-# OPTIONS_GHC -XNPlusKPatterns #-}
{-# LANGUAGE GeneralizedNewtypeDeriving, DeriveDataTypeable, FlexibleInstances #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Main where
import Cp
import List hiding (fac)
import Nat
import LTree
import FTree
import Data.List hiding (find)
import Control.Monad
import Control.Applicative hiding ((<|>))
import System.Random hiding (split)
import System.Process
import Data.Hashable
import Test.QuickCheck hiding ((><),choose,collect)
import qualified Test.QuickCheck as QuickCheck
import Distribution.Compat.CharParsing (newline, CharParsing (text))
import Data.Graph.Inductive (out)
import Text.Html (vspace, base)
-- import Graphics.Gloss
-- import Graphics.Gloss.Interface.Pure.Game

main = undefined
\end{code}
%endif

\Problema

Num sistema de informação distribuído, uma lista não vazia de transações
é vista como um \textit\blockchain\ sempre que possui um valor de \textit{hash}
que é dado pela raiz de uma \MerkleTree\ que lhe está associada. Isto significa
que cada \textit\blockchain\ está estruturado numa \MerkleTree.
Mas, o que é uma \MerkleTree?

Uma \MerkleTree\ é uma \FTree\ com as seguintes propriedades:
%
\begin{eqnarray}
\fbox{
\begin{minipage}{.85\textwidth}
\begin{enumerate}
\item as folhas são pares (|hash|, transação) ou simplesmente o |hash| de uma transação;
\item os nodos são |hashes| que correspondem à concatenação dos |hashes| dos filhos;
\item o |hash| que se encontra na raiz da árvore é designado |Merkle Root|; como se disse acima, corresponde ao valor de |hash| de todo o bloco de transações.
\end{enumerate}
\end{minipage}
}&&
     \label{eq:MTree_props}
\end{eqnarray}


\begin{figure}
\fbox{
\begin{minipage}{\textwidth}\em
\begin{itemize}
\item Se a lista for singular, calcular o |hash| da transação.

\item Caso contrário,
\begin{enumerate}
\item Mapear a lista com a função |hash|.

\item Se o comprimento da lista for ímpar, concatenar a lista com o seu último valor (que fica duplicado). Caso contrário, a lista não sofre alterações.

\item Agrupar a lista em pares.

\item Concatenar os |hashes| do par produzindo uma lista de (sub-)árvores nas quais a cabeça terá a respetiva concatenação.

\item Se a lista de (sub-)árvores não for singular, voltar ao passo 2 com a lista das cabeças como argumento, preservando a lista de (sub-)árvores. Se a lista for singular, chegamos à |Merkle Root|. Contudo, falta compor a |Merkle Tree| final. Para tal, tendo como resultado uma lista de listas de (sub-)árvores agrupada pelos níveis da árvore final, é necessário encaixar sucessivamente os tais níveis formando a |Merkle Tree| completa.
\end{enumerate}
\end{itemize}
\end{minipage}
}\caption{Algoritmo clássico de construção de uma \MerkleTree\ \cite{Se19} \label{fig:algMTree}.}
\end{figure}

Assumindo uma lista não vazia de transações, o algoritmo clássico de construção
de uma |Merkle Tree| é o que está dado na Figura \ref{fig:algMTree}. Contudo,
este algoritmo (que se pode mostrar ser um hilomorfismo de listas não vazias)
é demasiadamente complexo. Uma forma bem mais simples de produzir uma |Merkle
Tree| é através de um hilomorfismo de \LTree s. Começa-se por, a partir da
lista de transações, construir uma \LTree\ cujas folhas são as transações:
\begin{spec}
list2LTree :: [a] -> LTree a
\end{spec}
Depois, o objetivo é etiquetar essa árvore com os |hashes|,
\begin{spec}
lTree2MTree :: Hashable a => LTree a -> (underbrace (FTree Integer (Integer, a))(Merkle tree))
\end{spec}
formando uma \MerkleTree\ que satisfaça os três requisitos em (\ref{eq:MTree_props}).
Em suma, a construção de um \blockchain\ é um hilomorfismo de \LTree s
\begin{code}
computeMerkleTree :: Hashable a => [a] -> FTree Integer (Integer, a)
computeMerkleTree = lTree2MTree . list2LTree 
\end{code}

\begin{enumerate}
\item     Comece por definir o gene do anamorfismo que constrói \LTree s a partir de listas não vazias:

\begin{code}
list2LTree :: [a] -> LTree a
list2LTree = anaLTree g_list2LTree
\end{code}
\textbf{NB}: para garantir que |list2LTree| não aceita listas vazias deverá
usar em |g_list2LTree| o inverso |outNEList| do isomorfismo
\begin{code}
inNEList = either singl cons
\end{code}

\item

Assumindo as seguintes funções |hash| e |concHash|:\footnote{Para invocar a função |hash|, escreva |Main.hash|.}

\begin{code}
hash :: Hashable a => a -> Integer
hash = toInteger . (Data.Hashable.hash)
concHash :: (Integer, Integer) -> Integer
concHash = add
\end{code}

\noindent defina o gene do catamorfismo que consome a \LTree\ e produz
a correspondente \MerkleTree\ etiquetada com todos os |hashes|:

\begin{code}
lTree2MTree :: Hashable a => LTree a -> FTree Integer (Integer, a)
lTree2MTree = cataLTree g_lTree2MTree
\end{code}

\item Defina |g_mroot| por forma a
\begin{code}
mroot :: Hashable b => [b] -> Integer
mroot = cataFTree g_mroot . computeMerkleTree
\end{code}
nos dar a Merkle \emph{root} de um qualquer bloco |[b]| de transações.

\item

Calcule |mroot trs| da sequência de transações |trs| da no anexo e verifique que, sempre que se modifica (e.g.\ fraudulentamente) uma transação passada em |trs|, |mroot trs| altera-se necessariamente. Porquê? (Esse é exactamente o princípio de funcionamento da tecnologia \blockchain.)
\end{enumerate}

\begin{quote}\small
\vskip 1em \hrule \vskip 1em
\textbf{Valorização} (não obrigatória): implemente o algoritmo clássico de
construção de \MerkleTree s
\begin{spec}
classicMerkleTree :: Hashable a => [a] -> FTree Integer Integer
\end{spec}
sob a forma de um hilomorfismo de listas não vazias.
Para isso deverá definir esse combinador primeiro, da forma habitual:
\begin{spec}
hyloNEList h g = cataNEList h . anaNEList g
\end{spec}
etc.
Depois passe à definição do gene |g_pairsList| do anamorfismo de listas
\begin{spec}
pairsList :: [a] -> [(a, a)]
pairsList = anaList (g_pairsList)
\end{spec}
que agrupa a lista argumento por pares, duplicando o último valor caso seja necessário. Para tal, poderá usar a função (já definida)
\begin{spec}
getEvenBlock :: [a] -> [a]
\end{spec}
que, dada uma lista, se o seu comprimento for ímpar, duplica o último valor.

Por fim, defina os genes |divide| e |conquer| dos respetivos anamorfismo e catamorfimo por forma a
\begin{spec}
classicMerkleTree = (hyloNEList conquer divide) . (map Main.hash)
\end{spec}
Para facilitar a definição do |conquer|, terá apenas de definir o gene |g_mergeMerkleTree| do catamorfismo de ordem superior
\begin{spec}
mergeMerkleTree :: FTree a p -> [FTree a c] -> FTree a c
mergeMerkleTree = cataFTree (g_mergeMerkleTree)
\end{spec}
que compõe a \FTree\ (à cabeça) com a lista de \FTree s (como filhos), fazendo um ``merge'' dos valores intermédios. Veja o seguinte exemplo de aplicação da função |mergeMerkleTree|:
\begin{verbatim}
 > l = [Comp 3 (Unit 1, Unit 2), Comp 7 (Unit 3, Unit 4)]
 > 
 > m = Comp 10 (Unit 3, Unit 7)
 > 
 > mergeMerkleTree m l
Comp 10 (Comp 3 (Unit 1,Unit 2),Comp 7 (Unit 3,Unit 4))
\end{verbatim}

\textbf{NB}: o \textit{classicMerkleTree} retorna uma Merkle Tree cujas folhas são apenas o |hash| da transação e não o par (|hash|, transação).
\vskip 1em \hrule \vskip 1em
\end{quote}

\Problema

Se se digitar \wc{|man wc|} na shell do Unix (Linux) obtém-se:
\begin{quote}\small
\begin{verbatim}
NAME
     wc -- word, line, character, and byte count

SYNOPSIS
     wc [-clmw] [file ...]

DESCRIPTION
    The wc utility displays the number of lines, words, and bytes contained in
    each input file,  or standard input (if no file is specified) to the stan-
    dard  output.  A line is defined as  a string of characters delimited by a
    <newline> character.  Characters beyond the final <newline> character will
    not be included in the line count.
    (...)
    The following options are available:
    (...)
        -w   The number of words in each input file is written to the standard
             output.
    (...)
\end{verbatim}
\end{quote}
Se olharmos para o código da função que, em C, implementa esta funcionalidade
\cite{KR78} e nos focarmos apenas na parte que implementa a opção \verb!-w!,
verificamos que a poderíamos escrever, em Haskell, da forma seguinte:
\begin{code}
wc_w :: [Char] -> Int
wc_w []    = 0
wc_w (c:l) =
     if not (sep c) && lookahead_sep l then wc_w l + 1 else wc_w l
       where
          sep c = ( c == ' ' || c == '\n' || c == '\t')
          lookahead_sep []    = True
          lookahead_sep (c:l) = sep c
\end{code}
Por aplicação da lei de recursividade mútua
\begin{eqnarray}
|lcbr(
     f . inT = h . fF(split f g)
     )(
        g . inT = k . fF(split f g)
)|
     & \equiv &
     |split f g = cata(split h k)|
\end{eqnarray}
às funções |wc_w| e |lookahead_sep|, re-implemente a primeira segundo o
modelo \emph{|worker|/|wrapper|} onde |worker| deverá ser um catamorfismo
de listas:
\begin{spec}
wc_w_final :: [Char] -> Int
wc_w_final = wrapper . (underbrace (cataList (either g1 g2)) worker)
\end{spec}
Apresente os cálculos que fez para chegar à versão |wc_w_final| de |wc_w|,
com indicação dos genes |h|, |k| e |g = either g1 g2|.

\Problema

Neste problema pretende-se gerar o HTML de uma página de um jornal descrita
como uma agregação estruturada de blocos de texto ou imagens:
\begin{code}
data Unit a b = Image a | Text b deriving Show
\end{code}
O tipo |Sheet| (=``página de jornal'')
\begin{code}
data Sheet a b i = Rect (Frame i) (X (Unit a b) (Mode i)) deriving Show
\end{code}
é baseado num tipo indutivo $X$ que, dado em anexo (pág.~\pageref{sec:C}),
exprime a partição de um rectângulo (a página tipográfica) em vários subrectângulos
(as caixas tipográficas a encher com texto ou imagens),
segundo um processo de partição binária, na horizontal ou na vertical.
Para isso, o tipo
\begin{code}
data Mode i = Hr i | Hl i | Vt i | Vb i deriving Show
\end{code}
especifica quatro variantes de partição. O seu argumento deverá
ser um número de 0 a 1, indicando a fracção da altura (ou da largura) em que o
rectângulo é dividido, a saber:
\begin{itemize}
\item \texttt{Hr i} ---  partição horizontal, medindo $i$ a partir da direita
\item \texttt{Hl i} ---  partição horizontal, medindo $i$ a partir da esquerda
\item \texttt{Vt i} ---  partição vertical, medindo $i$ a partir do topo
\item \texttt{Vb i} ---  partição vertical, medindo $i$ a partir da base
\end{itemize}

Por exemplo, a partição dada na figura \ref{fig:1} corresponde à partição
de um rectângulo de acordo com a seguinte árvore de partições:
%
\begin{eqnarray*}
\mbox{
\tree{|Hl(0.41)|}
\subtree{|Vt(0.48)|}
\leaf{|c|}
\subtree{|Vt(0.36)|}
\leaf{|d|}
\leaf{|e|}
\endsubtree
\endsubtree
\subtree{|Vb(0.6)|}
\leaf{|a |}
\leaf{| b|}
\endsubtree
\endtree
}
\end{eqnarray*}

\begin{figure}
\begin{center}
\unitlength=.05mm
\special{em:linewidth 0.2pt}
\begin{picture}(780.00,960.00)
\put(0.00,0.00){\makebox(320,320)[cc]{$e$}}
\put(0.00,0.00){\line(1,0){320.00}}
\put(0.00,0.00){\line(0,1){320.00}}
\put(0.00,320.00){\line(1,0){320.00}}
\put(320.00,0.00){\line(0,1){320.00}}
\put(0.00,320.00){\makebox(320,180)[cc]{$d$}}
\put(0.00,320.00){\line(0,1){180.00}}
\put(0.00,500.00){\line(1,0){320.00}}
\put(320.00,320.00){\line(0,1){180.00}}
\put(0.00,500.00){\makebox(320,460)[cc]{$c$}}
\put(0.00,500.00){\line(0,1){460.00}}
\put(0.00,960.00){\line(1,0){320.00}}
\put(320.00,500.00){\line(0,1){460.00}}
\put(320.00,0.00){\makebox(460,580)[cc]{$ b$}}
\put(320.00,0.00){\line(1,0){460.00}}
\put(320.00,0.00){\line(0,1){580.00}}
\put(320.00,580.00){\line(1,0){460.00}}
\put(780.00,0.00){\line(0,1){580.00}}
\put(320.00,580.00){\makebox(460,380)[cc]{$a $}}
\put(320.00,580.00){\line(0,1){380.00}}
\put(320.00,960.00){\line(1,0){460.00}}
\put(780.00,580.00){\line(0,1){380.00}}
\end{picture}
\end{center}
\caption{Layout de página de jornal.\label{fig:1}}
\end{figure}

As caixas delineadas por uma partição (como a dada acima) correspondem a
folhas da árvore de partição e podem conter texto ou imagens. É o que
se verifica no objecto |example| da secção \ref{sec:test_data}
que, processado por |sheet2html| (secção \ref{sec:html})
vem a produzir o ficheiro \texttt{jornal.html}.

\paragraph{O que se pretende}
O código em \Haskell\ fornecido no anexo \ref{sec:codigo}
como ``kit'' para arranque deste trabalho não está estruturado
em termos dos combinadores \emph{cata-ana-hylo} estudados nesta disciplina.
%
O que se pretende é, então:
\begin{enumerate}
\item     A construção de uma biblioteca ``pointfree''
     \footnote{%
          A desenvolver de forma análoga a outras bibliotecas que
          conhece (\eg\ \LTree, etc).
}
     com base na qual o processamento (``pointwise'') já disponível
     possa ser redefinido.
\item     A evolução da biblioteca anterior para uma outra que permita
     partições $n$-árias (para \emph{qualquer} $n$ finito)
     e não apenas binárias. \footnote{
          Repare que é a falta desta capacidade expressiva
          que origina, no ``kit'' actual, a definição das funções
          auxiliares  da secção \ref{sec:faux}, por exemplo.
     }
\end{enumerate}

\Problema

Este exercício tem como objectivo determinar todos os caminhos
possíveis de um ponto \emph{A} para um ponto \emph{B}. Para tal,
iremos utilizar técnicas de
\href{https://en.wikipedia.org/wiki/Brute-force_search}{\emph{brute
force}} e
\href{https://en.wikipedia.org/wiki/Backtracking}{\emph{backtracking}}, que podem
ser codificadas no \listM{mónade das listas} (estudado na \href{https://haslab.github.io/CP/Material/}{aulas}). Comece por implementar a seguinte função auxiliar:

\begin{enumerate}
\item |pairL :: [a] -> [(a,a)]| que dada uma lista |l| de tamanho
maior que |1| produz uma nova lista cujos elementos são os pares |(x,y)| de
elementos de |l| tal que |x| precede imediatamente |y|. Por exemplo:
\begin{quote}
     |pairL [1,2] == [(1,2)]|,
\\
     |pairL [1,2,3] == [(1,2),(2,3)]| e
\\
     |pairL [1,2,3,4] == [(1,2),(2,3),(3,4)]|
\end{quote}
Para o caso em que |l = [x]|, i.e. o tamanho de |l| é |1|, assuma que |pairL [x] == [(x,x)]|. Implemente esta função como um \emph{anamorfismo de listas}, atentando na sua propriedade:

\begin{itemize}\em
\item      Para todas as listas |l| de tamanho maior que 1,
a lista |map p1 (pairL l)| é a lista original |l| a menos do último elemento.
Analogamente, a lista |map p2 (pairL l)|  é a lista original |l| a menos do primeiro elemento. 
\end{itemize}
\end{enumerate}


De seguida necessitamos de uma estrutura de dados representativa da noção de espaço,
para que seja possível formular a noção de \emph{caminho} de um ponto |A| para um ponto |B|,
por exemplo, num papel quadriculado. No nosso caso vamos ter:
\begin{code}
data Cell = Free | Blocked |  Lft | Rght | Up | Down deriving (Eq,Show)
type Map = [[Cell]]
\end{code}

O terreno onde iremos navegar é codificado então numa \emph{matriz} de
células.  Os valores \emph{Free} and \emph{Blocked} denotam uma célula
como livre ou bloqueada, respectivamente (a navegação entre dois
pontos terá que ser realizada \emph{exclusivamente} através de células
livres). Ao correr, por exemplo, |putStr $ showM $
map1| no interpretador  irá obter a seguinte apresentação de um mapa:
\begin{verbatim}
 _  _  _
 _  X  _
 _  X  _
\end{verbatim}
Para facilitar o teste das implementações pedidas abaixo, disponibilizamos no anexo \ref{sec:codigo}
a função |testWithRndMap|. Por exemplo, ao correr
|testWithRndMap| obtivemos o seguinte mapa aleatoriamente:
\begin{verbatim}
 _  _  _  _  _  _  X  _  _  X
 _  X  _  _  _  X  _  _  _  _
 _  _  _  _  _  X  _  _  _  _
 _  X  _  _  _  _  _  _  _  X
 _  _  _  _  _  _  X  _  X  _
 _  _  _  _  _  _  _  _  _  _
 _  X  X  _  _  X  _  _  _  _
 _  _  _  _  _  _  _  _  X  _
 _  _  _  _  _  X  _  _  X  _
 _  _  X  _  _  _  _  _  _  X
Map of dimension 10x10.
\end{verbatim}

De seguida, os valores |Lft|, |Rght|,
|Up| e |Down| em |Cell| denotam o facto de uma célula ter sido alcançada
através da célula à esquerda, direita, de cima, ou de baixo, respectivamente.
Tais valores irão ser usados na representação de caminhos num mapa.

\begin{enumerate}
\setcounter{enumi}{1}
\item

Implemente agora a função |markMap :: [Pos] -> Map -> Map|,
que dada uma lista de posições (representante de um \emph{caminho} de um ponto \emph{A} para
um ponto \emph{B}) e um mapa retorna um novo mapa com o caminho lá marcado.
Por exemplo, ao correr no interpretador,
\begin{center}
|putStr $ showM $ markMap [(0,0),(0,1),(0,2),(1,2)] map1|
\end{center}
deverá obter a seguinte apresentação de um mapa e respectivo caminho:
\begin{verbatim}
 >  _  _
 ^  X  _
 ^  X  _
\end{verbatim}
representante do caso em que subimos duas vezes no mapa e depois viramos à direita.
Para implementar a função |markMap| deverá recorrer à função |toCell| (disponibilizada
no anexo \ref{sec:codigo}) e a uma função auxiliar com o tipo |[(Pos,Pos)] -> Map -> Map| definida como
um \emph{catamorfismo de listas}. Tal como anteriormente, anote as propriedades seguintes sobre
|markMap|:\footnote{Ao implementar a função |markMap|, estude também
a função |subst| (disponibilizada no anexo \ref{sec:codigo}) pois as duas funções tem
algumas semelhanças.}
\begin{itemize}\em
\item      Para qualquer lista |l| a função |markMap l| é idempotente.
\item      Todas as posições presentes na lista dada como argumento
irão fazer com que as células correspondentes no mapa deixem de ser |Free|.
\end{itemize}
\end{enumerate}

Finalmente há que implementar a função |scout :: Map -> Pos -> Pos -> Int -> [[Pos]]|,
que dado um mapa |m|, uma posição inicial |s|, uma posição alvo |t|, e um número
inteiro |n|, retorna uma lista de caminhos que começam em |s| e que têm tamanho máximo
|n+1|. Nenhum destes caminhos pode conter |t| como elemento que não seja o último na lista (i.e. um caminho deve terminar logo que se alcança a posição |t|). Para além disso,
não é permitido voltar a posições previamente visitadas e se ao alcançar uma posição
diferente de |t| é impossivel sair dela então todo o caminho que levou a esta
posição deve ser removido (\emph{backtracking}). Por exemplo: \\

\noindent
|scout map1 (0,0) (2,0) 0 == [[(0,0)]]|

\noindent
|scout map1 (0,0) (2,0) 1 == [[(0,0),(0,1)]]|

\noindent
|scout map1 (0,0) (2,0) 4 == [[(0,0),(0,1),(0,2),(1,2),(2,2)]]|

\noindent
|scout map2 (0,0) (2,2) 2 == [[(0,0),(0,1),(1,1)],[(0,0),(0,1),(0,2)]]|

\noindent
|scout map2 (0,0) (2,2) 4 == [[(0,0),(0,1),(1,1),(2,1),(2,2)],[(0,0),(0,1),(1,1),(2,1),(2,0)]]|

\begin{enumerate}
\setcounter{enumi}{2}
\item   Implemente a função
\begin{spec}
scout :: Map -> Pos -> Pos -> Int -> [[Pos]]
\end{spec}
recorrendo à função |checkAround| (disponibilizada no anexo \ref{sec:codigo}) e de tal forma a que
|scout m s t| seja um catamorfismos de naturais \emph{monádico}.
Anote a seguinte propriedade desta função:

\begin{itemize}\em
\item     \label{en:6a}
Quanto maior for o tamanho máximo permitido aos caminhos,  mais caminhos que alcançam a
posição alvo iremos encontrar.
\end{itemize}
\end{enumerate}

\newpage
\part*{Anexos}

\appendix

\section{Documentação para realizar o trabalho}
\label{sec:documentacao}
Para cumprir de forma integrada os objectivos Rdo trabalho vamos recorrer
a uma técnica de programa\-ção dita
``\litp{literária}'' \cite{Kn92}, cujo princípio base é o seguinte:
%
\begin{quote}\em Um programa e a sua documentação devem coincidir.
\end{quote}
%
Por outras palavras, o código fonte e a documentação de um
programa deverão estar no mesmo ficheiro.

O ficheiro \texttt{cp2122t.pdf} que está a ler é já um exemplo de
\litp{programação literária}: foi gerado a partir do texto fonte
\texttt{cp2122t.lhs}\footnote{O sufixo `lhs' quer dizer
\emph{\lhaskell{literate Haskell}}.} que encontrará no
\MaterialPedagogico\ desta disciplina descompactando o ficheiro
\texttt{cp2122t.zip} e executando:
\begin{Verbatim}[fontsize=\small]
    $ lhs2TeX cp2122t.lhs > cp2122t.tex
    $ pdflatex cp2122t
\end{Verbatim}
em que \href{https://hackage.haskell.org/package/lhs2tex}{\texttt\LhsToTeX} é
um pre-processador que faz ``pretty printing''
de código Haskell em \Latex\ e que deve desde já instalar executando
\begin{Verbatim}[fontsize=\small,commandchars=\\\{\}]
    $ cabal install lhs2tex --lib
    $ cabal install --ghc-option=-dynamic lhs2tex
\end{Verbatim}
\textbf{NB}: utilizadores do macOS poderão instalar o |cabal| com o seguinte comando:
\begin{Verbatim}[fontsize=\small,commandchars=\\\{\}]
    $ brew install cabal-install
\end{Verbatim}
Por outro lado, o mesmo ficheiro \texttt{cp2122t.lhs} é executável e contém
o ``kit'' básico, escrito em \Haskell, para realizar o trabalho. Basta executar
\begin{Verbatim}[fontsize=\small]
    $ ghci cp2122t.lhs
\end{Verbatim}

\noindent Abra o ficheiro \texttt{cp2122t.lhs} no seu editor de texto preferido
e verifique que assim é: todo o texto que se encontra dentro do ambiente
\begin{quote}\small\tt
\verb!\begin{code}!
\\ ... \\
\verb!\end{code}!
\end{quote}
é seleccionado pelo \GHCi\ para ser executado.

\subsection{Como realizar o trabalho}
Este trabalho teórico-prático deve ser realizado por grupos de 3 (ou 4) alunos.
Os detalhes da avaliação (datas para submissão do relatório e sua defesa
oral) são os que forem publicados na \cp{página da disciplina} na \emph{internet}.

Recomenda-se uma abordagem participativa dos membros do grupo
em todos os exercícios do trabalho, para assim
poderem responder a qualquer questão colocada na
\emph{defesa oral} do relatório.

Em que consiste, então, o \emph{relatório} a que se refere o parágrafo anterior?
É a edição do texto que está a ser lido, preenchendo o anexo \ref{sec:resolucao}
com as respostas. O relatório deverá conter ainda a identificação dos membros
do grupo de trabalho, no local respectivo da folha de rosto.

Para gerar o PDF integral do relatório deve-se ainda correr os comando seguintes,
que actualizam a bibliografia (com \Bibtex) e o índice remissivo (com \Makeindex),
\begin{Verbatim}[fontsize=\small]
    $ bibtex cp2122t.aux
    $ makeindex cp2122t.idx
\end{Verbatim}
e recompilar o texto como acima se indicou. Dever-se-á ainda instalar o utilitário
\QuickCheck,
que ajuda a validar programas em \Haskell:
\begin{Verbatim}[fontsize=\small,commandchars=\\\{\}]
    $ cabal install QuickCheck --lib
\end{Verbatim}
Para testar uma propriedade \QuickCheck~|prop|, basta invocá-la com o comando:
\begin{verbatim}
    > quickCheck prop
    +++ OK, passed 100 tests.
\end{verbatim}
Pode-se ainda controlar o número de casos de teste e sua complexidade,
como o seguinte exemplo mostra:\footnote{
Como já sabe, os testes normalmente não provam a ausência
de erros no código, apenas a sua presença (\href{https://www.cs.utexas.edu/users/EWD/transcriptions/EWD03xx/EWD303.html}{cf. arquivo online}). Portanto não deve ver o facto
de o seu código passar nos testes abaixo como uma garantia que este está livre de erros.}
\begin{verbatim}
    > quickCheckWith stdArgs { maxSuccess = 200, maxSize = 10 } prop
    +++ OK, passed 200 tests.
\end{verbatim}

Qualquer programador tem, na vida real, de ler e analisar (muito!) código
escrito por outros. No anexo \ref{sec:codigo} disponibiliza-se algum
código \Haskell\ relativo aos problemas que se seguem. Esse anexo deverá
ser consultado e analisado à medida que isso for necessário.

\paragraph{Stack}

O \stack{Stack} é um programa útil para criar, gerir e manter projetos em \Haskell.
Um projeto criado com o Stack possui uma estrutura de pastas muito específica:

\begin{itemize}
\item Os módulos auxiliares encontram-se na pasta \emph{src}.
\item O módulo principal encontra-se na pasta \emph{app}.
\item A lista de dependências externas encontra-se no ficheiro \emph{package.yaml}.
\end{itemize}

\noindent Pode aceder ao \GHCi\ utilizando o comando:
\begin{verbatim}
stack ghci
\end{verbatim}

\noindent Garanta que se encontra na pasta mais externa \textbf{do projeto}.
A primeira vez que correr este comando as depêndencias externas serão instaladas automaticamente. Para gerar o PDF, garanta que se encontra na diretoria \emph{app}.

\subsection{Como exprimir cálculos e diagramas em LaTeX/lhs2tex}
Como primeiro exemplo, estudar o texto fonte deste trabalho para obter o
efeito:\footnote{Exemplos tirados de \cite{Ol18}.}
\begin{eqnarray*}
\start
     |id = split f g|
%
\just\equiv{ universal property }
%
        |lcbr(
          p1 . id = f
     )(
          p2 . id = g
     )|
%
\just\equiv{ identity }
%
        |lcbr(
          p1 = f
     )(
          p2 = g
     )|
\qed
\end{eqnarray*}

Os diagramas podem ser produzidos recorrendo à \emph{package} \LaTeX\
\href{https://ctan.org/pkg/xymatrix}{xymatrix}, por exemplo:
\begin{eqnarray*}
\xymatrix@@C=2cm{
    |Nat0|
           \ar[d]_-{|cataNat g|}
&
    |1 + Nat0|
           \ar[d]^{|id + (cataNat g)|}
           \ar[l]_-{|inNat|}
\\
     |B|
&
     |1 + B|
           \ar[l]^-{|g|}
}
\end{eqnarray*}

\section{Código fornecido}\label{sec:codigo}

\subsection*{Problema 1}

Sequência de transações para teste:
\begin{code}
trs = [ ("compra",  "20211102", -50),
        ("venda",   "20211103", 100),
        ("despesa", "20212103", -20),
        ("venda",   "20211205", 250),
        ("venda",   "20211205", 120)]
\end{code}

\begin{code}
getEvenBlock :: [a] -> [a]
getEvenBlock l = if (even(length l)) then l else l++[last l]

firsts = either p1 p1
\end{code}

\subsection*{Problema 2}

\begin{code}
wc_test = "Here is a sentence, for testing.\nA short one."

sp c = ( c == ' ' || c == '\n' || c == '\t')
\end{code}

\subsection*{Problema 3}\label{sec:C}
Tipos:
\begin{code}
data X u i = XLeaf u | Node i (X u i) (X u i) deriving Show

data Frame i = Frame i i deriving Show
\end{code}
Funções da API\footnote{
API (=``Application Program Interface'').
}
\begin{code}
printJournal :: Sheet String String Double -> IO ()
printJournal = write . sheet2html

write :: String  -> IO ()
write s = do writeFile "jornal.html" s
             putStrLn "Output HTML written into file `jornal.html'"
\end{code}
Geração de HTML: \label{sec:html}
\begin{code}
sheet2html (Rect (Frame w h) y) = htmlwrap (new_x2html y (w,h))

x2html :: X (Unit String String) (Mode Double) -> (Double, Double) -> String
x2html (XLeaf (Image i)) (w,h)= img w h i

x2html (XLeaf (Text txt)) _ = txt
x2html (Node (Vt i) x1 x2) (w,h) = htab w h (
                                     tr( td w (h*i)     (x2html x1 (w, h*i))) ++
                                     tr( td w (h*(1-i)) (x2html x2 (w, h*(1-i))))
                                   )
x2html (Node (Hl i) x1 x2) (w,h) = htab w h (
                                     tr( td (w*i) h     (x2html x1 (w*i, h)) ++
                                         td (w*(1-i)) h (x2html x2 (w*(1-i), h)))
                                   )

x2html (Node (Vb i) x1 x2) m = x2html (Node (Vt (1 - i)) x1 x2) m
x2html (Node (Hr i) x1 x2) m = x2html (Node (Hl (1 - i)) x1 x2) m
\end{code}
Funções auxiliares: \label{sec:faux}
\begin{code}
twoVtImg a b = Node (Vt 0.5) (XLeaf (Image a)) (XLeaf (Image b))

fourInArow a b c d =
        Node (Hl 0.5)
          (Node (Hl 0.5) (XLeaf (Text a)) (XLeaf (Text b)))
          (Node (Hl 0.5) (XLeaf (Text c)) (XLeaf (Text d)))
\end{code}
HTML:
\begin{code}
htmlwrap = html . hd . (title "CP/2122 - sheet2html") . body . divt

html = tag "html" [] . ("<meta charset=\"utf-8\" />"++)

title t = (tag "title" [] t ++)

body = tag "body" [ "BGCOLOR" |-> show "#F4EFD8" ]

hd = tag "head" []

htab w h = tag "table" [
                  "width" |-> show2 w, "height" |-> show2 h,
                  "cellpadding" |-> show2 0, "border" |-> show "1px" ]

tr = tag "tr" []

td w h = tag "td" [ "width" |-> show2 w, "height" |-> show2 h ]

divt = tag "div" [ "align" |-> show "center" ]

img w h i = tag "img" [ "width" |-> show2 w, "src" |-> show i ] ""

tag t l x = "<"++t++" "++ps++">"++x++"</"++t++">\n"
             where ps = unwords [concat[t,"=",v]| (t,v)<-l]

a |-> b = (a,b)

show2 :: Show a => a -> String
show2 = show . show
\end{code}
Exemplo para teste: \label{sec:test_data}
\begin{code}

example :: (Fractional i) => Sheet String String i
example =
   Rect (Frame 650 450)
    (Node (Vt 0.01)
      (Node (Hl 0.15)
         (XLeaf (Image "cp2122t_media/publico.jpg"))
         (fourInArow "Jornal Público" "Domingo, 5 de Dezembro 2021" "Simulação para efeitos escolares" "CP/2122-TP"))
      (Node (Vt 0.55)
          (Node (Hl 0.55)
              (Node (Vt 0.1)
                 (XLeaf (Text
                 "Universidade do Algarve estuda planta capaz de eliminar a doença do sobreiro"))
                 (XLeaf (Text
                  "Organismo (semelhante a um fungo) ataca de forma galopante os montados de sobro. O contra-poder para fazer recuar o agente destruidor reside numa planta (marioila), que nasce espontânea no Algarve e Alentejo.\nComo travar o declínio do sobreiro? A árvore, classificada como Património Nacional de Portugal desde Dezembro de 2011, continua numa lenta agonia. O processo destrutivo - ainda sem fim à vista à vista - pode agora ser estancado. (...)")))
              (XLeaf (Image
                  "cp2122t_media/1647472.jpg")))
          (Node (Hl 0.25)
              (twoVtImg
                  "cp2122t_media/1647981.jpg"
                  "cp2122t_media/1647982.jpg")
              (Node (Vt 0.1)
                  (XLeaf (Text "Manchester United vence na estreia de Rangnick"))
                  (XLeaf (Text "O Manchester United venceu, este domingo, em Old Trafford, na estreia do treinador alemão Ralf Rangnick, impondo-se por 1-0 frente ao Crystal Palace de Patrick Vieira graças a um golo do brasileiro Fred, já no último quarto de hora da partida da 15.ª ronda da Liga inglesa. (...)"))))))
\end{code}

\subsection*{Problema 4}\label{sec:D}
Exemplos de mapas:
\begin{code}
map1 = [[Free, Blocked, Free], [Free, Blocked, Free], [Free, Free, Free]]
map2 = [[Free, Blocked, Free], [Free, Free, Free], [Free, Blocked, Free]]
map3 = [[Free, Free, Free] , [Free, Blocked, Free], [Free, Blocked, Free]]
\end{code}
Código para impressões de mapas e caminhos:
\begin{code}
showM :: Map -> String
showM = unlines . (map showL) . reverse

showL  :: [Cell] -> String
showL = cataList (either f1 f2) where
  f1 = const ""
  f2 = (uncurry (++)) . (fromCell >< id)

fromCell Lft = " > "
fromCell Rght = " < "
fromCell Up = " ^ "
fromCell Down = " v "
fromCell Free = " _ "
fromCell Blocked = " X "

toCell (x,y) (w,z) | x < w = Lft
toCell (x,y) (w,z) | x > w = Rght
toCell (x,y) (w,z) | y < z = Up
toCell (x,y) (w,z) | y > z = Down
\end{code}

\noindent
Código para validação de mapas (útil, por exemplo, para testes
\QuickCheck):
\begin{code}
ncols :: Map -> Int
ncols = (either (const 0) (length . p1)) . outList

nlines :: Map -> Int
nlines = length

isValidMap :: Map -> Bool
isValidMap = (uncurry (&&)) . (split isSquare sameLength) where
  isSquare = (uncurry (==)) . (split nlines ncols)
  sameLength [] = True
  sameLength [x] = True
  sameLength (x1:x2:y) = length x1 == length x2 && sameLength (x2:y)
\end{code}

\noindent
Código para geração aleatória de mapas e automatização de testes
(envolve o mónade IO):
\begin{code}
randomRIOL :: (Random a) => (a,a) -> Int -> IO [a]
randomRIOL x = cataNat (either f1 f2) where
  f1 = const (return [])
  f2 l = do r1 <- randomRIO x
            r2 <- l
            return $ r1 : r2

buildMat :: Int -> Int -> IO [[Int]]
buildMat n = cataNat (either f1 f2) where
  f1 = const (return [])
  f2 l = do x <- randomRIOL (0::Int,3::Int) n
            y <- l
            return $ x : y

testWithRndMap :: IO ()
testWithRndMap = do
    dim <- randomRIO (2,10) :: IO Int
    out <- buildMat dim dim
    map <- return $ map (map table) out
    putStr $ showM map
    putStrLn $ "Map of dimension " ++ (show dim) ++ "x" ++ (show dim) ++ "."
    putStr "Please provide a target position (must be different from (0,0)): "
    t <- readLn :: IO (Int,Int)
    putStr "Please provide the number of steps to compute: "
    n <- readLn :: IO Int
    let paths = hasTarget t (scout map (0,0) t n) in
      if length paths == 0
      then putStrLn "No paths found."
      else putStrLn $ "There are at least " ++ (show $ length paths) ++
      " possible paths. Here is one case: \n" ++ (showM $ markMap (head paths) map)

table 0 = Free
table 1 = Free
table 2 = Free
table 3 = Blocked

hasTarget y = filter (\l -> elem y l)
\end{code}

\paragraph{Funções auxiliares}
|subst :: a -> Int -> [a] -> [a]|, que dado um valor |x| e um inteiro |n|,
produz uma função |f : [a] -> [a]| que dada uma lista |l| substitui o valor na posição
|n| dessa lista pelo valor |x|:
\begin{code}
subst :: a -> Int -> [a] -> [a]
subst x = cataNat (either f1 f2) where
  f1 = const (\l -> x : tail l)
  f2 f (h:t) = h : f t
\end{code}
|checkAround :: Map -> Pos -> [Pos]|, que
verifica se as células adjacentes estão livres:
\begin{code}
type Pos = (Int,Int)

checkAround :: Map -> Pos -> [Pos]
checkAround m p = concat $ map (\f -> f m p)
                  [checkLeft, checkRight, checkUp, checkDown]

checkLeft :: Map -> Pos -> [Pos]
checkLeft m (x,y) = if x == 0 || (m !! y) !! (x-1) == Blocked
                    then [] else [(x-1,y)]

checkRight :: Map -> Pos -> [Pos]
checkRight m (x,y) = if x == (ncols m - 1) || (m !! y) !! (x+1) == Blocked
                     then [] else [(x+1,y)]

checkUp :: Map -> Pos -> [Pos]
checkUp m (x,y) = if y == (nlines m - 1) || (m !! (y+1)) !! x == Blocked
                  then [] else [(x,y+1)]

checkDown :: Map -> Pos -> [Pos]
checkDown m (x,y) = if y == 0 || (m !! (y-1)) !! x == Blocked
                    then [] else [(x,y-1)]
\end{code}


\subsection*{QuickCheck}

%----------------- Outras definições auxiliares -------------------------------------------%
Lógicas:
\begin{code}
infixr 0 .==>.
(.==>.) :: (Testable prop) => (a -> Bool) -> (a -> prop) -> a -> Property
p .==>. f = \a -> p a ==> f a

infixr 0 .<==>.
(.<==>.) :: (a -> Bool) -> (a -> Bool) -> a -> Property
p .<==>. f = \a -> (p a ==> property (f a)) .&&. (f a ==> property (p a))

infixr 4 .==.
(.==.) :: Eq b => (a -> b) -> (a -> b) -> (a -> Bool)
f .==. g = \a -> f a == g a

infixr 4 .<=.
(.<=.) :: Ord b => (a -> b) -> (a -> b) -> (a -> Bool)
f .<=. g = \a -> f a <= g a

infixr 4 .&&&.
(.&&&.) :: (a -> Bool) -> (a -> Bool) -> (a -> Bool)
f .&&&. g = \a -> ((f a) && (g a))

instance Arbitrary Cell where
  -- 1/4 chance of generating a cell 'Block'.
  arbitrary = do x <- chooseInt (0,3)
                 return $ f x where
                   f x = if x < 3 then Free else Blocked
\end{code}

%----------------- Soluções dos alunos -----------------------------------------%

\section{Soluções dos alunos}\label{sec:resolucao}
Os alunos devem colocar neste anexo as suas soluções para os exercícios
propostos, de acordo com o "layout" que se fornece. Não podem ser
alterados os nomes ou tipos das funções dadas, mas pode ser adicionado
texto, diagramas e/ou outras funções auxiliares que sejam necessárias.

Valoriza-se a escrita de \emph{pouco} código que corresponda a soluções
simples e elegantes.

\subsection*{Problema 1} \label{pg:P1}

\subsubsection*{inNEList}

\begin{eqnarray*}
\start
  inNEList = [singl,\ cons]
%
\just\equiv{\textcolor{blue}{Universal-+\ (17)}}
%
        |lcbr(
    inNEList . i1 = singl
  )(
    inNEList . i2 = cons
  )|
%
\just\equiv{\textcolor{blue}{Igualdade\ Extensional\ (71),\ Def-comp\ (72)}}
%
      |lcbr(
    inNEList (i1 a) = singl a
  )(
    inNEList (i2 (h, t)) = cons (h,t)
  )|
\end{eqnarray*}

\vspace{0.5cm}

\subsubsection*{outNEList}

\begin{eqnarray*}
\start
  outNEList\ .\ inNEList = id
%
\just\equiv{\textcolor{blue}{Definição inNEList}}
%
  outNEList\ .\ [singl,\ cons] = id
%
\just\equiv{\textcolor{blue}{Fusão-+\ (20)}}
%
  [outNEList\ .\ singl,\ outNEList\ .\  cons] = id
%
\just\equiv{\textcolor{blue}{Universal-+\ (17)}}
%
        |lcbr(
    id . i1 = outNEList . singl
  )(
    id . i2 = outNEList . cons
  )|
%
\just\equiv{\textcolor{blue}{Natural-id\ (1),\ Igualdade\ Extensional\ (71),\ Def-comp\ (72)}}
%
      |lcbr(
    outNEList(single a) = i1 a
  )(
    outNEList(cons (h,t)) = i2 (h,t)
  )|
  %
\just\equiv{\textcolor{blue}{singl a = [a], cons(h,t) = h:t}}
%
      |lcbr(
    outNEList [a] = i1 a
  )(
    outNEList (h:t) = i2 (h,t)
  )|
\end{eqnarray*}

\vspace{0.5cm}

\subsubsection*{recNEList}
\par\noindent\hspace{0.5cm}Como a única diferença de NEList das List normais é o caso base, a estrutura das listas não vazias é identica ás das listas comums.

\xymatrixcolsep{0.5pc}\xymatrixrowsep{5pc}
\centerline{\xymatrix{
   NEList A \ar[d]_-{|f|}
                \ar@@/^2pc/ [rr]^-{|outNEList|} & \qquad \cong
&   A + (A \times NEList A)  \ar[d]^{|id + id >< f|}
                                     \ar@@/^2pc/ [ll]^-{|inNEList|}
\\
    |C| &  & A + (A \times C)\ar[ll]
}}

\vspace{0.5cm}

Assim,
\begin{eqnarray*}
  |baseNEList f g = id + f >< g| 
\end{eqnarray*}

\begin{eqnarray*}
\start
  recNEList\ f = {|id + id >< f|}
%
\just\equiv{\textcolor{blue}{Aplicando\ a\ definição\ dada\ de\ baseNEList}}
%
  recNEList\ f = baseNEList\ id\ f
%
\end{eqnarray*}

\vspace{0.5cm}

\subsubsection*{cataNEList}

\begin{eqnarray*}
\start
\just\equiv{\textcolor{blue}{Cancelamento-cata\ (46)}}
%
  \cata{g}\ .\ in = g\ .\ F\cata{g} 
%
\just\equiv{\textcolor{blue}{in.out = id}}
%
  \cata{g} = g\ .\ F\cata{g} \ .\ out
%
\just\equiv{\textcolor{blue}{Aplicando as definições em Haskell já determinadas}}
%
  cataNEList\ g = g\ .\ recNEList(cataNEList\ g)\ .\ outNEList
%
\end{eqnarray*}

\vspace{0.5cm}

\subsubsection*{anaNEList}

\begin{eqnarray*}
\start
\just\equiv{\textcolor{blue}{Cancelamento-ana\ (55)}}
%
  out\ .\ \ana{g} = F\ana{g}\ .\ g
%
\just\equiv{\textcolor{blue}{in.out = id}}
%
  \ana{g} = in\ .\ F\ana{g}\ .\ g
%
\just\equiv{\textcolor{blue}{Aplicando as definições em Haskell já determinadas}}
%
  anaNEList\ g = inNEList\ .\ recNEList(anaNEList\ g)\ .\ g
%
\end{eqnarray*}

\vspace{0.5cm}

\subsubsection*{hyloNEList}

\begin{eqnarray*}
\start
\just\equiv{\textcolor{blue}{Definição de hilomorfismo}}
%
  hyloNEList\ g\ h = \cata{g}.\ana{h}
%
\just\equiv{\textcolor{blue}{Cancelamento-cata (46); Cancelamento-ana(55)}}
%
  hyloNEList\ g\ h = g.F\cata{g}.inNEList.outNEList.F\ana{h}.h
%
\just\equiv{\textcolor{blue}{in.out = id; Aplicando as definições em Haskell já determinadas}}
%
  hyloNEList\ g\ h = g.recNEList(cataNEList g).recNEList(anaNEList h).h
%
\end{eqnarray*}

\vspace{0.5cm}

\subsubsection*{list2LTree}

\vspace{0.5cm}

\xymatrixcolsep{0.5pc}\xymatrixrowsep{5pc}
\centerline{\xymatrix@@C=2cm@@R=2cm{
     LTree A 
          \ar@@/^2pc/ [rr]^-{|outLTree|} & \qquad \cong
&   
     A + (LTree A \times LTree A)  
          \ar@@/^2pc/ [ll]^-{|inLTree|}
\\
    |NEList A|     
          \ar@@/^-2pc/[rr]_{|g_list2LTree|}      
          \ar[u]_-{|list2LTree|}
          \ar[r]^-{|outNEList|} 
&    
     A + (A \times NEList A)
          \ar[r]^-{|id + singl >< id|} 
& 
     A + (NEList A \times NEList A)
          \ar[u]_{|id + id >< |(list2LTree)^2}
}}

\vspace{0.5cm}

\par\noindent\hspace{0.5cm}Se \textit{g\_list2LTree} recebe um [\textbf{a}] a função \textit{outNEList} injeta o elemento \textbf{a} à esquerda. Seguidamente, esse elemento é preservado pelas funções \textit{id} e por fim transformando numa \textit{LTree}, neste caso através da função \textit{inLTree} é gerado uma \textit{Leaf a}.

Se \textit{g\_list2LTree} recebe um (\textbf{h}:\textbf{t}) a função \textit{outNEList} injeta (\textbf{h},\textbf{t}) à direita. O objetivo agora é aplicar recursivamente a função \textit{list2LTree} a este valor. Porém, esta função só recebe listas como argumento, então ao par (\textbf{h},\textbf{t}) aplica-se a função \textit{singl} ao \textbf{h} e ao \textbf{t} não se mexe, formando assim, o par ([\textbf{h}], \textbf{t}). Deste modo, aplica-se agora a função \textit{list2LTree} a cada lado do par, construindo outro par \textit{(Leaf h, Fork(...,...))}, o qual é passado á função \textit{inLTree} que constroí a árvore final. 

Deste modo podemos deduzir que:
\begin{center}
\fbox{\begin{minipage}{20em}
    \center $ | g_list2LTree = id + singl >< id . outNEList | $
\end{minipage}}
\end{center}

\vspace{0.5cm}

\par\noindent\hspace{0.5cm}No entanto, desta forma, ao correr esta função com a lista de teste disponibilizada reparamos que a árvore gerada não é balanceda, pois as folhas \textit{(Leaf)} ficam sempre à esquerda e as ramificações \textit{(Fork)} à direita.

\begin{figure}[h!]
  \centering
  \includegraphics[width=1\textwidth]{cp2122t_media/cp_p1_arDesbalanciada.png}
\end{figure}

\vspace{0.5cm}

\par\noindent\hspace{0.5cm}Assim, reparamos que o problema estava no \textit{outNEList}, porque vai sempre separar a cabeça da cauda e que posteriormente o \textit{inLTree} vai inserir a cabeça numa folha e a cauda num \textit{Fork}. Nesse sentido, a separação deve ser feita partindo a lista ao meio e assim sucessivamente e falando desta forma percebemos que este \textit{divide} de assemelha com o do algoritmo \textit{mergeSort}. Portanto, reparamos que na biblioteca \textit{LTree.hs} encontra-se este algoritmo e o seu anamorfismo, que é o que pretendemos. Logo, alterando a definição do gene para:
\begin{center}
\fbox{\begin{minipage}{9em}
    \center $ | g_list2LTree = lsplit | $
\end{minipage}}
\end{center}
a arvore fica balanceada:

\begin{figure}[h!]
  \centering
  \includegraphics[width=1\textwidth]{cp2122t_media/cp_p1_arBalanciada.png}
\end{figure}

\vspace{0.5cm}

\subsubsection*{lTree2MTree}

\vspace{0.5cm}

\par\noindent\hspace{0.5cm}A partir do diagrama seguinte do catamorfismo de \textit{LTree's} vamos tentar definir o gene \textit{g\_lTree2MTree}:

\vspace{0.5cm}

\xymatrixcolsep{0.5pc}\xymatrixrowsep{5pc}
\centerline{\xymatrix{
     LTree A 
          \ar[d]_-{|lTree2MTree|}
          \ar@@/^2pc/ [rr]^-{|outLTree|} & \qquad \cong
&   
     A + (LTree A \times LTree A)  
          \ar[d]^{|id + (lTree2MTree >< lTree2MTree)|}
          \ar@@/^2pc/ [ll]^-{|inLTree|}
\\
    |FTree Integer (Integer,A)| 
&  
& 
     A + (|FTree Integer (Integer,A)| \times |FTree Integer (Integer,A)|)
          \ar[ll]^-{|g_lTree2MTree|}
}}

\vspace{0.5cm}

Notemos que \textit{g\_lTree2MTree} "sai" de uma soma e portanto usar-se-á o combinador \textit{either}.

Vamos começar por definir \textit{g\_lTree2MTree} = |[g1, g2]|.

Ao executar o \textit{outLTree}, o "caso da esquerda" é um elemento que corresponde a uma folha que neste momento apenas possui a tarnsação "a" e que é preservada pela função \textit{id}. Assim, a função |g1| recebe uma tarnsação "a" e precisa criar um par em que o primeiro elemento é \textit{hash a} e o segundo é a própria tarnsação "a":

\xymatrixcolsep{2pc}\xymatrixrowsep{2pc}
\centerline{\xymatrix {
    A 
          \ar[r]^-{|split id id|} 
&
    (A,A) 
          \ar [r]^-{|hash >< id|}
&
    |(Integer, A)| 
          \ar [rr]^-{inFTree . i1}
&
&
    |Unit (Integer, A)| 
}}

\vspace{0.5cm}

\begin{eqnarray*}
\start
  |g1 = inFTree . i1 . (hash >< id) . split id id| 
%
\just\equiv{\textcolor{blue}{Absorção-x (11), Natural-id (1)}}
%
  |g1= inFTree . i1 . split hash id|
%
\just\equiv{\textcolor{blue}{Definição inFTree}}
%
  |g1 = [Unit, uncurry Comp] . split hash id|
%
\just\equiv{\textcolor{blue}{Cancelamento-+(18)}}
%
  |g1 = Unit . split hash id|
\end{eqnarray*}

\vspace{0.5cm}

Finalizando, podemos definir a função \textit{g1} como:

\vspace{0.5cm}

\begin{center}
\fbox{\begin{minipage}{11em}
    \center $ | g1 = Unit . split hash id | $
\end{minipage}}
\end{center}

\vspace{0.5cm}

\par\noindent\hspace{0.5cm}Relativamente ao |g2|, a função trata do caso em que a árvore não é uma folha mas uma ramificação \textit{Fork}. Assim, aplicando recursivamente a função \textit{lTree2MTree} ao par \textit{(LTree A, LTree A)}, resultante da ramificação devolvida pela função \textit{outLTree} obtém-se outro par \textit{(|FTree Integer (Integer,A), FTree Integer (Integer,A))|}. Por fim, resta a função |g2| juntar essas sub árvores numa  só, concatenando a informação desses nodos e guardando no nodo do pai.

\vspace{0.5cm}

\xymatrixcolsep{2pc}\xymatrixrowsep{2pc}
\centerline{\xymatrix {
    |FTree Integer (Integer, A)| 
          \ar[d]_{|split auxConcHash id|} \\
    |(Integer, (FTree Integer (Integer, A), FTree Integer (Integer, A)))| 
          \ar [d]_{|inFTree . i2 = uncurry Comp|} \\
    |FTree Integer (Integer, A)| \\
}}

\vspace{0.5cm}

Finalizando, podemos definir a função \textit{g2} como:

\vspace{0.5cm}

\begin{center}
\fbox{\begin{minipage}{15em}
    \center $ | g2 = uncurry Comp . split auxConcHash id | $
\end{minipage}}
\end{center}

\vspace{0.5cm}

\par\noindent\hspace{0.5cm}Em que a função auxiliar \textit{auxConcHash} definida mais abaixo, recebe duas árvores \textit{FTree} e aplica a função \textit{concHash} à informação contida nos nodos da árvore.

\vspace{0.5cm}

\begin{figure}[h!]
  \centering
  \includegraphics[width=1\textwidth]{cp2122t_media/cp_p1_mtree.png}
\end{figure}

\vspace{0.5cm}

\subsubsection*{mroot}

\xymatrixcolsep{0.5pc}\xymatrixrowsep{5pc}
\centerline{\xymatrix{
     |FTree Integer (Integer, A)| 
          \ar[d]_-{|mroot|}
          \ar@@/^2pc/ [rr]^-{|outFTree|} & \qquad \cong
&   
     |(Integer, A) + (Integer  >< (FTree Integer (Integer, A)|)^2)  
          \ar[d]^{|id + id >< |mroot^2}
          \ar@@/^2pc/ [ll]^-{|inFTree|}
\\
    |Integer| 
&  
& 
     |(Integer, A) + (Integer  >< (Integer >< Integer)|)
          \ar[ll]^-{|g_mroot|}
}}

\vspace{0.5cm}

\par\noindent\hspace{0.5cm}Nesta função quando o bloco [b] tem apenas uma transação a \textit{Merkle root} esta no primeiro elemento do par |(Integer, A)| gerado à esquerda. 

\vspace{0.5cm}

\begin{center}
\fbox{\begin{minipage}{11em}
    \center $ | Assim, g_mroot = [p1, ?] | $
\end{minipage}}
\end{center}

\vspace{0.5cm}

\par\noindent\hspace{0.5cm}Quando a árvore não é apenas uma folha a \textit{Merkle root} está no nodo da raiz que é o primeiro elemento do par |(Integer,(Integer,A))| gerado à direita, pelo que

\vspace{0.5cm}

\begin{center}
\fbox{\begin{minipage}{11em}
    \center $ | g_mroot = [p1, p1] | $
\end{minipage}}
\end{center}

\vspace{0.5cm}

\par\noindent\hspace{0.5cm}Ou seja, esta função já se encontra definida como:

\vspace{0.5cm}

\begin{center}
\fbox{\begin{minipage}{9em}
    \center $ | g_mroot = firsts | $
\end{minipage}}
\end{center}

\vspace{0.5cm}

\begin{figure}[h!]
  \centering
  \includegraphics[width=1\textwidth]{cp2122t_media/cp_p1_mroot.png}
\end{figure}

\vspace{0.5cm}

\subsubsection*{4.}

\vspace{0.5cm}

\par\noindent\hspace{0.5cm}Quando calculamos a \textit{Merkle root} do bloco de transações \textbf{trs}, obtemos a respetiva chave do bloco, mas se alterarmos alguma transação desse mesmo bloco e voltarmos a calcular a \textit{mroot trs}, reparamos que o valor agora é diferente do anterior. Nesse sentido, isto se deve porque esta chave final é resultado de concatenações de pares de transações e se uma é fraudulentamente alterada o valor na raiz também muda. Assim, este mecanismo permite a integridade, validade e segurança dos dados numa \textit{Blockchain}, pois cada bloco possui a chave do bloco anterior e do seguinte e se um for alterado os seus vizinhos não vai fazer correspondência e vai ser indentificada fraude no final.

\vspace{0.5cm}

\subsubsection*{Valorização}

\vspace{0.5cm}

\subsubsection*{pairsList}

\vspace{0.5cm}

\par\noindent\hspace{0.5cm}Este problema é muito semelhante ao Problema 4 relativo à função \textit{pairL}, pelo que os diagramas dos anamorfismos são praticamente idênticos:

\vspace{0.5cm}

\xymatrixcolsep{0.5pc}\xymatrixrowsep{5pc}
\centerline{\xymatrix@@C=1.5cm@@R=2cm{
     (A, A)^*
          \ar@@/^2pc/ [rrrr]^-{|outList|} & & \qquad \cong
&
&   
     1 + ((A,A) \times (A,A)^*)  
          \ar@@/^2pc/ [llll]^-{|inList|}
\\
    A^*     
          \ar@@/^-2pc/[rrrr]_{|g_pairsList|}      
          \ar[u]_-{|pairsList|}
          \ar[r]^-{|getEvenBlock|} 
&    
     A^*
          \ar[rr]^-{|outList|} 
&
&    
     1 + A + A^*
          \ar[r]^-{|id + ?|} 
& 
     1 + ((A,A) \times A^*)
          \ar[u]_{|id + id >< pairsList|}
}}

\vspace{0.5cm}

\par\noindent\hspace{0.5cm}A lista que recebemos como parâmetro começamos por aplicar a função \textit{getEvenBlock} para o caso de o tamanho da lista for impar o último elemento é duplicado.
De seguida, decompomos a lista pela respetiva cabeça e cauda (h,t) e aplicamos \textit{|dux >< id|} que tranforma a cabeça (h) no par (h,h) e preserva a cauda.
Por fim, com a função auxiliar \textit{pair\_aux} modificamos o segundo elemento do par(h,h) por (h, \textit{head} t) e à cauda retiramos a cabeça pois esta já foi inserida num par.

Assim, o gene fica definido da seguinte forma:

\vspace{0.5cm}

\begin{center}
\fbox{\begin{minipage}{27em}
    \center $ | g_pairsList = (id + pair_aux . (dup >< id)) . outList . getEvenBlock | $
\end{minipage}}
\end{center}

\vspace{0.5cm}

\begin{figure}[h!]
  \centering
  \includegraphics[width=1\textwidth]{cp2122t_media/cp_p1_pairsList.png}
\end{figure}

\vspace{0.5cm}

\subsubsection*{Soluções} % --------------------------------------SOLUÇÕES---------------------------------------- % 

Listas não vazias:
\begin{code}

outNEList [a]   = i1 a
outNEList (h:t) = i2 (h, t)

baseNEList g f = id -|- g >< f

recNEList f = baseNEList id f 

cataNEList g   = g . recNEList (cataNEList g) . outNEList  

anaNEList  g   = inNEList . recNEList (anaNEList g) . g

hyloNEList h g = cataNEList h . anaNEList g
\end{code}
Gene do anamorfismo:
\begin{code}
g_list2LTree = lsplit
\end{code}
Gene do catamorfismo:
\begin{code}
g_lTree2MTree :: Hashable c => Either c (FTree Integer (Integer, c), FTree Integer (Integer, c)) -> FTree Integer (Integer, c)
g_lTree2MTree = either g1 g2 where 
     g1 = Unit . split Main.hash id
     g2 = uncurry Comp . split auxConcHash id
\end{code}
\newline
\begin{code}
auxConcHash :: (FTree Integer (Integer, b1), FTree Integer (Integer, b2))-> Integer
auxConcHash (Unit (a,_), Unit (b,_)) = concHash (a,b)
auxConcHash (Unit (a,_), Comp b (_, _)) = concHash(concHash(a,a),b)
auxConcHash (Comp a (_, _), Unit (b,_)) = concHash(a,concHash(b,b))
auxConcHash (Comp a (_,_), Comp b (_,_)) = concHash(a,b)

\end{code}
Gene de |mroot| ("get Merkle root"):
\begin{code}
g_mroot = firsts
\end{code}
Valorização:

\begin{code}
pairsList :: [a] -> [(a, a)]
pairsList = anaList (g_pairsList)

g_pairsList = (id -|- pair_aux . (dup >< id)) . outList . getEvenBlock where
     pair_aux ((h1, h2), t) = ((h1, head t), tail t)

classicMerkleTree :: Hashable a => [a] -> FTree Integer Integer
classicMerkleTree = hyloNEList conquer divide . map Main.hash

divide = ((singl . Unit) -|- createMtree) . outNEList where
     createMtree = singl . Unit >< id

conquer = either head joinMerkleTree where
      joinMerkleTree (l, m) = mergeMerkleTree m (evenMerkleTreeList l)
      mergeMerkleTree = cataFTree (either h1 h2)
      h1 c l = undefined 
      h2 (c, (f, g)) l = undefined
      evenMerkleTreeList = getEvenBlock
\end{code}

\subsection*{Problema 2}

\noindent \newline
Por aplicações da lei da recursividade mútua às funções \textit{wc\_c}, \textit{lookAhead\_sep} temos:
\begin{eqnarray*}
\start
     |split (wc_c) (lookahead_sep) = |\cata{|split h k|}
%
\just\equiv{\textcolor{blue}{Definições de h e k}}
%
     |split wc_c lookahead_sep = |\cata{|split (either h1 h2) (either k1 k2)|}
%
\just\equiv{ \textcolor{blue}{Lei da Troca (28)}}
%
     |split wc_c lookahead_sep = |\cata{|either (split h1 k1) (split h2 k2)|}
\end{eqnarray*}

\noindent \newline
Logo, 
\begin{center}
\fbox{\begin{minipage}{13em}
    \center $ | worker = |\cata{|either (split h1 k1) (split h2 k2)|} $
\end{minipage}}
\end{center}

que por sua vez:
\begin{eqnarray*}
     | lcbr
     (g1 = split h1 k1)
     (g2 = split h2 k2)
     |
\end{eqnarray*}

\noindent \newline
Falta descobrir os genes h e k:

\begin{eqnarray*}
\centerline{\xymatrix@@C=3cm@@R=2cm{
    Char^*
          \ar[d]_-{|lookahead_sep|}
          \ar@@/^2pc/[r]_-{|out|}
&
    |1 + Char >< | Char^*
          \ar[d]^{|id + id >< (split wc_c lookahead_sep)|}
          \ar@@/^2pc/[l]_-{|inNat|}
\\
     |Bool|
&
     |1 + Char >< (Int >< Bool)|
           \ar[l]^-{|either k1 k2|}
}
}
\end{eqnarray*}

Analisando o diagrama, facilmente se deduz o |k1|, pois quando a função \textit{lookahead\_sep} recebe uma lista vazia, segundo a implementação em Haskell verificamos que:
\begin{eqnarray*}
     | k1 = const True |
\end{eqnarray*}

\noindent
Para o |k2| apenas nos interessa a cabeça do par \textit{(h,(int,bool))} resultando da aplicação da função \textit{out} das listas. Assim, para retirar a cabeça usamos a função |p1| 
e ao resultado aplicamos a função dada \textit{sp} para verificar se o carácter é de separação ou não. Logo:
\begin{eqnarray*}
     | k2 = sp . fst |
\end{eqnarray*}

\noindent
\begin{eqnarray*}
\centerline{\xymatrix@@C=3cm@@R=2cm{
    Char^*
          \ar[d]_-{|wc_c|}
          \ar@@/^2pc/[r]_-{|out|}
&
    |1 + Char >< | Char^*
          \ar[d]^{|id + id >< (split wc_c lookahead_sep)|}
          \ar@@/^2pc/[l]_-{|inNat|}
\\
     |Int|
&
     |1 + Char >< (Int >< Bool)|
           \ar[l]^-{|either h1 h2|}
}
}
\end{eqnarray*}

Agora olhando para o diagrama da função \textit{wc\_c} e para o código dado em Haskell, verificamos que o resultado, para a lista vazia, é de 0 palavras. Então:
\begin{eqnarray*}
     | h1 = const 0 |
\end{eqnarray*}

\noindent
Para a função |h2| reparamos que esta recebe um \textit{(char,(int, bool))} resultante da recursividade das funções \textit{|(split (wc_c) (lookahead_c))|} após o \textit{out} de listas.
Portanto, o primeiro elemento corresponde à cabeça da lista e o segundo elemeto, que é outro par, é o resultado da recursividade aplicado à cauda. Deste modo, 
analizando o código mais uma vez observamos que há uma condição, isto é, precisamos de verificar se a cabeça não é um elemento separador e se o próximo elemento 
da cauda é. Se sim, então incrementa-se o resultado que se tem no segundo par, se não, devolve-se o que temos.

\vspace{0.5cm}

Concluindo, assim, a seguinte definição de |h2|:

\begin{center}
\fbox{\begin{minipage}{5em}
    \center $ | h2 = aux| $
\end{minipage}}
\end{center}

Onde \textit{aux} é:

\begin{center}
\fbox{\begin{minipage}{21em}
    \center $ | aux (c, (i, b)) = if not (sp c) && b then i+1 else i | $
\end{minipage}}
\end{center}

\vspace{0.5cm}

\begin{figure}[h!]
  \centering
  \includegraphics[width=0.3\textwidth]{cp2122t_media/cp_p2.png}
\end{figure}

\vspace{0.5cm}

\subsubsection*{Solução} % ----------------------------------------SOLUÇÂO ---------------------------------------------- %
\begin{code}
wc_w_final :: [Char] -> Int 
wc_w_final = wrapper . worker
worker = cataList (either g1 g2)
wrapper = p1
\end{code}
Gene de |worker|:
\begin{code}
g1 = split h1 k1
g2 = split h2 k2
\end{code}
Genes |h = either h1 h2| e |k = either k1 k2| identificados no cálculo:
\begin{code}
h1 = const 0
h2 = aux where 
     aux (c, (i, b)) = if not (sp c) && b then i+1 else i 
k1 = const True
k2 = sp . p1
\end{code}

\subsection*{Problema 3} 

\vspace{0.5cm}

\subsubsection*{inX:}
\begin{eqnarray*}
\centerline{\xymatrix@@C=3cm@@R=2cm{
     |X u i|
          \ar@@/^2pc/[rr]_-{|outX|}
& \qquad \cong &
    |u + (i,(X u i, X u i))|
          \ar@@/^2pc/[ll]_-{|inx|}
}
}
\end{eqnarray*}

\vspace{0.5cm}

\begin{eqnarray*}
\start
     |inX = either XLeaf Node|
%
\just\equiv{\textcolor{blue}{Universal-+ (17)}}
%
     |lcbr(
          inX . i1 = XLeaf
     )(
          inX . i2 = Node
     )|
%
\just\equiv{\textcolor{blue}{ Igualdade extensional (71), Def-comp (72) }}
%
     |lcbr(
          inX(i1 u) = XLeaf u
     )(
          inX(i2(i1(a,b))) = Node i a b
     )|
\end{eqnarray*}

\vspace{0.5cm}

\subsubsection*{outX:}

\vspace{0.5cm}

\begin{eqnarray*}
\start
     |outX . inX = id|
%
\just\equiv{\textcolor{blue}{definição de inX}}
%
     |outX . either XLeaf Node = id|
%
\just\equiv{\textcolor{blue}{Fusão-+ (20)}}
%
     |either (outX . XLeaf) (outX . Node) = id|
%
\just\equiv{\textcolor{blue}{Universal-+ (17)}}
%
     |lcbr(
          id . i1 = outX . XLeaf
     )(
          id . i2 = outX . Node
     )|
%
\just\equiv{\textcolor{blue}{Natural-ID (1), Igualdade extensional (71), Def-comp(72)}}
%
     |lcbr(
          outX(XLeaf u) = i1 u
     )(
          outX(Node i a b) = i2 (i,(a,b))
     )|
\end{eqnarray*}

\vspace{0.5cm}

\subsubsection*{baseX:}

\vspace{0.5cm}

\begin{eqnarray*}
\centerline{\xymatrix@@C=3cm@@R=2cm{
     X
          \ar[d]_-{|g|}
          \ar@@/^2pc/[rr]_-{|outX|}
& \qquad \cong
&
    | A + B >< ( X >< X)|
          \ar[d]^{|f + g >< (g >< g)|}
          \ar@@/^2pc/[ll]_-{|inX|}
\\
     |C|
&  &
     |A´ + (B´ >< (C >< C))|
           \ar[ll]^-{|either h1 h2|}
}
}
\end{eqnarray*}

\vspace{0.5cm}

\subsubsection*{recX:}

\vspace{0.5cm}

\begin{eqnarray*}
\start
     |recX f = id + (id x (f x f))|
%
\just\equiv{\textcolor{blue}{Aplicando a definição de baseX}}
%
     |recX f = baseX id id f|
\end{eqnarray*}

\vspace{0.5cm}

\subsubsection*{cataX:}

\vspace{0.5cm}

\begin{eqnarray*}
\just\equiv{\textcolor{blue}{Cancelamento-cata (46)}}
     \cata{g}\ .\ in = g\ .\ F\cata{g}
%
\just\equiv{\textcolor{blue}{in . out = id}}
%
     \cata{g} = g\ .\ F\cata{g}\ .\ out
%
\just\equiv{\textcolor{blue}{Aplicando as definições em Haskell já definidas}}
%
     |cataX g = g . recX (cataX g) . outX|
\end{eqnarray*}

\vspace{0.5cm}

\subsubsection*{anaX:}

\vspace{0.5cm}

\begin{eqnarray*}
\just\equiv{\textcolor{blue}{Cancelamento-ana (55)}}
     out\ .\ \ana{g} = g\ .\ F\ana{g}\ .\ g
%
\just\equiv{\textcolor{blue}{in . out = id}}
%
     \ana{g} = in\ .\ F\ana{g}\ .\ g
%
\just\equiv{\textcolor{blue}{Aplicando as definições em Haskell já definidas}}
%
     |anaX g = inX . recX (anaX g) . g|
\end{eqnarray*}

\vspace{0.5cm}

\subsubsection*{hyloX:}

\vspace{0.5cm}

\begin{eqnarray*}
\just\equiv{\textcolor{blue}{Definição de hilomorfismo}}
     |hyloX g h |= \cata{g}\ .\ \ana{h}
%
\just\equiv{\textcolor{blue}{Cancelamento-cata (46), Cancelamento-ana(55)}}
%
     |hyloX g h = g . F|\cata{g}| . inX . outX . F|\ana{h}| . h|
%
\just\equiv{\textcolor{blue}{in . out = id, Aplicando as definições em Haskell já definidas}}
%
     |hyloX g h = g . recX (cataX g) . recX (anaX h) . h|
\end{eqnarray*}

\vspace{0.5cm}

\noindent
Segue-se o resto da resolução deste problema:

\vspace{0.5cm}

\subsubsection*{x2html}

\vspace{0.5cm}

\begin{eqnarray*}
\centerline{\xymatrix@@C=3cm@@R=2cm{
     |X u i|
          \ar[d]_-{|new_x2html|}
          \ar@@/^2pc/[rr]_-{|outX|}
& \qquad \cong
&
     u + (i, (x1, x2))
          \ar[d]^{|id + id >< (new_x2html >< new_x2html)|}
          \ar@@/^2pc/[ll]_-{|inX|}
\\
     Char^*
&  &
     u + (i, (s1, s2))
           \ar[ll]^-{|g_x2html|}
}
}
\end{eqnarray*}

\vspace{0.5cm}

\par\noindent\hspace{0.5cm}Analizando o diagrama do catamorfismo e o código em Haskell da função \textit{x2html} percebemos que o gene \textit{g\_x2html} recebe uma folha \textit{XLeaf} que tanto pode conter uma imagem ou texto, por isso definimos o gene da seguinte forma:

\begin{center}
\fbox{\begin{minipage}{13em}
    \center $ | g_x2html = either g1 g2 where| $
    \center $ | g1 = auxX1| $
    \center $ | g2 = auxX2| $
\end{minipage}}
\end{center}

\vspace{0.5cm}

\par\noindent\hspace{0.5cm}Nesse sentido, se a função auxX1 receber uma \textit{Image} é usada a função dada \textit{img} para devolver o formato \textit{HTML} de uma imagem. Caso a função auxiliar em questão receber um \textit{Text} é apenas devolvido a string que contém o texto.

Assim,
\begin{center}
\fbox{\begin{minipage}{17em}
    \center $ | auxX1 (Image a) (w,h) = img w h a | $
    \center $ | auxX1 (Text b) _ = b | $
\end{minipage}}
\end{center}

\vspace{0.5cm}

\par\noindent\hspace{0.5cm}Quanto à função auxX2 esta recebe um par em que o primeiro elemento é a informação que esta no nodo da estrutura X e que pode ser 4 tipos diferentes de \textit{Mode} e o segundo elemento é um outro par que contém a recursividade aplicada à árvore esquerda e direita, respetivamente. Assim, a definição desta função é bastante parecida à versão original, apenas se reescrevendo as chamadas recursivas:

\begin{center}
\fbox{\begin{minipage}{35em}
     \center $ | auxX2 (Vt i, (s1,s2)) (w,h) = htab w h (
                                     tr( td w (h*i)     (s1 (w, h*i))) ++
                                     tr( td w (h*(1-i)) (s2(w, h * (1-i))))
                                   ) | $
     \center $ | auxX2 (Hl i, (s1,s2)) (w,h) = htab w h (
                                     tr( td (w*i) h     (s1(w * i, h)) ++
                                         td (w*(1-i)) h (s2(w*(1-i),h)))
                                   )| $
     \center $ | auxX2 (Vb i, (s1,s2)) m = auxX2 (Vt (1-i), (s1,s2)) m | $
     \center $ | auxX2 (Hr i, (s1,s2)) m = auxX2 (Hl (1-i), (s1,s2)) m | $
\end{minipage}}
\end{center}

\vspace{0.5cm}

\begin{figure}[h!]
  \centering
  \includegraphics[width=0.4\textwidth]{cp2122t_media/cp_p3.png}
\end{figure}

\vspace{0.5cm}

\subsubsection*{Solução} %--------------------------------------------SOLUÇÂO------------------------------------------------------%
\begin{code}
inX :: Either u (i, (X u i, X u i)) -> X u i
inX(Left u) = XLeaf u
inX(Right (i, (l, r))) = Node i l r

outX :: X a1 a2 -> Either a1 (a2, (X a1 a2, X a1 a2))
outX (XLeaf u) = i1 u
outX (Node i l r) = i2 (i, (l,r))

baseX f h g = f -|- (h >< (g >< g))

recX f = baseX id id f

cataX g = g.recX (cataX g).outX

anaX g = inX.recX (anaX g).g

hyloX c d = c.recX (cataX c).recX (anaX d).d


new_printJournal = write . new_sheet2html
new_sheet2html (Rect (Frame w h) y) = htmlwrap (new_x2html y (w , h))

new_x2html :: X (Unit String String) (Mode Double) -> (Double, Double) -> String
new_x2html = cataX g_x2html


g_x2html = either g1 g2 where
     g1 = auxX1
     g2 = auxX2

auxX1 (Image a) (w,h) = img w h a
auxX1 (Text b) _ = b 

auxX2 (Vt i, (s1,s2)) (w,h) = htab w h (
                                     tr( td w (h*i)     (s1 (w, h*i))) ++
                                     tr( td w (h*(1-i)) (s2(w, h * (1-i))))
                                   )
auxX2 (Hl i, (s1,s2)) (w,h) = htab w h (
                                     tr( td (w*i) h     (s1(w * i, h)) ++
                                         td (w*(1-i)) h (s2(w*(1-i),h)))
                                   )
auxX2 (Vb i, (s1,s2)) m = auxX2 (Vt (1-i), (s1,s2)) m
auxX2 (Hr i, (s1,s2)) m = auxX2 (Hl (1-i), (s1,s2)) m


\end{code}

\subsection*{Problema 4}
\subsubsection*{pairL:}
\begin{eqnarray*}
\centerline{\xymatrix@@C=3cm@@R=2cm{
     (A,A)^*
          \ar@@/^2pc/[rr]_-{|outX|}
&    \qquad \cong
&
    | 1 + (A >< A) >< (A ><A)|^*
          \ar@@/^2pc/[ll]_-{|inX|}
\\
     |A|^*
          \ar[u]^-{|pairL|}
          \ar[r]^-{|outList|}
          \ar@@/^-2pc/[rr]_-{|g|}
&  
     1 + |A ><| A^*
          \ar[r]^-{|id + ?|}
&
     |1 + (A >< A) >< A|^*
           \ar[u]_{|id + id >< pairL|}
}
}
\end{eqnarray*}

A ideia é decompor a lista original para poder depois construir numa nova lista de pares. Embora estas funções não recebam listas vazias é necessário cobrir o 
caso em que a lista é vazia. Assim, o resultado é a própria lista vazia, logo basta preservar através da função \textit{id}.

Para o caso em que é dada uma lista \textbf{l} de tamanho maior que 1, esta é decomposta no par \textbf{(h,t)} pela função outlist.
\begin{eqnarray*}
\centerline{\xymatrix@@C=3cm@@R=2cm{
     (A,A)^*
         \ar[r]_-{|dup >< id|}
&    |(A,A) >< A|^*
          \ar[r]_-{|completePair|}
&
     |(A,A) >< A|^*
}
}
\end{eqnarray*}

A seguir é preciso transformar a cabeça \textbf{h} num par \textbf{(h,h)} através da função dup e, de seguida, com a função auxiliar \textit{completePair} completar o par de modo a que fique
\textbf{(h,x)} em que \textbf{x} é a cabela da lista \textbf{t} isto se \textbf{t} não for lista vazia senão mantém-se o par \textbf{(h,h)}.

Deste modo o gene do anamorfismo g é definido como:
\begin{center}
\fbox{\begin{minipage}{20em}
    \center $ |g = (id + completePair . (dup >< id)) . outList| $
\end{minipage}}
\end{center}

No entanto, ao correr a função \textit{pairL [1,2,3,4]} reparamos que o output é \textbf{[(1,2),(2,3),(3,4),(4,4)]} em que o último elemento está a mais. Porém se fizermos \textit{init} dessa
lista descartando o último elemento a função vai falhar para o caso \textit{pairL [1]} retornando \textit{[]} em vez de \textbf{[(1,1)]}.

Então modificamos a definição pair para o seguinte modo:
\begin{center}
\fbox{\begin{minipage}{12em}
    $ | pairL = (p -> f,h) | $ \\
    $ | where p l = length l > 1| $\\
    $ | f = init . anaList g | $\\
    $ | h = anaList g| $
\end{minipage}}
\end{center}

\vspace{0.5cm}

\begin{figure}[h!]
  \centering
  \includegraphics[width=0.4\textwidth]{cp2122t_media/cp_p4_pairL.png}
\end{figure}

\vspace{0.5cm}

\subsubsection*{markMap}
Diagrama geral da função \textit{markMap}:
\noindent
\newline
\begin{eqnarray*}
\centerline{\xymatrix@@C=3cm@@R=3cm{
     Pos^*
          \ar[dr]_{|markMap|}
          \ar[r]_-{|pairL|}
&
    | (Pos,Pos) |^*
     \ar[d]_-{|f = |\cata{g}}
\\
&
     |Map|
}
}
\end{eqnarray*}

Como podemos observar no diagrama, a função começa por transformar a lista inicial de posições numa lista de pares. Assim, essa lista será o input do catamorfismo de listas
que a consome e transforma num mapa marcado com o respetivo caminho.
Necessitamos definir a função \textit{f2} do gene \textbf{g=[id,f2]} e para isso foi feito um diagrama para extrair o tipo dos seus argumentos:

\begin{eqnarray*}
\centerline{\xymatrix@@C=3cm@@R=2cm{
     (Pos,Pos)^*
          \ar[d]_-{|f|}
          \ar@@/^2pc/[rr]_-{|outX|}
& \qquad \cong
&
    | 1 + (Pos,Pos) >< (Pos,Pos)|^*
          \ar[d]^{|id + id >< f|}
          \ar@@/^2pc/[ll]_-{|inX|}
\\
     |Map|
&  &
     |1 + (Pos,Pos) >< Map|
           \ar[ll]^-{|g = either id f2|}
}
}
\end{eqnarray*}
Com o diagrama concluiu-se que a função \textit{f2} recebia um par \textbf{((Pos,Pos),h)}, em que o primeiro elemento é um par de posições que indicam o movimento no mapa e por isso será necessário 
usar a função toCell para o processar. Por outro lado, o segundo elemento refere-se a uma função que devolve o mapa marcado com as posições na cauda da lista original e que será aplicado no mapa 
original dado como argumento.

\begin{eqnarray*}
\centerline{\xymatrix@@C=3cm@@R=2cm{
     (|either Pos Pos|,h)^*
          \ar[r]_-{|split p1 toCell >< id|}
&    | (Pos, Cell), h|
          \ar[r]_-{|substCell|}
&
    | Map |
}
}
\end{eqnarray*}

Como referido anteriormente, será necessário gerar o tipo \textit{Cell} com as coordenadas do primeiro par guardando no lado direito o resultado e preservando o lado esquerdo pois é onde vai ser inserido no mapa.
Finalmente, foi criada a função auxiliar \textit{substCell} que recebe o par \textit{((Pos, Cell),h)} mais o mapa dado e com o auxílio da função \textit{subst} faz as substituições necessárias no mapa 
original. Esta função também leva em conta se uma \textit{Call} está bloqueada ou não garantindo percorrer em apenas caminhos livres. Logo:

\begin{center}
\fbox{\begin{minipage}{20em}
    \center $ |f2 = substCell . ((split p1 (uncurry toCell)) >< id)| $
\end{minipage}}
\end{center}

\vspace{0.5cm}

\begin{figure}[h!]
  \centering
  \includegraphics[width=0.8\textwidth]{cp2122t_media/cp_p4_markMap.png}
\end{figure}

\vspace{0.5cm}

\subsubsection*{Soluções}
\begin{code}
pairL :: [a] -> [(a,a)]
pairL = cond p f h where
  p l = length l > 1
  f = init . anaList g_pairL
  h = anaList g_pairL 
  g_pairL = (id -|- completePair . (dup >< id)) . outList where
     completePair ((x1,x2), l) = if length l > 0 then ((x1, head l), l) else ((x1,x2),l)
\end{code}

\begin{code}
markMap :: [Pos] -> Map -> Map
markMap l = cataList (either (const id) f2) (pairL l) where
     f2 = substCell . (split p1 (uncurry toCell) >< id)
     substCell (((r,c),move), h) m 
                                   |(m !! c) !! r == Blocked = h m
                                   |otherwise = subst (subst move r (h m !! c)) c (h m)
     
\end{code}

\begin{code}
scout :: Map -> Pos -> Pos -> Int -> [[Pos]]
scout m s t = cataNat (either f1 (>>= f2 m s)) where
  f1 = undefined
  f2 = undefined
\end{code}


\paragraph{Valorização} (opcional) Completar as seguintes funções de teste no \QuickCheck\ para verificação de propriedades das funções pedidas, a saber:

\begin{propriedade}  A lista correspondente ao lado esquerdo
dos pares em (|pairL l|) é a lista original |l| a menos do último elemento.
Analogamente, a lista correspondente ao lado direito
dos pares em (|pairL l|) é a lista original |l| a menos do primeiro elemento:

\begin{code}
prop_reconst l 
               | length l <= 1 = map p1 (pairL l) == map p2 (pairL l)
               | otherwise = init l == map p1 (pairL l) && tail l == map p2 (pairL l)
\end{code}
\end{propriedade}

\begin{propriedade} 
Assuma que uma linha (de um mapa) é prefixa de uma outra linha. Então a representação
da primeira linha também prefixa a representação da segunda linha:
\end{propriedade}
\begin{code}
prop_prefix2 l l' = undefined
\end{code}
\begin{propriedade} 
Para qualquer linha (de um mapa), a sua representação  deve conter um número de símbolos correspondentes a um tipo célula igual
ao número de vezes que esse tipo de célula aparece na linha em questão.
\end{propriedade}
\begin{code}
prop_nmbrs l c = undefined

count :: (Eq a) => a -> [a] -> Int
count = undefined
\end{code}

\begin{propriedade} 
Para qualquer lista |l| a função |markMap l| é idempotente.
\end{propriedade}
\begin{code}
inBounds m (x,y) = undefined

prop_idemp2 l m = undefined
\end{code}
\begin{propriedade} 
Todas as posições presentes na lista dada como argumento irão fazer com que
as células correspondentes no mapa deixem de ser |Free|.
\end{propriedade}
\begin{code}
prop_extr2 l m = if (length l > 1 && isValidMap m) then checkCell (init l) (markMap l m) else False  
          
     
checkCell [] m = True
checkCell ((x,y):t) m = ((m !! y) !! x) /= Free && checkCell t m 
\end{code}

\begin{propriedade} 
Quanto maior for o tamanho máximo dos caminhos  mais caminhos que alcançam a
posição alvo iremos encontrar:
\end{propriedade}
\begin{code}
prop_reach m t n n' = undefined
\end{code}


%----------------- Índice remissivo (exige makeindex) -------------------------%

\printindex

%----------------- Bibliografia (exige bibtex) --------------------------------%

\bibliographystyle{plain}
\bibliography{cp2122t}

%----------------- Fim do documento -------------------------------------------%
\end{document}
