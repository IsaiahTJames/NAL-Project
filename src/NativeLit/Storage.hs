{-# LANGUAGE LambdaCase #-}
module NativeLit.Storage
  ( saveSession
  , loadSession
  , clearSession
  , Session(..)
  , emptySession
  ) where

import           Control.Exception      (catch, SomeException)
import           Data.Char              (isAlphaNum, toLower)
import           NativeLit.Types        (Work(..), Author(..))
import           NativeLit.Database     (works, authors)
import           System.Directory       (createDirectoryIfMissing,
                                         doesFileExist,
                                         getHomeDirectory,
                                         removeFile)
import           System.FilePath        ((</>))
import           System.IO              (IOMode(..), hClose, hPutStr,
                                         openFile, hGetContents)

-- | A saved session for a user: their reading list and recently viewed works.
data Session = Session
  { sessionCart    :: [(Int, Bool)]   -- (workId, isRead)
  , sessionRecent  :: [Int]           -- recently viewed workIds, newest first
  } deriving (Show, Read)

emptySession :: Session
emptySession = Session { sessionCart = [], sessionRecent = [] }

-- | Sanitize a username into a safe filename (lowercase alphanumeric only).
--   "Isaiah James" becomes "isaiahjames".
sanitize :: String -> String
sanitize = filter isAlphaNum . map toLower

-- | Path to the data directory: ~/.nativelit/
dataDir :: IO FilePath
dataDir = do
  home <- getHomeDirectory
  return (home </> ".nativelit")

-- | Path to the save file for a given username.
sessionPath :: String -> IO FilePath
sessionPath name = do
  dir <- dataDir
  return (dir </> (sanitize name ++ ".session"))

-- | Persist a session to disk for the given username.
--   Creates ~/.nativelit/ if it doesn't exist.
--   Silently swallows errors so a save failure never crashes the app.
saveSession :: String -> Session -> IO ()
saveSession name s = do
  (do
     dir  <- dataDir
     createDirectoryIfMissing True dir
     path <- sessionPath name
     -- Use openFile + hClose explicitly so we don't hold onto a handle.
     h <- openFile path WriteMode
     hPutStr h (show s)
     hClose h)
   `catch` (\e -> do
     let _ = (e :: SomeException)
     return ())

-- | Load a saved session for the given username.
--   Returns emptySession if no file exists or the file is corrupt.
loadSession :: String -> IO Session
loadSession name = do
  path   <- sessionPath name
  exists <- doesFileExist path
  if not exists
    then return emptySession
    else do
      result <- (do
        h <- openFile path ReadMode
        contents <- hGetContents h
        -- Force evaluation before closing handle (lazy IO trap).
        let !parsed = case reads contents of
                        [(s, _)] -> Just s
                        _        -> Nothing
        hClose h
        return parsed)
       `catch` (\e -> do
         let _ = (e :: SomeException)
         return Nothing)
      case result of
        Just s  -> return s
        Nothing -> return emptySession

-- | Delete the saved session file for a given username.
clearSession :: String -> IO ()
clearSession name = do
  path <- sessionPath name
  exists <- doesFileExist path
  if exists then removeFile path else return ()
   `catch` (\e -> do
     let _ = (e :: SomeException)
     return ())