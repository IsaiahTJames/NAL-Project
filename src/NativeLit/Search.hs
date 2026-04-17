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

-- | Convert a character to lowercase
toLowerChar :: Char -> Char
toLowerChar c
  | c >= 'A' && c <= 'Z' = toEnum (fromEnum c + 32)
  | otherwise             = c

-- | Convert a string to lowercase
toLowerStr :: String -> String
toLowerStr = map toLowerChar

-- | Find an author by name (partial match, case insensitive)
authorByName :: String -> [Author]
authorByName name =
  filter (\a -> toLowerStr name `isSubstring` toLowerStr (authorName a)) authors
  where
    isSubstring needle haystack = any (isPrefixOf needle) (tails haystack)
    isPrefixOf [] _          = True
    isPrefixOf _ []          = False
    isPrefixOf (x:xs) (y:ys) = x == y && isPrefixOf xs ys
    tails []         = [[]]
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

-- | Sort authors by last name
sortByName :: [Author] -> [Author]
sortByName [] = []
sortByName (x:xs) =
  sortByName smaller ++ [x] ++ sortByName bigger
  where
    smaller = filter (\a -> authorName a <= authorName x) xs
    bigger  = filter (\a -> authorName a > authorName x) xs

-- | Sort works by publication year (oldest first)
sortByYear :: [Work] -> [Work]
sortByYear [] = []
sortByYear (x:xs) =
  sortByYear smaller ++ [x] ++ sortByYear bigger
  where
    smaller = filter (\w -> yearPub w <= yearPub x) xs
    bigger  = filter (\w -> yearPub w > yearPub x) xs

-- | Sort works by publication year (newest first)
sortByYearDesc :: [Work] -> [Work]
sortByYearDesc = reverse . sortByYear

-- | Find works by tribe AND genre combined
worksByTribeAndGenre :: Tribe -> Genre -> [Work]
worksByTribeAndGenre t g =
  let tribeAuthors = authorsByTribe t
      tribeAuthorIds = map authorId tribeAuthors
  in filter (\w -> genre w == g && authorRef w `elem` tribeAuthorIds) works

-- | Return authors sorted by number of works (most first)
mostProlificAuthors :: [Author]
mostProlificAuthors = sortByCount authors
  where
    workCount a = length (worksByAuthor (authorId a))
    sortByCount [] = []
    sortByCount (x:xs) =
      sortByCount bigger ++ [x] ++ sortByCount smaller
      where
        bigger  = filter (\a -> workCount a >  workCount x) xs
        smaller = filter (\a -> workCount a <= workCount x) xs

-- | Find works in a year range with their authors
worksWithAuthors :: Int -> Int -> [(Work, Maybe Author)]
worksWithAuthors start end =
  map (\w -> (w, authorOfWork w)) (worksByEra start end)