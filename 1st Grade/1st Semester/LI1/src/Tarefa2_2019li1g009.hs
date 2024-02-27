-- | Este módulo define funções comuns da Tarefa 2 do trabalho prático.
module Tarefa2_2019li1g009 where

import LI11920
import Tarefa0_2019li1g009
import Tarefa1_2019li1g009

-- * Testes

-- | Testes unitários da Tarefa 2.
--
-- Cada teste é um triplo (/identificador do 'Jogador'/,/'Jogada' a efetuar/,/'Estado' anterior/).
testesT2 :: [(Int,Jogada,Estado)]
testesT2 = [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t]
    where a = (1,(Movimenta B),(Estado (gera 2 4 1) [(Jogador 1 2 0 2 (Morto (1))),(Jogador 0 1 3 2 (Chao True))]))
          b = (2,(Movimenta B),(Estado (gera 3 5 2) [(Jogador 1 (2.5) 3 3 (Chao True)),(Jogador 2 2 3 4 (Chao True)),(Jogador 0 (0.5) 6 1 (Ar 2 3 4))]))
          c = (0,(Movimenta B),(Estado (gera 2 7 3) [(Jogador 1 2 3 2 (Chao False)),(Jogador 0 1 0 2 (Morto (0.6)))]))
          d = (1,(Movimenta C),(Estado (gera 2 9 4) [(Jogador 0 2 0 2 (Morto (1))),(Jogador 1 7 3 2 (Chao True))]))
          e = (2,(Movimenta C),(Estado (gera 3 5 5) [(Jogador 1 (2.5) 0 3 (Morto (0))),(Jogador 2 2 3 2 (Chao True)),(Jogador 0 (0.5) 6 1 (Ar 2 3 4))]))
          f = (0,(Movimenta C),(Estado (gera 2 4 6) [(Jogador 1 2 3 2 (Chao False)),(Jogador 0 0 0 8 (Morto (0.6)))]))
          g = (0,(Movimenta D),(Estado (gera 1 7 7) [(Jogador 0 (2.7) 3 2 (Ar 10 10 5))]))
          h = (1,(Movimenta D),(Estado (gera 2 6 3) [(Jogador 0 (5.1) 3 2 (Ar 10 10 5)),(Jogador 0 0 0 8 (Morto (0.6)))]))
          i = (1,(Movimenta D),(Estado (gera 2 9 0) [(Jogador 0 (8.3) 0 2 (Morto (0.6))),(Jogador 1 0 4 8 (Ar 10 (-80) 5))]))
          j = (0,(Movimenta E),(Estado (gera 3 7 9) [(Jogador 0 (1.2) 3 2 (Ar 10 (-80) 5)),(Jogador 1 0 0 8 (Morto (0.6))),(Jogador 2 (6.2) 4 1 (Chao True))]))
          k = (0,(Movimenta E),(Estado (gera 1 6 0) [(Jogador 0 (2.6) 3 2 (Ar 10 10 5))]))
          l = (1,(Movimenta E),(Estado (gera 2 2 2) [(Jogador 0 (1.2) 0 2 (Morto (0.2))),(Jogador 1 0 4 8 (Ar 20 (77) 6))]))
          m = (0,(Dispara),(Estado (gera 1 6 0) [(Jogador 0 (2.7) 3 2 (Ar 10 (-80) 5))]))
          n = (1,(Dispara),(Estado (gera 2 2 5) [(Jogador 1 (1.9) 0 1 (Morto (1))),(Jogador 0 0 3 0 (Chao True))]))
          o = (2,(Dispara),(Estado (gera 3 3 4) [(Jogador 1 (2.5) 9 4 (Ar 3 2 1)),(Jogador 0 1 3 2 (Chao True)),(Jogador 1 (2.5) 3 2 (Chao True))]))
          p = (1,(Dispara),(Estado (gera 2 2 4) [(Jogador 0 (1.9) 4 8 (Chao False)),(Jogador 0 1 3 2 (Chao True))]))
          q = (0,(Acelera),(Estado (gera 2 4 9) [(Jogador 1 (3.1) 0 6 (Morto (0.3))),(Jogador 0 1 3 2 (Chao True))]))
          r = (1,(Acelera),(Estado (gera 2 4 3) [(Jogador 0 (2.5) 0 7 (Morto (1))),(Jogador 0 1 3 2 (Chao True))]))
          s = (2,(Desacelera),(Estado (gera 3 6 2) [(Jogador 2 (2.5) 3 2 (Chao False)),(Jogador 0 1 3 2 (Chao True)),(Jogador 0 (5.3) 3 2 (Chao True))]))
          t = (1,(Desacelera),(Estado (gera 2 2 4) [(Jogador 1 (1.5) 0 2 (Morto (0.4))),(Jogador 0 1 3 2 (Chao True))]))

