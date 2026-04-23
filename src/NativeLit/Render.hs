module NativeLit.Render where

import NativeLit.Types
import NativeLit.Database
import NativeLit.Search
import Data.Char (toLower)
import Data.List (intercalate)
import System.IO (hSetBuffering, stdout, BufferMode(..))

-- ============================================================
-- ENTRY POINT
-- ============================================================

runLibrary :: IO ()
runLibrary = do
  hSetBuffering stdout NoBuffering
  printBanner
  name <- getUsername
  mainMenu name []

-- ============================================================
-- BANNER & HELPERS
-- ============================================================

printBanner :: IO ()
printBanner = do
  putStrLn ""
  putStrLn "=============================================="
  putStrLn "    NATIVE AMERICAN LITERARY LIBRARY"
  putStrLn "    A Collection of Indigenous Voices"
  putStrLn "=============================================="
  putStrLn ""

divider :: IO ()
divider = putStrLn "----------------------------------------------"

prompt :: String -> IO String
prompt msg = do
  putStr msg
  getLine

getUsername :: IO String
getUsername = do
  name <- prompt "Enter your name to begin: "
  if null name
    then do
      putStrLn "Please enter a name."
      getUsername
    else do
      putStrLn $ "\nWelcome, " ++ name ++ "!\n"
      return name

-- ============================================================
-- MAIN MENU
-- ============================================================

mainMenu :: String -> [Work] -> IO ()
mainMenu name cart = do
  divider
  putStrLn $ "Hello, " ++ name ++ "  |  Reading List: " ++ show (length cart) ++ " works"
  divider
  putStrLn "[1] Browse All Authors"
  putStrLn "[2] Filter by Tribe"
  putStrLn "[3] Filter by Genre"
  putStrLn "[4] Filter by Tribes & Genres (multi-select)"
  putStrLn "[5] Search Author by Name"
  putStrLn "[6] Browse by Era (Year Range)"
  putStrLn "[7] Top 10 Most Prolific Authors"
  putStrLn "[8] View Reading List"
  putStrLn "[9] Quit"
  divider
  choice <- prompt "> "
  case choice of
    "1" -> browseAuthors name cart authors
    "2" -> tribeMenu name cart
    "3" -> genreMenu name cart
    "4" -> tribeAndGenreMenu name cart
    "5" -> searchByName name cart
    "6" -> eraMenu name cart
    "7" -> showMostProlific name cart
    "8" -> viewCart name cart
    "9" -> putStrLn "\nGoodbye!\n"
    _   -> do
      putStrLn "Invalid choice, try again."
      mainMenu name cart

-- ============================================================
-- BROWSE AUTHORS
-- ============================================================

browseAuthors :: String -> [Work] -> [Author] -> IO ()
browseAuthors name cart [] = do
  putStrLn "\nNo authors found.\n"
  mainMenu name cart
browseAuthors name cart filtered = do
  divider
  putStrLn $ "AUTHORS (" ++ show (length filtered) ++ ")"
  divider
  mapM_ (printAuthorSummary cart) (zip [1..] filtered)
  divider
  putStrLn "[0] Back to Main Menu"
  putStrLn "Enter author number to view details:"
  choice <- prompt "> "
  case reads choice of
    [(0, "")] -> mainMenu name cart
    [(n, "")] | n >= 1 && n <= length filtered -> do
      newCart <- authorDetail name cart (filtered !! (n - 1))
      browseAuthors name newCart filtered
    _ -> do
      putStrLn "Invalid choice."
      browseAuthors name cart filtered

printAuthorSummary :: [Work] -> (Int, Author) -> IO ()
printAuthorSummary cart (i, a) =
  let wCount = length (worksByAuthor (authorId a))
      inCart  = length (filter (\w -> w `elem` cart) (worksByAuthor (authorId a)))
      cartStr = if inCart > 0 then " [" ++ show inCart ++ " in list]" else ""
  in putStrLn $ " " ++ show i ++ ". " ++ authorName a ++
                "  (" ++ showTribe (tribe a) ++ " | " ++
                show wCount ++ " works)" ++ cartStr

