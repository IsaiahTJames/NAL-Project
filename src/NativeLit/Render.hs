{-# LANGUAGE OverloadedStrings #-}
module NativeLit.Render where

import NativeLit.Types
import NativeLit.Database
import NativeLit.Search
import NativeLit.Storage
import Data.Char (toLower)
import Data.List (intercalate, sortBy)
import Data.Ord (comparing, Down(..))
import System.IO (hSetBuffering, stdout, BufferMode(..), IOMode(..), withFile, hPutStrLn)
import System.Random (randomRIO)
import System.Directory (createDirectoryIfMissing, getHomeDirectory)
import System.FilePath ((</>))
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
-- SORT MODES
-- ============================================================

-- | Sort modes for author lists. Cycles in order shown.
data AuthorSort
  = AuthorByName
  | AuthorByWorkCount
  | AuthorByTribe
  deriving (Show, Eq, Enum, Bounded)

nextAuthorSort :: AuthorSort -> AuthorSort
nextAuthorSort s
  | s == maxBound = minBound
  | otherwise     = succ s

sortAuthors :: AuthorSort -> [Author] -> [Author]
sortAuthors AuthorByName      = sortBy (comparing (map toLower . authorName))
sortAuthors AuthorByWorkCount = sortBy (comparing (Down . length . worksByAuthor . authorId))
sortAuthors AuthorByTribe     = sortBy (comparing (showTribe . tribe))

authorSortLabel :: AuthorSort -> String
authorSortLabel AuthorByName      = "Name (A-Z)"
authorSortLabel AuthorByWorkCount = "Most Works"
authorSortLabel AuthorByTribe     = "Tribe (A-Z)"

-- | Sort modes for work lists.
data WorkSort
  = WorkByTitle
  | WorkByYearNew
  | WorkByYearOld
  | WorkByAuthor
  deriving (Show, Eq, Enum, Bounded)

nextWorkSort :: WorkSort -> WorkSort
nextWorkSort s
  | s == maxBound = minBound
  | otherwise     = succ s

sortWorks :: WorkSort -> [Work] -> [Work]
sortWorks WorkByTitle   = sortByTitle
sortWorks WorkByYearNew = sortBy (comparing (Down . yearPub))
sortWorks WorkByYearOld = sortByYear
sortWorks WorkByAuthor  = sortBy (comparing authorOfWorkName)
  where
    authorOfWorkName w = case authorOfWork w of
      Just a  -> map toLower (authorName a)
      Nothing -> ""

workSortLabel :: WorkSort -> String
workSortLabel WorkByTitle   = "Title (A-Z)"
workSortLabel WorkByYearNew = "Year (newest)"
workSortLabel WorkByYearOld = "Year (oldest)"
workSortLabel WorkByAuthor  = "Author (A-Z)"

-- ============================================================
-- APP STATE & PERSISTENCE
-- ============================================================

data AppState = AppState
  { stCart   :: Cart
  , stRecent :: [Work]
  } deriving Show

emptyAppState :: AppState
emptyAppState = AppState { stCart = [], stRecent = [] }

maxRecent :: Int
maxRecent = 10

touchRecent :: Work -> [Work] -> [Work]
touchRecent w ws = take maxRecent (w : filter (/= w) ws)

toSession :: AppState -> Session
toSession st = Session
  { sessionCart   = map (\(w, r) -> (workId w, r)) (stCart st)
  , sessionRecent = map workId (stRecent st)
  }

fromSession :: Session -> AppState
fromSession s = AppState
  { stCart   = [(w, r) | (i, r) <- sessionCart s
                       , Just w  <- [lookupWork i]]
  , stRecent = [w      | i      <- sessionRecent s
                       , Just w  <- [lookupWork i]]
  }
  where
    lookupWork i = case filter (\w -> workId w == i) works of
                     (w:_) -> Just w
                     []    -> Nothing

persist :: String -> AppState -> IO ()
persist name st = saveSession name (toSession st)

-- ============================================================
-- ENTRY POINT
-- ============================================================

runLibrary :: IO ()
runLibrary = do
  hSetBuffering stdout NoBuffering
  printBanner
  name <- getUsername
  session <- loadSession name
  let appState = fromSession session
  if null (stCart appState) && null (stRecent appState)
    then do
      putStrLn $ "\nWelcome, " ++ name ++ "!\n"
      mainMenu name appState
    else
      welcomeBack name appState

welcomeBack :: String -> AppState -> IO ()
welcomeBack name st = do
  let total  = cartSize (stCart st)
      readN  = length (filter snd (stCart st))
  putStrLn ""
  putStrLn $ render $ row
    [ sage   $ statusCard "Welcome back" name
    , orange $ statusCard "Reading List" (show total ++ " works")
    , turquoise $ statusCard "Read" (show readN ++ " / " ++ show total)
    ]
  putStrLn ""
  case stRecent st of
    []     -> return ()
    recent -> putStrLn $ render $
      withBorder BorderRound $
      turquoise $
      box "Recently Viewed"
        (map (text . formatRecentLine) (zip [1..] (take 5 recent)))
  putStrLn ""
  mainMenu name st

formatRecentLine :: (Int, Work) -> String
formatRecentLine (i, w) = show i ++ ". " ++ title w ++ " (" ++ show (yearPub w) ++ ")"

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
    else return name

-- ============================================================
-- MAIN MENU
-- ============================================================

mainMenu :: String -> AppState -> IO ()
mainMenu name st = do
  let cart = stCart st
  featured <- randomAuthor 
  
  putStrLn ""
  putStrLn $ render $ row
    [ sage   $ statusCard "Reader" name
    , orange $ statusCard "Reading List" (show (cartSize cart) ++ " works")
    ]
  
  putStrLn $ render $
    withBorder BorderDouble $
    amber $
    box "Featured Author Spotlight"
      [ tightRow [ amber $ text (authorName featured), text " (", turquoise $ text (showTribe (tribe featured)), text ")" ]
      , withColor ColorBrightWhite $ wrap 70 (biography featured)
      , text ""
      -- 🌟 Updated to Amber/Yellow text
      , tightRow [ turquoise $ text "[S] ", amber $ text "View this Author's Profile & Works" ] 
      ]

  putStrLn ""
  putStrLn $ render $ row
    [ withBorder BorderRound $
      turquoise $
      box "Library Navigation"
        [ tightRow [ turquoise $ text "[1] ", amber $ text "Browse All Authors" ]
        , tightRow [ turquoise $ text "[2] ", amber $ text "Filter by Tribe" ]
        , tightRow [ turquoise $ text "[3] ", amber $ text "Filter by Genre" ]
        , tightRow [ turquoise $ text "[4] ", amber $ text "Filter by Tribes & Genres" ]
        , tightRow [ turquoise $ text "[5] ", amber $ text "Search Author by Name" ]
        , tightRow [ turquoise $ text "[6] "
                   , amber $ text "Browse by Era "
                   , withColor ColorBrightWhite $ text "(Year Range)" ]
        , tightRow [ turquoise $ text "[7] ", amber $ text "Top 10 Most Prolific Authors" ]
        , tightRow [ turquoise $ text "[8] ", amber $ text "View Reading List" ]
        , tightRow [ turquoise $ text "[9] ", amber $ text "Quit" ]
        ]
    , withBorder BorderRound $
      orange $
      box "Special Features"
        [ tightRow [ text "[C] ", amber $ text "Curated Collections" ]
        , tightRow [ text "[V] ", amber $ text "Recently Viewed ", text ("(" ++ show (length (stRecent st)) ++ ")") ]
        , tightRow [ text "[R] ", amber $ text "Surprise me ", text "(random)" ]
        , tightRow [ text "[T] ", amber $ text "Library Stats" ]
        ]
    ]
  
  putStrLn ""
  choice <- prompt "> "
  case map toLower choice of
    "1" -> browseAuthors name st AuthorByName authors
    "2" -> tribeMenu name st
    "3" -> genreMenu name st
    "4" -> tribeAndGenreMenu name st
    "5" -> searchByName name st
    "6" -> eraMenu name st
    "7" -> showMostProlific name st
    "8" -> do
      newSt <- viewCart name st
      mainMenu name newSt
    "9" -> do
      persist name st
      putStrLn "\nGoodbye! Your reading list has been saved.\n"
    "c" -> curatedMenu name st
    -- 🌟 Now jumps STRAIGHT to the profile and captures the updated state
    "s" -> do
      newSt <- authorDetail name st featured
      mainMenu name newSt
    "v" -> do
      newSt <- viewRecent name st
      mainMenu name newSt
    "r" -> do
      newSt <- surpriseMe name st
      mainMenu name newSt
    "t" -> do
      showStats name st
      mainMenu name st
    _   -> do
      putStrLn "Invalid choice, try again."
      mainMenu name st

-- ============================================================
-- SURPRISE ME (random pick)
-- ============================================================

surpriseMe :: String -> AppState -> IO AppState
surpriseMe name st
  | null works = do
      putStrLn "No works in the library."
      return st
  | otherwise = do
      idx <- randomRIO (0, length works - 1)
      let w = works !! idx
      putStrLn ""
      putStrLn $ render $ center $
        orange $ text "*** Surprise pick! ***"
      case authorOfWork w of
        Just a  -> workDetail name st w a Nothing
        Nothing -> do
          putStrLn "Author not found for that work."
          return st

-- ============================================================
-- LIBRARY STATS
-- ============================================================

showStats :: String -> AppState -> IO ()
showStats _ st = do
  let totalAuthors = length authors
      totalWorks   = length works
      uniqueTribes = length (uniqueOn tribe authors)
      years        = map yearPub works
      yearRange    = (minimum years, maximum years)
      mostTribe    = mostFrequentBy (showTribe . tribe) authors
      mostProlific = case mostProlificAuthors of
                       (a:_) -> authorName a ++ " (" ++
                                show (length (worksByAuthor (authorId a))) ++
                                " works)"
                       []    -> "n/a"
      cart   = stCart st
      added  = cartSize cart
      readN  = length (filter snd cart)
  putStrLn ""
  putStrLn $ render $
    withBorder BorderDouble $
    turquoise $
    box "Library Stats"
      [ tightRow [ text "Total authors:        ", amber $ text (show totalAuthors) ]
      , tightRow [ text "Total works:          ", amber $ text (show totalWorks) ]
      , tightRow [ text "Tribes represented:   ", amber $ text (show uniqueTribes) ]
      , tightRow [ text "Year range:           "
                 , amber $ text (show (fst yearRange) ++ " - " ++ show (snd yearRange)) ]
      , tightRow [ text "Most-represented:     ", amber $ text mostTribe ]
      , tightRow [ text "Most prolific:        ", amber $ text mostProlific ]
      ]
  putStrLn ""
  putStrLn $ render $
    withBorder BorderRound $
    sage $
    box "Your Progress"
      [ tightRow [ text "Works in your list:   ", amber $ text (show added) ]
      , tightRow [ text "Works read:           "
                 , amber $ text (show readN ++ " / " ++ show added) ]
      ]
  putStrLn ""
  putStrLn $ render $ amber $
    text "Press Enter to return."
  _ <- getLine
  return ()

-- | Helper: get unique values when projected with f.
uniqueOn :: Eq b => (a -> b) -> [a] -> [b]
uniqueOn f = go . map f
  where go []     = []
        go (x:xs) = x : go (filter (/= x) xs)

-- | Helper: find the most frequent value when projected with f.
mostFrequentBy :: Eq b => (a -> b) -> [a] -> b
mostFrequentBy f xs =
  let groups = [(g, length (filter (\x -> f x == g) xs)) | g <- uniqueOn f xs]
      best   = sortBy (comparing (Down . snd)) groups
  in case best of
       ((g, _):_) -> g
       []         -> error "empty input to mostFrequentBy"

-- ============================================================
-- BROWSE AUTHORS (with sort modes)
-- ============================================================

browseAuthors :: String -> AppState -> AuthorSort -> [Author] -> IO ()
browseAuthors name st _ [] = do
  putStrLn "\nNo authors found.\n"
  mainMenu name st
browseAuthors name st sortMode filtered = do
  let cart   = stCart st
      sorted = sortAuthors sortMode filtered
  putStrLn ""
  putStrLn $ render $
    withBorder BorderRound $
    box ("Authors (" ++ show (length sorted) ++ ") -- sorted by " ++ authorSortLabel sortMode)
      (map (authorRowL cart) (zip [1..] sorted))
  putStrLn ""
  putStrLn $ render $ amber $
    text "[0] Back  |  [H] Home  |  [L] List  |  [S] Sort  |  Enter author #:"
  choice <- prompt "> "
  case map toLower choice of
    "0" -> mainMenu name st
    "h" -> mainMenu name st
    "s" -> browseAuthors name st (nextAuthorSort sortMode) filtered
    "l" -> do
      newSt <- viewCart name st
      browseAuthors name newSt sortMode filtered
    _ -> case reads choice of
      [(n, "")] | n >= 1 && n <= length sorted -> do
        newSt <- authorDetail name st (sorted !! (n - 1))
        browseAuthors name newSt sortMode filtered
      _ -> do
        putStrLn "Invalid choice."
        browseAuthors name st sortMode filtered

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

browseAuthorsInGenre :: String -> AppState -> Genre -> [Author] -> IO ()
browseAuthorsInGenre name st _ [] = do
  putStrLn "\nNo authors found.\n"
  mainMenu name st
browseAuthorsInGenre name st g filtered = do
  let cart = stCart st
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
    "0" -> mainMenu name st
    "h" -> mainMenu name st
    "l" -> do
      newSt <- viewCart name st
      browseAuthorsInGenre name newSt g filtered
    _ -> case reads choice of
      [(n, "")] | n >= 1 && n <= length filtered -> do
        newSt <- authorDetailInGenre name st g (filtered !! (n - 1))
        browseAuthorsInGenre name newSt g filtered
      _ -> do
        putStrLn "Invalid choice."
        browseAuthorsInGenre name st g filtered

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

authorDetailInGenre :: String -> AppState -> Genre -> Author -> IO AppState
authorDetailInGenre name st g a = do
  let cart = stCart st
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
      let newCart = foldl (flip addToCart) cart newWorks
          newSt   = st { stCart = newCart }
      persist name newSt
      return newSt
    "0" -> return st
    "h" -> mainMenu name st >> return st
    "l" -> do
      newSt <- viewCart name st
      authorDetailInGenre name newSt g a
    _ -> case reads choice of
      [(n, "")] | n >= 1 && n <= length ws -> do
        newSt <- workDetail name st (ws !! (n - 1)) a Nothing
        authorDetailInGenre name newSt g a
      _ -> do
        putStrLn "Invalid choice."
        authorDetailInGenre name st g a

-- ============================================================
-- BROWSE WORKS (with sort modes)
-- ============================================================

browseWorks :: String -> AppState -> String -> [Work] -> IO ()
browseWorks name st heading filtered =
  browseWorksSorted name st heading WorkByTitle filtered

browseWorksSorted :: String -> AppState -> String -> WorkSort -> [Work] -> IO ()
browseWorksSorted name st _ _ [] = do
  putStrLn $ render $
    withBorder BorderRound $
    amber $
    box "No works found"
      [ text "Try removing or changing some of your filters." ]
  mainMenu name st
browseWorksSorted name st heading sortMode filtered = do
  let cart   = stCart st
      sorted = sortWorks sortMode filtered
      headingText = heading ++ " (" ++ show (length sorted) ++ ") -- sorted by " ++ workSortLabel sortMode
  putStrLn ""
  putStrLn $ render $ turquoise $ text ("--- " ++ headingText ++ " ---")
  putStrLn ""
  mapM_ (\iw -> putStrLn (render (workRowL cart iw))) (zip [1..] sorted)
  putStrLn ""
  putStrLn $ render $ amber $
    text "[0] Back  |  [H] Home  |  [L] List  |  [S] Sort  |  Enter work #:"
  choice <- prompt "> "
  case map toLower choice of
    "0" -> mainMenu name st
    "h" -> mainMenu name st
    "s" -> browseWorksSorted name st heading (nextWorkSort sortMode) filtered
    "l" -> do
      newSt <- viewCart name st
      browseWorksSorted name newSt heading sortMode filtered
    _ -> case reads choice of
      [(n, "")] | n >= 1 && n <= length sorted -> do
        let w = sorted !! (n - 1)
        case authorOfWork w of
          Just a -> do
            let sideTrip s' = authorDetail name s' a
            newSt <- workDetail name st w a (Just sideTrip)
            browseWorksSorted name newSt heading sortMode filtered
          Nothing -> do
            putStrLn "Author not found for this work."
            browseWorksSorted name st heading sortMode filtered
      _ -> do
        putStrLn "Invalid choice."
        browseWorksSorted name st heading sortMode filtered

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

authorDetail :: String -> AppState -> Author -> IO AppState
authorDetail name st a = do
  let cart = stCart st
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
      let newCart = foldl (flip addToCart) cart newWorks
          newSt   = st { stCart = newCart }
      persist name newSt
      return newSt
    "0" -> return st
    "h" -> mainMenu name st >> return st
    "l" -> do
      newSt <- viewCart name st
      authorDetail name newSt a
    _ -> case reads choice of
      [(n, "")] | n >= 1 && n <= length ws -> do
        newSt <- workDetail name st (ws !! (n - 1)) a Nothing
        authorDetail name newSt a
      _ -> do
        putStrLn "Invalid choice."
        authorDetail name st a

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

workDetail :: String -> AppState -> Work -> Author
           -> Maybe (AppState -> IO AppState)
           -> IO AppState
workDetail name st w a mSideTrip = do
  let stTouched = st { stRecent = touchRecent w (stRecent st) }
  persist name stTouched
  workDetailLoop name stTouched w a mSideTrip

workDetailLoop :: String -> AppState -> Work -> Author
               -> Maybe (AppState -> IO AppState)
               -> IO AppState
workDetailLoop name st w a mSideTrip = do
  let cart = stCart st
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
  let handleMore s' = case mSideTrip of
                       Just sideTrip -> sideTrip s'
                       Nothing       -> do
                         putStrLn "Not available here."
                         workDetailLoop name s' w a mSideTrip
  choice <- prompt "> "
  let saveAnd newCart = do
        let newSt = st { stCart = newCart }
        persist name newSt
        return newSt
  case map toLower choice of
    "a" | not isIn -> do
      putStrLn $ "Added \"" ++ title w ++ "\" to reading list!"
      saveAnd (addToCart w cart)
    "r" | isIn -> do
      putStrLn $ "Removed \"" ++ title w ++ "\" from reading list."
      saveAnd (removeFromCart w cart)
    "k" | isIn && not isRead -> do
      putStrLn $ "Marked \"" ++ title w ++ "\" as read."
      saveAnd (toggleReadCart w cart)
    "u" | isIn && isRead -> do
      putStrLn $ "Marked \"" ++ title w ++ "\" as unread."
      saveAnd (toggleReadCart w cart)
    "l" -> do
      newSt <- viewCart name st
      workDetailLoop name newSt w a mSideTrip
    "h" -> mainMenu name st >> return st
    "m" -> handleMore st
    _   -> return st

-- ============================================================
-- FILTER MENUS
-- ============================================================

tribeMenu :: String -> AppState -> IO ()
tribeMenu name st = do
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
    "0" -> mainMenu name st
    "h" -> mainMenu name st
    "l" -> do
      newSt <- viewCart name st
      tribeMenu name newSt
    _ -> case reads choice of
      [(n, "")] | n >= 1 && n <= length tribes -> do
        let t = tribes !! (n - 1)
        let filtered = authorsByTribe t
        if null filtered
          then do
            putStrLn $ render $
              withBorder BorderRound $ amber $
              box ("No authors from " ++ showTribe t)
                [ text "This tribe has no authors in the database yet." ]
            tribeMenu name st
           else do
              viewTribeInfo name st t
      _ -> do
        putStrLn "Invalid choice."
        tribeMenu name st

genreMenu :: String -> AppState -> IO ()
genreMenu name st = do
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
    "0" -> mainMenu name st
    "h" -> mainMenu name st
    "l" -> do
      newSt <- viewCart name st
      genreMenu name newSt
    _ -> case reads choice of
      [(n, "")] | n >= 1 && n <= length genres -> do
        let g = genres !! (n - 1)
        let ws = worksByGenre g
        browseWorks name st (showGenre g) ws
      _ -> do
        putStrLn "Invalid choice."
        genreMenu name st

tribeAndGenreMenu :: String -> AppState -> IO ()
tribeAndGenreMenu name st =
  multiFilterMenu name st [] []

multiFilterMenu :: String -> AppState -> [Tribe] -> [Genre] -> IO ()
multiFilterMenu name st selTribes selGenres = do
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
    "0" -> mainMenu name st
    "h" -> mainMenu name st
    "c" -> multiFilterMenu name st [] []
    "l" -> do
      newSt <- viewCart name st
      multiFilterMenu name newSt selTribes selGenres
    "a" -> do
      let ws = worksByTribesAndGenres selTribes selGenres
      let heading = buildFilterHeading selTribes selGenres
      browseWorks name st heading ws
    ('t':rest) -> case reads rest of
      [(n, "")] | n >= 1 && n <= length filterTribes ->
        let t = filterTribes !! (n - 1)
            newSel = toggle t selTribes
        in multiFilterMenu name st newSel selGenres
      _ -> invalid
    ('g':rest) -> case reads rest of
      [(n, "")] | n >= 1 && n <= length filterGenres ->
        let g = filterGenres !! (n - 1)
            newSel = toggle g selGenres
        in multiFilterMenu name st selTribes newSel
      _ -> invalid
    _ -> invalid
  where
    invalid = do
      putStrLn "Invalid input. Use t<n>, g<n>, a, c, l, h, or 0."
      multiFilterMenu name st selTribes selGenres

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

searchByName :: String -> AppState -> IO ()
searchByName name st = do
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
    "0" -> mainMenu name st
    "h" -> mainMenu name st
    "l" -> do
      newSt <- viewCart name st
      searchByName name newSt
    _ -> do
      let results = authorByName query
      if null results
        then do
          putStrLn $ render $
            withBorder BorderRound $ amber $
            box "No authors found"
              [ text $ "Nothing matched \"" ++ query ++ "\". Try a partial name." ]
          mainMenu name st
        else browseAuthors name st AuthorByName results

-- ============================================================
-- View TribeInfo
-- ============================================================
viewTribeInfo :: String -> AppState -> Tribe -> IO ()
viewTribeInfo name st t = do
  putStrLn ""
  putStrLn $ render $
    withBorder BorderDouble $
    amber $
    box (showTribe t ++ " Nation")
      [ withColor ColorBrightWhite $ wrap 70 (tribeInfo t) ]
  
  let filtered = authorsByTribe t
  putStrLn ""
  putStrLn $ render $ turquoise $ text "Press Enter to browse authors from this nation..."
  _ <- getLine
  browseAuthors name st AuthorByName filtered

-- ============================================================
-- ERA BROWSER
-- ============================================================

eraMenu :: String -> AppState -> IO ()
eraMenu name st = do
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
      newSt <- viewCart name st
      eraMenu name newSt
    "h" -> mainMenu name st
    "0" -> mainMenu name st
    _ -> do
      end <- prompt "End year:   "
      case (reads start, reads end) of
        ([(s, "")], [(e, "")]) -> do
          let pairs = worksWithAuthors s e
          let ws    = map fst pairs
          let heading = "Published " ++ show s ++ "-" ++ show e
          browseWorks name st heading ws
        _ -> do
          putStrLn "Invalid years. Please enter numbers."
          eraMenu name st

-- ============================================================
-- MOST PROLIFIC
-- ============================================================

showMostProlific :: String -> AppState -> IO ()
showMostProlific name st = do
  let top10 = take 10 mostProlificAuthors
  putStrLn ""
  putStrLn $ render $ center $
    orange $
    text "Top 10 Most Prolific Authors"
  putStrLn ""
  browseAuthors name st AuthorByWorkCount top10

-- ============================================================
-- READING LIST / CART
-- ============================================================

viewCart :: String -> AppState -> IO AppState
viewCart name st = do
  let cart = stCart st
  putStrLn ""
  let total = cartSize cart
      readN = length (filter snd cart)
  putStrLn $ render $ row
    [ sage   $ statusCard "Reader" name
    , orange $ statusCard "Reading List" (show total ++ " works")
    , turquoise $ statusCard "Read" (show readN ++ " / " ++ show total)
    ]
  putStrLn ""
  if null cart
    then putStrLn $ render $
           withBorder BorderRound $
           turquoise $
           box "Reading List"
             [ text "Your reading list is empty."
             , text "Browse and use [A] on any work to add it."
             ]
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
      , text "[E] Export to text file"
      , text "[C] Clear list   [H] Home   [0] Back"
      ]
  putStrLn ""
  choice <- prompt "> "
  handleCartChoice name st choice