-- | Função que altera a peça, quando o jogador dispara.
alteraPeca :: Peca -- ^ Peça anterior
           -> Peca -- ^ Peça atual
alteraPeca (Recta piso x) = Recta Cola x
alteraPeca (Rampa piso x y) = Rampa Cola x y


-- | Função que verifica se o jogador está no Ar.
estaAr :: [Jogador] -- ^ Lista de jogadores
          -> Bool 
estaAr ((Jogador _ _ _ _ (Ar _ _ _)):xs) = True
estaAr ((Jogador _ _ _ _ _):xs) = False
estaAr [] = False


-- | Função que altera o EstadoJogador do Jogador, diminuindo a sua inclinação.
-- Só existe um caso: quando o jogador está no Ar.
movimentaD :: [Jogador] -- ^ Lista de Jogador
           -> [Jogador] -- ^ Lista de Jogador modificada
movimentaD [] = []
movimentaD ((Jogador pj dj vj cj (Ar aj ij gj)):xs)
    | (ij-15)>(-90) = ((Jogador pj dj vj cj (Ar aj (ij-15) gj)):xs)
    | (ij-15)<=(-90) = ((Jogador pj dj vj cj (Ar aj (-90) gj)):xs)


-- | Função que faz o mesmo que a movimentaD.
-- Só existe um caso, quando o jogador está no Ar.
-- Contudo, esta função aumenta a inclinação do jogador.
movimentaE :: [Jogador] -- ^ Lista de Jogadores
           -> [Jogador] -- ^ Lista de Jogadores Modificada
movimentaE [] = []
movimentaE ((Jogador pj dj vj cj (Ar aj ij gj)):xs)
    | ij>90 = movimentaE ((Jogador pj dj vj cj (Ar aj (ij-360) gj)):xs)
    | (ij+15)<=(90) = ((Jogador pj dj vj cj (Ar aj (ij+15) gj)):xs)
    | (ij+15)>=(90) = ((Jogador pj dj vj cj (Ar aj (90) gj)):xs)
   

-- | Função que verifica se o jogador está no Chao.
estaChao :: Int -- ^ Identificador do Jogador
         -> [Jogador] -- ^ Lista de Jogadores
         -> Bool
estaChao j ((Jogador _ _ _ _ (Chao _)):xs)
    | j==0 = True
    | otherwise = (estaChao (j-1) xs)
estaChao j ((Jogador _ _ _ _ _):xs)
 | j==0 = False
 | otherwise = (estaChao (j-1) xs)
estaChao _ [] = False

-- | Função que altera a pista de um determinado jogador, diminuindo-a em uma unidade.
mixTudoC :: Int -- ^ Identificador do Jogador
        -> Mapa  
        -> [Jogador] -- ^ Lista de Jogadores
        -> [Jogador] -- ^ Lista de Jogadores modificada
mixTudoC j m [] = []
mixTudoC j m ((Jogador pj dj vj cj ej):xs)
    | j==0 && pj==0 = ((Jogador pj dj vj cj ej):xs)
    | j==0 && pj>0 && (sod dA == True) = ((Jogador (pj-1) dj vj cj ej):xs)
    | j==0 && pj>0 && (sod dA == False) && (qa)<(qpe) = ((Jogador pj dj vj cj (Morto 1.0)):xs)
    | j==0 && pj>0 && (sod dA == False) && (qa)>(qpe) = ((Jogador (pj-1) dj vj cj (Ar (qa) (inc (oe)) 0)):xs)
    | otherwise = ((Jogador pj dj vj cj ej):(mixTudoC (j-1) m xs))

   where dA = difA j m ((Jogador pj dj vj cj ej):xs)
         qa = (qalturaj (ondeestas j m ((Jogador pj dj vj cj ej):xs)) dj)
         oe = ondeestas j m ((Jogador pj dj vj cj ej):xs)
         qpe = (qalturaj (qpeca (pj-1) (dj) m) dj)

