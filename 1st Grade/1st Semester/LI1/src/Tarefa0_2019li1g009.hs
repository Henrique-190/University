-- | Este módulo define funções genéricas sobre vetores e matrizes, que serão úteis na resolução do trabalho prático.
module Tarefa0_2019li1g009 where

-- * Funções não-recursivas.

-- | Um ponto a duas dimensões dado num referencial cartesiado (distâncias aos eixos vertical e horizontal)
--
-- <<http://li1.lsd.di.uminho.pt/images/cartesiano.png cartesisano>>
-- , ou num referencial polar (distância à origem e ângulo do respectivo vector com o eixo horizontal).
--
-- <<http://li1.lsd.di.uminho.pt/images/polar.png polar>>
data Ponto = Cartesiano Double Double | Polar Double Angulo deriving Show

-- | Um ângulo em graus.
type Angulo = Double

-- ** Funções sobre vetores

-- | Um 'Vetor' na representação escalar é um 'Ponto' em relação à origem.
type Vetor = Ponto
-- ^ <<http://li1.lsd.di.uminho.pt/images/vetor.png vetor>>

-- *** Funções gerais sobre 'Vetor'es.
-- | Função que transforma um polar num cartesiano
polarToCartesiano :: Ponto -> Ponto
polarToCartesiano (Cartesiano x y) = (Cartesiano x y)
polarToCartesiano (Polar r a) = 
            let x = r * cos (a * pi / 180) 
                y = r * sin (a * pi / 180)
             in (Cartesiano x y)
         

-- | Soma dois 'Vetor'es.
somaVetores :: Vetor -> Vetor -> Vetor
somaVetores a b =
          let 
              (Cartesiano x1 y1) = polarToCartesiano a 
              (Cartesiano x2 y2) = polarToCartesiano b
          in 
              (Cartesiano (x1+x2) (y1+y2))

-- | Subtrai dois 'Vetor'es.
subtraiVetores :: Vetor -> Vetor -> Vetor
subtraiVetores a b =
          let 
              (Cartesiano x1 y1) = polarToCartesiano a 
              (Cartesiano x2 y2) = polarToCartesiano b
          in 
              (Cartesiano (x1-x2) (y1-y2))

-- | Multiplica um escalar por um 'Vetor'.
multiplicaVetor :: Double -> Vetor -> Vetor
multiplicaVetor a b = 
          let 
              (Cartesiano x y) = polarToCartesiano b
          in 
              (Cartesiano (a*x) (a*y))

-- ** Funções sobre rectas.

-- | Um segmento de reta é definido por dois pontos.
type Reta = (Ponto,Ponto)

-- | Testar se dois segmentos de reta se intersetam.
--
-- __NB:__ Aplique as equações matemáticas bem conhecidas, como explicado por exemplo em <http://www.cs.swan.ac.uk/~cssimon/line_intersection.html>.
intersetam :: Reta -> Reta -> Bool
intersetam r1 r2 = (ta <= 1 && ta >= 0) && (tb <= 1 && tb >= 0)
                 where (ta,tb) = calculaTaTb r1 r2

-- | Calcular o ponto de intersecao entre dois segmentos de reta.
-- __NB:__ Aplique as equações matemáticas bem conhecidas, como explicado por exemplo em <http://www.cs.swan.ac.uk/~cssimon/line_intersection.html>.
intersecao :: Reta -> Reta -> Ponto
intersecao r1@(a,b) r2@(c,d) 
                            | intersetam r1 r2 = let (ta, tb) = calculaTaTb r1 r2
                                                 in  somaVetores a (multiplicaVetor ta (subtraiVetores b a))
                            | otherwise = error "As retas não se intersetam"
  
-- Definir uma função auxiliar que calcula os valores de ta e tb, consoante os pontos (a,b) e (c,d) que definem o segmento.
-- | FUnção que verifica calcula ta e tb, dando dois pontos
calculaTaTb :: Reta -> Reta -> (Double, Double)
calculaTaTb (a, b) (c, d) = (ta, tb) 
          where
              (Cartesiano x1 y1) = polarToCartesiano a
              (Cartesiano x2 y2) = polarToCartesiano b
              (Cartesiano x3 y3) = polarToCartesiano c
              (Cartesiano x4 y4) = polarToCartesiano d
              ta = ((y3 - y4) * (x1 - x3) + (x4 - x3) * (y1 - y3)) / ((x4 - x3) * (y1 - y2) - (x1 - x2) * (y4 - y3))
              tb = ((y1 - y2) * (x1 - x3) + (x2 - x1) * (y1 - y3)) / ((x4 - x3) * (y1 - y2) - (x1 - x2) * (y4 - y3))

-- ** Funções sobre listas