-- ============================================================
-- BROWSE AUTHORS (scoped to a genre)
-- ============================================================

-- | Browse a list of authors whose works we want to display filtered
--   to a specific genre. Picking an author shows their bio and ONLY
--   the works matching the given genre.
browseAuthorsInGenre :: String -> [Work] -> Genre -> [Author] -> IO ()
browseAuthorsInGenre name cart _ [] = do
  putStrLn "\nNo authors found.\n"
  mainMenu name cart
browseAuthorsInGenre name cart g filtered = do
  divider
  putStrLn $ showGenre g ++ " -- AUTHORS (" ++ show (length filtered) ++ ")"
  divider
  mapM_ (printAuthorInGenreSummary cart g) (zip [1..] filtered)
  divider
  putStrLn "[0] Back to Main Menu"
  putStrLn "Enter author number to view details:"
  choice <- prompt "> "
  case reads choice of
    [(0, "")] -> mainMenu name cart
    [(n, "")] | n >= 1 && n <= length filtered -> do
      newCart <- authorDetailInGenre name cart g (filtered !! (n - 1))
      browseAuthorsInGenre name newCart g filtered
    _ -> do
      putStrLn "Invalid choice."
      browseAuthorsInGenre name cart g filtered

-- | Author summary line showing count of works in the given genre
--   (rather than total works).
printAuthorInGenreSummary :: [Work] -> Genre -> (Int, Author) -> IO ()
printAuthorInGenreSummary cart g (i, a) =
  let ws      = worksByAuthorInGenre (authorId a) g
      wCount  = length ws
      inCart  = length (filter (`elem` cart) ws)
      cartStr = if inCart > 0 then " [" ++ show inCart ++ " in list]" else ""
  in putStrLn $ " " ++ show i ++ ". " ++ authorName a ++
                "  (" ++ showTribe (tribe a) ++ " | " ++
                show wCount ++ " " ++ showGenre g ++ " works)" ++ cartStr

-- | Like authorDetail, but the works list is filtered to a specific genre.
authorDetailInGenre :: String -> [Work] -> Genre -> Author -> IO [Work]
authorDetailInGenre name cart g a = do
  divider
  putStrLn $ authorName a
  putStrLn $ showTribe (tribe a) ++ "  |  Born: " ++ show (birthYear a)
  divider
  putStrLn $ biography a
  divider
  let ws = sortByYear (worksByAuthorInGenre (authorId a) g)
  putStrLn $ showGenre g ++ " WORKS (" ++ show (length ws) ++ "):"
  putStrLn ""
  mapM_ (printWorkSummary cart) (zip [1..] ws)
  divider
  putStrLn "[A] Add all works to reading list"
  putStrLn "[0] Back"
  putStrLn "Enter work number to view details:"
  choice <- prompt "> "
  case map toLower choice of
    "a" -> do
      let newWorks = filter (`notElem` cart) ws
      putStrLn $ "Added " ++ show (length newWorks) ++ " works to your reading list."
      return (cart ++ newWorks)
    "0" -> return cart
    _ -> case reads choice of
      [(n, "")] | n >= 1 && n <= length ws -> do
        newCart <- workDetail name cart (ws !! (n - 1)) a Nothing
        authorDetailInGenre name newCart g a
      _ -> do
        putStrLn "Invalid choice."
        authorDetailInGenre name cart g a

-- ============================================================
-- BROWSE WORKS (interactive work list)
-- ============================================================

-- | Interactive work list: shows a numbered list of works, lets the user
--   pick one to view its details (and add/remove from reading list).
--   The `heading` string is printed above the list (e.g. "Navajo + Poetry").
browseWorks :: String -> [Work] -> String -> [Work] -> IO ()
browseWorks name cart _ [] = do
  putStrLn "\nNo works found.\n"
  mainMenu name cart