-- | Função que verifica se o jogador pode ir para a pista anterior ou posterior
sod :: Double -- ^ Diferença entre alturas entre as duas peças 
    -> Bool
sod x | x<=(0.2) && x>=(-0.2) = True
      | otherwise = False

-- | Função que calcula a diferença de alturas.
difA :: Int -- ^ Identificador do Jogador
     -> Mapa 
     -> [Jogador] -- ^ Lista de Jogadores
     -> Double -- diferença de alturas final e inicial
difA j m [] = 0
difA j m ((Jogador pj dj vj cj ej):xs) 
    | j==0 = (qa-qac)
    | otherwise = difA (j-1) m (xs)

 where qa = qalturaj (ondeestas j m ((Jogador pj dj vj cj ej):xs)) dj
       qac = qalturaj (qpeca (pj-1) (dj) m) dj


-- | Função que determina a altura do jogador
qalturaj :: Peca -> Double -> Double
qalturaj (Recta piso x) _= (fromIntegral x)
qalturaj (Rampa piso x y) dj
    | dj==0 = fromIntegral (x)
    | dj>1 = qalturaj (Rampa piso x y) (dj-1)
    | dj<=1 && dj>0 = (dj* (abs ((fromIntegral y)-(fromIntegral x))))


-- | Função que determina a peça onde o jogador está.
ondeestas :: Int -- ^ Identificador do Jogador
          -> Mapa 
          -> [Jogador] -- ^ Lista de Jogadores
          -> Peca -- ^ peça onde o Jogador se encontra
ondeestas j ((x:t):ts) ((Jogador pj dj vj cj ej):xs)
    | j==0 && pj==0 && dj>=0 && dj<=1 = x
    | j==0 && pj==0 && dj>1 = ondeestas j ((t):ts) ((Jogador pj (dj-1) vj cj ej):xs)
    | j==0 && pj>0 = ondeestas j (ts) ((Jogador (pj-1) dj vj cj ej):xs)
    | otherwise = ondeestas (j-1) ((x:t):ts) (xs)   


-- | Função que determina a peça da pista acima da do jogador.
qpeca :: Int -- ^ Número da Pista
      -> Double -- ^ Distância do Jogador ao início da pista
      -> Mapa 
      -> Peca -- ^ Peça acima do Jogador
qpeca _ _ [] = (Recta Terra 0)
qpeca p dj ((x:xs):t)
    | p==0 && dj<1 = x
    | p==0 && dj>=1 = qpeca p (dj-1) ((xs):t)
    | otherwise = qpeca (p-1) dj t


-- | Função que calcula a inclinação.
inc :: Peca -- ^ Peça recebida
    -> Double -- ^ inclinação do jogador
inc (Recta piso x) = 0
inc (Rampa piso x y) = (180* (atan ((fromIntegral y)-(fromIntegral x))))/(pi)


-- | Função que forma a Lista de Jogadores através da diferença de alturas
mixTudoB :: Int -- ^ Identificador do Jogador
         -> Mapa 
         -> [Jogador] -- ^ Lista de Jogadores
         -> [Jogador] -- ^ Lista de Jogadores modificada
