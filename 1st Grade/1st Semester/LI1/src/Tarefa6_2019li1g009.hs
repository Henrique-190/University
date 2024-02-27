-- | Este módulo define funções comuns da Tarefa 6 do trabalho prático.
module Tarefa6_2019li1g009 where

import LI11920
import Data.List
import Tarefa0_2019li1g009
import Tarefa1_2019li1g009
import Tarefa2_2019li1g009
import Tarefa3_2019li1g009

 
-- * Funções principais da Tarefa 6.

-- | Define um ro'bot' capaz de jogar autonomamente o jogo.
bot :: Int          -- ^ O identificador do 'Jogador' associado ao ro'bot'.
    -> Estado       -- ^ O 'Estado' para o qual o ro'bot' deve tomar uma decisão.
    -> Maybe Jogada -- ^ Uma possível 'Jogada' a efetuar pelo ro'bot'.
bot x (Estado mapa jogadores) 
    | estaMorto x jogadores = Nothing
    | estAr x jogadores =
        if (inclinacao x jogadores)-(inc (whereu parteA dP mapa)) > (15)
        then Just (Movimenta D)
        else if (inclinacao x jogadores)-(inc (whereu parteA dP mapa)) < (-15)
             then Just (Movimenta E)
             else Nothing
    | estaChaoFALSE x jogadores = Just Acelera
    | otherwise =
        if distancia (qualjogador x jogadores) == 0
        then Just Acelera
        else if (parteA-parteB)==0
             then if colaatras (ondeestas x mapa jogadores)
                  then Just Acelera
                  else if dispara x jogadores
                       then Just Dispara
                       else Just Acelera
             else if segundamelhor parteA (parteA-parteB) (distancia parte) mapa
                  then Just (jogar (parteA) (parteD))
                  else Just Acelera

 where parte = (qualjogador x jogadores)
       parteA = pista parte
       dP = (distancia parte)
       parteB = melhorPeca dP mapa
       fPe = (findPerrada (parteA) (parteA-parteB) dP mapa)
       parteC = melhorPeca dP fPe
       eP = encontraPista parteC fPe
       parteD = encontraMapa eP mapa


-- | Função que verifica que se o estadojogador é Chao False.
estaChaoFALSE :: Int -- ^ Identificador do bot.
              -> [Jogador] -- ^ Lista de jogadores.
              -> Bool
estaChaoFALSE x (Jogador _ _ _ _ (Chao False):xs) 
    | x==0 = True
    | otherwise = estaChaoFALSE (x-1) xs
estaChaoFALSE a (x:xs)
 | a==0 = False
 | otherwise = estaChaoFALSE (a-1) (x:xs)


-- | Função que encontra uma pista num mapa.
encontraPista :: Int -- ^ Número da pista.
              -> Mapa -- ^ Mapa recebido.
              -> Pista
encontraPista n [] = []
encontraPista n ((x:xs):t)
    | n==0 = (x:xs)
    | otherwise = encontraPista (n-1) t


-- | Função que encontra uma pista, num determinado mapa.
encontraMapa :: Pista -- ^ Mapa novo.
             -> Mapa -- ^ Mapa inicial.
             -> Int
encontraMapa p [] = 0
encontraMapa (x:xs) ((y:ys):z) 
    | encontraMapaAux (x:xs) (y:ys) = 0
    | otherwise = 1+(encontraMapa (x:xs) z)


-- | Função que recebe duas pistas e compara-as.
encontraMapaAux :: Pista -- ^ Primeira pista.
                -> Pista -- ^ Segunda pista.
                -> Bool
encontraMapaAux [] [] = True
encontraMapaAux (x:xs) (y:ys)
    | encontraMapaAux2 x y = encontraMapaAux xs ys
    | otherwise = False


-- | Função que compara duas peças e verifica se são iguais.
encontraMapaAux2 :: Peca -- ^ Primeira peça.
                 -> Peca -- ^ Segunda peça.
                 -> Bool
