-- | Este módulo define funções comuns da Tarefa 3 do trabalho prático.
module Tarefa3_2019li1g009 where

import LI11920
import Tarefa0_2019li1g009
import Tarefa1_2019li1g009
import Tarefa2_2019li1g009

-- * Testes

-- | Testes unitários da Tarefa 3.
--
-- Cada teste é um 'Mapa'.
testesT3 :: [Mapa]
testesT3 = [a,b,c,d,e,f,g,h,i,j]
 where a = (gera 3 4 2)
       b = (gera 1 2 1)
       c = (gera 10 10 10)
       d = (gera 2 3 7)
       e = (gera 7 8 9)
       f = (gera 1 2 3)
       g = (gera 7 6 5)
       h = (gera 8 2 4)
       i = (gera 2 7 0)
       j = (gera 2 5 5)


-- | Função que divide o mapa em pistas.
padrao :: Mapa 
       -> Int -- ^ Número da Pista.
       -> [([Peca],Int)] -- ^ Pista com o número da pista.
padrao [] a = []
padrao ((x:xs):t) a = (((x:xs),a)):(padrao t (a+1))
                      

-- | Função que transforma as peças em instruções.
pecInstr :: [([Peca],Int)] -- ^ Pista com o número da pista.
            -> [Instrucao]
pecInstr [] = []
pecInstr (((x:xs),p):a) = (pecInstrAux ((x:xs),p))++(pecInstr a)


-- | Função que transforma uma peça numa instrução.
pecInstrAux :: ([Peca],Int) -- ^ Pista com o número da pista.
            -> [Instrucao]
pecInstrAux ([],_) = []
pecInstrAux (((Recta piso a):xs),p) = (Anda [p] piso):(pecInstrAux ((xs),p))
pecInstrAux (((Rampa piso a b):xs),p) | a>b = (Desce [p] piso (a-b)):(pecInstrAux ((xs),p))
                                      | otherwise = (Sobe [p] piso (b-a)):(pecInstrAux ((xs),p))


-- * Funções principais da Tarefa 3.

-- | Desconstrói um 'Mapa' numa sequência de 'Instrucoes'.
--
-- __NB:__ Uma solução correcta deve retornar uma sequência de 'Instrucoes' tal que, para qualquer mapa válido 'm', executar as instruções '(desconstroi m)' produza o mesmo mapa 'm'.
--
-- __NB:__ Uma boa solução deve representar o 'Mapa' dado no mínimo número de 'Instrucoes', de acordo com a função 'tamanhoInstrucoes'.
desconstroi :: Mapa -> Instrucoes
desconstroi m = (pecInstr (padrao (map (drop 1) m) 0))


----------------------------------------------------------Relatório-----------------------------------------------------------
-- * Introdução
--    Naturalmente, perante o desenvolvimento do jogo, torna-se necessária a construção do mapa e da perceção de como esta
-- funciona. Depois, desconstruir esse mapa vai permitir que, ao longo do desenvolvimento do jogo, se possa gerar o mapa,
-- construí-lo e desconstruí-lo, com o avanço do(s) jogador(es) na(s) pista(s), de forma automática. 

-- * Objetivo:
--    Esta tarefa pretende determinar o modo como se converte um mapa gerado num outro mapa. No nosso caso, dado um mapa
-- (conjunto de peças), geram-se as instruções necessárias para o bulldozers, que constroem o mapa em questão, com o avanço na
-- pista.

-- * Raciocínio
--    Primeiramente, a principal ideia foi transformar cada uma das peças de modo a formar uma instrução, todavia, para isso,
-- tornou-se necessário dividir o mapa num conjunto de peças, passíveis de serem convertidas em instruções. Assim sendo,
-- pensamos depois no modo como dando este conjunto de peças e uma lista de instruções poderíamos desconstruir um mapa. 

-- * Funções
--    De uma forma sucinta, esta tarefa é composta por quatro funções, sendo que cada uma delas tem objetivos concretos. A 
-- primeira função tem o objetivo de dividir o mapa em pistas, mais propriamente, recebendo uma mapa e um inteiro (número da 
-- pista), retorna cada uma das pistas com o seu número em questão. Então, o que resulta é uma lista cujo primeiro componente
-- é a pista (lista de peças) e o segundo componente é o número da pista correspondente.
-- A função seguinte está definida à custa de uma função auxiliar que transforma os elementos da lista anterior numa 
-- instrução. Note-se, no entanto, que não é recebida uma lista, mas sim, os seus elementos, como que um par. Então, definimos
-- as instruções para cada um dos casos, quer se tratasse de uma recta, quer se tratasse de uma rampa. Quanto ao primeiro 
-- caso, caso o conjunto de elementos seja do tipo recta, então, o que é retornado é uma instrução que obriga o bulldozer a 
-- andar para a frente considerando um certo piso.
-- No outro caso, é definido para os dois tipos de rampas, a que sobe e a que desce. Se se tratar de uma rampa que desce, 
-- formar-se-á uma instrução que transmite tal informação aos bulldozers; o mesmo caso se trate de uma rampa que desce.
--    A última função, desconstrói o mapa no sentido em que, primeiro, destrói as peças, ou seja, pega nas pistas e separa em
-- cada peça, de seguida, forma as instruções.

-- * Conclusão
--    Esta tarefa permitiu, acima de tudo, aprimorar o nosso raciocínio sobre o modo como um mapa se constrói e desconstrói,
-- de tal modo que, através de instruções, se compreendeu melhor o processo. Em suma, foi possível compreender que cada função
-- ficava encarregue de determinada função: destruir o mapa recebido, peça a peça, formar o par ([peça], número da pista), 
-- a respetiva lista e retornar a Instrução interpretada pelo bulldozer. 
