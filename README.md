Native American Literary Library (NAL Project)
This project is a Haskell-based digital archive designed to catalog and explore Indigenous literature. It provides a structured environment to browse authors and works while maintaining cultural and historical context.

Core Features
Database: A comprehensive collection of entries including titles, genres, page counts, publishers, and award history.

Featured Author Spotlight: A startup routine that randomly selects an author to display their biography and bibliography.

Categorical Filtering: Navigation systems to sort the library by tribal affiliation, literary genre, and publication era.

Reading List Persistence: A session-management system that saves user-selected books to a local file for future access.

Terminal User Interface: A command-line interface utilizing ANSI color coding and double-bordered layouts for data organization.

Technical Architecture
Types.hs: Defines the core data structures for authors, literary works, and application state.

Database.hs: Contains the primary data records for all 102 works, author profiles, and tribal histories.

Render.hs: Manages the interface logic, including menu rendering and visual formatting.

Search.hs: Implements the logic for filtering and selecting data based on user input.

Storage.hs: Handles file input/output operations for the persistent reading list.

Build Instructions
Build: cabal build

Execution: cabal run