browseWorks name cart heading filtered = do
  divider
  putStrLn $ heading ++ " (" ++ show (length filtered) ++ " works)"
  divider
  mapM_ (printWorkListItem cart) (zip [1..] filtered)
  divider
  putStrLn "[0] Back to Main Menu"
  putStrLn "Enter work number to view details:"
  choice <- prompt "> "
  case reads choice of
    [(0, "")] -> mainMenu name cart
    [(n, "")] | n >= 1 && n <= length filtered -> do
      let w = filtered !! (n - 1)
      case authorOfWork w of
        Just a -> do
          -- [M] on work detail shows this author's full page.
          -- When the user exits that page, we fall back here and
          -- the outer browseWorks recurses, returning them to the
          -- filtered list they came from.
          let sideTrip c = authorDetail name c a
          newCart <- workDetail name cart w a (Just sideTrip)
          browseWorks name newCart heading filtered
        Nothing -> do
          putStrLn "Author not found for this work."
          browseWorks name cart heading filtered
    _ -> do
      putStrLn "Invalid choice."
      browseWorks name cart heading filtered

-- | Compact work line used by browseWorks. Shows title, year, genre,
--   author, and a [in list] marker if already in the reading list.
printWorkListItem :: [Work] -> (Int, Work) -> IO ()
printWorkListItem cart (i, w) =
  let inCart  = w `elem` cart
      cartStr = if inCart then " [in list]" else ""
      authorStr = case authorOfWork w of
        Just a  -> "  by " ++ authorName a
        Nothing -> ""
  in putStrLn $ " " ++ show i ++ ". " ++ title w ++
                " (" ++ show (yearPub w) ++ ")  [" ++
                showGenre (genre w) ++ "]" ++ authorStr ++ cartStr

-- ============================================================
-- AUTHOR DETAIL
-- ============================================================

authorDetail :: String -> [Work] -> Author -> IO [Work]
authorDetail name cart a = do
  divider
  putStrLn $ authorName a
  putStrLn $ showTribe (tribe a) ++ "  |  Born: " ++ show (birthYear a)
  divider
  putStrLn $ biography a
  divider
  let ws = sortByYear (worksByAuthor (authorId a))
  putStrLn $ "WORKS (" ++ show (length ws) ++ "):"
  putStrLn ""
  mapM_ (printWorkSummary cart) (zip [1..] ws)
  divider
  putStrLn "[A] Add all works to reading list"
  putStrLn "[0] Back"
  putStrLn "Enter work number to view details:"
  choice <- prompt "> "
  case map toLower choice of
    "a" -> do
      let newWorks = filter (`notElem` cart) ws
      putStrLn $ "Added " ++ show (length newWorks) ++ " works to your reading list."
      return (cart ++ newWorks)
    "0" -> return cart
    _ -> case reads choice of
      [(n, "")] | n >= 1 && n <= length ws -> do
        newCart <- workDetail name cart (ws !! (n - 1)) a Nothing
        authorDetail name newCart a
      _ -> do
        putStrLn "Invalid choice."
        authorDetail name cart a

printWorkSummary :: [Work] -> (Int, Work) -> IO ()
printWorkSummary cart (i, w) =
  let inCart = w `elem` cart
      cartStr = if inCart then " [in list]" else ""
  in do
    putStrLn $ " " ++ show i ++ ". " ++ title w ++
               " (" ++ show (yearPub w) ++ ")  [" ++
               showGenre (genre w) ++ "]" ++ cartStr
    putStrLn $ "    \"" ++ take 80 (excerpt w) ++ "\""

-- ============================================================
-- WORK DETAIL
-- ============================================================

-- | Show the full detail page for a single work.
--
--   The `mSideTrip` parameter, when Just, enables the [M] "More from this
--   author" option. It's a function that takes the current cart and returns
--   what to do (typically: show authorSideTrip, then route back to origin).
--   Pass Nothing when the caller is already on the author's page, so that
--   [M] would be redundant.
workDetail :: String -> [Work] -> Work -> Author
           -> Maybe ([Work] -> IO [Work])
           -> IO [Work]
