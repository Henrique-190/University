module Ficha4 where

-- Exercício 2
-- a)
--[2^x | x<-[0..6]]

--b)
--[x | x <-[1..5], y<-[1..5], x+y=6]

-- c)
--[y | [1..x] | x<-[1..5]]

-- d)
--[[1 | y<-[1..x]] | x<-[1..5]]

-- e)
--[fact x | x<-[1..5]]
--[product [y | y<-[1..x]] | x<-[1..5]]


-- Exercício 7
maxSumInit :: (Num a, Ord a) => [a] -> a
maxSumInit [] = 0
maxSumInit (x:xs) = aux x x xs
  where aux m s [] = m
        aux m s (x:xs) =
         let s' = s+x
         in if s'>m then aux s' s' xs
         else aux m s' xs


-- Exercício 8
fib :: Int -> Int
fib 0 = 0
fib x =aux 0 1 x
   where aux n1 n2 1 = n2
         aux n1 n2 n = aux n2 (n1+n2)(n-1)