mixTudoB _ [] _ = []
mixTudoB _ _ [] = []
mixTudoB j m ((Jogador pj dj vj cj ej):xs)
    | j==0 && pj==((findnpistas m)-1) = ((Jogador pj dj vj cj ej):xs)
    | j==0 && pj<((findnpistas m)-1) && (sod dB == True) = ((Jogador (pj+1) dj vj cj ej):xs)
    | j==0 && pj<((findnpistas m)-1) && (sod dB == False) && (qa)<(qpe) = res1
    | j==0 && pj<((findnpistas m)-1) && (sod dB == False) && (qa)>=(qpe) = res2
    | otherwise = ((Jogador pj dj vj cj ej):(mixTudoB (j-1) m xs))

   where dB = difB j m ((Jogador pj dj vj cj ej):xs)
         qa = (qalturaj (ondeestas j m ((Jogador pj dj vj cj ej):xs)) dj)
         oe = ondeestas j m ((Jogador pj dj vj cj ej):xs)
         qpe = (qalturaj (qpeca (pj+1) (dj) m) dj)
         res1 = ((Jogador (pj) dj vj cj (Morto 1.0)):xs)
         res2 = ((Jogador (pj+1) dj vj cj (Ar (qalturaj (oe) dj) (inc (oe)) 0)):xs)

-- | Função que calcula a diferença de alturas.
difB :: Int -- ^ Identificador do Jogador
     -> Mapa 
     -> [Jogador] -- ^ Lista de Jogadores
     -> Double -- diferença de alturas final e inicial
difB j m [] = 0
difB j m ((Jogador pj dj vj cj ej):xs) 
    | j==0 = (qa-qac)
    | otherwise = difB (j-1) m (xs)

 where qa = qalturaj (ondeestas j m ((Jogador pj dj vj cj ej):xs)) dj
       qac = qalturaj (qpeca (pj+1) (dj) m) dj

-- | Função que encontra o número de pistas num mapa.
findnpistas :: Mapa 
            -> Int -- ^ Número de pistas do mapa
findnpistas [] = 0
findnpistas ((x:xs):t) = 1+(findnpistas t)


-- | Função que altera o estado do jogador de Chao False para True
chaoTrue :: Int -- ^ identificador do Jogador
         -> [Jogador] -- ^ Lista de Jogadores
         -> [Jogador] -- ^ Lista de Jogadores modificada
chaoTrue x [] = []
chaoTrue x ((Jogador pj dj vj cj ej):xs)
    | x==0 = ((Jogador pj dj vj cj (Chao True)):xs)
    | otherwise = ((Jogador pj dj vj cj ej):(chaoTrue (x-1) (xs)))


-- | Função que altera o estado do jogador de Chao True para False
chaoFalse :: Int -- ^ identificador do Jogador
          -> [Jogador] -- ^ Lista de Jogadores
          -> [Jogador] -- ^ Lista de Jogadores modificada
chaoFalse x [] = []
chaoFalse x ((Jogador pj dj vj cj ej):xs)
    | x==0 =((Jogador pj dj vj cj (Chao False)):xs)
    | otherwise = ((Jogador pj dj vj cj ej):(chaoFalse (x-1) (xs)))


-- | Função que diminui o valor do colaJogador, de acordo com algumas condições
alteraCola :: Int -- ^ identificador do Jogador
           -> [Jogador] -- ^ Lista de Jogadores
           -> [Jogador] -- ^ Lista de Jogadores modificada
alteraCola x ((Jogador pj dj vj cj ej):xs)
    | x==0 && cj>0 && dj>=(1.0) = ((Jogador pj dj vj (cj-1) ej):xs)
    | x==0 && cj>0 && dj<(1.0) = ((Jogador pj dj vj cj ej):xs)
    | x==0 && cj==0 = ((Jogador pj dj vj cj ej):xs)
    | otherwise = ((Jogador pj dj vj cj ej):(alteraCola (x-1) xs))


-- | Função que altera a Peça numa determinada pista de um mapa
alteraMapa :: Int -- ^ Identificador do Jogador 
           -> [Jogador] -- ^ Lista de Jogadores
           -> Mapa 
           -> Mapa -- ^ Mapa alterado
alteraMapa _ [] m = m
alteraMapa _ _ [] = []
alteraMapa j ((Jogador pj dj vj cj ej):js) ((x:xs):t)
    | j==0 && cj>0 && (floor dj)>=1 = atualizaPosicaoMatriz ((pj),(floor (dj-1))) (alteraPeca (encontraPosicaoMatriz ((pj),((floor dj)-1)) ((x:xs):t))) ((x:xs):t)
    | j==0 && (floor dj)<1 = ((x:xs):t)
    | j==0 && cj==0 = ((x:xs):t)
    | otherwise = (alteraMapa (j-1) (js) ((x:xs):t))


