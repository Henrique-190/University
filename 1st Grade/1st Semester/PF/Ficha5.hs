module Ficha5 where

any' :: (a -> Bool) -> [a] -> Bool
any' f [] = True
any' f (x:xs)
  | f x = True
  | otherwise = any' f xs


all' :: (a-> Bool) -> [a] -> Bool
all' f [] = True
all' f (x:xs)
 | f x = all' f xs
 | not (f x) = False


zipWith' :: (a->b->c) -> [a] -> [b] -> [c]
zipWith' f (x:xs) (y:ys) = ((f x y):(zipWith' f xs ys))
zipWith' _ _ _ = []



takeWhile' :: (a->Bool) -> [a] -> [a]
takeWhile' f [] = []
takeWhile' f (x:xs)
 | f x = x:(takeWhile' f xs)
 | otherwise = []


dropWhile' :: (a->Bool) -> [a] -> [a]
dropWhile' _ [] = []
dropWhile' f (x:xs)
 | f x = dropWhile' f xs
 | otherwise = x:(dropWhile' f xs)



span' :: (a-> Bool) -> [a] -> ([a],[a])
span' f l = (takeWhile f l, dropWhile' f l)

myspan :: (a-> Bool) -> [a] -> ([a],[a])
myspan f l = aux f ([],[]) l
 where aux f (l,r) [] = (l,r)
       aux f (l,r) (x:xs)
        | f x = aux f (l++[x],r) xs
        | otherwise = (l,(x:xs))


deleteBy :: (a -> a -> Bool) -> a -> [a] -> [a]
deleteBy _ _ [] = []
deleteBy f x (y:ys)
 | f x y = ys
 | otherwise = y:(deleteBy f x ys)