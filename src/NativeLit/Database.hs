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
  , Author
      { authorId   = 28
      , authorName = "Darcie Little Badger"
      , tribe      = Apache
      , birthYear  = 1987
      , biography  = "Darcie Little Badger is a Lipan Apache author and oceanographer whose young adult novels blend Apache folklore with science fiction and mystery. Her debut Elatsoe won the Locus Award for Best First Novel."
      }
  , Author
      { authorId   = 29
      , authorName = "Veronica E. Velarde Tiller"
      , tribe      = Apache
      , birthYear  = 1947
      , biography  = "Veronica E. Velarde Tiller is a Jicarilla Apache historian and publisher whose reference works on Indian tribes and communities have become essential resources for scholars and tribal nations."
      }
  , Author
      { authorId   = 30
      , authorName = "Margo Tamez"
      , tribe      = Apache
      , birthYear  = 1962
      , biography  = "Margo Tamez is a Lipan Apache poet and scholar whose work confronts borderlands, colonization, and Indigenous sovereignty along the Texas-Mexico frontier."
      }
  , Author
      { authorId   = 31
      , authorName = "John Joseph Mathews"
      , tribe      = Osage
      , birthYear  = 1894
      , biography  = "John Joseph Mathews was an Osage writer, historian, and tribal council member whose books helped establish Native American literature as a serious literary tradition during the 20th century."
      }
  , Author
      { authorId   = 32
      , authorName = "Louis F. Burns"
      , tribe      = Osage
      , birthYear  = 1920
      , biography  = "Louis F. Burns was an Osage historian who devoted his life to documenting the genealogy, customs, and history of the Osage people through meticulously researched volumes."
      }
  , Author
      { authorId   = 33
      , authorName = "Charles H. Red Corn"
      , tribe      = Osage
      , birthYear  = 1936
      , biography  = "Charles H. Red Corn was an Osage novelist whose work brought the experiences of the Osage Nation's oil-boom era to literary fiction with quiet authority."
      }
  , Author
      { authorId   = 34
      , authorName = "Chelsea T. Hicks"
      , tribe      = Osage
      , birthYear  = 1990
      , biography  = "Chelsea T. Hicks is an Osage author whose debut story collection A Calm and Normal Heart explores contemporary Osage identity, language reclamation, and intergenerational memory."
      }
  , Author
      { authorId   = 35
      , authorName = "Elise Paschen"
      , tribe      = Osage
      , birthYear  = 1959
      , biography  = "Elise Paschen is an Osage poet and former executive director of the Poetry Society of America. Her collections weave personal history with Osage heritage and classical poetic forms."
      }
  , Author
      { authorId   = 36
      , authorName = "Carter Revard"
      , tribe      = Osage
      , birthYear  = 1931
      , biography  = "Carter Revard was an Osage poet and medieval literature scholar whose poetry blended Indigenous oral tradition with formal Western verse, creating a bridge between worlds."
      }
  , Author
      { authorId   = 37
      , authorName = "Taiaiake Alfred"
      , tribe      = Mohawk
      , birthYear  = 1964
      , biography  = "Gerald Taiaiake Alfred is a Kahnawake Mohawk scholar and activist whose writings on Indigenous resurgence, sovereignty, and decolonization have shaped contemporary Native political thought."
      }
  , Author
      { authorId   = 38
      , authorName = "Beth Brant"
      , tribe      = Mohawk
      , birthYear  = 1941
      , biography  = "Beth Brant was a Mohawk writer from the Bay of Quinte Mohawk community whose pioneering work centered Indigenous women, Two-Spirit identity, and the power of storytelling as witness."
      }
  , Author
      { authorId   = 39
      , authorName = "Maurice Kenny"
      , tribe      = Mohawk
      , birthYear  = 1929
      , biography  = "Maurice Kenny was a Mohawk poet whose decades-long career produced essential works of Native American poetry, often returning to themes of land, ancestry, and queer Indigenous experience."
      }
  , Author
      { authorId   = 40
      , authorName = "Tomson Highway"
      , tribe      = Cree
      , birthYear  = 1951
      , biography  = "Tomson Highway is a Cree playwright, novelist, and musician from northern Manitoba whose works have helped define modern Indigenous theater in Canada."
      }
  , Author
      { authorId   = 41
      , authorName = "Billy-Ray Belcourt"
      , tribe      = Cree
      , birthYear  = 1994
      , biography  = "Billy-Ray Belcourt is a Driftpile Cree Nation poet and scholar whose work explores queer Indigenous love, grief, and resistance. He was the youngest-ever winner of the Griffin Poetry Prize."
      }
  , Author
      { authorId   = 42
      , authorName = "Jessica Johns"
      , tribe      = Cree
      , birthYear  = 1989
      , biography  = "Jessica Johns is a nehiyaw Cree writer and editor whose debut novel Bad Cree blends horror, dreams, and intergenerational memory into a striking exploration of grief and survival."
      }
  , Author
      { authorId   = 43
      , authorName = "Louise Bernice Halfe"
      , tribe      = Cree
      , birthYear  = 1953
      , biography  = "Louise Bernice Halfe, also known as Sky Dancer, is a Cree poet and former Canadian Parliamentary Poet Laureate whose work integrates Cree language, residential school memory, and ceremony."
      }
  , Author
      { authorId   = 44
      , authorName = "David A. Robertson"
      , tribe      = Cree
      , birthYear  = 1977
      , biography  = "David A. Robertson is a Norway House Cree Nation author who writes acclaimed books for young readers and adults that explore identity, reconciliation, and Indigenous worldviews."
      }
  , Author
      { authorId   = 45
      , authorName = "Michelle Good"
      , tribe      = Cree
      , birthYear  = 1956
      , biography  = "Michelle Good is a Cree author and lawyer from the Red Pheasant Cree Nation whose debut novel Five Little Indians follows survivors of Canadian residential schools into adulthood."
      }
  ]