encontraMapaAux2 (Rampa pisoA x y) (Rampa pisoB w z)
    | pisoA==pisoB && x==w && y==z = True
    | otherwise = False
encontraMapaAux2 (Recta pisoA x) (Recta pisoB y)
    | pisoA==pisoB && x==y = True
    | otherwise = False
encontraMapaAux2 _ _ = False


-- | Função que descobre se o piso da peça é Cola.
colaatras :: Peca -- ^ Peça dada.
          -> Bool
colaatras (Recta piso _)
    | piso == Cola = True
    | otherwise = False
colaatras (Rampa piso _ _)
    | piso == Cola = True
    | otherwise = False


-- | Função que se divide em várias funções, de modo a descobrir se o bot pode disparar.
dispara :: Int -- ^ Identificador do bot
        -> [Jogador] -- ^ Lista de jogadores
        -> Bool
dispara x (h:t) = verifica pJ dJ cJ (eliminaJog x (h:t))
 
 where pJ = (pista (qualjogador x (h:t)))
       dJ = (distancia (qualjogador x (h:t)))
       cJ = (cola (qualjogador x (h:t)))


-- | Função que verifica se o bot tem algum adversário atrás de si.
verifica :: Int -- ^ Pista do bot
         -> Double -- ^ Distância do bot
         -> Int -- ^ Cola do bot
         -> [Jogador] -- ^ Lista de jogadores
         -> Bool
verifica pj dj cj [] = False
verifica pj dj cj (x:xs)
    | (dist dj (x:xs)) && (pist pj (x:xs)) && cj>0 = True
    | otherwise = False


-- | Função que verifica se o bot possui cola
cola :: Jogador -- ^ Bot
     -> Int
cola (Jogador _ _ _ cj _) = cj


-- | Função que verifica se algum adversário tem o bot tem um adversário com diferença de distãncia igual ou inferior a 1 à sua.
dist :: Double -- ^ Distância do bot
     -> [Jogador] -- ^ Lista de Jogadores
     -> Bool
dist d [] = False
dist d ((Jogador _ dj _ _ _):xs) 
    | d-dj<=1 = True
    | otherwise = dist d xs
 

-- | Função que verifica se algum adversário está na mesma pista que o bot.
pist :: Int -- ^ Pista do bot
     -> [Jogador] -- ^ Lista de Jogadores
     -> Bool
pist p [] = False
pist p ((Jogador pj _ _ _ _):xs)
    | p==pj = True
    | otherwise = pist p xs


-- | Função que elimina o bot da lista de jogadores, para a função "verifica".
eliminaJog :: Int -- ^ Identificador do bot
           -> [Jogador] -- ^ Lista de jogadores
           -> [Jogador] -- ^ Nova lista de jogadores
eliminaJog x [] = []
eliminaJog x (h:t) 
    | x==0 = t
    | otherwise = h:(eliminaJog (x-1) t)


-- | Função que determina se existe uma segunda melhor opção.
segundamelhor :: Int -- ^ Pista do bot
              -> Int -- ^ Subtração da pista do jogador com a pista com a melhor peça
              -> Double -- ^ Distância do bot
              -> Mapa
              -> Bool
segundamelhor pj x dj m 
    | (altpos pj x dj m) == False = segundamelhor pj (pj-parte1) dj newmapa
    | otherwise = True
 
 where parte1 = (melhorPeca dj newmapa)
       newmapa = (findPerrada pj x dj m)


-- | Função que encontra as pistas que não servem para comparar, para o bot ir para a melhor peça.
findPerrada :: Int -- ^ Pista do bot
            -> Int -- ^ Subtração da pista do jogador com a pista com a melhor peça
            -> Double -- ^ Distância do bot
            -> Mapa -- ^ Mapa inicial
            -> Mapa -- ^ Novo mapa