handleCartChoice :: String -> AppState -> String -> IO AppState
handleCartChoice name st choice =
  let cart = stCart st
      saveAnd newCart = do
        let newSt = st { stCart = newCart }
        persist name newSt
        return newSt
  in case map toLower choice of
    "0" -> return st
    "h" -> mainMenu name st >> return st
    "c" -> do
      putStrLn "Reading list cleared."
      newSt <- saveAnd []
      return newSt
    "e" -> do
      exportReadingList name st
      viewCart name st
    ('r':rest) -> case reads rest of
      [(n, "")] | n >= 1 && n <= cartSize cart -> do
        let (w, _) = cart !! (n - 1)
            newCart = toggleReadCart w cart
            newRead = isReadInCart w newCart
        putStrLn $ "Marked \"" ++ title w ++ "\" as " ++
                   (if newRead then "read." else "unread.")
        newSt <- saveAnd newCart
        viewCart name newSt
      _ -> do
        putStrLn "Invalid input."
        viewCart name st
    ('d':rest) -> case reads rest of
      [(n, "")] | n >= 1 && n <= cartSize cart -> do
        let (w, _) = cart !! (n - 1)
        putStrLn $ "Removed \"" ++ title w ++ "\" from reading list."
        newSt <- saveAnd (removeFromCart w cart)
        viewCart name newSt
      _ -> do
        putStrLn "Invalid input."
        viewCart name st
    _ -> case reads choice of
      [(n, "")] | n >= 1 && n <= cartSize cart -> do
        let (w, _) = cart !! (n - 1)
        case filter (\a -> authorId a == authorRef w) authors of
          (a:_) -> do
            newSt <- workDetail name st w a Nothing
            viewCart name newSt
          [] -> do
            putStrLn "Author not found."
            viewCart name st
      _ -> do
        putStrLn "Invalid input."
        viewCart name st

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
-- EXPORT READING LIST TO TEXT FILE
-- ============================================================

