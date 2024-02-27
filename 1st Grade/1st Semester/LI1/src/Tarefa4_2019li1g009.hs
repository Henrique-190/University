-- | Este módulo define funções comuns da Tarefa 4 do trabalho prático.
module Tarefa4_2019li1g009 where

import LI11920
import Tarefa0_2019li1g009
import Tarefa1_2019li1g009
import Tarefa2_2019li1g009
import Tarefa3_2019li1g009
import Tarefa6_2019li1g009

-- * Testes
-- | Testes unitários da Tarefa 4.
--
-- Cada teste é um par (/tempo/,/'Mapa'/,/'Jogador'/).
testesT4 :: [(Double,Mapa,Jogador)]
testesT4 = [a,b,c,d,e,f,g,h,i,j]
 where a = ((0.2),(gera 3 3 3),(Jogador 1 (1.5) 4 5 (Chao True)))
       b = ((1),(gera 2 5 7),(Jogador 0 (1.3) 0 7 (Morto (1.0))))
       c = ((0.4),(gera 3 4 6),(Jogador 2 1 0 0 (Morto (1.0))))
       d = ((0.1),(gera 5 6 7),(Jogador 1 4 7 3 (Chao False)))
       e = ((1),(gera 4 6 2),(Jogador 3 4 2 9 (Chao True)))
       f = ((1.9),(gera 10 10 2),(Jogador 6 4 20 9 (Chao True)))
       g = ((0.4),(gera 1 2 1),(Jogador 0 (0.2) 3 0 (Chao True)))
       h = ((0.95),(gera 3 5 1),(Jogador 1 4 3 0 (Chao False)))
       i = ((0.172),(gera 1 7 2),(Jogador 0 (4.3) 6 2 (Chao False)))
       j = ((0.190),(gera 1 9 0),(Jogador 0 (8.1) 5 7 (Chao False)))

-- * Funções principais da Tarefa 4.

-- | Avança o estado de um 'Jogador' um 'passo' em frente, durante um determinado período de tempo.
passo :: Double -- ^ O tempo decorrido.
     -> Mapa    -- ^ O mapa utilizado.
     -> Jogador -- ^ O estado anterior do 'Jogador'.
     -> Jogador -- ^ O estado do 'Jogador' após um 'passo'.
passo t m j = move t m (acelera t m j)


-- | Altera a velocidade de um 'Jogador', durante um determinado período de tempo.
acelera :: Double -- ^ O tempo decorrido.
        -> Mapa    -- ^ O mapa utilizado.
        -> Jogador -- ^ O estado anterior do 'Jogador'.
        -> Jogador -- ^ O estado do 'Jogador' após acelerar.
acelera t m (Jogador pj dj vj cj (Chao b)) = (Jogador pj dj vn cj (Chao b))
    where vn = (velMenChao vj t b (pecajog m ((Jogador pj dj vj cj (Chao b)))))
acelera t m (Jogador pj dj vj cj (Ar aj gj ij)) = (Jogador pj dj (nv) cj (Ar aj (calcGrav gj t) ij))
    where nv = velMenAr vj t
acelera t m (Jogador pj dj vj cj ej) = (Jogador pj dj vj cj ej)


-- | Altera a posição de 'Jogador', durante um determinado período de tempo.
move :: Double -- ^ O tempo decorrido.
     -> Mapa    -- ^ O mapa utilizado.
     -> Jogador -- ^ O estado anterior do 'Jogador'.
     -> Jogador -- ^ O estado do 'Jogador' após se movimentar.
move t m (Jogador pj dj vj cj (Morto tj))
    | (tj-t)>0 = (Jogador pj dj vj cj (Morto (tj-t)))
    | otherwise = (Jogador pj dj 0 cj (Chao False))
move t m (Jogador pj dj vj cj (Chao bj))
    | (vA>=pA) && (incA<=incB) = (Jogador pj (fromIntegral (floor dj)+(fromIntegral 1)) vj cj (Chao bj))
    | (vA>=pA) && (incA>incB) = (Jogador pj (fromIntegral (floor dj)+(fromIntegral 1)) vj cj (Ar a incA 0))
    | otherwise = (Jogador pj vA vj cj (Chao bj))
 where vA = (dj+((t*vj)*(cos(grausRadianos (inc (ondeestas 0 m [(Jogador pj dj vj cj (Chao bj))]))))))
       pA = ((fromIntegral (floor (dj)))+1)
       incA = inc (pecajog m (Jogador pj (dj) vj cj (Chao bj)))
       incB = (inc (pecajog m (Jogador pj (dj+1) vj cj (Chao bj))))
       a = (qalturaj (pecajog m (Jogador pj (dj) vj cj (Chao bj))) (1.0))
{-- move t m (Jogador pj dj vj cj (Ar aj ij gj))
    | intersetam ((cartA),(cartB)) ((cartJ),(somaVetores vel gra)) = if ij-inc(whereu pj dj m)>45 then (Jogador pj dj vj cj (Morto 1.0))
                                                                     else (Jogador pj (dnova) vj cj (Chao True))
    | intersetam ((cartC),(cartD)) ((cartJ),(somaVetores vel gra)) = undefined
    | otherwise = undefined

 
 where cartA = (Cartesiano (fromIntegral (floor dj)) (qalturai (ondeestas 1 m [(Jogador pj dj vj cj (Ar aj ij gj))])))
       cartB = (Cartesiano (fromIntegral ((floor dj)+1)) (qalturaf (ondeestas 1 m [(Jogador pj dj vj cj (Ar aj ij gj))])))
       cartC = (Cartesiano (fromIntegral ((floor dj)+1)) 0)
       cartD = (Cartesiano (fromIntegral ((floor dj)+1)) 1)
       cartJ = (Cartesiano (dj) (aj))
       vpeca = (Polar 1 incA)
       incA = inc (pecajog m (Jogador pj (dj) vj cj (Chao True)))
       vel = Polar (vj*t) ij
       gra = Polar (gj*t) (-90)
       dnova = primeiro (intersecao ((cartA),(cartB)) ((cartJ),(somaVetores vel gra)))--}



