module NativeLit.Types where

-- | Tribal nation affiliation
data Tribe
  = Navajo
  | Cherokee
  | Lakota
  | Apache
  | Choctaw
  | Osage
  | Pueblo
  | Sioux
  | Muscogee
  | Blackfeet
  | Coeur_dAlene
  | Chickasaw
  | Anishinaabe
  | Ojibwe
  | HoChunk
  | Mohawk
  | Mojave
  | Cree
  | Metis
  | Ojicree
  | OtherTribe String
  deriving (Show, Eq)

-- | Broad literary genre
data Genre
  = Poetry
  | Memoir
  | LiteraryFiction
  | Nonfiction
  | ShortStory
  | Mythology
  | Autobiography
  deriving (Show, Eq)

-- | A Native American author or poet
data Author = Author
  { authorId   :: Int
  , authorName :: String
  , tribe      :: Tribe
  , birthYear  :: Int
  , biography  :: String
  } deriving (Show, Eq)

-- | A literary work
data Work = Work
  { workId    :: Int
  , title     :: String
  , authorRef :: Int
  , genre     :: Genre
  , yearPub   :: Int
  , excerpt   :: String
  } deriving (Show, Eq)