exportReadingList :: String -> AppState -> IO ()
exportReadingList name st = do
  let cart = stCart st
  if null cart
    then putStrLn "Your reading list is empty -- nothing to export."
    else do
      home <- getHomeDirectory
      let dir  = home </> ".nativelit"
          path = dir </> (sanitizeName name ++ "-reading-list.txt")
      createDirectoryIfMissing True dir
      withFile path WriteMode $ \h -> do
        hPutStrLn h ("Reading List for " ++ name)
        hPutStrLn h (replicate 50 '=')
        hPutStrLn h ""
        let total = cartSize cart
            readN = length (filter snd cart)
        hPutStrLn h ("Total: " ++ show total ++ " works  |  Read: " ++
                     show readN ++ " / " ++ show total)
        hPutStrLn h ""
        mapM_ (writeCartLine h) (zip [1..] cart)
      putStrLn $ render $
        withBorder BorderRound $ sage $
        box "Exported"
          [ text $ "Reading list saved to:"
          , amber $ text path
          ]
  where
    writeCartLine h (i, (w, isRead)) = do
      let mark = if isRead then "[X]" else "[ ]"
          author = case filter (\a -> authorId a == authorRef w) authors of
            (a:_) -> authorName a
            []    -> "Unknown"
      hPutStrLn h $ mark ++ " " ++ show i ++ ". " ++ title w
      hPutStrLn h $ "    by " ++ author ++
                    "  [" ++ showGenre (genre w) ++ ", " ++
                    show (yearPub w) ++ "]"
      hPutStrLn h $ "    \"" ++ excerpt w ++ "\""
      hPutStrLn h ""