-- | Função que determina a altura inicial da peça do Jogador.
qalturai :: Peca -- ^ Peça recebida
         -> Double -- ^ Altura
qalturai (Recta piso x) = (fromIntegral x)
qalturai (Rampa piso x _) = (fromIntegral x)


-- | Função que determina a altura final da peça do Jogador.
qalturaf :: Peca-- ^ Peça recebida
         -> Double -- ^ Altura
qalturaf (Recta piso x) = (fromIntegral x)
qalturaf (Rampa piso _ y) = (fromIntegral y)


-- | Função que determina a peça onde o jogador está.
pecajog :: Mapa 
        -> Jogador -- ^ Jogador
        -> Peca -- ^ peça onde o Jogador se encontra
pecajog ((x:t):ts) ((Jogador pj dj vj cj ej))
    | pj==0 && dj>=0 && dj<=1 = x
    | pj==0 && dj>1 = pecajog ((t):ts) (Jogador pj (dj-1) vj cj ej)
    | pj>0 = pecajog (ts) (Jogador (pj-1) dj vj cj ej)


-- | Altera o ângulo de graus para radianos
grausRadianos :: Double -- ^ Ângulo em graus
              -> Double -- ^ Ângulo em radianos
grausRadianos x = (x*180)/pi


-- | Calcula a Velocidade no Chão.
calcVelChao :: Double -- ^ Velocidade anterior do Jogador
            -> Bool -- ^ Aceleração do Jogador
            -> Double -- ^ Tempo
            -> Peca -- ^ Onde o Jogador está
            -> Double -- ^ Velocidade atual do Jogador
calcVelChao vj (True) t p = vj + (accelMota - (selAtrito p) * vj) * t 
 where accelMota = if (vj < 2) then 1 else 0   
calcVelChao vj (False) t p = vj + (0 - (selAtrito p)* vj) * t
 

-- | Verifica se a velocidade é menor, igual ou maior que zero.
velMenChao :: Double -- ^ Velocidade anterior do Jogador 
           -> Double -- ^ Tempo
           -> Bool -- ^ Aceleração do Jogador
           -> Peca -- ^ Onde o Jogador está
           -> Double -- ^ Velocidade atual do Jogador
velMenChao vj t b p
 | (calcVelChao vj b t p) >= 0 = (calcVelChao vj b t p)
 | otherwise = 0


-- | Verifica se a velocidade é menor, igual ou maior que zero.
velMenAr :: Double -- ^ Velocidade anterior do Jogador 
         -> Double -- ^ Tempo
         -> Double -- ^ Velocidade atual do Jogador
velMenAr vj t
    | calcVelAr vj t >=0 = (calcVelAr vj t)
    | otherwise = 0


-- | Calcula a Velocidade no Ar.
calcVelAr :: Double -- ^ Velocidade anterior do Jogador 
          -> Double -- ^ Tempo
          -> Double -- ^ Velocidade atual do Jogador
calcVelAr vj t = vj - ((0.125) * vj * t)


-- | Calcula a Gravidade do Jogador, quando ele está no Ar.
calcGrav :: Double -- ^ Gravidade anterior do Jogador 
         -> Double -- ^ Tempo
         -> Double -- ^ Gravidade atual do Jogador 
calcGrav gj t = gj + t


-- | Função que coloca coloca valores de atrito, de acordo com o piso.
selAtrito :: Peca -- ^ Peça recebida
         -> Double -- ^ Atrito
selAtrito (Recta piso x) = atrito piso
selAtrito (Rampa piso x y) = atrito piso


-- | Função que dá o atrito
atrito :: Piso -- ^ Piso onde está o jogador.
       -> Double -- ^ Atrito
atrito piso = case piso of Terra -> (0.25)
                           Relva -> (0.75)
                           Lama -> (1.50)
                           Boost -> (-0.50)
                           Cola -> (3.00)
                          