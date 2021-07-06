module Ficha7 where

data ExpInt = Const Int
 | Simetrico ExpInt
 | Mais ExpInt ExpInt
 | Menos ExpInt ExpInt
 | Mult ExpInt ExpInt


calcula :: ExpInt -> Int
calcula (Const x) = x
calcula (Simetrico x) = (-1)*(calcula x)
calcula (Mais x y) = (calcula x) + (calcula y)
calcula (Menos x y) = (calcula x) - (calcula y)
calcula (Mult x y) = (calcula x) * (calcula y)


infixa :: ExpInt -> String
infixa (Const x) = show x
infixa (Simetrico x) = "(-"++(infixa x)++")"
infixa (Mais x y) = "("++(infixa x)++"+"++(infixa y)++")"
infixa (Menos x y) = "("++(infixa x)++"-"++(infixa y)++")"
infixa (Mult x y) = "("++(infixa x)++"*"++(infixa y)++")"



data RTree a = R a [RTree a] deriving Show

soma :: Num a => RTree a -> a
soma (R x []) = x
soma (R x l) = x+ (sum (map soma l))


altura :: RTree a -> Int
altura (R x []) = 1
altura (R x l) = 1+(maximum (map altura l))


prune :: Int -> RTree a -> RTree a
prune 0 (R x _) = R x []
prune _ (R x []) = R x []
prune n (R x l) = R x (map (prune (n-1)) l)


mirror :: RTree a -> RTree a
mirror (R x l) = R x (reverse (map mirror l))


postorder :: RTree a -> [a]
postorder (R x l) = (concat (map postorder l))++[x]



data BTree a = Empty | Node a (BTree a) (BTree a) deriving Show
data LTree a = Tip a | Fork (LTree a) (LTree a) deriving Show

ltSum :: Num a => LTree a -> a
ltSum (Tip x) = 1
ltSum (Fork e d) = (ltSum e)+(ltSum d)


listaLT :: LTree a -> [a]
listaLT (Tip x) = [x]
listaLT (Fork e d) = (listaLT e)++(listaLT d)

ltHeight :: LTree a -> Int
ltHeight (Tip x) = 1
ltHeight (Fork e d) = 1+ (max (ltHeight e) (ltHeight d))



data FTree a b = Leaf b | No a (FTree a b) (FTree a b) deriving Show

splitFTree :: FTree a b -> (BTree a, LTree b)
splitFTree (Leaf b) = (Empty,Tip b)
splitFTree (No a e d) =
    let (bte,lfe) = splitFTree e
        (btd,lfd) = splitFTree d
    in (Node a bte btd, Fork lfe lfd)


joinTrees :: BTree a -> LTree b -> Maybe (FTree a b)
joinTrees _ (Tip x) = Just (Leaf x)
joinTrees Empty _ = Nothing
joinTrees (Node x e d) (Fork e1 d1) = 
    let te = joinTrees e e1
        td = joinTrees d d1
    in case te of
       Nothing -> Nothing
       Just (fte) -> case td of
                    Nothing -> Nothing
                    Just (ftd) -> Just (No x fte ftd)