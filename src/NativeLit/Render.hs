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
  putStrLn "[4] Filter by Tribe AND Genre"
  putStrLn "[5] Search Author by Name"
  putStrLn "[6] Browse by Era (Year Range)"
  putStrLn "[7] Most Prolific Authors"
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
        newCart <- workDetail name cart (ws !! (n - 1)) a
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

workDetail :: String -> [Work] -> Work -> Author -> IO [Work]
workDetail name cart w a = do
  divider
  putStrLn $ title w
  putStrLn $ showGenre (genre w) ++ "  |  " ++ show (yearPub w)
  putStrLn $ "by " ++ authorName a
  divider
  putStrLn $ "\"" ++ excerpt w ++ "\""
  divider
  let inCart = w `elem` cart
  if inCart
    then do
      putStrLn "[R] Remove from reading list"
      putStrLn "[0] Back"
      choice <- prompt "> "
      case map toLower choice of
        "r" -> do
          putStrLn $ "Removed \"" ++ title w ++ "\" from reading list."
          return (filter (/= w) cart)
        _   -> return cart
    else do
      putStrLn "[A] Add to reading list"
      putStrLn "[0] Back"
      choice <- prompt "> "
      case map toLower choice of
        "a" -> do
          putStrLn $ "Added \"" ++ title w ++ "\" to reading list!"
          return (cart ++ [w])
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
      let ws = worksByGenre g
      divider
      putStrLn $ showGenre g ++ " (" ++ show (length ws) ++ " works)"
      divider
      mapM_ (\w -> putStrLn $ " - " ++ title w ++ " (" ++ show (yearPub w) ++ ")") ws
      divider
      putStrLn "\nPress Enter to go back."
      _ <- getLine
      mainMenu name cart
    _ -> do
      putStrLn "Invalid choice."
      genreMenu name cart

tribeAndGenreMenu :: String -> [Work] -> IO ()
tribeAndGenreMenu name cart = do
  divider
  putStrLn "FILTER BY TRIBE AND GENRE"
  divider
  let tribes = [ Navajo, Cherokee, Lakota, Apache, Choctaw, Osage
               , Pueblo, Sioux, Muscogee, Blackfeet, Coeur_dAlene
               , Chickasaw, Anishinaabe, Ojibwe, Mojave, Metis, Ojicree ]
  putStrLn "Select tribe:"
  mapM_ (\(i, t) -> putStrLn $ " " ++ show i ++ ". " ++ showTribe t)
        (zip [1..] tribes)
  divider
  tChoice <- prompt "Tribe > "
  case reads tChoice of
    [(tn, "")] | tn >= 1 && tn <= length tribes -> do
      let t = tribes !! (tn - 1)
      let genres = [Poetry, Memoir, LiteraryFiction, Nonfiction, ShortStory]
      putStrLn "\nSelect genre:"
      mapM_ (\(i, g) -> putStrLn $ " " ++ show i ++ ". " ++ showGenre g)
            (zip [1..] genres)
      gChoice <- prompt "Genre > "
      case reads gChoice of
        [(gn, "")] | gn >= 1 && gn <= length genres -> do
          let g = genres !! (gn - 1)
          let ws = worksByTribeAndGenre t g
          divider
          putStrLn $ showTribe t ++ " + " ++ showGenre g ++
                     " (" ++ show (length ws) ++ " works)"
          divider
          if null ws
            then putStrLn "No works found for this combination."
            else mapM_ (\w -> putStrLn $ " - " ++ title w ++
                                         " (" ++ show (yearPub w) ++ ")") ws
          divider
          putStrLn "\nPress Enter to go back."
          _ <- getLine
          mainMenu name cart
        _ -> do
          putStrLn "Invalid genre."
          mainMenu name cart
    _ -> do
      putStrLn "Invalid tribe."
      mainMenu name cart

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
  putStrLn "MOST PROLIFIC AUTHORS (by number of works)"
  divider
  let ranked = zip [1..] mostProlificAuthors
  mapM_ (\(i, a) ->
    putStrLn $ " " ++ show i ++ ". " ++ authorName a ++
               "  (" ++ show (length (worksByAuthor (authorId a))) ++ " works)"
    ) ranked
  divider
  putStrLn "\nPress Enter to go back."
  _ <- getLine
  mainMenu name cart

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
showGenre Mythology       = "Mythology"
showGenre Autobiography   = "Autobiography"