-- *** Funções gerais sobre listas.
--
-- Funções não disponíveis no 'Prelude', mas com grande utilidade.

-- | Verifica se o indice pertence à lista.
--
-- __Sugestão:__ use a função 'length' que calcula tamanhos de listas
eIndiceListaValido :: Int -> [a] -> Bool
eIndiceListaValido i l =
    if i < length l && i >= 0
    then True
    else False

-- ** Funções sobre matrizes.

-- *** Funções gerais sobre matrizes.

-- | A dimensão de um mapa dada como um par (/número de linhas/,/número de colunhas/).
type DimensaoMatriz = (Int,Int)

-- | Uma posição numa matriz dada como um par (/linha/,/colunha/).
-- As coordenadas são dois números naturais e começam com (0,0) no canto superior esquerdo, com as linhas incrementando para baixo e as colunas incrementando para a direita:
--
-- <<http://li1.lsd.di.uminho.pt/images/posicaomatriz.png posicaomatriz>>
type PosicaoMatriz = (Int,Int)

-- | Uma matriz é um conjunto de elementos a duas dimensões.
--
-- Em notação matemática, é geralmente representada por:
--
-- <<https://upload.wikimedia.org/wikipedia/commons/d/d8/Matriz_organizacao.png matriz>>
type Matriz a = [[a]]

-- | Calcula a dimensão de uma matriz.
--
-- __NB:__ Note que não existem matrizes de dimensão /m * 0/ ou /0 * n/, e que qualquer matriz vazia deve ter dimensão /0 * 0/.
--
-- __Sugestão:__ relembre a função 'length', referida anteriormente.

dimensaoMatriz :: Matriz a -> DimensaoMatriz
dimensaoMatriz [] = (0,0)
dimensaoMatriz ([]:xs) = (0,0)
dimensaoMatriz a = (length a,length (head a))

-- | Verifica se a posição pertence à matriz.
ePosicaoMatrizValida :: PosicaoMatriz -> Matriz a -> Bool 
ePosicaoMatrizValida (l, c) a = length a /= 0 && l < length a && c < length (a !! l) 
-- * Funções recursivas.

-- ** Funções sobre ângulos

-- | Normaliza um ângulo na gama [0..360).
--  Um ângulo pode ser usado para representar a rotação
--  que um objecto efectua. Normalizar um ângulo na gama [0..360)
--  consiste, intuitivamente, em extrair a orientação do
--  objecto que resulta da aplicação de uma rotação. Por exemplo, é verdade que:
--
-- prop> normalizaAngulo 360 = 0
-- prop> normalizaAngulo 390 = 30
-- prop> normalizaAngulo 720 = 0
-- prop> normalizaAngulo (-30) = 330
normalizaAngulo :: Angulo -> Angulo
normalizaAngulo x 
                    | x > 360 = normalizaAngulo (x - 360)
                    | x < 0 = normalizaAngulo (x + 360)
                    | otherwise = x

-- ** Funções sobre listas.

-- | Devolve o elemento num dado índice de uma lista.
--
-- __Sugestão:__ Não use a função (!!) :: [a] -> Int -> a :-)
encontraIndiceLista :: Int -> [a] -> a
encontraIndiceLista 0 (h:t) = h
encontraIndiceLista n (h:t) = encontraIndiceLista (n-1) t

-- | Modifica um elemento num dado índice.
--
-- __NB:__ Devolve a própria lista se o elemento não existir.
atualizaIndiceLista :: Int -> a -> [a] -> [a]
atualizaIndiceLista 0 n (h:t) = (n:t)
atualizaIndiceLista i n (h:t) = h : (atualizaIndiceLista (i-1) n t)

-- ** Funções sobre matrizes.

-- | Devolve o elemento numa dada 'Posicao' de uma 'Matriz'.
encontraPosicaoMatriz :: PosicaoMatriz -> Matriz a -> a
encontraPosicaoMatriz (0,c) [[x],[y]] = encontraIndiceLista c [x]
encontraPosicaoMatriz (l,0) [[x],[y]] = encontraIndiceLista 0 (encontraIndiceLista l [[x],[y]])
encontraPosicaoMatriz (l,c) a = let r = encontraIndiceLista 
                                in r c (r l a)

-- | Modifica um elemento numa dada 'Posicao'
--
-- __NB:__ Devolve a própria 'Matriz' se o elemento não existir.
atualizaPosicaoMatriz :: PosicaoMatriz -> a -> Matriz a -> Matriz a
atualizaPosicaoMatriz (a,b) n [] = []
atualizaPosicaoMatriz (0,c) n (h:t) = (atualizaIndiceLista c n h) : t
atualizaPosicaoMatriz (l,c) n (h:t) = h : (atualizaPosicaoMatriz (l-1,c) n t)