import System.IO
import System.Random
import Data.Char
import Data.List

-- import System.IO -> putStrLn ; getLine ; getChar
-- import System.Random -> randomIO ; randomRIO

-- randomIO :: Random a => IO a
-- randomRIO :: Random a => (a,a) -> IO a

bingo :: IO ()
bingo = geraN []

geraN :: [Int] -> IO ()
geraN l 
    | length l == 90 = putStrLn "Fim"
    | otherwise = do n <- randomRIO (1,90)
                     if (elem n l) then geraN l
                     else do x <- getChar
                             putStrLn (show n)
                             geraN (n:l)

geraChave :: IO [Int]
geraChave = do n1 <- randomRIO (0,9)
               n2 <- randomRIO (0,9)
               n3 <- randomRIO (0,9)
               n4 <- randomRIO (0,9)
               return [n1,n2,n3,n4]

left :: IO [Int]
left = do putStrLn "Aposta:"
          s <- getLine
          if (valida s) then return (converte s)
          else do putStrLn "Dados Inválidos"
                  left

valida :: String -> Bool 
valida s = (all isDigit s) && (length s == 4)

converte :: String -> [Int]
converte s = map digitToInt s

certos :: [Int] -> [Int] -> Int
certos [] [] = 0
certos (x:xs) (y:ys)
    | x==y = 1+ (certos xs ys)
    | x/=y = certos xs ys

certosp :: [Int] -> [Int] -> [Int] -> Int
certosp ap ch lc = length (intersect (ap\\lc) (ch\\lc))

mastermind :: IO ()
mastermind = do putStrLn "Início do jogo"
                ch <- geraChave;
                putStrLn (show ch)
                ap <- left;
                let lc = certos ap ch
                putStrLn (" NumCertosPosCertas " ++ (show (length lc)))
                putStrLn (" NumErradosPosErrados " ++ (show (certosp ap ch lc)))
                
--joga :: IO ()
--joga = do ap <- left
--          let lc = certos ap ch
--           in do putStrLn " yayayaya "
--                 putStrLn " yayayayayaya "
--                if (length lc) == y then putStrLn "Fim"
--                else joga ch

data Aposta = Ap [Int] (Int,Int) deriving Show

--validar :: Aposta -> Bool
--validar (Ap l (x,y)) = (length l)==5 &&
