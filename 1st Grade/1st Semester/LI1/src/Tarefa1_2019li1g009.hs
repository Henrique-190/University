-- | Este módulo define funções comuns da Tarefa 2 do trabalho prático.
module Tarefa1_2019li1g009 where

import LI11920
import System.Random

-- * Testes

-- | Testes unitários da Tarefa 1.
--
-- Cada teste é um triplo (/número de 'Pista's/,/comprimento de cada 'Pista' do 'Mapa'/,/semente de aleatoriedades/).
testesT1 :: [(Int,Int,Int)]
testesT1 = [(2,9,0),(1,1,9),(4,2,2),(3,7,3),(10,10,4),(2,6,5),(9,6,6),(17,6,7),(3,6,9),(4,2,10),(80,80,80),(9,3,5),(20,20,20),(80,1,2),(12,13,14),(14,13,12),(3,3,3)]


-- * Funções pré-definidas da Tarefa 1.
-- | A função __geraAleatorios__ pretende gerar um conjunto de números aleatórios de 0 a 9.
geraAleatorios :: Int -- ^ Quantidade de números necessária para a formação do mapa.
               -> Int -- ^ A Semente.
               -> [Int] -- ^ Lista de número aleatórios.
geraAleatorios n seed = take n (randomRs (0,9) (mkStdGen seed))


-- | Função que divide uma lista de números numa lista de pares.
{- == Esta função faz com que, por exemplo: 
>>>> [1,2,3,4]
[(1,2),(3,4)] 
>>>> [4,3,2,1,0,3]
[(4,3),(2,1),(0,3)]-}
dividePar :: [Int] -- ^ Lista de números aleatórios
          -> [(Int,Int)] -- ^ Lista de pares
dividePar [] = []
dividePar (x:y:xs) = (x,y):(dividePar xs)