findPerrada _ _ _ [] = []
findPerrada pj x dj m
    | x==0 = m
    | x<(-1) = if altpos pj (x+1) dj m == True
               then findPerrada pj (x+1+1) dj m
               else eliminaPista [(pj-x)..((findnpistas m)-1)] m
    | x==(-1) = if altpos pj x dj m == False
                then eliminaPista [(pj+1)..((findnpistas m)-1)] m
                else m
    | x==1 = if altpos pj x dj m == False
             then eliminaPista [0..(pj-1)] m
             else m
    | x>1 = if altpos pj (x-1) dj m == False
            then findPerrada (pj-1-1) (x-1-1) dj m
            else eliminaPista [1..(pj-x)] m


-- | Função que elimina as pistas que não servem para o bot se deslocar.
eliminaPista :: [Int] -- ^ Lista de números que representam as pistas que vão ser eliminadas
             -> Mapa -- ^ Mapa inicial
             -> Mapa -- ^ Novo mapa
eliminaPista [] mapa = mapa
eliminaPista _ [] = []
eliminaPista (x:xs) ((h:t):ts) 
    | x==0 = (eliminaPista (subt (xs)) ts)
    | otherwise = (h:t):(eliminaPista (subt (x:xs)) ts) 


-- | Função que subtrai uma unidade à lista das pistas que vão ser eliminadas.
subt :: [Int] -- ^ Lista de números que representam as pistas que vão ser eliminadas
     -> [Int] -- ^ Nova lista de números que representam as pistas que vão ser eliminadas
subt (x:xs) = map (subtract 1) (x:xs)


-- | Função que compara as alturas das peças, de modo a saber se o bot consegue deslocar-se.
altpos :: Int -- ^ Pista do bot
       -> Int -- ^ Subtração da pista do jogador com a pista com a melhor peça
       -> Double -- ^ Distância do bot
       -> Mapa 
       -> Bool
altpos pj x dj m  
    | x==0 = True
    | x==1 = if difAlt1 >= (-0.2)
             then True else False
    | x==(-1) = if difALt2 >= (-0.2)
                then True else False
    | x>1 = if difAlt1 >= (-0.2)
            then altpos (pj-1) (x-1) dj m else False
    | x<(-1) = if difALt2 >= (-0.2)
               then altpos (pj+1) (x+1) dj m else False
 
 where difAlt1 = (difAlt11-difAlt111)
       difALt2 = (difAlt22-difAlt222)
       difAlt11 =(altu (whereu pj dj m)) (dj-(fromIntegral (floor dj)))
       difAlt111 = (altu (whereu (pj-1) dj m) (dj-(fromIntegral (floor dj))))
       difAlt22 = (altu (whereu pj dj m)) (dj-(fromIntegral (floor dj)))
       difAlt222 = (altu (whereu (pj+1) dj m) (dj-(fromIntegral (floor dj))))


-- | Função que define a altura do bot, de acordo com a sua distância e peça.
altu :: Peca -- ^ Peça definida
     -> Double -- ^ Distância do bot
     -> Double
altu (Recta piso x) _ = (fromIntegral x)
altu (Rampa piso x y) dj
    | dj == 0 = (fromIntegral x)
    | dj == 1 = (fromIntegral y)
    | x>y = ((fromIntegral x)-(fromIntegral y))*(1.0-dj)+(fromIntegral y)
    | otherwise = ((fromIntegral y)-(fromIntegral x))*(dj)+(fromIntegral x)


-- | Função que diz em que peça é que o bot está.
whereu :: Int -- ^ Pista do bot
       -> Double -- ^ Distância do bot
       -> Mapa 
       -> Peca
whereu pj dj [] = (Recta Terra 0)
whereu pj dj ((x:xs):t)
    | pj==0 && dj<1 = x
    | pj==0 && dj>=1 = whereu pj (dj-1) ((xs):t)
    | otherwise = whereu (pj-1) dj t