workDetail name cart w a mSideTrip = do
  divider
  putStrLn $ title w
  putStrLn $ showGenre (genre w) ++ "  |  " ++ show (yearPub w)
  putStrLn $ "by " ++ authorName a
  divider
  putStrLn $ "\"" ++ excerpt w ++ "\""
  divider
  let inCart    = w `elem` cart
  let showMore  = case mSideTrip of
                    Just _  -> putStrLn $ "[M] More from " ++ authorName a
                    Nothing -> return ()
  let handleMore c = case mSideTrip of
                       Just sideTrip -> sideTrip c
                       Nothing       -> do
                         putStrLn "Not available here."
                         workDetail name c w a mSideTrip
  if inCart
    then do
      putStrLn "[R] Remove from reading list"
      showMore
      putStrLn "[0] Back"
      choice <- prompt "> "
      case map toLower choice of
        "r" -> do
          putStrLn $ "Removed \"" ++ title w ++ "\" from reading list."
          return (filter (/= w) cart)
        "m" -> handleMore cart
        _   -> return cart
    else do
      putStrLn "[A] Add to reading list"
      showMore
      putStrLn "[0] Back"
      choice <- prompt "> "
      case map toLower choice of
        "a" -> do
          putStrLn $ "Added \"" ++ title w ++ "\" to reading list!"
          return (cart ++ [w])
        "m" -> handleMore cart
        _   -> return cart

-- ============================================================
-- FILTER MENUS
-- ============================================================

tribeMenu :: String -> [Work] -> IO ()
tribeMenu name cart = do
  divider
  putStrLn "FILTER BY TRIBE"
  divider
  let tribes = [ Navajo, Cherokee, Lakota, Apache, Choctaw, Osage
               , Pueblo, Sioux, Muscogee, Blackfeet, Coeur_dAlene
               , Chickasaw, Anishinaabe, Ojibwe, Mojave, Metis, Ojicree ]
  mapM_ (\(i, t) -> putStrLn $ " " ++ show i ++ ". " ++ showTribe t)
        (zip [1..] tribes)
  divider
  putStrLn "[0] Back"
  choice <- prompt "> "
  case reads choice of
    [(0, "")] -> mainMenu name cart
    [(n, "")] | n >= 1 && n <= length tribes -> do
      let t = tribes !! (n - 1)
      let filtered = authorsByTribe t
      putStrLn $ "\nAuthors from " ++ showTribe t ++ ":"
      browseAuthors name cart filtered
    _ -> do
      putStrLn "Invalid choice."
      tribeMenu name cart

genreMenu :: String -> [Work] -> IO ()
genreMenu name cart = do
  divider
  putStrLn "FILTER BY GENRE"
  divider
  let genres = [Poetry, Memoir, LiteraryFiction, Nonfiction, ShortStory]
  mapM_ (\(i, g) -> putStrLn $ " " ++ show i ++ ". " ++ showGenre g)
        (zip [1..] genres)
  divider
  putStrLn "[0] Back"
  choice <- prompt "> "
  case reads choice of
    [(0, "")] -> mainMenu name cart
    [(n, "")] | n >= 1 && n <= length genres -> do
      let g = genres !! (n - 1)
      let ws = sortByTitle (worksByGenre g)
      browseWorks name cart (showGenre g) ws
    _ -> do
      putStrLn "Invalid choice."
      genreMenu name cart

tribeAndGenreMenu :: String -> [Work] -> IO ()
tribeAndGenreMenu name cart =
  multiFilterMenu name cart [] []