-- | Função que, formada a pista, a divide em várias outras listas, formando um lista de várias listas, de acordo com o comprimento de cada pista.
-- O comprimento de uma lista de pares fica igual ao (comprimento da pista-1).
-- Era obrigatório colocar uma exceção para quando o comprimento da peça fosse 1, senão daria erro.
-- No caso de comp=1, esta função já forma uma pista.
-- Remove 1 unidade ao comprimento, dado que a primeira peça já está definida (Recta Terra 0).
-- comp = comprimento da pista.
{- == Esta função faz com que, por exemplo: 
>>>> [[(1,2),(3,4)] 3
[[(1,2),(3,4)],[(5,4),(7,9)]]
>>>> [(4,3),(2,1),(0,3)] 4
[(4,3),(2,1),(0,3)] -}
divideP :: [(Int,Int)] -- ^ Lista de Pares.
        -> Int -- ^ Comprimento de cada pista.
        -> [[(Int,Int)]] -- ^ Nova Lista com várias listas.
divideP [] comp = []
divideP l comp = (dividePAux l (comp-1)):(divideP restante comp)
 where restante = (drop (length (dividePAux l (comp-1))) l)

-- | Função que forma uma pista, quando comp>1.
{- == Exemplos:
>>>> [(1,2),(3,4),(5,4),(7,9)] 2
[[(1,2),(3,4)],[(5,4),(7,9)]].
>>>> [(4,3),(2,1),(0,3)] 4
[[(4,3),(2,1),(0,3)]] -}
dividePAux :: [(Int,Int)] -- ^ Lista de aleatórios em pares.
           -> Int -- ^ Comprimento da pista.
           -> [(Int,Int)] -- ^ Nova Lista com várias listas.
dividePAux ((x,y):ys) 1 = [(x,y)]
dividePAux ((x,y):ys) comp = (x,y):(dividePAux ys (comp-1))


-- | Função que adiciona (0,6), ou seja, Recta Terra 0, que é a primeira peça de uma pista, às várias pistas.
{- == Exemplo:
>>>> [[(1,2),(3,4)],[(5,4),(7,9)]] 
[[(0,6),(1,2),(3,4)],[(0,6),(5,4),(7,9)]] -}
addZero :: [[(Int,Int)]] -- ^ Pista sem Secção inicial de Recta Terra 0
        -> [[(Int,Int)]] -- ^ Pista com Secção inicial de Recta Terra 0
addZero [] = [] 
addZero (((a,b):xs):l) = [[(0,6)]++((a,b):xs)]++(addZero l)


-- | Função que define o tipo de piso.
{- >>>> [[[(0,6),(1,2),(3,4)],[(0,6),(5,4),(7,9)]]
[[Terra, Terra, Relva],[Terra, Boost, Boost]] -}
pisoAux :: [(Int,Int)] -- ^ Lista de pares
        -> Piso -- ^ Piso anterior
        -> [Piso] -- ^ Lista com os diferentes pisos associados.
pisoAux ((x,y):t) p = if x==0 || x==1 then Terra:(pisoAux t Terra)
    else if x==2 || x==3 then Relva:(pisoAux t Relva)
    else if x==4 then Lama:(pisoAux t Lama)
    else if x==5 then Boost:(pisoAux t Boost)
    else p:(pisoAux t p)


-- | Função que adiciona o acumulador "0", de modo a definir todas as alturas. 
-- A primeira altura de uma pista será sempre 0.
altura :: [(Int,Int)] -- ^ Lista de Pares
       -> [Peca] -- ^ Lista de peças
altura ((x,y):t) = alturaAux ((x,y):t) 0

-- | Função que define a altura da primeira peça de cada pista.
-- Só existe um caso: quando o "a" é 0, dado que estamos a falar da primeira pista.
alturaAux :: [(Int,Int)] -- ^ Lista de pares
          -> Int -- ^ Altura anterior
          -> [Peca] -- ^ Lista de peças
alturaAux ((x,y):t) 0 = (Recta Terra 0):(alturaAux2 t 0 (pisoAux t Terra))

-- | Função que define as alturas das restantes peças da pista.
alturaAux2 :: [(Int,Int)] -- ^ Lista de pares
           -> Int -- ^ Altura anterior
           -> [Piso] -- ^ Lista de pisos
           -> [Peca] -- ^ Lista de peças
alturaAux2 [] a p = []
alturaAux2 ((x,y):t) a p
    | y==0 || y==1 = (Rampa (hp) a (a+y+1)):(alturaAux2 t (a+y+1) (pi))
    | a==0 && y>=2 && y<=5 = (Recta (hp) a):(alturaAux2 t a (pi))
    | y>=2 && y<=5 && (a-y+1)<0 = (Rampa (hp) a 0):(alturaAux2 t 0 (pi))
    | y>=2 && y<=5 = (Rampa (hp) a (a-y+1)):(alturaAux2 t (a-y+1) (pi))
    | otherwise = (Recta (hp) a):(alturaAux2 t a (pi))

-- hp dá a "cabeça" de pi.
-- pi define o piso da lista, sendo que "head p" é a "cabeça" da lista de pisos.
   where hp = head pi
         pi = (pisoAux ((x,y):t) (head p))


-- | Funções principais da Tarefa 1.
-- npistas = número de pistas ; comp = comprimento da pista.
gera :: Int -- ^ Número de pistas.
     -> Int -- ^ Comprimento de cada pista.
     -> Int -- ^ Semente
     -> Mapa -- ^ Lista formada por listas de pares
gera 0 _ _ = []
gera npistas 1 semente = ([Recta Terra 0]):(gera (npistas-1) 1 semente)
gera npistas comp semente = map altura (addZero pistaPar)

-- gA é a função que gera números pseudo-aleatórios, de acordo com o npistas, o comp e a semente.
-- pistaPar é o conjunto das várias funções definidas anteriormente.
 where gA = (geraAleatorios (2*(comp-1)*npistas) semente)
       pistaPar = (divideP (dividePar (gA)) comp)