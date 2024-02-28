-- | Este módulo define funções comuns da Tarefa 5 do trabalho prático.
module Main where

import LI11920
import Tarefa1_2019li1g009
import Tarefa6_2019li1g009
import Graphics.Gloss
import Graphics.Gloss.Juicy
import Graphics.Gloss.Interface.Pure.Game
import Graphics.Gloss.Data.Bitmap


type EstadoGloss = (Float,Float,[Picture])

-- | Função principal da Tarefa 5.
--
-- __NB:__ Esta Tarefa é completamente livre. Deve utilizar a biblioteca <http://hackage.haskell.org/package/gloss gloss> para animar o jogo, e reutilizar __de forma completa__ as funções das tarefas anteriores.

-- ! Estado inicial Gloss
estadoInicial :: [Picture] -- ^ Lista de imagens 
              -> EstadoGloss
estadoInicial z = (0,0,z)


-- | Mapa gerado
mapagerado1 :: Mapa
mapagerado1 = (gera 5 5 1)


-- | Função que transforma o Estado Gloss numa imagem.
desenhaEstado :: EstadoGloss -- ^ Estado Gloss recebido.
              -> Picture
desenhaEstado (x,y,[]) = Blank
desenhaEstado (x,y,[principal,z,ret,rer,rel,rec,reb,rat,rar,ral,rac,rab,raat,raar,raal,raac,raab]) = Pictures ([principal,z]++mapaa)
 where mapaa = (drawMapa mapagerado1 x y [ret,rer,rel,rec,reb,rat,rar,ral,rac,rab,raat,raar,raal,raac,raab])


-- | Função que altera o Estado Gloss com algum toque de uma tecla.
reageEvento :: Event -- ^ Tecla recebida.
            -> EstadoGloss -- ^ Antigo Estado Gloss.
            -> EstadoGloss -- ^ Novo Estado Gloss.
reageEvento (EventKey (SpecialKey KeyUp)    Down _ _) (x,y,z) = (x,y+10,z)
reageEvento (EventKey (SpecialKey KeyDown)  Down _ _) (x,y,z) = (x,y-10,z)
reageEvento (EventKey (SpecialKey KeyLeft)  Down _ _) (x,y,z) = (x-10,y,z)
reageEvento (EventKey (SpecialKey KeyRight) Down _ _) (x,y,z) = (x+10,y,z)
reageEvento _ e = e 


-- | Função que divide um mapa em peças.
drawMapa :: Mapa -- ^ Mapa recebido.
         -> Float -- ^ Coordenada x.
         -> Float -- ^ Coordenada y.
         -> [Picture] -- ^ Lista de imagens.
         -> [Picture] -- ^ Mapa gerado por imagens.
drawMapa [] _ _ _ = []
drawMapa ((h:hs):t) x y im@[ret,rer,rel,rec,reb,rat,rar,ral,rac,rab,raat,raar,raal,raac,raab] = 
    (drawLinha (h:hs) x y im)++
    (drawMapa t x (y-13) im)


-- | Função que divide a pista em peças.
drawLinha :: [Peca] -- ^ Pista recebida.
         -> Float -- ^ Coordenada x.
         -> Float -- ^ Coordenada y.
         -> [Picture] -- ^ Lista de imagens.
         -> [Picture] -- ^ Mapa gerado por imagens.
drawLinha [] _ _ _ = []
drawLinha (h:t) x y im@[ret,rer,rel,rec,reb,rat,rar,ral,rac,rab,raat,raar,raal,raac,raab] = 
    (drawPeca h x y im) ++ 
    (drawLinha t x (y+13) im)


-- | Função que desenha peças.
drawPeca :: Peca -- ^ Peça recebida.
         -> Float -- ^ Coordenada x.
         -> Float -- ^ Coordenada y.
         -> [Picture] -- ^ Lista de imagens.
         -> [Picture] -- ^ Mapa gerado por imagens.
