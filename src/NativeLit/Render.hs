module NativeLit.Render where

import Graphics.Gloss
import Graphics.Gloss.Interface.Pure.Game
import NativeLit.Types
import NativeLit.Database
import NativeLit.Search

-- | App state
data AppState = AppState
  { scrollOffset   :: Float
  , selectedAuthor :: Maybe Int
  }

initState :: AppState
initState = AppState { scrollOffset = 0, selectedAuthor = Nothing }

window :: Display
window = InWindow "Native American Literary Library" (900, 700) (100, 50)

background :: Color
background = makeColorI 20 20 30 255

runLibrary :: IO ()
runLibrary = play window background 30 initState drawState handleInput updateState

-- | Drawing
drawState :: AppState -> Picture
drawState state =
  pictures
    [ drawTitle
    , translate 0 (scrollOffset state) $ drawAuthorList (selectedAuthor state)
    ]

drawTitle :: Picture
drawTitle =
  translate (-380) 310 $
  scale 0.18 0.18 $
  color (makeColorI 210 160 80 255) $
  text "Native American Literary Library"

drawAuthorList :: Maybe Int -> Picture
drawAuthorList sel =
  pictures $ zipWith (drawAuthorEntry sel) [0..] authors

drawAuthorEntry :: Maybe Int -> Int -> Author -> Picture
drawAuthorEntry sel i a =
  translate (-380) (240 - fromIntegral i * 55) $
  pictures
    [ -- highlight selected
      case sel of
        Just sid | sid == authorId a ->
          color (makeColorI 60 40 20 180) $
          translate 180 8 $
          rectangleSolid 760 48
        _ -> blank
    , color (makeColorI 180 120 60 255) $
      scale 0.14 0.14 $
      text (authorName a)
    , translate 0 (-18) $
      color (makeColorI 140 200 160 255) $
      scale 0.09 0.09 $
      text (showTribe (tribe a) ++ "  |  " ++ show (length (worksByAuthor (authorId a))) ++ " works")
    , case sel of
        Just sid | sid == authorId a ->
          translate 0 (-38) $
          drawWorks (worksByAuthor (authorId a))
        _ -> blank
    ]

drawWorks :: [Work] -> Picture
drawWorks ws =
  pictures $ zipWith drawWorkLine [0..] ws
  where
    drawWorkLine i w =
      translate 20 (- fromIntegral i * 22) $
      color (makeColorI 200 180 140 255) $
      scale 0.08 0.08 $
      text ("- " ++ title w ++ " (" ++ show (yearPub w) ++ ")")

-- | Input handling
handleInput :: Event -> AppState -> AppState
handleInput (EventKey (SpecialKey KeyUp) Down _ _) state =
  state { scrollOffset = scrollOffset state - 40 }
handleInput (EventKey (SpecialKey KeyDown) Down _ _) state =
  state { scrollOffset = scrollOffset state + 40 }
handleInput (EventKey (MouseButton LeftButton) Down _ (mx, my)) state =
  state { selectedAuthor = clickedAuthor mx my (scrollOffset state) }
handleInput _ state = state

clickedAuthor :: Float -> Float -> Float -> Maybe Int
clickedAuthor _ my offset =
  let adjustedY = my - offset
      i = round ((240 - adjustedY) / 55) :: Int
  in if i >= 0 && i < length authors
     then Just (authorId (authors !! i))
     else Nothing

-- | No time-based updates needed
updateState :: Float -> AppState -> AppState
updateState _ state = state

-- | Convert tribe to display string
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