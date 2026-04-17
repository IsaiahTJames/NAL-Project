module NativeLit.Search where

import NativeLit.Types
import NativeLit.Database

-- | Find all works by a specific author ID
worksByAuthor :: Int -> [Work]
worksByAuthor aid = filter (\w -> authorRef w == aid) works

-- | Find all works of a specific genre
worksByGenre :: Genre -> [Work]
worksByGenre g = filter (\w -> genre w == g) works

-- | Find all authors from a specific tribe
authorsByTribe :: Tribe -> [Author]
authorsByTribe t = filter (\a -> tribe a == t) authors

-- | Find an author by name (partial match, case sensitive)
authorByName :: String -> [Author]
authorByName name = filter (\a -> name `isSubstring` authorName a) authors
  where
    isSubstring needle haystack = any (isPrefixOf needle) (tails haystack)
    isPrefixOf [] _ = True
    isPrefixOf _ [] = False
    isPrefixOf (x:xs) (y:ys) = x == y && isPrefixOf xs ys
    tails [] = [[]]
    tails xs@(_:rest) = xs : tails rest

-- | Find works published in a given year range
worksByEra :: Int -> Int -> [Work]
worksByEra startYear endYear =
  filter (\w -> yearPub w >= startYear && yearPub w <= endYear) works

-- | Look up the author of a given work
authorOfWork :: Work -> Maybe Author
authorOfWork w =
  case filter (\a -> authorId a == authorRef w) authors of
    []    -> Nothing
    (a:_) -> Just a