-- * Funções principais da Tarefa 2.

-- | Função que efetua uma jogada.
jogada :: Int -- ^ O identificador do 'Jogador' que efetua a jogada.
       -> Jogada -- ^ A 'Jogada' a efetuar.
       -> Estado -- ^ O 'Estado' anterior.
       -> Estado -- ^ O 'Estado' resultante após o jogador efetuar a jogada.
jogada _ _ (Estado m []) = (Estado m [])
jogada x (Movimenta D) (Estado m (j:js)) =
    if x==0
    then if estaAr (j:js) == True
         then (Estado m (movimentaD (j:js)))
         else (Estado m (j:js))
    else if estaAr (js) == True
         then (Estado m (j:(movimentaD js)))
         else (Estado m (j:js))
jogada x (Movimenta E) (Estado m (j:js)) =
    if x==0 
    then if estaAr (j:js) == True
         then (Estado m (movimentaE (j:js)))
         else (Estado m (j:js))
    else if estaAr (js) == True
         then (Estado m (j:(movimentaE js)))
         else (Estado m (j:js))
jogada x (Movimenta C) (Estado m ((Jogador pj dj vj cj ej):xs)) =
    if estaChao x ((Jogador pj dj vj cj ej):xs)==True
    then (Estado m (mixTudoC x m ((Jogador pj dj vj cj ej):xs)))
    else (Estado m ((Jogador pj dj vj cj ej):xs))
jogada x (Movimenta B) (Estado m ((Jogador pj dj vj cj ej):xs)) =
    if estaChao x ((Jogador pj dj vj cj ej):xs)==True
    then (Estado m (mixTudoB x m ((Jogador pj dj vj cj ej):xs)))
    else (Estado m ((Jogador pj dj vj cj ej):xs))
jogada x (Acelera) (Estado m ((Jogador pj dj vj cj ej):xs)) =
    if estaChao x ((Jogador pj dj vj cj ej):xs)==True
    then (Estado m (chaoTrue x ((Jogador pj dj vj cj ej):xs)))
    else (Estado m ((Jogador pj dj vj cj ej):xs))
jogada x (Desacelera) (Estado m ((Jogador pj dj vj cj ej):xs)) =
    if estaChao x ((Jogador pj dj vj cj ej):xs)==True
    then (Estado m (chaoFalse x ((Jogador pj dj vj cj ej):xs)))
    else (Estado m ((Jogador pj dj vj cj ej):xs))
jogada x (Dispara) (Estado m ((Jogador pj dj vj cj ej):xs)) =
    if estaChao x ((Jogador pj dj vj cj ej):xs)==True
    then Estado (alteraMapa x ((Jogador pj dj vj cj ej):xs) m) (alteraCola x ((Jogador pj dj vj cj ej):xs))
    else (Estado m ((Jogador pj dj vj cj ej):xs))

-- * jogada x D : diminui 15 graus a inclinação do jogador.
-- / Primeiramente verifica se x==1, depois se está no Ar, e, se tudo estiver correto, altera.

-- * jogada x E : diminui 15 graus a inclinação do jogador.
-- / Primeiramente verifica se x==1, depois se está no Ar, e, se tudo estiver correto, altera.

-- * jogada x C : jogador sobe de pista.
-- / Primeiramente verifica se x==1, depois se está no chão e 
-- / se o módulo das diferenças de altura é menor que 0.2. Se tudo estiver correto, muda de pista.

-- * jogada x B : jogador sobe de pista.
-- / Primeiramente verifica se x==1, depois se está no chão e 
-- / se o módulo das diferenças de altura é menor que 0.2. Se tudo estiver correto, muda de pista.

-- m=mapa ; pj=pistaJogador ; dj=distanciaJogador ; 
-- vj=velocidadeJogador ; cj=colajogador ; ej=estadoJogador ;
-- aj=alturajogador ; ij=inclinaçãojogador ; gj=gravidadeJogador ;
-- tj=timeoutJogador ; acj=aceleraJogador.