-- | Multi-select filter: lets the user toggle any number of tribes and
--   genres on/off, then apply to see matching works.
--   Commands:
--     t<n>  toggle tribe number n
--     g<n>  toggle genre number n
--     a     apply filter and view results
--     c     clear all selections
--     0     back to main menu
multiFilterMenu :: String -> [Work] -> [Tribe] -> [Genre] -> IO ()
multiFilterMenu name cart selTribes selGenres = do
  divider
  putStrLn "FILTER BY TRIBES AND GENRES (multi-select)"
  divider
  putStrLn "TRIBES:"
  mapM_ (printToggleLine showTribe selTribes) (zip [1..] filterTribes)
  putStrLn ""
  putStrLn "GENRES:"
  mapM_ (printToggleLine showGenre selGenres) (zip [1..] filterGenres)
  divider
  putStrLn $ "Selected: " ++ show (length selTribes) ++ " tribe(s), "
                          ++ show (length selGenres) ++ " genre(s)"
  putStrLn "Type t<n> to toggle a tribe, g<n> to toggle a genre"
  putStrLn "[A] Apply filter   [C] Clear all   [0] Back to Main Menu"
  choice <- prompt "> "
  case map toLower choice of
    "0" -> mainMenu name cart
    "c" -> multiFilterMenu name cart [] []
    "a" -> do
      let ws = worksByTribesAndGenres selTribes selGenres
      let heading = buildFilterHeading selTribes selGenres
      browseWorks name cart heading ws
      -- browseWorks ends by returning to mainMenu, so control
      -- does not come back here after the user is done.
    ('t':rest) -> case reads rest of
      [(n, "")] | n >= 1 && n <= length filterTribes ->
        let t = filterTribes !! (n - 1)
            newSel = toggle t selTribes
        in multiFilterMenu name cart newSel selGenres
      _ -> invalid
    ('g':rest) -> case reads rest of
      [(n, "")] | n >= 1 && n <= length filterGenres ->
        let g = filterGenres !! (n - 1)
            newSel = toggle g selGenres
        in multiFilterMenu name cart selTribes newSel
      _ -> invalid
    _ -> invalid
  where
    invalid = do
      putStrLn "Invalid input. Use t<n>, g<n>, a, c, or 0."
      multiFilterMenu name cart selTribes selGenres

-- | Toggle an item's membership in a list.
toggle :: Eq a => a -> [a] -> [a]
toggle x xs
  | x `elem` xs = filter (/= x) xs
  | otherwise   = xs ++ [x]

-- | Print one line of a toggle list, showing [x] if selected, [ ] if not.
printToggleLine :: Eq a => (a -> String) -> [a] -> (Int, a) -> IO ()
printToggleLine showFn selected (i, item) =
  let mark = if item `elem` selected then "[x]" else "[ ]"
  in putStrLn $ "  " ++ mark ++ " " ++ show i ++ ". " ++ showFn item

-- | Fixed list of tribes offered in the filter menu.
filterTribes :: [Tribe]
filterTribes =
  [ Navajo, Cherokee, Lakota, Apache, Choctaw, Osage
  , Pueblo, Sioux, Muscogee, Blackfeet, Coeur_dAlene
  , Chickasaw, Anishinaabe, Ojibwe, Mojave, Metis, Ojicree
  ]

-- | Fixed list of genres offered in the filter menu.
filterGenres :: [Genre]
filterGenres = [Poetry, Memoir, LiteraryFiction, Nonfiction, ShortStory]

-- | Build a human-readable heading for the results screen based on
--   which tribes/genres were selected.
buildFilterHeading :: [Tribe] -> [Genre] -> String
buildFilterHeading [] [] = "All works"
buildFilterHeading ts [] = "Tribes: "  ++ intercalate ", " (map showTribe ts)
buildFilterHeading [] gs = "Genres: "  ++ intercalate ", " (map showGenre gs)
buildFilterHeading ts gs =
  intercalate ", " (map showTribe ts) ++ "  +  " ++
  intercalate ", " (map showGenre gs)

-- ============================================================
-- SEARCH BY NAME
-- ============================================================

searchByName :: String -> [Work] -> IO ()
searchByName name cart = do
  divider
  query <- prompt "Search author name: "
  let results = authorByName query
  if null results
    then do
      putStrLn $ "No authors found matching \"" ++ query ++ "\"."
      mainMenu name cart
    else browseAuthors name cart results

-- ============================================================
-- ERA BROWSER
-- ============================================================