-- | Função que dá a distância do bot.
distancia :: Jogador -- ^ Bot 
          -> Double
distancia (Jogador _ dj _ _ _) = dj


-- | Função que dá a pista em que o bot se localiza.
pista :: Jogador -- ^ Bot
      -> Int
pista (Jogador pj _ _ _ _) = pj


-- | Função que dá um valor.
-- Se for menor que zero, o bot tem de ir para a pista abaixo;
-- Se for igual a zero, o bot está na pista com a melhor peça;
-- Se for maior que zero, então o bot tem de ir para a pista acima.
jogar :: Int -- ^ Pista do bot 
      -> Int -- ^ Pista com melhor peça
      -> Jogada
jogar pj x 
    | (pj-x)<0 = (Movimenta B)
    | (pj-x)==0 = (Acelera)
    | otherwise = (Movimenta C)


-- | Função que dá a inclinação do bot.
inclinacao :: Int -- ^ Identificador do Jogador 
           -> [Jogador] -- ^ Lista de Jogadores
           -> Double -- ^ Inclinação
inclinacao x ((Jogador _ _ _ _ (Ar _ ij _)):xs)
    | x==0 = ij
    | otherwise = inclinacao (x-1) xs


-- | FUnção que verifica se o bot está no Ar.
estAr :: Int -> [Jogador] -> Bool
estAr x ((Jogador _ _ _ _ (Ar _ _ _)):xs)
    | x==0 = True
    | otherwise = estAr (x-1) xs
estAr x (h:t)
    | x==0 = False
    | otherwise = estAr (x-1) t
estAr x [] = False


-- | Função que verifica se o bot está Morto.
estaMorto :: Int -- ^ Identificador do bot
          -> [Jogador] -- ^ Lista de jogadores
          -> Bool 
estaMorto x ((Jogador _ _ _ _ (Morto _)):xs)
    | x==0 = True
    | otherwise = estaMorto (x-1) xs
estaMorto x ((Jogador _ _ _ _ _):xs)
    | x==0 = False
    | otherwise = estaMorto (x-1) xs
estaMorto x [] = False


-- | Função que dá o bot, de acordo com o identificador.
qualjogador :: Int -- ^ Identificador do bot 
            -> [Jogador] -- ^ Lista de jogadores
            -> Jogador -- ^ Bot
qualjogador x (h:t) = (h:t) !! x


-- | Função que encontra a melhor peça para o bot.
-- Escolhe a peça da pista acima, da própria pista ou da pista abaixo.
melhorPeca :: Double -- ^ Distância do bot
           -> Mapa
           -> Int  -- ^ Pista para onde ele se tem de movimentar
melhorPeca dj ((x:xs):t) = head (elemIndices (minimum atribvalores) atribvalores)
 where truemapa = map (drop (floor dj)) ((x:xs):t)
       firstpecas = map head truemapa
       atribvalores = map valo firstpecas


-- | Função que atribui valores a cada piso.
valo :: Peca -- ^ Peça que recebe
     -> Int -- ^ Valor dado
valo (Recta piso _)
    | piso == Terra = 1
    | piso == Relva = 2
    | piso == Lama = 3
    | piso == Boost = 0
    | otherwise = 4
valo (Rampa piso _ _)
    | piso == Terra = 1
    | piso == Relva = 2
    | piso == Lama = 3
    | piso == Boost = 0
    | otherwise = 4


----------------------------------------------------------Relatório----------------------------------------------------------
-- * Introdução sobre o bot e objetivos deste.
-- O bot é uma espécie de inteligência artificial que, neste caso, percorre um mapa e acaba quando este chegar à ultima peça.
-- O objetivo é fazer com que o bot seja o mais rápido a percorrer a pista, indo para as peças com menos atrito e colocando 
-- uma cola, se tivesse algum adversário atrás.