drawPeca p x y [ret,rer,rel,rec,reb,rat,rar,ral,rac,rab,raat,raar,raal,raac,raab]
    | encontraMapaAux2 p (Recta Terra 0) = [Translate (x+100) (y+100) ret]
    | encontraMapaAux2 p (Recta Relva 0) = [Translate (x+100) (y+100) rer]
    | encontraMapaAux2 p (Recta Lama 0) = [Translate (x+100) (y+100) rel]
    | encontraMapaAux2 p (Recta Cola 0) = [Translate (x+100) (y+100) rec]
    | encontraMapaAux2 p (Recta Boost 0) = [Translate (x+100) (y+100) reb]
    | encontraMapaAux2 p (Recta Terra 2) = [Translate (x+100) (y+100) ret]
    | encontraMapaAux2 p (Recta Relva 2) = [Translate (x+100) (y+100) rer]
    | encontraMapaAux2 p (Recta Lama 2) = [Translate (x+100) (y+100) rel]
    | encontraMapaAux2 p (Recta Cola 2) = [Translate (x+100) (y+100) rec]
    | encontraMapaAux2 p (Recta Boost 2) = [Translate (x+100) (y+100) reb]
    | encontraMapaAux2 p (Recta Terra 1) = [Translate (x+100) (y+100) ret]
    | encontraMapaAux2 p (Recta Relva 1) = [Translate (x+100) (y+100) rer]
    | encontraMapaAux2 p (Recta Lama 1) = [Translate (x+100) (y+100) rel]
    | encontraMapaAux2 p (Recta Cola 1) = [Translate (x+100) (y+100) rec]
    | encontraMapaAux2 p (Recta Boost 1) = [Translate (x+100) (y+100) reb]
    | encontraMapaAux2 p (Recta Terra 2) = [Translate (x+100) (y+100) ret]
    | encontraMapaAux2 p (Recta Relva 2) = [Translate (x+100) (y+100) rer]
    | encontraMapaAux2 p (Recta Lama 2) = [Translate (x+100) (y+100) rel]
    | encontraMapaAux2 p (Recta Cola 2) = [Translate (x+100) (y+100) rec]
    | encontraMapaAux2 p (Recta Boost 2) = [Translate (x+100) (y+100) reb]
    | encontraMapaAux2 p (Rampa Terra 0 1) = [Translate (x+100) (y+100) rat]
    | encontraMapaAux2 p (Rampa Relva 0 1) = [Translate (x+100) (y+100) rar]
    | encontraMapaAux2 p (Rampa Lama 0 1) = [Translate (x+100) (y+100) ral]
    | encontraMapaAux2 p (Rampa Cola 0 1) = [Translate (x+100) (y+100) rac]
    | encontraMapaAux2 p (Rampa Boost 0 1) = [Translate (x+100) (y+100) rab]
    | encontraMapaAux2 p (Rampa Terra 1 2) = [Translate (x+100) (y+100) rat]
    | encontraMapaAux2 p (Rampa Relva 1 2) = [Translate (x+100) (y+100) rar]
    | encontraMapaAux2 p (Rampa Lama 1 2) = [Translate (x+100) (y+100) ral]
    | encontraMapaAux2 p (Rampa Cola 1 2) = [Translate (x+100) (y+100) rac]
    | encontraMapaAux2 p (Rampa Boost 1 2) = [Translate (x+100) (y+100) rab] 
    | encontraMapaAux2 p (Rampa Terra 0 2) = [Translate (x+100) (y+100) raat]
    | encontraMapaAux2 p (Rampa Relva 0 2) = [Translate (x+100) (y+100) raar]
    | encontraMapaAux2 p (Rampa Lama 0 2) = [Translate (x+100) (y+100) raal]
    | encontraMapaAux2 p (Rampa Cola 0 2) = [Translate (x+100) (y+100) raac]
    | encontraMapaAux2 p (Rampa Boost 0 2) = [Translate (x+100) (y+100) raab]
    | encontraMapaAux2 p (Rampa Terra 1 0) = [Rotate (180) (Translate (x+100) (y) rat)]
    | encontraMapaAux2 p (Rampa Relva 1 0) = [Rotate (180) (Translate (x+100) (y) rar)]
    | encontraMapaAux2 p (Rampa Lama 1 0) = [Rotate (180) (Translate (x+100) (y) ral)]
    | encontraMapaAux2 p (Rampa Cola 1 0) = [Rotate (180) (Translate (x+100) (y) rac)]
    | encontraMapaAux2 p (Rampa Boost 1 0) = [Rotate (180) (Translate (x+100) (y) rab)]
    | encontraMapaAux2 p (Rampa Terra 2 1) = [Rotate (180) (Translate (x+100) (y) rat)]
    | encontraMapaAux2 p (Rampa Relva 2 1) = [Rotate (180) (Translate (x+100) (y) rar)]
    | encontraMapaAux2 p (Rampa Lama 2 1) = [Rotate (180) (Translate (x+100) (y) ral)]
    | encontraMapaAux2 p (Rampa Cola 2 1) = [Rotate (180) (Translate (x+100) (y) rac)]
    | encontraMapaAux2 p (Rampa Boost 2 1) = [Rotate (180) (Translate (x+100) (y) rab)] 
    | encontraMapaAux2 p (Rampa Terra 2 0) = [Rotate (180) (Translate (x+100) (y) raat)]
    | encontraMapaAux2 p (Rampa Relva 2 0) = [Rotate (180) (Translate (x+100) (y) raar)]
    | encontraMapaAux2 p (Rampa Lama 2 0) = [Rotate (180) (Translate (x+100) (y) raal)]
    | encontraMapaAux2 p (Rampa Cola 2 0) = [Rotate (180) (Translate (x+100) (y) raac)]
    | encontraMapaAux2 p (Rampa Boost 2 0) = [Rotate (180) (Translate (x+100) (y) raab)]


