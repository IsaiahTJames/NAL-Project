module NativeLit.Database where

import NativeLit.Types

authors :: [Author]
authors =
  [ Author
      { authorId   = 1
      , authorName = "Joy Harjo"
      , tribe      = Muscogee
      , birthYear  = 1951
      , biography  = "Joy Harjo is the first Native American US Poet Laureate. A member of the Muscogee Nation, her work weaves together personal and collective memory, nature, and justice."
      }
  , Author
      { authorId   = 2
      , authorName = "Sherman Alexie"
      , tribe      = Sioux
      , birthYear  = 1966
      , biography  = "Sherman Alexie is a Spokane/Coeur d Alene author known for his sharp humor and unflinching portrayal of life on and off the reservation."
      }
  , Author
      { authorId   = 3
      , authorName = "Louise Erdrich"
      , tribe      = Ojibwe
      , birthYear  = 1954
      , biography  = "Louise Erdrich is a Pulitzer Prize-winning novelist and member of the Turtle Mountain Band of Chippewa. Her novels explore the lives of Native Americans in the Great Plains."
      }
  , Author
      { authorId   = 4
      , authorName = "N. Scott Momaday"
      , tribe      = OtherTribe "Kiowa"
      , birthYear  = 1934
      , biography  = "N. Scott Momaday is a Kiowa author and the first Native American to win the Pulitzer Prize for Fiction, awarded for House Made of Dawn in 1969."
      }
  , Author
      { authorId   = 5
      , authorName = "Leslie Marmon Silko"
      , tribe      = Pueblo
      , birthYear  = 1948
      , biography  = "Leslie Marmon Silko is a Laguna Pueblo author whose work draws on oral tradition, landscape, and community to explore Native American identity and survival."
      }
  , Author
      { authorId   = 6
      , authorName = "Luci Tapahonso"
      , tribe      = Navajo
      , birthYear  = 1953
      , biography  = "Luci Tapahonso is the first Poet Laureate of the Navajo Nation. Born in Shiprock, New Mexico, her poetry is deeply rooted in Dine language, landscape, and oral tradition."
      }
  , Author
      { authorId   = 7
      , authorName = "Simon J. Ortiz"
      , tribe      = Pueblo
      , birthYear  = 1941
      , biography  = "Simon J. Ortiz is an Acoma Pueblo poet and storyteller regarded as one of the most important voices in Native American literature."
      }
  , Author
      { authorId   = 8
      , authorName = "James Welch"
      , tribe      = Blackfeet
      , birthYear  = 1940
      , biography  = "James Welch was a Blackfeet and Gros Ventre novelist and poet whose work explored the history and contemporary life of Native Americans in Montana."
      }
  , Author
      { authorId   = 9
      , authorName = "Janet Campbell Hale"
      , tribe      = Coeur_dAlene
      , birthYear  = 1947
      , biography  = "Janet Campbell Hale is a Coeur d Alene author known for her novels and memoir exploring Native American identity, poverty, and survival."
      }
  , Author
      { authorId   = 10
      , authorName = "Gerald Vizenor"
      , tribe      = Anishinaabe
      , birthYear  = 1934
      , biography  = "Gerald Vizenor is an Anishinaabe author and scholar known for his concept of survivance and his trickster narratives that challenge colonial representations of Native peoples."
      }
  , Author
      { authorId   = 11
      , authorName = "Vine Deloria Jr."
      , tribe      = Sioux
      , birthYear  = 1933
      , biography  = "Vine Deloria Jr. was a Standing Rock Sioux author, theologian, and activist best known for Custer Died for Your Sins, a landmark work of Native American political thought."
      }
  , Author
      { authorId   = 12
      , authorName = "Linda Hogan"
      , tribe      = Chickasaw
      , birthYear  = 1947
      , biography  = "Linda Hogan is a Chickasaw poet, novelist, and essayist whose work centers on the relationship between humans, animals, and the natural world."
      }
  , Author
      { authorId   = 13
      , authorName = "LeAnne Howe"
      , tribe      = Choctaw
      , birthYear  = 1951
      , biography  = "LeAnne Howe is a Choctaw novelist, poet, and playwright known for weaving together Native oral tradition, history, and humor in her work."
      }
  , Author
      { authorId   = 14
      , authorName = "Susan Power"
      , tribe      = Sioux
      , birthYear  = 1961
      , biography  = "Susan Power is a Standing Rock Sioux author whose debut novel The Grass Dancer won the PEN/Hemingway Award and explores generations of Sioux family life."
      }
  , Author
      { authorId   = 15
      , authorName = "Thomas King"
      , tribe      = Cherokee
      , birthYear  = 1943
      , biography  = "Thomas King is a Cherokee Canadian author and broadcaster known for his sharp wit and exploration of Native identity in both his fiction and nonfiction."
      }
  , Author
      { authorId   = 16
      , authorName = "Eddie Chuculate"
      , tribe      = OtherTribe "Creek/Cherokee"
      , birthYear  = 1966
      , biography  = "Eddie Chuculate is a Creek and Cherokee author whose short story collection Cheyenne Madonna won the Iowa Short Fiction Award."
      }
  , Author
      { authorId   = 17
      , authorName = "Heid E. Erdrich"
      , tribe      = Ojibwe
      , birthYear  = 1963
      , biography  = "Heid E. Erdrich is an Ojibwe poet and editor known for her experimental work exploring Native identity, science, and language."
      }
  , Author
      { authorId   = 18
      , authorName = "Natalie Diaz"
      , tribe      = Mojave
      , birthYear  = 1978
      , biography  = "Natalie Diaz is a Mojave poet and MacArthur Fellow whose work explores language, the body, addiction, and the landscapes of the American Southwest."
      }
  , Author
      { authorId   = 19
      , authorName = "Cherie Dimaline"
      , tribe      = Metis
      , birthYear  = 1975
      , biography  = "Cherie Dimaline is a Metis author from Georgian Bay whose dystopian novel The Marrow Thieves became a celebrated work of Canadian Indigenous literature."
      }
  , Author
      { authorId   = 20
      , authorName = "Brandon Hobson"
      , tribe      = Cherokee
      , birthYear  = 1974
      , biography  = "Brandon Hobson is a Cherokee Nation author whose novel Where the Dead Sit Talking was a National Book Award finalist and explores Native foster youth."
      }
  , Author
      { authorId   = 21
      , authorName = "Rebecca Roanhorse"
      , tribe      = OtherTribe "Ohkay Owingeh"
      , birthYear  = 1971
      , biography  = "Rebecca Roanhorse is an Ohkay Owingeh author known for her Nebula and Hugo Award-winning science fiction and fantasy rooted in Indigenous worldviews."
      }
  , Author
      { authorId   = 22
      , authorName = "Stephen Graham Jones"
      , tribe      = Blackfeet
      , birthYear  = 1972
      , biography  = "Stephen Graham Jones is a Blackfeet author and professor known for his prolific output of horror and literary fiction, including the acclaimed The Only Good Indians."
      }
  , Author
      { authorId   = 23
      , authorName = "Robin Wall Kimmerer"
      , tribe      = OtherTribe "Potawatomi"
      , birthYear  = 1953
      , biography  = "Robin Wall Kimmerer is a Potawatomi botanist and author whose book Braiding Sweetgrass weaves together Indigenous wisdom and Western science."
      }
  , Author
      { authorId   = 24
      , authorName = "Layli Long Soldier"
      , tribe      = Lakota
      , birthYear  = 1973
      , biography  = "Layli Long Soldier is an Oglala Lakota poet whose collection WHEREAS responds directly to the US government apology to Native peoples and won the National Book Critics Circle Award."
      }
  , Author
      { authorId   = 25
      , authorName = "Jake Skeets"
      , tribe      = Navajo
      , birthYear  = 1991
      , biography  = "Jake Skeets is a Navajo poet from the Tsalie/Wheatfields area of the Navajo Nation whose debut collection Eyes Bottle Dark with a Mouthful of Flowers won the National Poetry Series."
      }
  , Author
      { authorId   = 26
      , authorName = "Joshua Whitehead"
      , tribe      = Ojicree
      , birthYear  = 1989
      , biography  = "Joshua Whitehead is an Oji-Cree Two-Spirit author from Peguis First Nation known for his genre-bending novel Jonny Appleseed and his poetry collection Full Metal Indigiqueer."
      }
  , Author
      { authorId   = 27
      , authorName = "Dennis E. Staples"
      , tribe      = Anishinaabe
      , birthYear  = 1988
      , biography  = "Dennis E. Staples is an Anishinaabe author from the Leech Lake Reservation whose debut novel This Town Sleeps blends mystery and Indigenous spirituality."
      }
  ]