tribeInfo :: Tribe -> String
tribeInfo Navajo       = "The Navajo (Diné) of the Southwest possess a rich literary tradition rooted in the 'Diné Bahane' creation stories and a profound spiritual connection to the sacred landscape of the Four Mountains."
tribeInfo Cherokee     = "The Cherokee Nation, originally of the Southeast, has a long-standing written tradition dating back to the creation of the Cherokee Syllabary by Sequoyah in 1821."
tribeInfo Lakota       = "The Lakota (Western Sioux) are known for a powerful oral tradition of 'ohunkakan' (myths) and 'woyakapi' (history), often reflecting themes of bravery and the sacredness of the Black Hills."
tribeInfo Sioux        = "The Sioux (Oceti Sakowin) encompass a vast territory across the Great Plains. Their literature often explores resistance, political activism, and the preservation of cultural identity."
tribeInfo Apache       = "Apache literature often centers on place-based storytelling and 'wisdom sits in places,' emphasizing the moral lessons embedded in the geography of the Southwest."
tribeInfo Choctaw      = "The Choctaw Nation of Oklahoma (originally from the Southeast) has a literary history that weaves together ancestral mound-builder heritage with contemporary stories of resilience."
tribeInfo Pueblo       = "Pueblo literature (including Acoma, Laguna, and Zuni) is deeply communal, drawing on thousands of years of continuous habitation and complex agricultural and ceremonial cycles."
tribeInfo Muscogee     = "The Muscogee (Creek) Nation's literature is characterized by a blend of traditional tribal histories and sharp, contemporary social commentary, often using the 'Stomp Dance' as a cultural anchor."
tribeInfo Blackfeet    = "The Blackfeet (Siksikaitsitapi) of Montana and Alberta produce works that focus on the relationship between the people, the buffalo, and the rugged landscape of the Rocky Mountains."
tribeInfo Coeur_dAlene = "The Coeur d'Alene (Schitsu'umsh) people of Idaho have a storytelling tradition that emphasizes the connection to the lakes and the survival of the 'Heart of the People.'"
tribeInfo Anishinaabe  = "Anishinaabe literature (including Ojibwe) often features the 'Manidog' (spirits) and the trickster 'Nanabozho,' focusing on the philosophy of 'Mino-bimaadiziwin' (the good life)."
tribeInfo Ojibwe       = "The Ojibwe (Chippewa) are one of the largest Indigenous groups in North America, with a vast body of literature ranging from traditional birchbark scrolls to Pulitzer-winning modern novels."
tribeInfo Mojave       = "The Mojave people of the Colorado River valley have a unique literary voice often centered on the river as the lifeblood of the community and the preservation of the Mojave language."
tribeInfo Metis        = "Métis literature reflects a distinct culture born of Cree, Ojibwe, and French fur trader ancestry, often exploring themes of 'road allowance' history and the 'Michif' language."
tribeInfo Ojicree      = "Oji-Cree (Anishinini) literature represents the northern boreal forest cultures, blending the linguistic and cultural traditions of both the Ojibwe and the Cree nations."
tribeInfo Osage        = "Osage literature reflects a nation transformed by the early 20th century oil boom and the violence that followed, producing some of the most important Indigenous American writing of the modern era."
tribeInfo Mohawk       = "Mohawk (Kanien'keha:ka) literature, rooted in the Haudenosaunee Confederacy, blends political clarity, ceremonial knowledge, and a long tradition of women's leadership and storytelling."
tribeInfo Cree         = "Cree (Nehiyawak) literature is among the most vibrant in contemporary Indigenous letters, drawing on the vast boreal forests and prairies and on a deep tradition of language preservation and storytelling."
tribeInfo _            = "A resilient Indigenous nation with an ancient oral tradition and a deep, enduring connection to their ancestral lands and cultural heritage."