-- | Função que altera o EstadoGloss com o tempo
reageTempo :: Float -> EstadoGloss -> EstadoGloss
reageTempo n (x,y,p) = (x+1,y+1,p)


-- | Frame rate.
fr :: Int
fr = 60


-- | Tela.
dm :: Display
dm = InWindow "ExciteBike Haskell" (1200,999) (10,10) 


-- | Função que dá o jogo.
main :: IO ()
main = do Just principal <- loadJuicy "Imagens/Background.png"
          Just z <- loadJuicy "Imagens/Mota.png"
          Just ret <- loadJuicy "Imagens/Pecas/TERRA.png"
          Just rer <- loadJuicy "Imagens/Pecas/RELVA.png"
          Just rel <- loadJuicy "Imagens/Pecas/LAMA.png"
          Just rec <- loadJuicy "Imagens/Pecas/COLA.png"
          Just reb <- loadJuicy "Imagens/Pecas/BOOST.png"
          Just rat <- loadJuicy "Imagens/Pecas/TERRA 0 1.png"
          Just rar <- loadJuicy "Imagens/Pecas/RELVA 0 1.png"
          Just ral <- loadJuicy "Imagens/Pecas/LAMA 0 1.png"
          Just rac <- loadJuicy "Imagens/Pecas/COLA 0 1.png"
          Just rab <- loadJuicy "Imagens/Pecas/BOOST 0 1.png"
          Just raat <- loadJuicy "Imagens/Pecas/TERRA 0 2.png"
          Just raar <- loadJuicy "Imagens/Pecas/RELVA 0 2.png"
          Just raal <- loadJuicy "Imagens/Pecas/LAMA 0 2.png"
          Just raac <- loadJuicy "Imagens/Pecas/COLA 0 2.png"
          Just raab <- loadJuicy "Imagens/Pecas/BOOST 0 2.png"
          play dm         -- janela onde irá correr o jogo
               (greyN 0.5)    -- côr do fundo da janela
               fr              -- frame rate
               (estadoInicial [principal,(scale 0.15 0.15 z),ret,rer,rel,rec,reb,rat,rar,ral,rac,rab,raat,raar,raal,raac,raab]) -- estado inicial
               desenhaEstado   -- desenha o estado do jogo
               reageEvento     -- reage a um evento
               reageTempo      -- reage ao passar do tempo



----------------------------------------------------------Relatório----------------------------------------------------------
-- * Introdução
--      Esta tarefa prendeu-se com a interpretção gráfica do que acontece neste jogo. Para além disso trata o modo como o 
--jogador interage com o próprio jogo e a forma como cada estrutura surge no ambiente do jogo. 
-- | Objetivo:
--      Construir o ambiente gráfico associado ao nosso jogo, através da criação de funções específicas.

-- * Raciocínio
--      A primeira ideia foi construir o mapa, pensando em construir as diferentes partes e posteriormente associar cada
-- uma delas. Começou-se por uma linha, depois passou-se para o mapa, enquanto um conjunto de várias pistas.

-- * Funções
--      As primeiras funções que devem ser analisadas são as que permitem desenhar algo no ecrâ, nomeadamente, uma linha e 
-- um conjunto de linhas. Assim a função draw linha recebendo uma lista de peças, duas coordenadas e uma lista de imagens
-- retorna uma nova lista de imagens. Sendo que estas, com a função IO poderão ser apresentadas no ecrã do utilizador.
-- O que a função faz é criar uma lista de imagens e alterar a sua ordenada para +13 e assim sucessivamente, criando-se uma
-- linha de imagens. Posteriormente, a funçao drawMapa, através desta função, desenha as vaŕias listas de imagens. Há, 
-- portanto toda uma recursividade também na utilização destas funções,sendo que é a drawPeca que está na base de todas elas.
-- Esta úlrima função, ao receber uma peca, e uma posição (x e y), estabelece uma translação em todas as imagens, ou seja,
-- consoante as peças, dispõe as respetivas imagens.

-- * Conclusão
--      A tarefa foi importante para a perceção do funcionamento do ambiente gráfico do Gloss, sendo que, o grupo notou a
-- importância da perceção do funcionamento de cada função na construção gráfica.
-- Em suma, esta tarefa desenvolvou competências com IO.