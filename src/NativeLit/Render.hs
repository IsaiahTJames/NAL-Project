{-# LANGUAGE OverloadedStrings #-}
module NativeLit.Render where

import NativeLit.Types
import NativeLit.Database
import NativeLit.Search
import Data.Char (toLower)
import Data.List (intercalate)
import System.IO (hSetBuffering, stdout, BufferMode(..))
import Layoutz

-- ============================================================
-- COLOR PALETTE (New Mexico / Native American inspired)
-- ============================================================

turquoise :: L -> L
turquoise = withColor ColorBrightCyan

amber :: L -> L
amber = withColor ColorYellow

brick :: L -> L
brick = withColor ColorRed

sage :: L -> L
sage = withColor ColorGreen

orange :: L -> L
orange = withColor (ColorTrue 255 140 0)

-- ============================================================
-- CART (READING LIST) MODEL
-- ============================================================

type CartItem = (Work, Bool)
type Cart = [CartItem]

inCart :: Work -> Cart -> Bool
inCart w = any (\(w', _) -> w' == w)

isReadInCart :: Work -> Cart -> Bool
isReadInCart w c = case filter (\(w', _) -> w' == w) c of
  ((_, r):_) -> r
  []         -> False

addToCart :: Work -> Cart -> Cart
addToCart w c
  | inCart w c = c
  | otherwise  = c ++ [(w, False)]

removeFromCart :: Work -> Cart -> Cart
removeFromCart w = filter (\(w', _) -> w' /= w)

toggleReadCart :: Work -> Cart -> Cart
toggleReadCart w = map (\(w', r) -> if w' == w then (w', not r) else (w', r))

cartSize :: Cart -> Int
cartSize = length

countInCart :: [Work] -> Cart -> Int
countInCart ws c = length (filter (`inCart` c) ws)

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
  putStrLn $ render $ center $
    withBorder BorderDouble $
    turquoise $
    box "Native American Literary Library"
      [ center $ amber $
          text "A Collection of Indigenous Voices"
      ]
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

mainMenu :: String -> Cart -> IO ()
mainMenu name cart = do
  putStrLn ""
  putStrLn $ render $ row
    [ sage   $ statusCard "Reader" name
    , orange $ statusCard "Reading List" (show (cartSize cart) ++ " works")
    ]
  putStrLn ""
  putStrLn $ render $
    withBorder BorderRound $
    turquoise $
    box "Main Menu"
      [ text "[1] Browse All Authors"
      , text "[2] Filter by Tribe"
      , text "[3] Filter by Genre"
      , tightRow [ text "[4] Filter by Tribes & Genres "
                 , amber $ text "(multi-select)" ]
      , text "[5] Search Author by Name"
      , tightRow [ text "[6] Browse by Era "
                 , amber $ text "(Year Range)" ]
      , text "[7] Top 10 Most Prolific Authors"
      , text "[8] View Reading List"
      , text "[9] Quit"
      ]
  putStrLn ""
  choice <- prompt "> "
  case choice of
    "1" -> browseAuthors name cart authors
    "2" -> tribeMenu name cart
    "3" -> genreMenu name cart
    "4" -> tribeAndGenreMenu name cart
    "5" -> searchByName name cart
    "6" -> eraMenu name cart
    "7" -> showMostProlific name cart
    "8" -> do
      newCart <- viewCart name cart
      mainMenu name newCart
    "9" -> putStrLn "\nGoodbye!\n"
    _   -> do
      putStrLn "Invalid choice, try again."
      mainMenu name cart

-- ============================================================
-- BROWSE AUTHORS
-- ============================================================

browseAuthors :: String -> Cart -> [Author] -> IO ()
browseAuthors name cart [] = do
  putStrLn "\nNo authors found.\n"
  mainMenu name cart
browseAuthors name cart filtered = do
  putStrLn ""
  putStrLn $ render $
    withBorder BorderRound $
    box ("Authors (" ++ show (length filtered) ++ ")")
      (map (authorRowL cart) (zip [1..] filtered))
  putStrLn ""
  putStrLn $ render $ amber $
    text "[0] Back  |  [H] Home  |  [L] Reading List  |  Enter author number:"
  choice <- prompt "> "
  case map toLower choice of
    "0" -> mainMenu name cart
    "h" -> mainMenu name cart
    "l" -> do
      newCart <- viewCart name cart
      browseAuthors name newCart filtered
    _ -> case reads choice of
      [(n, "")] | n >= 1 && n <= length filtered -> do
        newCart <- authorDetail name cart (filtered !! (n - 1))
        browseAuthors name newCart filtered
      _ -> do
        putStrLn "Invalid choice."
        browseAuthors name cart filtered

authorRowL :: Cart -> (Int, Author) -> L
authorRowL cart (i, a) =
  let ws       = worksByAuthor (authorId a)
      wCount   = length ws
      countIn  = countInCart ws cart
      cartStr  = if countIn > 0 then "  [" ++ show countIn ++ " in list]" else ""
  in tightRow
       [ turquoise $ text (show i ++ ". " ++ authorName a ++ "  (")
       , amber     $ text (showTribe (tribe a))
       , turquoise $ text " | "
       , amber     $ text (show wCount ++ " works")
       , turquoise $ text (")" ++ cartStr)
       ]

-- ============================================================
-- BROWSE AUTHORS (scoped to a genre)
-- ============================================================

browseAuthorsInGenre :: String -> Cart -> Genre -> [Author] -> IO ()
browseAuthorsInGenre name cart _ [] = do
  putStrLn "\nNo authors found.\n"
  mainMenu name cart
browseAuthorsInGenre name cart g filtered = do
  putStrLn ""
  putStrLn $ render $
    withBorder BorderRound $
    turquoise $
    box (showGenre g ++ " Authors (" ++ show (length filtered) ++ ")")
      (map (authorInGenreRowL cart g) (zip [1..] filtered))
  putStrLn ""
  putStrLn $ render $ amber $
    text "[0] Back  |  [H] Home  |  [L] Reading List  |  Enter author number:"
  choice <- prompt "> "
  case map toLower choice of
    "0" -> mainMenu name cart
    "h" -> mainMenu name cart
    "l" -> do
      newCart <- viewCart name cart
      browseAuthorsInGenre name newCart g filtered
    _ -> case reads choice of
      [(n, "")] | n >= 1 && n <= length filtered -> do
        newCart <- authorDetailInGenre name cart g (filtered !! (n - 1))
        browseAuthorsInGenre name newCart g filtered
      _ -> do
        putStrLn "Invalid choice."
        browseAuthorsInGenre name cart g filtered

authorInGenreRowL :: Cart -> Genre -> (Int, Author) -> L
authorInGenreRowL cart g (i, a) =
  let ws      = worksByAuthorInGenre (authorId a) g
      wCount  = length ws
      countIn = countInCart ws cart
      cartStr = if countIn > 0 then "  [" ++ show countIn ++ " in list]" else ""
  in tightRow
       [ turquoise $ text (show i ++ ". " ++ authorName a ++ "  (")
       , amber     $ text (showTribe (tribe a))
       , turquoise $ text " | "
       , amber     $ text (show wCount ++ " " ++ showGenre g ++ " works")
       , turquoise $ text (")" ++ cartStr)
       ]

authorDetailInGenre :: String -> Cart -> Genre -> Author -> IO Cart
authorDetailInGenre name cart g a = do
  putStrLn ""
  putStrLn $ render $
    withBorder BorderDouble $
    amber $
    box (authorName a)
      [ tightRow
          [ amber $ text (showTribe (tribe a))
          , text "    Born: "
          , amber $ text (show (birthYear a))
          ]
      , br
      , withColor ColorBrightWhite $ wrap 70 (biography a)
      ]
  let ws = sortByYear (worksByAuthorInGenre (authorId a) g)
  putStrLn ""
  putStrLn $ render $
    withBorder BorderRound $
    turquoise $
    box (showGenre g ++ " Works (" ++ show (length ws) ++ ")")
      (concatMap (workDetailLines cart) (zip [1..] ws))
  putStrLn ""
  putStrLn $ render $ amber $
    text "[A] Add all   [H] Home   [L] List   [0] Back   |  Enter work #:"
  choice <- prompt "> "
  case map toLower choice of
    "a" -> do
      let newWorks = filter (\w -> not (inCart w cart)) ws
      putStrLn $ "Added " ++ show (length newWorks) ++ " works to your reading list."
      return (foldl (flip addToCart) cart newWorks)
    "0" -> return cart
    "h" -> mainMenu name cart >> return cart
    "l" -> do
      newCart <- viewCart name cart
      authorDetailInGenre name newCart g a
    _ -> case reads choice of
      [(n, "")] | n >= 1 && n <= length ws -> do
        newCart <- workDetail name cart (ws !! (n - 1)) a Nothing
        authorDetailInGenre name newCart g a
      _ -> do
        putStrLn "Invalid choice."
        authorDetailInGenre name cart g a

-- ============================================================
-- BROWSE WORKS
-- ============================================================

browseWorks :: String -> Cart -> String -> [Work] -> IO ()
browseWorks name cart _ [] = do
  putStrLn "\nNo works found.\n"
  mainMenu name cart
browseWorks name cart heading filtered = do
  putStrLn ""
  putStrLn $ render $
    withBorder BorderRound $
    box (heading ++ " (" ++ show (length filtered) ++ " works)")
      (map (workRowL cart) (zip [1..] filtered))
  putStrLn ""
  putStrLn $ render $ amber $
    text "[0] Back  |  [H] Home  |  [L] Reading List  |  Enter work number:"
  choice <- prompt "> "
  case map toLower choice of
    "0" -> mainMenu name cart
    "h" -> mainMenu name cart
    "l" -> do
      newCart <- viewCart name cart
      browseWorks name newCart heading filtered
    _ -> case reads choice of
      [(n, "")] | n >= 1 && n <= length filtered -> do
        let w = filtered !! (n - 1)
        case authorOfWork w of
          Just a -> do
            let sideTrip c = authorDetail name c a
            newCart <- workDetail name cart w a (Just sideTrip)
            browseWorks name newCart heading filtered
          Nothing -> do
            putStrLn "Author not found for this work."
            browseWorks name cart heading filtered
      _ -> do
        putStrLn "Invalid choice."
        browseWorks name cart heading filtered

workRowL :: Cart -> (Int, Work) -> L
workRowL cart (i, w) =
  let isIn   = inCart w cart
      isRead = isReadInCart w cart
      authorPart = case authorOfWork w of
        Just a  -> [text ("  by " ++ authorName a)]
        Nothing -> []
      statusPart
        | isRead    = [sage  $ text "  [\10003 read]"]
        | isIn      = [amber $ text "  [in list]"]
        | otherwise = []
  in tightRow $
       [ turquoise $ text (show i ++ ". " ++ title w)
       , amber     $ text (" (" ++ show (yearPub w) ++ ")")
       , amber     $ text ("  [" ++ showGenre (genre w) ++ "]")
       ] ++ authorPart ++ statusPart

-- ============================================================
-- AUTHOR DETAIL
-- ============================================================

authorDetail :: String -> Cart -> Author -> IO Cart
authorDetail name cart a = do
  putStrLn ""
  putStrLn $ render $
    withBorder BorderDouble $
    amber $
    box (authorName a)
      [ tightRow
          [ amber $ text (showTribe (tribe a))
          , text "    Born: "
          , amber $ text (show (birthYear a))
          ]
      , br
      , withColor ColorBrightWhite $ wrap 70 (biography a)
      ]
  let ws = sortByYear (worksByAuthor (authorId a))
  putStrLn ""
  putStrLn $ render $
    withBorder BorderRound $
    turquoise $
    box ("Works (" ++ show (length ws) ++ ")")
      (concatMap (workDetailLines cart) (zip [1..] ws))
  putStrLn ""
  putStrLn $ render $ amber $
    text "[A] Add all   [H] Home   [L] List   [0] Back   |  Enter work #:"
  choice <- prompt "> "
  case map toLower choice of
    "a" -> do
      let newWorks = filter (\w -> not (inCart w cart)) ws
      putStrLn $ "Added " ++ show (length newWorks) ++ " works to your reading list."
      return (foldl (flip addToCart) cart newWorks)
    "0" -> return cart
    "h" -> mainMenu name cart >> return cart
    "l" -> do
      newCart <- viewCart name cart
      authorDetail name newCart a
    _ -> case reads choice of
      [(n, "")] | n >= 1 && n <= length ws -> do
        newCart <- workDetail name cart (ws !! (n - 1)) a Nothing
        authorDetail name newCart a
      _ -> do
        putStrLn "Invalid choice."
        authorDetail name cart a

workDetailLines :: Cart -> (Int, Work) -> [L]
workDetailLines cart (i, w) =
  let isIn   = inCart w cart
      isRead = isReadInCart w cart
      statusStr
        | isRead    = "  [\10003 read]"
        | isIn      = "  [in list]"
        | otherwise = ""
      titleLine = turquoise $ text $
                  show i ++ ". " ++ title w
      metaLine  = amber $ text $
                  "    " ++ show (yearPub w) ++
                  "  [" ++ showGenre (genre w) ++ "]" ++ statusStr
      quoteLine = withColor ColorBrightWhite $
                  text $ "    \"" ++ take 80 (excerpt w) ++ "\""
  in [titleLine, metaLine, quoteLine]

-- ============================================================
-- WORK DETAIL
-- ============================================================

workDetail :: String -> Cart -> Work -> Author
           -> Maybe (Cart -> IO Cart)
           -> IO Cart
workDetail name cart w a mSideTrip = do
  putStrLn ""
  putStrLn $ render $
    withBorder BorderDouble $
    turquoise $
    box (title w)
      [ amber  $ text (showGenre (genre w) ++ "  |  " ++ show (yearPub w))
      , orange $ text ("by " ++ authorName a)
      , br
      , withColor ColorBrightWhite $
          text ("\"" ++ excerpt w ++ "\"")
      ]
  putStrLn ""
  let isIn   = inCart w cart
  let isRead = isReadInCart w cart
  let moreLine = case mSideTrip of
                   Just _  -> [text $ "[M] More from " ++ authorName a]
                   Nothing -> []
  let cartLines
        | isIn = [ if isRead
                     then text "[U] Mark as unread"
                     else text "[K] Mark as read"
                 , text "[R] Remove from reading list"
                 ]
        | otherwise = [text "[A] Add to reading list"]
  let actionLines = cartLines ++ moreLine ++
                    [ text "[L] View reading list"
                    , text "[H] Home"
                    , text "[0] Back"
                    ]
  putStrLn $ render $
    withBorder BorderRound $
    sage $
    box "Actions" actionLines
  let handleMore c = case mSideTrip of
                       Just sideTrip -> sideTrip c
                       Nothing       -> do
                         putStrLn "Not available here."
                         workDetail name c w a mSideTrip
  choice <- prompt "> "
  case map toLower choice of
    "a" | not isIn -> do
      putStrLn $ "Added \"" ++ title w ++ "\" to reading list!"
      return (addToCart w cart)
    "r" | isIn -> do
      putStrLn $ "Removed \"" ++ title w ++ "\" from reading list."
      return (removeFromCart w cart)
    "k" | isIn && not isRead -> do
      putStrLn $ "Marked \"" ++ title w ++ "\" as read."
      return (toggleReadCart w cart)
    "u" | isIn && isRead -> do
      putStrLn $ "Marked \"" ++ title w ++ "\" as unread."
      return (toggleReadCart w cart)
    "l" -> do
      newCart <- viewCart name cart
      workDetail name newCart w a mSideTrip
    "h" -> mainMenu name cart >> return cart
    "m" -> handleMore cart
    _   -> return cart

-- ============================================================
-- FILTER MENUS
-- ============================================================

tribeMenu :: String -> Cart -> IO ()
tribeMenu name cart = do
  let tribes = [ Navajo, Cherokee, Lakota, Apache, Choctaw, Osage
               , Pueblo, Sioux, Muscogee, Blackfeet, Coeur_dAlene
               , Chickasaw, Anishinaabe, Ojibwe, Mojave, Metis, Ojicree ]
  putStrLn ""
  putStrLn $ render $
    withBorder BorderRound $
    turquoise $
    box "Filter by Tribe"
      (map (\(i, t) -> tightRow
              [ turquoise $ text (show i ++ ". ")
              , amber     $ text (showTribe t)
              ])
           (zip [1..] tribes))
  putStrLn ""
  putStrLn $ render $ amber $
    text "[0] Back  |  [H] Home  |  [L] Reading List  |  Enter tribe number:"
  choice <- prompt "> "
  case map toLower choice of
    "0" -> mainMenu name cart
    "h" -> mainMenu name cart
    "l" -> do
      newCart <- viewCart name cart
      tribeMenu name newCart
    _ -> case reads choice of
      [(n, "")] | n >= 1 && n <= length tribes -> do
        let t = tribes !! (n - 1)
        let filtered = authorsByTribe t
        putStrLn $ "\nAuthors from " ++ showTribe t ++ ":"
        browseAuthors name cart filtered
      _ -> do
        putStrLn "Invalid choice."
        tribeMenu name cart

genreMenu :: String -> Cart -> IO ()
genreMenu name cart = do
  let genres = [Poetry, Memoir, LiteraryFiction, Nonfiction, ShortStory]
  putStrLn ""
  putStrLn $ render $
    withBorder BorderRound $
    turquoise $
    box "Filter by Genre"
      (map (\(i, g) -> tightRow
              [ turquoise $ text (show i ++ ". ")
              , amber     $ text (showGenre g)
              ])
           (zip [1..] genres))
  putStrLn ""
  putStrLn $ render $ amber $
    text "[0] Back  |  [H] Home  |  [L] Reading List  |  Enter genre number:"
  choice <- prompt "> "
  case map toLower choice of
    "0" -> mainMenu name cart
    "h" -> mainMenu name cart
    "l" -> do
      newCart <- viewCart name cart
      genreMenu name newCart
    _ -> case reads choice of
      [(n, "")] | n >= 1 && n <= length genres -> do
        let g = genres !! (n - 1)
        let ws = sortByTitle (worksByGenre g)
        browseWorks name cart (showGenre g) ws
      _ -> do
        putStrLn "Invalid choice."
        genreMenu name cart

tribeAndGenreMenu :: String -> Cart -> IO ()
tribeAndGenreMenu name cart =
  multiFilterMenu name cart [] []

multiFilterMenu :: String -> Cart -> [Tribe] -> [Genre] -> IO ()
multiFilterMenu name cart selTribes selGenres = do
  putStrLn ""
  putStrLn $ render $
    withBorder BorderDouble $
    amber $
    box "Filter by Tribes & Genres (multi-select)"
      [ text $ "Selected: " ++ show (length selTribes) ++ " tribe(s), "
                            ++ show (length selGenres) ++ " genre(s)"
      ]
  putStrLn ""
  putStrLn $ render $ row
    [ withBorder BorderRound $
      turquoise $
      box "Tribes"
        (map (toggleTextLine amber showTribe selTribes) (zip [1..] filterTribes))
    , withBorder BorderRound $
      sage $
      box "Genres"
        (map (toggleTextLine (withColor ColorBrightWhite) showGenre selGenres) (zip [1..] filterGenres))
    ]
  putStrLn ""
  putStrLn $ render $
    withBorder BorderRound $
    orange $
    box "Commands"
      [ text "t<n> -- toggle tribe number n"
      , text "g<n> -- toggle genre number n"
      , text "[A] Apply filter"
      , text "[C] Clear all selections"
      , text "[L] View Reading List"
      , text "[H] Home"
      , text "[0] Back to Main Menu"
      ]
  putStrLn ""
  choice <- prompt "> "
  case map toLower choice of
    "0" -> mainMenu name cart
    "h" -> mainMenu name cart
    "c" -> multiFilterMenu name cart [] []
    "l" -> do
      newCart <- viewCart name cart
      multiFilterMenu name newCart selTribes selGenres
    "a" -> do
      let ws = worksByTribesAndGenres selTribes selGenres
      let heading = buildFilterHeading selTribes selGenres
      browseWorks name cart heading ws
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
      putStrLn "Invalid input. Use t<n>, g<n>, a, c, l, h, or 0."
      multiFilterMenu name cart selTribes selGenres

toggleTextLine :: Eq a => (L -> L) -> (a -> String) -> [a] -> (Int, a) -> L
toggleTextLine colorFn showFn selected (i, item) =
  let mark = if item `elem` selected then "[x]" else "[ ]"
  in tightRow
       [ text (mark ++ " " ++ show i ++ ". ")
       , colorFn $ text (showFn item)
       ]

toggle :: Eq a => a -> [a] -> [a]
toggle x xs
  | x `elem` xs = filter (/= x) xs
  | otherwise   = xs ++ [x]

filterTribes :: [Tribe]
filterTribes =
  [ Navajo, Cherokee, Lakota, Apache, Choctaw, Osage
  , Pueblo, Sioux, Muscogee, Blackfeet, Coeur_dAlene
  , Chickasaw, Anishinaabe, Ojibwe, Mojave, Metis, Ojicree
  ]

filterGenres :: [Genre]
filterGenres = [Poetry, Memoir, LiteraryFiction, Nonfiction, ShortStory]

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

searchByName :: String -> Cart -> IO ()
searchByName name cart = do
  putStrLn ""
  putStrLn $ render $
    withBorder BorderRound $
    turquoise $
    box "Search Author by Name"
      [ text "Type a name (or part of one) and press Enter."
      , text "(Or 'l' = reading list, 'h' = home, '0' = back.)"
      ]
  putStrLn ""
  query <- prompt "> "
  case map toLower query of
    "0" -> mainMenu name cart
    "h" -> mainMenu name cart
    "l" -> do
      newCart <- viewCart name cart
      searchByName name newCart
    _ -> do
      let results = authorByName query
      if null results
        then do
          putStrLn $ "No authors found matching \"" ++ query ++ "\"."
          mainMenu name cart
        else browseAuthors name cart results

-- ============================================================
-- ERA BROWSER
-- ============================================================

eraMenu :: String -> Cart -> IO ()
eraMenu name cart = do
  putStrLn ""
  putStrLn $ render $
    withBorder BorderRound $
    turquoise $
    box "Browse by Era"
      [ text "Enter a year range (e.g. 1980 to 2000)."
      , text "(At start year: 'l' = list, 'h' = home, '0' = back.)"
      ]
  putStrLn ""
  start <- prompt "Start year: "
  case map toLower start of
    "l" -> do
      newCart <- viewCart name cart
      eraMenu name newCart
    "h" -> mainMenu name cart
    "0" -> mainMenu name cart
    _ -> do
      end <- prompt "End year:   "
      case (reads start, reads end) of
        ([(s, "")], [(e, "")]) -> do
          let pairs = worksWithAuthors s e
          let ws    = sortByTitle (map fst pairs)
          let heading = "Published " ++ show s ++ "-" ++ show e
          browseWorks name cart heading ws
        _ -> do
          putStrLn "Invalid years. Please enter numbers."
          eraMenu name cart

-- ============================================================
-- MOST PROLIFIC
-- ============================================================

showMostProlific :: String -> Cart -> IO ()
showMostProlific name cart = do
  let top10 = take 10 mostProlificAuthors
  putStrLn ""
  putStrLn $ render $ center $
    orange $
    text "Top 10 Most Prolific Authors"
  putStrLn ""
  browseAuthors name cart top10

-- ============================================================
-- READING LIST / CART
-- ============================================================

viewCart :: String -> Cart -> IO Cart
viewCart name cart = do
  putStrLn ""
  let total = cartSize cart
      readN = length (filter snd cart)
  putStrLn $ render $ row
    [ sage   $ statusCard "Reader" name
    , orange $ statusCard "Reading List" (show total ++ " works")
    , withColor ColorBrightCyan $
        statusCard "Read" (show readN ++ " / " ++ show total)
    ]
  putStrLn ""
  if null cart
    then putStrLn $ render $
           withBorder BorderRound $
           turquoise $
           box "Reading List" [text "Your reading list is empty."]
    else putStrLn $ render $
           withBorder BorderRound $
           box (name ++ "'s Reading List")
             (map cartRowL (zip [1..] cart))
  putStrLn ""
  putStrLn $ render $
    withBorder BorderRound $
    orange $
    box "Commands"
      [ text "<n>     -- view work n's details"
      , text "r<n>    -- toggle read/unread for work n"
      , text "d<n>    -- remove work n from list"
      , text "[C] Clear list   [H] Home   [0] Back"
      ]
  putStrLn ""
  choice <- prompt "> "
  handleCartChoice name cart choice

handleCartChoice :: String -> Cart -> String -> IO Cart
handleCartChoice name cart choice =
  case map toLower choice of
    "0" -> return cart
    "h" -> mainMenu name cart >> return cart
    "c" -> do
      putStrLn "Reading list cleared."
      return []
    ('r':rest) -> case reads rest of
      [(n, "")] | n >= 1 && n <= cartSize cart -> do
        let (w, _) = cart !! (n - 1)
            newCart = toggleReadCart w cart
            newRead = isReadInCart w newCart
        putStrLn $ "Marked \"" ++ title w ++ "\" as " ++
                   (if newRead then "read." else "unread.")
        viewCart name newCart
      _ -> do
        putStrLn "Invalid input."
        viewCart name cart
    ('d':rest) -> case reads rest of
      [(n, "")] | n >= 1 && n <= cartSize cart -> do
        let (w, _) = cart !! (n - 1)
        putStrLn $ "Removed \"" ++ title w ++ "\" from reading list."
        viewCart name (removeFromCart w cart)
      _ -> do
        putStrLn "Invalid input."
        viewCart name cart
    _ -> case reads choice of
      [(n, "")] | n >= 1 && n <= cartSize cart -> do
        let (w, _) = cart !! (n - 1)
        case filter (\a -> authorId a == authorRef w) authors of
          (a:_) -> do
            newCart <- workDetail name cart w a Nothing
            viewCart name newCart
          [] -> do
            putStrLn "Author not found."
            viewCart name cart
      _ -> do
        putStrLn "Invalid input."
        viewCart name cart

cartRowL :: (Int, CartItem) -> L
cartRowL (i, (w, isRead)) =
  let mark = if isRead then sage $ text "[\10003]" else text "[ ]"
      authorPart = case filter (\a -> authorId a == authorRef w) authors of
        (a:_) -> [text "  by ", withColor ColorBrightWhite $ text (authorName a)]
        []    -> []
  in tightRow $
       [ mark
       , text " "
       , turquoise $ text (show i ++ ". " ++ title w)
       ]
       ++ authorPart ++
       [ text "  ["
       , amber $ text (showGenre (genre w))
       , text ", "
       , amber $ text (show (yearPub w))
       , text "]"
       ]

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