works :: [Work]
works =
  [ Work { workId = 1, title = "Crazy Brave", authorRef = 1, genre = Memoir, yearPub = 2012, pages = 176, publisher = "W. W. Norton", awards = ["American Book Award"], form = "Memoir", excerpt = "I was born a poet, though I did not know it until much later." }
  , Work { workId = 2, title = "She Had Some Horses", authorRef = 1, genre = Poetry, yearPub = 1983, pages = 74, publisher = "Thunder's Mouth Press", awards = [], form = "Poetry Collection", excerpt = "She had horses who were bodies of sand. She had horses who were maps drawn of blood." }
  , Work { workId = 3, title = "An American Sunrise", authorRef = 1, genre = Poetry, yearPub = 2019, pages = 144, publisher = "W. W. Norton", awards = [], form = "Poetry Collection", excerpt = "We were running out of time and the world was made of turquoise and regret." }
  , Work { workId = 4, title = "Poet Warrior", authorRef = 1, genre = Memoir, yearPub = 2021, pages = 256, publisher = "W. W. Norton", awards = [], form = "Memoir", excerpt = "Poetry is the voice of the spirit that speaks to all people across time and place." }
  , Work { workId = 5, title = "In Mad Love and War", authorRef = 1, genre = Poetry, yearPub = 1990, pages = 65, publisher = "Wesleyan University Press", awards = ["American Book Award"], form = "Poetry Collection", excerpt = "There is something about the human spirit that insists on singing even in the darkest of times." }
  , Work { workId = 6, title = "How We Became Human", authorRef = 1, genre = Poetry, yearPub = 2002, pages = 242, publisher = "W. W. Norton", awards = [], form = "Poetry Collection", excerpt = "We are the gathering of all who have ever lived and loved on this earth." }
  , Work { workId = 7, title = "The Absolutely True Diary of a Part-Time Indian", authorRef = 2, genre = LiteraryFiction, yearPub = 2007, pages = 230, publisher = "Little, Brown", awards = ["National Book Award"], form = "Novel", excerpt = "I used to think the world was broken down by tribes. I was wrong." }
  , Work { workId = 8, title = "Reservation Blues", authorRef = 2, genre = LiteraryFiction, yearPub = 1995, pages = 306, publisher = "Grove Press", awards = ["American Book Award"], form = "Novel", excerpt = "Life is a series of doors. Some you open, some slam in your face." }
  , Work { workId = 9, title = "Love Medicine", authorRef = 3, genre = LiteraryFiction, yearPub = 1984, pages = 367, publisher = "Holt, Rinehart and Winston", awards = ["National Book Critics Circle Award"], form = "Novel", excerpt = "The medicine was all about love, and love is what brought us together and tore us apart." }
  , Work { workId = 10, title = "The Plague of Doves", authorRef = 3, genre = LiteraryFiction, yearPub = 2008, pages = 313, publisher = "HarperCollins", awards = ["Anisfield-Wolf Book Award"], form = "Novel", excerpt = "Justice is a story we tell ourselves to keep from drowning." }
  , Work { workId = 11, title = "House Made of Dawn", authorRef = 4, genre = LiteraryFiction, yearPub = 1968, pages = 212, publisher = "Harper & Row", awards = ["Pulitzer Prize"], form = "Novel", excerpt = "He was running, and under his feet the earth was alive." }
  , Work { workId = 12, title = "The Way to Rainy Mountain", authorRef = 4, genre = Memoir, yearPub = 1969, pages = 88, publisher = "University of New Mexico Press", awards = [], form = "Memoir", excerpt = "A single knoll rises out of the plain in Oklahoma, north and west of the Wichita Range." }
  , Work { workId = 13, title = "Ceremony", authorRef = 5, genre = LiteraryFiction, yearPub = 1977, pages = 262, publisher = "Viking Press", awards = [], form = "Novel", excerpt = "The old ones say the world is fragile. We are part of that fragility." }
  , Work { workId = 14, title = "Almanac of the Dead", authorRef = 5, genre = LiteraryFiction, yearPub = 1991, pages = 763, publisher = "Simon & Schuster", awards = [], form = "Novel", excerpt = "The land remembers everything that has ever happened on it." }
  , Work { workId = 15, title = "Saanii Dahataal: The Women Are Singing", authorRef = 6, genre = Poetry, yearPub = 1993, pages = 94, publisher = "University of Arizona Press", awards = [], form = "Poetry Collection", excerpt = "The songs and stories are the strongest part of us." }
  , Work { workId = 16, title = "Blue Horses Rush In", authorRef = 6, genre = Poetry, yearPub = 1997, pages = 104, publisher = "University of Arizona Press", awards = [], form = "Poetry Collection", excerpt = "In the Navajo way, horses represent strength, beauty, and the continuity of life." }
  , Work { workId = 17, title = "A Radiant Curve", authorRef = 6, genre = Poetry, yearPub = 2008, pages = 112, publisher = "University of Arizona Press", awards = [], form = "Poetry Collection", excerpt = "The land and the people are one. We carry the songs of our ancestors in our bones." }
  , Work { workId = 18, title = "A Breeze Swept Through", authorRef = 6, genre = Poetry, yearPub = 1987, pages = 64, publisher = "West End Press", awards = [], form = "Poetry Collection", excerpt = "The wind carries the voices of those who came before us across the desert." }
  , Work { workId = 19, title = "Songs of Shiprock Fair", authorRef = 6, genre = Poetry, yearPub = 1999, pages = 76, publisher = "University of Arizona Press", awards = ["American Book Award (2000)"], form = "Poetry Collection", excerpt = "At the fair the people gather, and the old songs rise again into the New Mexico sky." }
  , Work { workId = 20, title = "Woven Stone", authorRef = 7, genre = Poetry, yearPub = 1992, pages = 365, publisher = "University of Arizona Press", awards = [], form = "Poetry Collection", excerpt = "We are the land. That is the fundamental idea embedded in Native American life." }
  , Work { workId = 21, title = "From Sand Creek", authorRef = 7, genre = Poetry, yearPub = 1981, pages = 95, publisher = "Thunder's Mouth Press", awards = ["Pushcart Prize"], form = "Poetry Collection", excerpt = "This is the victory. This is the morning star. This is the people." }
  , Work { workId = 22, title = "A Good Journey", authorRef = 7, genre = Poetry, yearPub = 1977, pages = 165, publisher = "University of Arizona Press", awards = [], form = "Poetry Collection", excerpt = "The journey is always the point. The road teaches us who we are." }
  , Work { workId = 23, title = "After and Before the Lightning", authorRef = 7, genre = Poetry, yearPub = 1994, pages = 134, publisher = "University of Arizona Press", awards = [], form = "Poetry Collection", excerpt = "The plains in winter hold a silence that is ancient and alive." }
  , Work { workId = 24, title = "Fools Crow", authorRef = 8, genre = LiteraryFiction, yearPub = 1986, pages = 391, publisher = "Viking Press", awards = ["Los Angeles Times Book Prize"], form = "Novel", excerpt = "The old ways were changing, and with them the hearts of the people." }
  , Work { workId = 25, title = "Winter in the Blood", authorRef = 8, genre = LiteraryFiction, yearPub = 1974, pages = 176, publisher = "Harper & Row", awards = [], form = "Novel", excerpt = "The distance between me and a stranger had vanished and I was alone." }
  , Work { workId = 26, title = "The Jailing of Cecelia Capture", authorRef = 9, genre = LiteraryFiction, yearPub = 1985, pages = 0, publisher = "", awards = [], form = "Novel", excerpt = "She had survived everything life had thrown at her. This was just one more thing." }
  , Work { workId = 27, title = "Bloodlines", authorRef = 9, genre = Memoir, yearPub = 1993, pages = 0, publisher = "", awards = [], form = "Memoir", excerpt = "To understand who I am, I must understand where I come from." }
  , Work { workId = 28, title = "Bearheart: The Heirship Chronicles", authorRef = 10, genre = LiteraryFiction, yearPub = 1978, pages = 0, publisher = "", awards = [], form = "Novel", excerpt = "The trickster moves through the world undoing what others have made certain." }
  , Work { workId = 29, title = "Custer Died for Your Sins", authorRef = 11, genre = Nonfiction, yearPub = 1969, pages = 279, publisher = "Macmillan", awards = [], form = "Nonfiction", excerpt = "When Indians speak of the colonialists they generally cite three people: Custer, Columbus, and the missionaries." }
  , Work { workId = 30, title = "God Is Red", authorRef = 11, genre = Nonfiction, yearPub = 1973, pages = 0, publisher = "", awards = [], form = "Nonfiction", excerpt = "Religion is not something separated from the land. It is the land." }
  , Work { workId = 31, title = "Mean Spirit", authorRef = 12, genre = LiteraryFiction, yearPub = 1990, pages = 374, publisher = "Atheneum", awards = ["Pulitzer Prize Finalist"], form = "Novel", excerpt = "The oil beneath the land brought wealth and with it a darkness that swallowed whole families." }
  , Work { workId = 32, title = "Savings", authorRef = 12, genre = Poetry, yearPub = 1988, pages = 0, publisher = "", awards = [], form = "Poetry Collection", excerpt = "We save what we can. The rest we carry in silence." }
  , Work { workId = 33, title = "Shell Shaker", authorRef = 13, genre = LiteraryFiction, yearPub = 2001, pages = 0, publisher = "", awards = ["American Book Award"], form = "Novel", excerpt = "The Choctaw women have always been the keepers of the nation." }
  , Work { workId = 34, title = "Miko Kings", authorRef = 13, genre = LiteraryFiction, yearPub = 2007, pages = 0, publisher = "", awards = [], form = "Novel", excerpt = "Baseball and blood memory are both passed down through generations." }
  , Work { workId = 35, title = "The Grass Dancer", authorRef = 14, genre = LiteraryFiction, yearPub = 1994, pages = 0, publisher = "", awards = ["PEN/Hemingway Award"], form = "Novel", excerpt = "The past is not behind us. It dances alongside us always." }
  , Work { workId = 36, title = "Green Grass Running Water", authorRef = 15, genre = LiteraryFiction, yearPub = 1993, pages = 469, publisher = "Houghton Mifflin", awards = [], form = "Novel", excerpt = "The world is full of stories and the stories are all one." }
  , Work { workId = 37, title = "The Inconvenient Indian", authorRef = 15, genre = Nonfiction, yearPub = 2012, pages = 304, publisher = "Doubleday Canada", awards = ["RBC Taylor Prize"], form = "Nonfiction", excerpt = "The history of Indians in North America is not a happy story." }
  , Work { workId = 38, title = "Cheyenne Madonna", authorRef = 16, genre = ShortStory, yearPub = 2010, pages = 0, publisher = "", awards = [], form = "Story Collection", excerpt = "We live in the spaces between what we were and what we are becoming." }
  , Work { workId = 39, title = "Original Local", authorRef = 17, genre = Poetry, yearPub = 2013, pages = 0, publisher = "", awards = [], form = "Poetry Collection", excerpt = "What does it mean to be from a place that was taken?" }
  , Work { workId = 40, title = "Postcolonial Love Poem", authorRef = 18, genre = Poetry, yearPub = 2020, pages = 120, publisher = "Graywolf Press", awards = ["Pulitzer Prize"], form = "Poetry Collection", excerpt = "I am the language my mother taught me and the one that was forbidden." }
  , Work { workId = 41, title = "When My Brother Was an Aztec", authorRef = 18, genre = Poetry, yearPub = 2012, pages = 120, publisher = "Copper Canyon Press", awards = ["American Book Award"], form = "Poetry Collection", excerpt = "Addiction is a war fought in the body and the soul simultaneously." }
  , Work { workId = 42, title = "The Marrow Thieves", authorRef = 19, genre = LiteraryFiction, yearPub = 2017, pages = 231, publisher = "Cormorant Books", awards = ["Governor General's Literary Award"], form = "Novel", excerpt = "They were hunting us for our bones. We ran north into the dark." }
  , Work { workId = 43, title = "Funeral Songs for Dying Stars", authorRef = 19, genre = Poetry, yearPub = 2022, pages = 0, publisher = "", awards = [], form = "Poetry Collection", excerpt = "Even dying things leave light behind." }
  , Work { workId = 44, title = "Where the Dead Sit Talking", authorRef = 20, genre = LiteraryFiction, yearPub = 2018, pages = 280, publisher = "Soho Press", awards = ["National Book Award Finalist"], form = "Novel", excerpt = "Foster care teaches you that belonging is always temporary." }
  , Work { workId = 45, title = "The removed", authorRef = 20, genre = LiteraryFiction, yearPub = 2021, pages = 288, publisher = "Ecco", awards = [], form = "Novel", excerpt = "The Trail of Tears never really ended. It just changed shape." }
  , Work { workId = 46, title = "Trail of Lightning", authorRef = 21, genre = LiteraryFiction, yearPub = 2018, pages = 287, publisher = "Saga Press", awards = ["Locus Award"], form = "Novel", excerpt = "The monsters are real. So are the people who fight them." }
  , Work { workId = 47, title = "Storm of Locusts", authorRef = 21, genre = LiteraryFiction, yearPub = 2019, pages = 314, publisher = "Saga Press", awards = [], form = "Novel", excerpt = "The Sixth World is fragile. We hold it together with ceremony and will." }
  , Work { workId = 48, title = "The Only Good Indians", authorRef = 22, genre = LiteraryFiction, yearPub = 2020, pages = 310, publisher = "Saga Press", awards = ["Shirley Jackson Award"], form = "Novel", excerpt = "The past does not stay buried. It comes back with teeth." }
  , Work { workId = 49, title = "Mongrels", authorRef = 22, genre = LiteraryFiction, yearPub = 2016, pages = 320, publisher = "William Morrow", awards = [], form = "Novel", excerpt = "Being werewolf and being Indian are not so different. Both mean living between worlds." }
  , Work { workId = 50, title = "Braiding Sweetgrass", authorRef = 23, genre = Nonfiction, yearPub = 2013, pages = 390, publisher = "Milkweed Editions", awards = [], form = "Nonfiction", excerpt = "The land is the real teacher. All we need as students is attention." }
  , Work { workId = 51, title = "Gathering Moss", authorRef = 23, genre = Nonfiction, yearPub = 2003, pages = 168, publisher = "Oregon State University Press", awards = ["John Burroughs Medal"], form = "Nonfiction", excerpt = "Mosses are a reminder that the world was not made for us alone." }
  , Work { workId = 52, title = "WHEREAS", authorRef = 24, genre = Poetry, yearPub = 2017, pages = 120, publisher = "Graywolf Press", awards = ["National Book Critics Circle Award"], form = "Poetry Collection", excerpt = "Whereas my name means nothing to the government. Whereas I am still here." }
  , Work { workId = 53, title = "Eyes Bottle Dark with a Mouthful of Flowers", authorRef = 25, genre = Poetry, yearPub = 2019, pages = 104, publisher = "Milkweed Editions", awards = ["National Poetry Series"], form = "Poetry Collection", excerpt = "The desert holds its breath between storms and so do we." }
  , Work { workId = 54, title = "Jonny Appleseed", authorRef = 26, genre = LiteraryFiction, yearPub = 2018, pages = 224, publisher = "Arsenal Pulp Press", awards = ["Canada Reads"], form = "Novel", excerpt = "To be Two-Spirit and Oji-Cree is to carry multiple worlds inside one body." }
  , Work { workId = 55, title = "Full Metal Indigiqueer", authorRef = 26, genre = Poetry, yearPub = 2017, pages = 120, publisher = "Talonbooks", awards = [], form = "Poetry Collection", excerpt = "I sing myself into existence in a language that was almost taken from me." }
  , Work { workId = 56, title = "This Town Sleeps", authorRef = 27, genre = LiteraryFiction, yearPub = 2020, pages = 228, publisher = "Counterpoint", awards = [], form = "Novel", excerpt = "The reservation holds its secrets the way the earth holds its dead." }
  , Work { workId = 57, title = "Elatsoe", authorRef = 28, genre = LiteraryFiction, yearPub = 2020, pages = 368, publisher = "Levine Querido", awards = ["Locus Award"], form = "Novel", excerpt = "The dead have lessons for the living, if we know how to listen." }
  , Work { workId = 58, title = "A Snake Falls to Earth", authorRef = 28, genre = LiteraryFiction, yearPub = 2021, pages = 352, publisher = "Levine Querido", awards = ["Newbery Honor"], form = "Novel", excerpt = "Two worlds press against each other, and only the storytellers can hear what crosses between." }
  , Work { workId = 59, title = "Sheine Lende", authorRef = 28, genre = LiteraryFiction, yearPub = 2024, pages = 0, publisher = "", awards = [], form = "Novel", excerpt = "Before Elatsoe walked these paths, her grandmother ran them with the same kind of hunger." }
  , Work { workId = 60, title = "Tiller's Guide to Indian Country", authorRef = 29, genre = Nonfiction, yearPub = 1996, pages = 1136, publisher = "BowArrow Publishing", awards = [], form = "Nonfiction", excerpt = "Every tribal nation deserves to be seen, named, and understood on its own terms." }
  , Work { workId = 61, title = "The Jicarilla Apache Tribe", authorRef = 29, genre = Nonfiction, yearPub = 2000, pages = 0, publisher = "", awards = [], form = "Nonfiction", excerpt = "The history of the Jicarilla is a history of survival and self-determination." }
  , Work { workId = 62, title = "Culture and Customs of the Apache Indians", authorRef = 29, genre = Nonfiction, yearPub = 2011, pages = 0, publisher = "", awards = [], form = "Nonfiction", excerpt = "To know the Apache is to know the mountains, the deserts, and the resilient heart of the people." }
  , Work { workId = 63, title = "Naked Wanting", authorRef = 30, genre = Poetry, yearPub = 2003, pages = 0, publisher = "", awards = [], form = "Poetry Collection", excerpt = "On the borderlands we learn what hunger means before we learn what home means." }
  , Work { workId = 64, title = "Raven Eye", authorRef = 30, genre = Poetry, yearPub = 2007, pages = 0, publisher = "", awards = [], form = "Poetry Collection", excerpt = "The river remembers the names the maps have tried to erase." }
  , Work { workId = 65, title = "Sundown", authorRef = 31, genre = LiteraryFiction, yearPub = 1934, pages = 312, publisher = "Longmans, Green and Co.", awards = [], form = "Novel", excerpt = "Chal stood between two worlds, and neither one would have him whole." }
  , Work { workId = 66, title = "Wah'Kon-Tah: The Osage and the White Man's Road", authorRef = 31, genre = Nonfiction, yearPub = 1932, pages = 359, publisher = "University of Oklahoma Press", awards = [], form = "Nonfiction", excerpt = "The Great Mystery watched as the people walked into a future they had not chosen." }
  , Work { workId = 67, title = "The Osages: Children of the Middle Waters", authorRef = 31, genre = Nonfiction, yearPub = 1961, pages = 826, publisher = "University of Oklahoma Press", awards = [], form = "Nonfiction", excerpt = "From the middle waters we came, and the rivers still carry our names." }
  , Work { workId = 68, title = "Talking to the Moon", authorRef = 31, genre = Memoir, yearPub = 1945, pages = 244, publisher = "University of Chicago Press", awards = [], form = "Memoir", excerpt = "Out here on the blackjack ridges I learned to listen to what most men cannot hear." }
  , Work { workId = 69, title = "A History of the Osage People", authorRef = 32, genre = Nonfiction, yearPub = 1989, pages = 0, publisher = "", awards = [], form = "Nonfiction", excerpt = "Every family carries a thread of the larger story. Together those threads are a nation." }
  , Work { workId = 70, title = "Osage Indian Customs and Myths", authorRef = 32, genre = Nonfiction, yearPub = 1984, pages = 0, publisher = "", awards = [], form = "Nonfiction", excerpt = "The old stories are not entertainment. They are the architecture of the world." }
  , Work { workId = 71, title = "A Pipe for February", authorRef = 33, genre = LiteraryFiction, yearPub = 2002, pages = 271, publisher = "University of Oklahoma Press", awards = [], form = "Novel", excerpt = "When the oil came, the Osage learned that wealth could be a kind of violence too." }
  , Work { workId = 72, title = "A Calm and Normal Heart", authorRef = 34, genre = ShortStory, yearPub = 2022, pages = 224, publisher = "Unnamed Press", awards = [], form = "Story Collection", excerpt = "She was learning her language one word at a time, and each word was a small homecoming." }
  , Work { workId = 73, title = "Bestiary", authorRef = 35, genre = Poetry, yearPub = 2009, pages = 0, publisher = "", awards = [], form = "Poetry Collection", excerpt = "Each creature carries a memory the human world has forgotten how to read." }
  , Work { workId = 74, title = "The Nightlife", authorRef = 35, genre = Poetry, yearPub = 2017, pages = 0, publisher = "", awards = [], form = "Poetry Collection", excerpt = "In the small hours the city becomes another country, and we become other selves." }
  , Work { workId = 75, title = "Blood Wolf Moon", authorRef = 35, genre = Poetry, yearPub = 2025, pages = 0, publisher = "", awards = [], form = "Poetry Collection", excerpt = "Under the wolf moon, the women of my family rise into the cold to remember." }
  , Work { workId = 76, title = "An Eagle Nation", authorRef = 36, genre = Poetry, yearPub = 1993, pages = 0, publisher = "", awards = [], form = "Poetry Collection", excerpt = "We are a nation of relatives. The eagle, the cousin, the unborn, the stone." }
  , Work { workId = 77, title = "Winning the Dust Bowl", authorRef = 36, genre = Poetry, yearPub = 2001, pages = 0, publisher = "", awards = [], form = "Poetry Collection", excerpt = "Dust returns. Land returns. Memory returns. We belong to all of it." }
  , Work { workId = 78, title = "Wasase: Indigenous Pathways of Action and Freedom", authorRef = 37, genre = Nonfiction, yearPub = 2005, pages = 313, publisher = "Broadview Press", awards = [], form = "Nonfiction", excerpt = "Resurgence is not nostalgia. It is the disciplined refusal of the colonial present." }
  , Work { workId = 79, title = "Heeding the Voices of Our Ancestors", authorRef = 37, genre = Nonfiction, yearPub = 1995, pages = 0, publisher = "", awards = [], form = "Nonfiction", excerpt = "Sovereignty begins inside the people, in the way they speak to each other and to the land." }
  , Work { workId = 80, title = "Mohawk Trail", authorRef = 38, genre = ShortStory, yearPub = 1985, pages = 0, publisher = "", awards = [], form = "Story Collection", excerpt = "We are women who refuse to be unseen, refuse to be unheard, refuse to be unwoven." }
  , Work { workId = 81, title = "Food & Spirits", authorRef = 38, genre = ShortStory, yearPub = 1991, pages = 0, publisher = "", awards = [], form = "Story Collection", excerpt = "What we cook, what we feed each other, that is the truest history of a people." }
  , Work { workId = 82, title = "Writing as Witness", authorRef = 38, genre = Nonfiction, yearPub = 1994, pages = 0, publisher = "", awards = [], form = "Nonfiction", excerpt = "To write is to refuse forgetting. That is the writer's first ceremony." }
  , Work { workId = 83, title = "Mama Poems", authorRef = 39, genre = Poetry, yearPub = 1984, pages = 0, publisher = "", awards = [], form = "Poetry Collection", excerpt = "My mother's hands held the world together with thread the priests could not see." }
  , Work { workId = 84, title = "Greyhounding This America", authorRef = 39, genre = Poetry, yearPub = 1988, pages = 0, publisher = "", awards = [], form = "Poetry Collection", excerpt = "Through the bus window the country unfolds itself like a wound we keep choosing to dress." }
  , Work { workId = 85, title = "Tekonwatonti / Molly Brant", authorRef = 39, genre = Poetry, yearPub = 1992, pages = 0, publisher = "", awards = [], form = "Poetry Collection", excerpt = "She walked between empires and made herself a nation of one." }
  , Work { workId = 86, title = "Kiss of the Fur Queen", authorRef = 40, genre = LiteraryFiction, yearPub = 1998, pages = 310, publisher = "Doubleday Canada", awards = [], form = "Novel", excerpt = "Two brothers, two pianos, and the howling wind of the residential school behind them." }
  , Work { workId = 87, title = "Caribou Song", authorRef = 40, genre = LiteraryFiction, yearPub = 2001, pages = 0, publisher = "", awards = [], form = "Novel", excerpt = "When the caribou come, the world becomes a thunder of belonging." }
  , Work { workId = 88, title = "The Rez Sisters", authorRef = 40, genre = LiteraryFiction, yearPub = 1986, pages = 118, publisher = "Fifth House", awards = ["Chalmers Award"], form = "Novel", excerpt = "Seven women, one bingo, and all the laughter and grief a reservation can hold." }
  , Work { workId = 89, title = "This Wound Is a World", authorRef = 41, genre = Poetry, yearPub = 2017, pages = 0, publisher = "", awards = ["Griffin Poetry Prize"], form = "Poetry Collection", excerpt = "To be NDN and queer is to be a question the world tries to close and cannot." }
  , Work { workId = 90, title = "A History of My Brief Body", authorRef = 41, genre = Memoir, yearPub = 2020, pages = 208, publisher = "Two Dollar Radio", awards = [], form = "Memoir", excerpt = "The body is a country I am still learning to inhabit without flinching." }
  , Work { workId = 91, title = "A Minor Chorus", authorRef = 41, genre = LiteraryFiction, yearPub = 2022, pages = 296, publisher = "W. W. Norton", awards = [], form = "Novel", excerpt = "Sometimes the smallest voice in the room is the one keeping the song alive." }
  , Work { workId = 92, title = "Bad Cree", authorRef = 42, genre = LiteraryFiction, yearPub = 2023, pages = 272, publisher = "Doubleday", awards = [], form = "Novel", excerpt = "The crows in her dreams were carrying messages, and one of them was her sister." }
  , Work { workId = 93, title = "Bear Bones & Feathers", authorRef = 43, genre = Poetry, yearPub = 1994, pages = 0, publisher = "", awards = [], form = "Poetry Collection", excerpt = "Even the bones know how to sing the old songs back into the wind." }
  , Work { workId = 94, title = "Blue Marrow", authorRef = 43, genre = Poetry, yearPub = 1998, pages = 0, publisher = "", awards = [], form = "Poetry Collection", excerpt = "My grandmothers stand behind me, and behind them stand the mothers of all our mothers." }
  , Work { workId = 95, title = "Burning in This Midnight Dream", authorRef = 43, genre = Poetry, yearPub = 2016, pages = 0, publisher = "", awards = [], form = "Poetry Collection", excerpt = "The school is gone but the dream still wakes me, still kneels me to the floor." }
  , Work { workId = 96, title = "The Barren Grounds", authorRef = 44, genre = LiteraryFiction, yearPub = 2020, pages = 256, publisher = "Puffin Books", awards = [], form = "Novel", excerpt = "Two foster kids slip through a hidden door and find a land they were always meant to defend." }
  , Work { workId = 97, title = "When We Were Alone", authorRef = 44, genre = LiteraryFiction, yearPub = 2016, pages = 24, publisher = "Portage & Main Press", awards = ["Governor General's Award"], form = "Novel", excerpt = "Why is your hair long, kohkom? Because once they tried to cut all of us short." }
  , Work { workId = 98, title = "Black Water", authorRef = 44, genre = Memoir, yearPub = 2020, pages = 384, publisher = "HarperCollins", awards = [], form = "Memoir", excerpt = "My father walked back to his trapline and brought a piece of his old self home with him." }
  , Work { workId = 99, title = "52 Ways to Reconcile", authorRef = 44, genre = Nonfiction, yearPub = 2022, pages = 0, publisher = "", awards = [], form = "Nonfiction", excerpt = "Reconciliation is not a destination. It is a daily practice of attention and choice." }
  , Work { workId = 100, title = "Five Little Indians", authorRef = 45, genre = LiteraryFiction, yearPub = 2020, pages = 304, publisher = "Harper Perennial", awards = ["Governor General's Award", "Canada Reads"], form = "Novel", excerpt = "Five children left the school. None of them left the school whole." }
  , Work { workId = 101, title = "Truth Telling", authorRef = 45, genre = Nonfiction, yearPub = 2023, pages = 288, publisher = "HarperCollins", awards = [], form = "Nonfiction", excerpt = "We are not asking to be heard. We are telling you, and the telling itself is the work." }
  , Work { workId = 102, title = "Making Love with the Land", authorRef = 26, genre = Nonfiction, yearPub = 2022, pages = 240, publisher = "Knopf Canada", awards = [], form = "Nonfiction", excerpt = "To love the land is to remember that you are it, and that it has always been loving you back." }
  ]