sanitizeName :: String -> String
sanitizeName = filter (`elem` (['a'..'z'] ++ ['0'..'9'])) . map toLower

-- ============================================================
-- RECENTLY VIEWED
-- ============================================================

viewRecent :: String -> AppState -> IO AppState
viewRecent name st = do
  putStrLn ""
  let recent = stRecent st
  if null recent
    then do
      putStrLn $ render $
        withBorder BorderRound $ turquoise $
        box "Recently Viewed"
          [ text "You haven't viewed any works yet."
          , text "Browse around and they'll show up here."
          ]
      mainMenu name st >> return st
    else do
      putStrLn $ render $
        withBorder BorderRound $ turquoise $
        box ("Recently Viewed (" ++ show (length recent) ++ ")")
          (map (recentRowL (stCart st)) (zip [1..] recent))
      putStrLn ""
      putStrLn $ render $ amber $
        text "[H] Home  |  [0] Back  |  Enter number to revisit:"
      choice <- prompt "> "
      case map toLower choice of
        "0" -> return st
        "h" -> mainMenu name st >> return st
        _ -> case reads choice of
          [(n, "")] | n >= 1 && n <= length recent -> do
            let w = recent !! (n - 1)
            case filter (\a -> authorId a == authorRef w) authors of
              (a:_) -> do
                newSt <- workDetail name st w a Nothing
                viewRecent name newSt
              [] -> do
                putStrLn "Author not found."
                viewRecent name st
          _ -> do
            putStrLn "Invalid input."
            viewRecent name st