-- * Raciocínio
-- 		Primeiro, pensamos em como seria um bot muito competitivo. Dividimos em 4 casos: quando o bot está morto, quando está
-- no ar ou no chão com a aceleração verdadeira ou falsa. Caso estivesse no chão com aceleração True, ele teria que ver as 
-- peças que tinha "à sua frente" e viajar até à peça com o melhor piso, caso pudesse. Se não pudesse, por causa da diferença 
-- de alturas, ele teria que fazer outra opção que não a primeira. Depois, estando na melhor pista, iria verificar se tinha 
-- algum adversário atrás de si. Caso tivesse e caso possuísse pelo menos uma cola, deitava uma cola. Se estas condições não 
-- se verificassem, ele apenas acelerava. No caso da aceleração ser False, então ele apenas acelerava.
-- 		Quando o bot está morto, não pode fazer nada.
-- 		Quando o bot está no ar, o bot pode diminuir a sua inclinação, para que ele desça mais rapidamente e consiga escolher  
-- melhor peça, então, o bot inclina-se sempre até ter uma inclinação cuja subtração com a inclinação da peça esteja entre 
-- uma (-5) e (-15). Assim, o bot não se inclina demasiado, de modo a que ele morra.

-- * Funções
-- 		Primeiro colocamos funções para verificarem em que estado estão. Depois, no caso Morto, introduzimos logo a resposta:
-- Nothing. No Ar, colocamos funções que verificavam a inclinação da peça e do bot e, se o resultado da subtração destas 
-- inclinações fosse maior do que (-5), o resultado era Just (Movimenta D). Se o resultado fosse menor do que (-15), a jogada
-- era Just (Movimenta E).
-- 		Em relação ao caso Chao, se a melhor peça estivesse na mesma pista onde o bot estava, o bot verificava se tinha algum 
-- adversário estava na mesma pista, a uma distância inferior a 1, e se tinha o número de colas suficientes. Caso estas duas
-- condições se verificassem, o bot disparava uma cola (Just Dispara). Caso contrário, o resultado era Just Acelera.
-- Para descobrir a melhor peça, establecemos funções que davam valores às peças, dependendo do piso (quanto mais atrito a 
-- peça tinha, maior o valor). Depois, descobrimos o menor valor e a posição deste na lista de todos os valores. A posição
-- dava a melhor pista. Após isto, comparamos a altura entre cada pista que o bot precisava de passar até estar na melhor 
-- pista. Caso a diferença de alturas entre duas pistas adjacentes fosse igual ou inferior a 0.2, o bot conseguia passar, e
-- depois comparava as pistas que faltam, até chegar a melhor pista. Se conseguisse passar para a pista com a melhor peça,
-- o resultado era Just (Movimenta B) ou Just (Movimenta C), dependendo se a melhor pista estava acima ou abaixo da pista onde
-- o bot se localiza. Se o bot não conseguisse ir para a melhor pista, o bot elimina todas as pistas que a diferença de
-- alturas fosse superior a 0.2 e faz uma nova escolha, com um novo mapa, sem as ditas pistas. O processo acaba até ele
-- descobrir a melhor pista, obedecendo a todas as condições.

-- * Conclusão
-- 		Nesta tarefa conseguimos perceber o quão difícil é construir um bot que obedeça a várias condições, sem que consiga 
-- errar. Contudo, gostamos desta tarefa porque foi uma forma de desenvolver as nossas capacidades de programação de 
-- inteligência artificial.
-- Em suma, este bot tem várias funções. Se ele estiver morto, não faz nada. Se ele estiver no Ar, ele movimenta-se de modo a
-- que o resultado da subtração das inclinações da peça e dele mesmo estiver entre (-5) e (-15). Se ele estiver no Chao, ele
-- movimenta-se até estar na melhor peça e, quando ele estiver na melhor peça, dispara cola se tiver um adversário perto de
-- si. Caso não se verificar, ele acelera.
