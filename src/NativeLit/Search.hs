module NativeLit.Search where

import NativeLit.Types
import NativeLit.Database
import System.Random (randomRIO)

-- | Find all works by a specific author ID
worksByAuthor :: Int -> [Work]
worksByAuthor aid = filter (\w -> authorRef w == aid) works

-- | Find all works of a specific genre
worksByGenre :: Genre -> [Work]
worksByGenre g = filter (\w -> genre w == g) works

-- | Find all authors from a specific tribe
authorsByTribe :: Tribe -> [Author]
authorsByTribe t = filter (\a -> tribe a == t) authors

-- | Count of works by this author in the given genre.
worksByAuthorInGenre :: Int -> Genre -> [Work]
worksByAuthorInGenre aid g =
  filter (\w -> authorRef w == aid && genre w == g) works

-- | All authors who have at least one work in the given genre,
--   sorted by the number of matching works (most first).
authorsByGenre :: Genre -> [Author]
authorsByGenre g =
  let matching = filter (\a -> not (null (worksByAuthorInGenre (authorId a) g))) authors
      countFor a = length (worksByAuthorInGenre (authorId a) g)
      sortByCount [] = []
      sortByCount (x:xs) =
        sortByCount bigger ++ [x] ++ sortByCount smaller
        where
          bigger  = filter (\a -> countFor a >  countFor x) xs
          smaller = filter (\a -> countFor a <= countFor x) xs
  in sortByCount matching

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

-- | Sort works alphabetically by title (case-insensitive).
sortByTitle :: [Work] -> [Work]
sortByTitle [] = []
sortByTitle (x:xs) =
  sortByTitle smaller ++ [x] ++ sortByTitle bigger
  where
    key w   = toLowerStr (title w)
    smaller = filter (\w -> key w <= key x) xs
    bigger  = filter (\w -> key w >  key x) xs

-- | Find works by tribe AND genre combined
worksByTribeAndGenre :: Tribe -> Genre -> [Work]
worksByTribeAndGenre t g =
  let tribeAuthors = authorsByTribe t
      tribeAuthorIds = map authorId tribeAuthors
  in filter (\w -> genre w == g && authorRef w `elem` tribeAuthorIds) works

-- | Find works matching ANY of the given tribes AND ANY of the given genres.
--   An empty list for either axis means "no filter on that axis".
--   Examples:
--     worksByTribesAndGenres [] []                 = all works
--     worksByTribesAndGenres [Navajo] []           = all Navajo works
--     worksByTribesAndGenres [] [Poetry]           = all poetry works
--     worksByTribesAndGenres [Navajo, Cherokee]
--                            [Poetry, Memoir]      = works that are
--                                                    (Navajo OR Cherokee) AND
--                                                    (Poetry OR Memoir)
worksByTribesAndGenres :: [Tribe] -> [Genre] -> [Work]
worksByTribesAndGenres ts gs =
  let matchingAuthorIds = map authorId (filter (\a -> tribe a `elem` ts) authors)
      tribeMatches w    = null ts || authorRef w `elem` matchingAuthorIds
      genreMatches w    = null gs || genre w `elem` gs
  in filter (\w -> tribeMatches w && genreMatches w) works

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

  -- | Pre-defined collections of works for new readers
data Collection = IntroToPoetry | AwardWinners | ModernHorror | HeritageMemoirs

collectionTitle :: Collection -> String
collectionTitle IntroToPoetry  = "Intro to Native Poetry"
collectionTitle AwardWinners   = "Award-Winning Masterpieces"
collectionTitle ModernHorror   = "Modern Indigenous Horror"
collectionTitle HeritageMemoirs = "Heritage & Memoirs"

-- | The list of work IDs for each collection
collectionIds :: Collection -> [Int]
collectionIds IntroToPoetry   = [2, 15, 20, 40, 52] -- Harjo, Tapahonso, Ortiz, Diaz, Long Soldier
collectionIds AwardWinners    = [9, 10, 11, 48, 52] -- Erdrich, Momaday, Jones, Long Soldier
collectionIds ModernHorror    = [46, 48, 49, 56]     -- Roanhorse, Jones, Staples
collectionIds HeritageMemoirs = [1, 4, 12, 27, 44]    -- Harjo, Momaday, Hale, Hobson

-- | Look up the actual Work objects for a collection
getCollectionWorks :: Collection -> [Work]
getCollectionWorks col = filter (\w -> workId w `elem` collectionIds col) works

-- | Pick a truly random author from the database
randomAuthor :: IO Author
randomAuthor = do
  -- We explicitly tell it we want an Int for the index
  idx <- randomRIO (0, length authors - 1) :: IO Int
  return (authors !! idx)