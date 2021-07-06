module FICHA8 where


-------------------------------------------------------------Exercício 1-------------------------------------------------------------

data Frac = F Integer Integer

normaliza :: Frac -> Frac
normaliza (F 0 _) = F 0 1
normaliza (F n d) = 
    let k = mdc (abs n) (abs d)
        s = if (n*d)>0 then -1 else 1
    in F (s*(div (abs n) k)) (div (abs d) k)


mdc :: Integer -> Integer -> Integer
mdc x y
    | x==y = x
    | x>y = mdc (x-y) y
    | x<y = mdc x (y-x)


instance Eq Frac where
    --(==) :: Frac -> Frac -> Bool
    (==) (F m1 d1) (F m2 d2) = (m1*d2)==(m2*d1) 


instance Ord Frac where
   -- compare :: Frac -> Frac -> Ordering
    compare (F m1 d1) (F m2 d2)
     | (m1*d2) == (m2*d1) = EQ
     | (m1*d2) > (m2*d1) = LT
     | otherwise = GT


instance Show Frac where
    show (F a b) = (show a)++"/"++(show b)


instance  Num Frac where
    (+) (F m1 d1) (F m2 d2) = normaliza (F ((m1*d2)+(m2*d1)) (d1*d2))
    (-) (F m1 d1) (F m2 d2) = normaliza (F ((m1*d2)-(m2*d1)) (d1*d2))
    (*) (F m1 d1) (F m2 d2) = normaliza (F (m1*m2) (d1*d2))
    negate (F n d) = normaliza (F ((-1)*n) d)
    abs (F n d) = (F (abs n) (abs d))
    signum (F n d) 
         | n*d==0 = (F 0 1)
         | n*d<0 = (F (-1) 1)
         | otherwise = (F 1 1)
    fromInteger n = F n 1

maiores :: Frac -> [Frac] -> [Frac]
maiores f l = filter (\f1 -> f1>(2*f)) l

-------------------------------------------------------------Exercício 2-------------------------------------------------------------

data Exp a = Const a
 | Simetrico (Exp a)
 | Mais (Exp a) (Exp a)
 | Menos (Exp a) (Exp a)
 | Mult (Exp a) (Exp a)

instance Show (Exp a) where
    show e = infixa e

instance (Eq a, Num a) => Eq (Exp a) where
   (==) e1 e2 = (calcula e1)==(calcula e2) 

instance Num a => Num (Exp a) where
    (+) e1 e2 = (Const ((calcula e1)+(calcula e2)))
    (-) e1 e2 = (Const ((calcula e1)-(calcula e2)))
    (*) e1 e2 = (Const ((calcula e1)*(calcula e2)))
    negate e = (Const (negate (calcula e)))
    abs e = (Const (abs (calcula e)))
    signum e = (Const (signum (calcula e)))
    fromInteger n = (Const (fromInteger n))

calcula :: Num a => Exp a -> a
calcula (Const x) = x
calcula (Simetrico x) = (calcula ((-1)*x))
calcula (Mais x y) = (calcula x) + (calcula y)
calcula (Menos x y) = (calcula x) - (calcula y)
calcula (Mult x y) = (calcula x) * (calcula y)


infixa :: Exp a -> String
infixa (Const x) = "x"
infixa (Simetrico x) = "(-"++(infixa x)++")"
infixa (Mais x y) = "("++(infixa x)++"+"++(infixa y)++")"
infixa (Menos x y) = "("++(infixa x)++"-"++(infixa y)++")"
infixa (Mult x y) = "("++(infixa x)++"*"++(infixa y)++")"

{--
-------------------------------------------------------------Exercício 3-------------------------------------------------------------
data Movimento = Cred Float | Deb Float
data Datas = D Int Int Int -- DIA,MÊS,ANO
data Extracto = Ext Float [(Datas,String,Movimento)]


instance Ord Datas where
    compare (D d1 m1 a1) (D d2 m2 a2)
     | (a1,m1,d1)==(a2,m2,d2) = EQ
     | (a1,m1,d1)>(a2,m2,d2) = GT
     | otherwise = LT

instance Show Datas where
	show (D d m a) = show a ++ "/" ++ show m ++ "/" ++ show d

instance Show Extracto where
	show (Ext vi l) =
    let l1 = ordena (Ext vi l)
    in (header vi)++(lista l)++(saldo vi l)

ordena :: Extracto -> Extracto
ordena (Ext vi l) = 
    let l0 = sortOn (\(x,y,z)->x) l
    in Ext vi l0

header :: Float -> String
header v = "Saldo Anterior:" ++ (show v) ++ "\n" ++ (replicate 80 '-') ++ "\n" ++ " Desta .... Débito \n" ++ (replicate 80 '-') ++ "\n"
--}