recentRowL :: Cart -> (Int, Work) -> L
recentRowL cart (i, w) =
  let isIn   = inCart w cart
      isRead = isReadInCart w cart
      authorPart = case filter (\a -> authorId a == authorRef w) authors of
        (a:_) -> [text "  by ", withColor ColorBrightWhite $ text (authorName a)]
        []    -> []
      statusPart
        | isRead    = [sage  $ text "  [\10003 read]"]
        | isIn      = [amber $ text "  [in list]"]
        | otherwise = []
  in tightRow $
       [ turquoise $ text (show i ++ ". " ++ title w)
       , amber     $ text (" (" ++ show (yearPub w) ++ ")")
       ] ++ authorPart ++ statusPart

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

-- ============================================================
-- Curated Menu
-- ============================================================

curatedMenu :: String -> AppState -> IO ()
curatedMenu name st = do
  let collections = [IntroToPoetry, AwardWinners, ModernHorror, HeritageMemoirs]
  putStrLn ""
  putStrLn $ render $
    withBorder BorderRound $
    turquoise $
    box "Curated Collections"
      (map (\(i, col) -> tightRow
              [ turquoise $ text (show i ++ ". ")
              , amber     $ text (collectionTitle col)
              ])
           (zip [1..] collections))
  putStrLn ""
  choice <- prompt "Pick a collection # (or [0] for Back): "
  case choice of
    "0" -> mainMenu name st
    _   -> case reads choice of
      [(n, "")] | n >= 1 && n <= length collections -> do
        let col = collections !! (n - 1)
        let ws = getCollectionWorks col
        browseWorks name st (collectionTitle col) ws
      _ -> do
        putStrLn "Invalid choice."
        curatedMenu name st