works :: [Work]
works =
  [ Work { workId = 1, title = "Crazy Brave", authorRef = 1, genre = Memoir, yearPub = 2012, excerpt = "I was born a poet, though I did not know it until much later." }
  , Work { workId = 2, title = "She Had Some Horses", authorRef = 1, genre = Poetry, yearPub = 1983, excerpt = "She had horses who were bodies of sand. She had horses who were maps drawn of blood." }
  , Work { workId = 3, title = "An American Sunrise", authorRef = 1, genre = Poetry, yearPub = 2019, excerpt = "We were running out of time and the world was made of turquoise and regret." }
  , Work { workId = 4, title = "Poet Warrior", authorRef = 1, genre = Memoir, yearPub = 2021, excerpt = "Poetry is the voice of the spirit that speaks to all people across time and place." }
  , Work { workId = 5, title = "In Mad Love and War", authorRef = 1, genre = Poetry, yearPub = 1990, excerpt = "There is something about the human spirit that insists on singing even in the darkest of times." }
  , Work { workId = 6, title = "How We Became Human", authorRef = 1, genre = Poetry, yearPub = 2002, excerpt = "We are the gathering of all who have ever lived and loved on this earth." }
  , Work { workId = 7, title = "The Absolutely True Diary of a Part-Time Indian", authorRef = 2, genre = LiteraryFiction, yearPub = 2007, excerpt = "I used to think the world was broken down by tribes. I was wrong." }
  , Work { workId = 8, title = "Reservation Blues", authorRef = 2, genre = LiteraryFiction, yearPub = 1995, excerpt = "Life is a series of doors. Some you open, some slam in your face." }
  , Work { workId = 9, title = "Love Medicine", authorRef = 3, genre = LiteraryFiction, yearPub = 1984, excerpt = "The medicine was all about love, and love is what brought us together and tore us apart." }
  , Work { workId = 10, title = "The Plague of Doves", authorRef = 3, genre = LiteraryFiction, yearPub = 2008, excerpt = "Justice is a story we tell ourselves to keep from drowning." }
  , Work { workId = 11, title = "House Made of Dawn", authorRef = 4, genre = LiteraryFiction, yearPub = 1968, excerpt = "He was running, and under his feet the earth was alive." }
  , Work { workId = 12, title = "The Way to Rainy Mountain", authorRef = 4, genre = Memoir, yearPub = 1969, excerpt = "A single knoll rises out of the plain in Oklahoma, north and west of the Wichita Range." }
  , Work { workId = 13, title = "Ceremony", authorRef = 5, genre = LiteraryFiction, yearPub = 1977, excerpt = "The old ones say the world is fragile. We are part of that fragility." }
  , Work { workId = 14, title = "Almanac of the Dead", authorRef = 5, genre = LiteraryFiction, yearPub = 1991, excerpt = "The land remembers everything that has ever happened on it." }
  , Work { workId = 15, title = "Saanii Dahataal: The Women Are Singing", authorRef = 6, genre = Poetry, yearPub = 1993, excerpt = "The songs and stories are the strongest part of us." }
  , Work { workId = 16, title = "Blue Horses Rush In", authorRef = 6, genre = Poetry, yearPub = 1997, excerpt = "In the Navajo way, horses represent strength, beauty, and the continuity of life." }
  , Work { workId = 17, title = "A Radiant Curve", authorRef = 6, genre = Poetry, yearPub = 2008, excerpt = "The land and the people are one. We carry the songs of our ancestors in our bones." }
  , Work { workId = 18, title = "A Breeze Swept Through", authorRef = 6, genre = Poetry, yearPub = 1987, excerpt = "The wind carries the voices of those who came before us across the desert." }
  , Work { workId = 19, title = "Songs of Shiprock Fair", authorRef = 6, genre = Poetry, yearPub = 1999, excerpt = "At the fair the people gather, and the old songs rise again into the New Mexico sky." }
  , Work { workId = 20, title = "Woven Stone", authorRef = 7, genre = Poetry, yearPub = 1992, excerpt = "We are the land. That is the fundamental idea embedded in Native American life." }
  , Work { workId = 21, title = "From Sand Creek", authorRef = 7, genre = Poetry, yearPub = 1981, excerpt = "This is the victory. This is the morning star. This is the people." }
  , Work { workId = 22, title = "A Good Journey", authorRef = 7, genre = Poetry, yearPub = 1977, excerpt = "The journey is always the point. The road teaches us who we are." }
  , Work { workId = 23, title = "After and Before the Lightning", authorRef = 7, genre = Poetry, yearPub = 1994, excerpt = "The plains in winter hold a silence that is ancient and alive." }
  , Work { workId = 24, title = "Fools Crow", authorRef = 8, genre = LiteraryFiction, yearPub = 1986, excerpt = "The old ways were changing, and with them the hearts of the people." }
  , Work { workId = 25, title = "Winter in the Blood", authorRef = 8, genre = LiteraryFiction, yearPub = 1974, excerpt = "The distance between me and a stranger had vanished and I was alone." }
  , Work { workId = 26, title = "The Jailing of Cecelia Capture", authorRef = 9, genre = LiteraryFiction, yearPub = 1985, excerpt = "She had survived everything life had thrown at her. This was just one more thing." }
  , Work { workId = 27, title = "Bloodlines", authorRef = 9, genre = Memoir, yearPub = 1993, excerpt = "To understand who I am, I must understand where I come from." }
  , Work { workId = 28, title = "Bearheart: The Heirship Chronicles", authorRef = 10, genre = LiteraryFiction, yearPub = 1978, excerpt = "The trickster moves through the world undoing what others have made certain." }
  , Work { workId = 29, title = "Custer Died for Your Sins", authorRef = 11, genre = Nonfiction, yearPub = 1969, excerpt = "When Indians speak of the colonialists they generally cite three people: Custer, Columbus, and the missionaries." }
  , Work { workId = 30, title = "God Is Red", authorRef = 11, genre = Nonfiction, yearPub = 1973, excerpt = "Religion is not something separated from the land. It is the land." }
  , Work { workId = 31, title = "Mean Spirit", authorRef = 12, genre = LiteraryFiction, yearPub = 1990, excerpt = "The oil beneath the land brought wealth and with it a darkness that swallowed whole families." }
  , Work { workId = 32, title = "Savings", authorRef = 12, genre = Poetry, yearPub = 1988, excerpt = "We save what we can. The rest we carry in silence." }
  , Work { workId = 33, title = "Shell Shaker", authorRef = 13, genre = LiteraryFiction, yearPub = 2001, excerpt = "The Choctaw women have always been the keepers of the nation." }
  , Work { workId = 34, title = "Miko Kings", authorRef = 13, genre = LiteraryFiction, yearPub = 2007, excerpt = "Baseball and blood memory are both passed down through generations." }
  , Work { workId = 35, title = "The Grass Dancer", authorRef = 14, genre = LiteraryFiction, yearPub = 1994, excerpt = "The past is not behind us. It dances alongside us always." }
  , Work { workId = 36, title = "Green Grass Running Water", authorRef = 15, genre = LiteraryFiction, yearPub = 1993, excerpt = "The world is full of stories and the stories are all one." }
  , Work { workId = 37, title = "The Inconvenient Indian", authorRef = 15, genre = Nonfiction, yearPub = 2012, excerpt = "The history of Indians in North America is not a happy story." }
  , Work { workId = 38, title = "Cheyenne Madonna", authorRef = 16, genre = ShortStory, yearPub = 2010, excerpt = "We live in the spaces between what we were and what we are becoming." }
  , Work { workId = 39, title = "Original Local", authorRef = 17, genre = Poetry, yearPub = 2013, excerpt = "What does it mean to be from a place that was taken?" }
  , Work { workId = 40, title = "Postcolonial Love Poem", authorRef = 18, genre = Poetry, yearPub = 2020, excerpt = "I am the language my mother taught me and the one that was forbidden." }
  , Work { workId = 41, title = "When My Brother Was an Aztec", authorRef = 18, genre = Poetry, yearPub = 2012, excerpt = "Addiction is a war fought in the body and the soul simultaneously." }
  , Work { workId = 42, title = "The Marrow Thieves", authorRef = 19, genre = LiteraryFiction, yearPub = 2017, excerpt = "They were hunting us for our bones. We ran north into the dark." }
  , Work { workId = 43, title = "Funeral Songs for Dying Stars", authorRef = 19, genre = Poetry, yearPub = 2022, excerpt = "Even dying things leave light behind." }
  , Work { workId = 44, title = "Where the Dead Sit Talking", authorRef = 20, genre = LiteraryFiction, yearPub = 2018, excerpt = "Foster care teaches you that belonging is always temporary." }
  , Work { workId = 45, title = "The removed", authorRef = 20, genre = LiteraryFiction, yearPub = 2021, excerpt = "The Trail of Tears never really ended. It just changed shape." }
  , Work { workId = 46, title = "Trail of Lightning", authorRef = 21, genre = LiteraryFiction, yearPub = 2018, excerpt = "The monsters are real. So are the people who fight them." }
  , Work { workId = 47, title = "Storm of Locusts", authorRef = 21, genre = LiteraryFiction, yearPub = 2019, excerpt = "The Sixth World is fragile. We hold it together with ceremony and will." }
  , Work { workId = 48, title = "The Only Good Indians", authorRef = 22, genre = LiteraryFiction, yearPub = 2020, excerpt = "The past does not stay buried. It comes back with teeth." }
  , Work { workId = 49, title = "Mongrels", authorRef = 22, genre = LiteraryFiction, yearPub = 2016, excerpt = "Being werewolf and being Indian are not so different. Both mean living between worlds." }
  , Work { workId = 50, title = "Braiding Sweetgrass", authorRef = 23, genre = Nonfiction, yearPub = 2013, excerpt = "The land is the real teacher. All we need as students is attention." }
  , Work { workId = 51, title = "Gathering Moss", authorRef = 23, genre = Nonfiction, yearPub = 2003, excerpt = "Mosses are a reminder that the world was not made for us alone." }
  , Work { workId = 52, title = "WHEREAS", authorRef = 24, genre = Poetry, yearPub = 2017, excerpt = "Whereas my name means nothing to the government. Whereas I am still here." }
  , Work { workId = 53, title = "Eyes Bottle Dark with a Mouthful of Flowers", authorRef = 25, genre = Poetry, yearPub = 2019, excerpt = "The desert holds its breath between storms and so do we." }
  , Work { workId = 54, title = "Jonny Appleseed", authorRef = 26, genre = LiteraryFiction, yearPub = 2018, excerpt = "To be Two-Spirit and Oji-Cree is to carry multiple worlds inside one body." }
  , Work { workId = 55, title = "Full Metal Indigiqueer", authorRef = 26, genre = Poetry, yearPub = 2017, excerpt = "I sing myself into existence in a language that was almost taken from me." }
  , Work { workId = 56, title = "This Town Sleeps", authorRef = 27, genre = LiteraryFiction, yearPub = 2020, excerpt = "The reservation holds its secrets the way the earth holds its dead." }
  ]