eraMenu :: String -> [Work] -> IO ()
eraMenu name cart = do
  divider
  putStrLn "BROWSE BY ERA"
  divider
  start <- prompt "Start year: "
  end   <- prompt "End year:   "
  case (reads start, reads end) of
    ([(s, "")], [(e, "")]) -> do
      let ws = worksWithAuthors s e
      divider
      putStrLn $ "Works published " ++ start ++ " - " ++ end ++
                 " (" ++ show (length ws) ++ " found)"
      divider
      if null ws
        then putStrLn "No works found in that range."
        else mapM_ printEraWork ws
      divider
      putStrLn "\nPress Enter to go back."
      _ <- getLine
      mainMenu name cart
    _ -> do
      putStrLn "Invalid years. Please enter numbers."
      eraMenu name cart

printEraWork :: (Work, Maybe Author) -> IO ()
printEraWork (w, Just a)  =
  putStrLn $ " - " ++ title w ++ " (" ++ show (yearPub w) ++ ")" ++
             "  by " ++ authorName a ++ "  [" ++ showGenre (genre w) ++ "]"
printEraWork (w, Nothing) =
  putStrLn $ " - " ++ title w ++ " (" ++ show (yearPub w) ++ ")"

-- ============================================================
-- MOST PROLIFIC
-- ============================================================

showMostProlific :: String -> [Work] -> IO ()
showMostProlific name cart = do
  divider
  putStrLn "TOP 10 MOST PROLIFIC AUTHORS (by number of works)"
  divider
  let top10 = take 10 mostProlificAuthors
  browseAuthors name cart top10

-- ============================================================
-- READING LIST / CART
-- ============================================================

viewCart :: String -> [Work] -> IO ()
viewCart name cart = do
  divider
  putStrLn $ name ++ "'s Reading List (" ++ show (length cart) ++ " works)"
  divider
  if null cart
    then putStrLn "Your reading list is empty."
    else mapM_ (\(i, w) ->
      case filter (\a -> authorId a == authorRef w) authors of
        (a:_) -> putStrLn $ " " ++ show i ++ ". " ++ title w ++
                            "  by " ++ authorName a ++
                            "  [" ++ showGenre (genre w) ++ ", " ++
                            show (yearPub w) ++ "]"
        []    -> putStrLn $ " " ++ show i ++ ". " ++ title w
      ) (zip [1..] cart)
  divider
  putStrLn "[C] Clear reading list"
  putStrLn "[0] Back to Main Menu"
  choice <- prompt "> "
  case map toLower choice of
    "c" -> do
      putStrLn "Reading list cleared."
      mainMenu name []
    _ -> mainMenu name cart

-- ============================================================
-- SHOW HELPERS
-- ============================================================

showTribe :: Tribe -> String
showTribe Navajo         = "Navajo"
showTribe Cherokee       = "Cherokee"
showTribe Lakota         = "Lakota"
showTribe Apache         = "Apache"
showTribe Choctaw        = "Choctaw"
showTribe Osage          = "Osage"
showTribe Pueblo         = "Pueblo"
showTribe Sioux          = "Sioux"
showTribe Muscogee       = "Muscogee"
showTribe Blackfeet      = "Blackfeet"
showTribe Coeur_dAlene   = "Coeur d'Alene"
showTribe Chickasaw      = "Chickasaw"
showTribe Anishinaabe    = "Anishinaabe"
showTribe Ojibwe         = "Ojibwe"
showTribe HoChunk        = "Ho-Chunk"
showTribe Mohawk         = "Mohawk"
showTribe Mojave         = "Mojave"
showTribe Cree           = "Cree"
showTribe Metis          = "Metis"
showTribe Ojicree        = "Oji-Cree"
showTribe (OtherTribe t) = t

showGenre :: Genre -> String
showGenre Poetry          = "Poetry"
showGenre Memoir          = "Memoir"
showGenre LiteraryFiction = "Literary Fiction"
showGenre Nonfiction      = "Nonfiction"
showGenre ShortStory      = "Short Story"
