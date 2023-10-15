r = {
  g = {
    case = {
      camel_snake = "[a-zA-Z][a-zA-Z0-9]*(?:_[A-Z]+[a-zA-Z0-9]+)*",
      camel = "[a-zA-Z][a-z0-9]*(?:[A-Z][a-z0-9]*)*",
    },
    syntax = {
      dice = "(?:\\d+)?d\\d+(?:[/x\\*]\\d+)?(?:[+-]\\d+)?",
      point = "(-?\\d+)..*?(-?\\d+)"
    },
    char_range = {
      printable_ascii = "\\x20-\\x7E",
      ascii = "\\x00-\\x7F",
    },
    rfc3339like_dt = "\\d{4}(?:" ..
        "\\-\\d{2}(?:" ..
          "\\-\\d{2}(?:" ..
            "T\\d{2}(?:" ..
              "\\:\\d{2}(?:" ..
                "\\:\\d{2}(?:" ..
                  "\\.\\d{1,9}"
                ..")?"
              ..")?"
            ..")?Z?"
          ..")?"
        ..")?"
      ..")?",
    fs_tag_str = "(?:%[a-z0-9_]+-[a-z0-9_]+)*",
    b = {
      b64 = {
        gen = "[A-Za-z0-9\\+/=]+",
        url = "[A-Za-z0-9_\\-=]+"
      },
      b32 = {
        gen = "[A-Za-z2-7=]+",
        crockford = "[0-9A-HJKMNP-TV-Z=]+"
      }
    },
    cronspec = "(?:@(annually|yearly|monthly|weekly|daily|hourly|reboot))|(?:@every (\\d+(ns|us|µs|ms|s|m|h))+)|((((\\d+,)+\\d+|(\\d+(\\/|-)\\d+)|\\d+|\\*) ?){5,7})",
    id = {
      issn = "[0-9]{4}-?[0-9]{3}[0-9xX]",
      isbn10 = "[0-9]{9}[0-9xX]",
      isbn13 = "[0-9]{13}",
      uuid = "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}",
      doi = "(10\\.\\d{4,9}/[-._;()/:A-Z0-9]+)",
      doi_prefix = "^https?://[^/]+/",
      relay_identifier = "[a-z]{2}-[a-z]{3}-(?:wg|ovpn)-\\d{3}",
      media_type = "[-\\w.]+/[-\\w.\\+]+",
      domain_name = "(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]",
      ipc_socket_id = "\\d+-\\d+",
    },
    html_entity = "&(?:[a-zA-Z\\d]+|#\\d+|#x[a-fA-F\\d]+);",
    input_spec_str = "(?:\\.[lrm])|(?::.*)|(?:[ms]-?\\d+..*?-?\\d+ %[a-zA-Z]+)",
    whitespace = {
      large = "[\t\r\n]"
    },
    url_scheme = "[a-zA-Z][a-zA-Z0-9+.-]*-:",
    ipv4 = "(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)",
    extract_key_value_assoc = "^(\\w+)_key(?:_(\\w+)_value)?_assoc$",
    shell_shebang = "^#!\\s*/.*?(?:ba|z|fi|da|k|t?c)sh\\s+",
    url = {
      host = {
        subpart = {
          domain_and_tld = "(\\w+\\.\\w+)$",
          domain = "(\\w+)\\.\\w+$",
          tld = "\\w+\\.(\\w+)$"
        }
      },
      scheme = "^([a-zA-Z][a-zA-Z0-9+.-]*)-:"
    },
    version = {
      semver = "(\\d+)(?:\\.(\\d+)(?:\\.(\\d+)(?:\\-([\\w.-]+))?(?:\\+([\\w.-]+))?)?)?",
    }
  },
  lua = {
    without_extension_and_extension = "(.+)%.([^%.]+)",
    classes = {
      sep = "[_%-%.:;%s/T]",
    },
  }
}

consts = {
  unique_record_separator  = "__ENDOFRECORD5579__",
  unique_field_separator = "Y:z:Y"
}

ls = {
  lua_regex_metacharacters = {"%", "^", "$", "(", ")", ".", "[", "]", "*", "+", "-", "?"},
  general_regex_metacharacters =  {"\\", "^", "$", ".", "[", "]", "*", "+", "?", "(", ")", "{", "}", "|", "-"},
  small_words = {
    "a", "an", "and", "as", "at", "but", "by", "en", "for", "if", "in", "of", "on", "or", "the", "to", "v", "v.", "via", "vs", "vs."
  },
  booru_hosts = {
    "gelbooru.com",
    "danbooru.donmai.us",
    "yande.re",
  },
  proximate_sources = {
    "booru",
      "danbooru",
      "gelbooru",
      "xbooru",
      "aibooru",
    "pornpendotai", -- cnm pornpen.ai
    "trynectardotai", -- cnm trynectar.ai
    "discord",
    "reddit",
    "aliexpress"
  },
  proximate_source_page_type = {
    "post",
    "thread",
    "product page",
  },
  proximate_source_subdivision = {
    "midjourney"
  },

  tree_node_keys = {"pos", "children", "parent", "text", "tag", "attrs", "cdata"},
  project_type = {
    "latex",
    "omegat",
    "npm",
    "cargo",
    "sass"
  },
  apis_that_dont_support_authorization_code_fetch = {"google"},
  backup_type = {
    "facebook",
    "telegram",
    "signal",
    "discord"
  },
  booru_rating = {
    "general",
    "sensitive",
    "safe", -- safe ≙ general or sensitive
    "questionable",
    "explicit"
  },
  hydrus_namespace = {
    "character",
    "date",
    "medium",
    "meta",
    "person",
    "series",
    "studio",
    "general",
    "title"
  },
  all_namespace = {

    -- series tag namespaces - where within some general series does this object fit?

    "chapter_index", -- numerical index of a chapter, e.g. 25
    "chapter_title", -- title of a chapter, e.g. "Can't stop won't stop can't stop"
    "page_index", -- numerical index of a page within a chapter or work, e.g. 11
    "volume_index", -- numerical index of a volume, e.g. 3
    "episode_index", -- numerical index of an episode, e.g. 3
    "episode_subindex", -- numerical index of an object within an episode, e.g. 5. In principle, episode_timestamp would be better, but this is exists where that information isn't easily available or has been lost.
    "episode_timestamp", -- timestamp of an object within an episode, e.g. 00:03:12.
    "season_index", -- numerical index of a season, e.g. 3

    -- creation tag namespaces - who, when, where, and how was this object created?
    
    "creation_ware", -- anything that was used to create the object, be that meatspace or cyberspace, tools or people, organizations or brands. E.g. "studio trigger", "kana hanazawa", "makoto shinkai", "adobe illustrator", "mirrorless camera"
    "official_title", -- the official title of a work, if applicable. E.g. "The Lord of the Rings: The Fellowship of the Ring", "One Hundred Years of Solitude", etc. Bear in mind that this isn't the title of the series, but of the specific work. 
    "semver", -- semantic version of a work, e.g. 1.0.0
    "creation_use", -- what the object was created for. Don't use this when the message tags could apply, and also consider if general tags might not be sufficient. So, if this is a photo of an antique contract, creation_use:contract *could* be used, but why not just use format:contract and maybe general:yellowed paper?
    "creation_stage", -- what stage of the creation process the object is in. E.g. brainstorming, conceptualization, mockup, final_product, etc. Don't forget to add any relevant general tags. So if you have a mockup that which uses a smartphone mockup, add general:smartphone_mockup.
    "completeness", -- how complete the creator considers the object to be. E.g. complete, incomplete, abandoned, creation_stage_of_other_object

    -- creation tags > creation settings tag namespaces - what settings were used to create the object?

    "prompt", -- if creator:ai or a child tag of creator:ai, what the prompt was. e.g. "a picture of a cat"
    -- in the future, I may add more tags for specific settings, e.g. "brush size", "f-stop", etc.

    -- creation tags > location tag namespaces - where was the object created?
    -- if the location is also visually identifiable in the object, don't forget to add the corresponding general:<location name> (<location type>) tag, e.g. general:berlin (city)
    "lat", -- latitude of the object as a decimal number, if applicable. E.g. 48.137154.
    "lon", -- longitude of the object as a decimal number, if applicable. E.g. 11.576124
    "country",
    "city",
    "venue", -- a specific name of a location, e.g. My mom's house, 2016 italy rental, etc.
    "tourism", -- works like the OSM tourism field

    -- thing tag namespaces - what can be percieved in the fobjectlike, or inferred only from the fobjectlike and a reasonable knowledge of the world? What importance does it have to the fobjectlike?
    
    "thing", -- Anything that appears in the fobjectlike, or is referenced. This describes the thing namespace set, which is also used below.
    "substance", -- A thing namespace item which describes the fobjectlike itself, rather than one of its parts or something contained within. thing:apple means it contains an apple, substance:apple means it is an apple. thing:aqua 1-adic range SBCS^2^ means there is something aqua, substance:aqua 1-adic range SBCS^2^ means the object is a color sample of aqua.
    "substance_part", -- A thing namespace item which describes something that contributes to the substance of the fobjectlike. E.g. substance_part:apple means that a recognizable part of the fobjectlike itself is an apple. substance_part:photo means that a recognizable part of the fobjectlike itself is a photo.
    "focus", -- A thing namespace item which describes the main focus of the fobjectlike. E.g. focus:apple means the apple is the main focus of the object.
    "theme", -- A thing namespace item which describes something that is important throughout the fobjectlike, but not necessarily the main focus. E.g. theme:apple might mean that apples are strategically placed around the object to symbolize temptation, or just because it's a food picture with a fall-apple theme.
    "accent", -- A thing namespace item which describes something that has some amount of focus within the fobjectlike, but not as much as the focus or theme. E.g. thing:dagger means it contains a dagger, accent:dagger might mean that there is a dagger in the background as an easter egg or foreshadowing.
    "framing", -- A thing namespace item which describes something that gives major context to the fobjectlike. E.g. framing:dagger might mean that the fobjectlike is a dagger with some intericate metalwork, where the metalwork is the focus, but the dagger is the framing. framing:web browser might mean that the focus is some content on the web, but the web browser what gives it context and meaning. This does not mean that anything e.g. in a web browser must be tagged with framing:web browser, if that fact is unimportant to the fobjectilke.
    "incidental", -- A thing namespace item which describes something that is present in the fobjectlike, but is not important to it at all.

    -- important illocutionary message tag namespaces - what is the object trying to tell me? 

    "message_force", -- what illocutionary force does the message have
    "message_direction", -- what direction does the message have? e.g. inbound, outbound
    "message_change", -- what kind of change does the message have? e.g. change_of_amount, increase, decrease, change_of_state, commencement, ...
    "message_subject", -- i.e. the general locutionary content. What is the force about? e.g. money, employment, housing, etc.
    -- there'd be some reason to add a "message_audience" tag, but for now I think I'm well enough served by tagging that with person:<name>, given the audience's name is likely to be mentioned or implied in the object, which forces me to tag it with person:<name> anyway. Thus there'd be a lot of redundancy.

    -- sharing tag namespaces - many objects I encounter were shared in some way, such that I was able to encounter them. These tags are for that.

    "proximate_source", -- the location where I encountered an object, or where it was shared. E.g. reddit, danbooru, etc. Many downloaders automatically populate this tag, but setting it manually is not strictly necessary.
    "proximate_source_page_type", -- the type of the page where I encountered the object. E.g. post, thread, product page, etc.
    "proximate_source_subdivision", -- the subdivision of the proximate_source where I encountered the object. E.g. the subreddit, the board, etc.
    "proximate_source_title", -- the title of the proximate_source. E.g. the reddit post title
    "proximate_source_use", -- what was the object used for on the proximate_source? For many proximate sources there isn't an interesting one, but for example for amazon, this could be product_picture
    "uploader", -- the uploader/sharer of the object on the proximate_source. E.g. the reddit username, or the twitter handle.

    -- acquisition tag namespaces - how did I acquire the object? This is not the same as sharing, as I may have acquired the object in a way that doesn't involve sharing, e.g. by creating it myself.

    "date", -- date of acquisition in (partial) RFC3339 format
    "occasion", -- the occasion the object was acquired in/for. This may be specific e.g. 2025 trip to canada, or more general, e.g. christmas. 
    "acquisition_context", -- the context of my life this object was created or encountered in. Can be general, e.g. edu, work, leisure, etc., or more specific, e.g. freelance translation. The more specific ones should be tag children of the more general ones. The difference between this and occasion is that an occasion is a temporally bounded event, while an acquisition_context is an area of my life that may or may not be temporally bounded. In a sense, these are orthogonal to each other. If I have a christmas party at my workplace, I would tag the occasion as christmas (or perhaps 2015 christmas party, with corresponding parents), and the acquisition_context as work (or perhaps 2012-2017 graphic design job). So if I was wondering what I did at christmas, I could just search occasion:christmas, even though I spent the 2015 christmas at work, and perhaps another at home.
    "acquisition_institution", -- the institution that I created the object at/for or encountered it in.. E.g. university of melbourne, etc. 
    "period", -- Some processes or organizations categorize things into periods, even where the `date` field may lie outside of those periods. Financial years & quarters, academic years, semesters, trimesters, etc. This tag is for those. If it's not a recognized period, consider using `occasion` or another tag instead. Specific examples: "winter semester 2020", "2018 school year". Inheritance is set up thus that e.g. winter semester 2020 -> winter semester & 2020 semester -> semester, 2018 school year -> school year

    -- use tag namespaces - why did I keep the object? What do I use it for?

    "use", -- Without complex semantics, what might I want to use the iamge for? e.g. reaction_face, inspiration, etc. 

    -- general meta tag namespaces - tags with a more general purpose, that don't fit into any of the above categories.

    "collection", -- a wide field that allows grouping objects in a way where I don't want to create a specific tag namespace, potentially only temporarily. Prefer more specific namespaces where possible.
    "meta", -- things that you know about the object, but aren't directly visible, and aren't included in other fields. I rarely use this, but parsers I use sometimes do.
    "title", -- the title of a work. This is fed from various sources and may be quite polluted. I don't use this much, but it's there.
  },
  acquisition_context = {
    "edu",
    "kindergarden",
    "school",
    "primary",
    "secondary",
    "uni",
    "philosophy bachelors",
    "official",
    "contract",
    "insurance",
    "health insurance",
    "barmer health insurance",
    "housing",
    "rental housing",
    "2023 stw berlin housing", -- cnm 2023- stw berlin housing
    "leisure",
    "sports",
    "surfing",
    "hornysurfing",
    "gaming",
    "animanga",
    "reading manga",
    "watching anime",
    "dating",
    "work",
    "freelance",
    "freelance translation",
    "permanent employment",
    "2022 mycontrol", -- cnm 2022- mycontrol
    "ownership",
    "interests",
    "dev",
    "language",
    "japanese",
    "systems",
    "2022 hammerspoon" -- cnm 2022- hammerspoon
  },
  acquisition_institution = {
    "tu",
    "hu",
    "fu",
    "ur",
    "primary"

  },
  use = {
    "hot",
      "medium hot",
      "very hot",
      "incredibly hot",
    "funny",
      "medium funny",
      "very funny",
      "incredibly funny",
    "inspiration",
      "medium inspiration",
      "very inspiration",
      "incredibly inspiration",
      "style inspiration",
    "reflection",
      "medium reflection",
      "very reflection",
      "incredibly reflection",
  },

  things = {
    "agentlike", -- anything that is an agent, or is shaped like one, or otherwise similar
      "unique agentlike",
        "real agentlike",
        "fictional agentlike",
      "gendered agentlikes",
        "male agentlike",
        "female agentlike",
        "nonbinary agentlike",
        "agender agentlike",
        "genderfluid agentlike",
      "related agentlike",
        "family agentlike",
          "parent",
            "male parent",
            "female parent",
            "nonbinary parent",
            "agender parent",
            "genderfluid parent",
      "aged agentlike",
        "old agentlike", -- aliases general:old
        "young agentlike",
          "child agentlike", -- aliases general:child
          "baby agentlike", -- aliases general:baby
        "modified age agentlike",
          "aged up agentlike", -- aliases general:aged up
          "aged down agentlike", -- aliases general:aged down
      "agentlike state",
        "amputee", -- aliases general:amputee
      "semihumanoid", -- a semihumanoid has at least some of the features of a humanoid.
        "dullahan", -- aliases general:dullahan
        "hemihumanoid",
          "leg hemihumanoid", -- look mom, no arms!
          "arm hemihumanoid", -- look mom, no legs!
        "humanoid hybrid", -- humanoid plus something extra
          "monster humanoid",
            "taur", -- aliases general:taur
              "centauroid", -- aliases general:centauroid
                "centaur", -- aliases general:centaur
              "arachne", -- aliases general:arachne
            "female monster humanoid", -- aliases general:monster girl
              
        "humanoid", -- two arms, two legs, a head, and a torso, plus extras. Minor deviations allowed.
          "basically humans", -- almost human, don't sweat the details
          "clearly nonhuman humanoid",
            "slime girl", -- aliases general:slime girl

      "animallike",
        "animal by taxon (simplified)",
          "vertebrate",
            "mammal",
              "carnivora animal",
                "bear",
                  "brown bear",
                  "black bear",
                  "polar bear",
                "felidae animal",
                  "felinae animal",
                    "cat",
                    "lynx",
                    "puma",
                  "panthera animal",
                    "tiger",
                    "lion",
                    "leopard",
                    "jaguar",
                    "snow leopard",
                "canidae animal",
                  "canina animal",
                    "wolf",
                    "dog",
                    "coyote",
                  "vulpini animal",
                    "racoon dog",
                      "tanuki",
                    "fox",
                  "other canidae animal",
                    "jackal",
                "musteloidae animal",
                  "weasel",
                  "otter",
                  "badger",
                  "raccoon",
                  "skunk",
                  "ferret",
                "other carnivora taxa animal",
              "rodentia",
                "porcupine",
                "quinea pig",
                "beaver",
                "chipmunk",
                "squirrel",
                "rat",
                "mouse",
                "hamster",
                "gerbil",
              "primate",
                "prosimian",
                  "lemur",
                  "loris",
                "monkey",
                "ape",
                  "lesser ape",
                  "great ape",
                    "orangutan",
                    "gorilla",
                    "chimpanzee",
                    "bonobo",
              "lagomorpha animal",
                "hare",
                "rabbit",
              "ungulate",
                "perisodactyl",
                  "equid",
                    "horse",
                    "ass (animal)",
                      "donkey",
                    "zebra",
                  "rhinoceros",
                  "tapir",
                "artiodactyl",
                  "camelid",
                    "llama",
                    "alpaca",
                    "camel",
                      "dromedary camel",
                  "suinan",
                    "domestic pig",
                    "wild boar",
                  "ruminant",
                    "giraffidae animal",
                      "giraffe",
                      "okapi",
                    "bovid",
                      "cattle",
                      "yak",
                      "bison",
                      "buffalo",
                      "antilope",
                      "sheep",
                      "goat",
                    "deer",
                      "elk",
                      "reindeer",
                      "moose",
                  "hippopotamid",
                    "hippopotamus",
                  "whale",


            "fish",
            "amphiban",
            "reptile",
            "bird",
        "real animal",
        "imagined animal",
          "pokemon", -- aliases general:pokemon (creature)
            "pikachu", 
      "robot", -- aliases general:robot
        "robot animallike", -- implies things:animallike
        "semihumanoid robot", -- implies things:semihumanoid -- just decided to put it here arbitrarily
          "humanoid robot", -- implies things:humanoid -- just decided to put it here arbitrarily
            "human-passing humanoid robot", -- aliases general:android
            "non human-passing humanoid robot", -- aliases general:humanoid robot
          "mecha", -- aliases general:mecha; giant andor piloted robot
            "walker mecha", -- aliases general:walker; implies things:leg hemihumanoid
    "message",
      "message change",
        "change of amount message",
            "increase message",
            "decrease message",
          "complete change message",
            "commencement message",
            "pause message",
            "resumption message",
            "cessation message",
          "change of state message",
            "modification message",
          "unchanged continuation message",
      "message direction",
        "inbound message",
        "outbound message",
      "message force", -- -- illocutionary force of the message
        "declarative",
          "notice",
          "regulations",
          "declaration",
            "authorization",
            "revocation",
            "certificate",
            "declaration of fact",
              "affidavit",
        "commissive",
          "twosided commissive",
            "contract",
            "agreement",
            "terms and conditions",
          "onesided commissive",
            "promise",
            "offer",
        "assertive",
          "evidence",
            "indirect evidence",
              "artifact",
              "documentation",
              "indicator",
            "direct evidence",
          "information",
            "breakdown",
              "numerical breakdown",
            "schematic",
            "documentation",
              "manual",
            "overview",
            "miscellaneous information",

    "style", 
      "visual style",
        "color style",
          "SBCS^2^",
            "lightness SBCS^2",
              "lightness 1-adic SBCS^2",
                "lightness 1-adic range SBCS^2", -- [theme] aliases general:pale color
            "saturation SBCS^2",
              "saturation 1-adic SBCS^2",
                "0 saturation 1-adic SBCS^2", -- [substance] aliases general:greyscale
            "hsv saturation SBCS^2",
              "hsv saturation 1-adic SBCS^2",
                "hsv saturation 1-adic range SBCS^2", 
                  "1st 2tile hsv saturation 1-adic range SBCS^2", -- [theme] aliases general:muted color
            "hsv saturation value SBCS^2",
              "hsv saturation value 1-adic SBCS^2",
                "hsv saturation value 1-adic range SBCS^2",
                  "1st 4tile hsv saturation 4th 4tile value 1-adic range SBCS^2", -- [theme] aliases general:pastel colors
            "hue SBCS^2^",
              "temperature SBCS^2^",
                "red-based temperature SBCS^2^",
                  "red-based cool SBCS^2^",
                    "red-based cool range SBCS^2^",
                  "red-based warm SBCS^2^",
                    "red-based warm range SBCS^2^",
                "yellow-based temperature SBCS^2^",
                  "yellow-based cool SBCS^2^",
                    "yellow-based cool range SBCS^2^",
                  "yellow-based warm SBCS^2^",
                    "yellow-based warm range SBCS^2^",
              "hue 1-adic SBCS^2^",
                "hue 1-adic range SBCS^2^", -- [substance] aliases general:monochrome
                  "aqua 1-adic range SBCS^2^", -- [theme] aliases general:aqua theme
                  "black 1-adic range SBCS^2^", -- [theme] aliases general:black theme
                  "blue 1-adic range SBCS^2^", -- [theme] aliases general:blue theme
                  "brown 1-adic range SBCS^2^", -- [theme] aliases general:brown theme
                  "green 1-adic range SBCS^2^", -- [theme] aliases general:green theme
                  "grey 1-adic range SBCS^2^", -- [theme] aliases general:grey theme
                  "orange 1-adic range SBCS^2^", -- [theme] aliases general:orange theme
                  "pink 1-adic range SBCS^2^", -- [theme] aliases general:pink theme
                  "purple 1-adic range SBCS^2^", -- [theme] aliases general:purple theme
                  "red 1-adic range SBCS^2^", -- [theme] aliases general:red theme
                  "white 1-adic range SBCS^2^", -- [theme] aliases general:white theme
                  "yellow 1-adic range SBCS^2^", -- [theme] aliases general:yellow theme
        "hyperbody style",
          "line style",
            "line thickness style",
            "line roughness style",
          "surface style",
    "effect",
      "visual effect",
        "2d effect",
          "cameralike effect",
            "lens effect", -- -- an effect due to the fact that cameras use lenses
              "lens artifact",
                "lens flare", -- aliases general:lens flare
                "bokeh", -- aliases general:bokeh
                "chromatic aberration", -- aliases general:chromatic aberration
                "diffraction spikes", -- aliases general:diffraction spikes
              "expousre triangle effect",
                "exposure effect",
                  "motion blur", -- aliases general:motion blur
            "signal processing effect",
              "film effect", 
                "film grain", -- aliases general:film grain
          "perceptual effect",
            "afterimage", -- aliases general:afterimage
          "post effect",
            "symbolic effects",
  
            "insert",
              "cut-in",
            "blur effect", -- aliases general:blur 
    "object",
      "non body part",
        "real object",
          "specific object",
            "general assemblage",
              "assemblage of structures",
                
            "spatial features",
              "natural features",
                "earthen features",
                  "firmamental features",
                  "grounded features",
              "infrastructure",

            "single object",
              "abstract object",
                "text",
              "digital object",
                "digital mockup",
                  "smartphone mockup",
                "user interface object",
                  "user interface component",
                    "icon",
                  "user interface",
                    "os user interface",
                      "smartphone user interface", -- aliases general:fake phone screenshot
                      "desktop user interface",
                    "app user interface", -- -- the user interface of an app or program covering the entire screen. Protyptically in the kind of screenshots cmd+shift+5 can take
                "software application",

                "operating system",
                  "mobile operating system",
                    "android os", -- cnm android (os); aliases general:android (os); implies android google
              "prototypically 2d object",
                "document",
                  "slide",
                    "latex slide", -- -- you know the one
                  "cv",
                "photograph",
                  "polaroid", -- aliases general:polaroid
                "2d functional art",
                  "large format functional",
                    "poster",
                      "movie poster",
                  "medium format functional",
                    "calendar page", -- [substance] aliases general:calendar (medium)
                    "cover", -- [substance] aliases general:cover
                      "standalone print media cover", -- [substance] aliases general:cover page
                        "novel cover", -- [substance] aliases general:novel cover
                        "doujin cover", -- [substance] aliases general:doujin cover
                        "manga cover", -- [substance] aliases general:manga cover
                      "album cover", -- [substance] aliases general:album cover
                      "magazine cover", -- [substance] aliases general:magazine cover
                      "video game cover", -- [substance] aliases general:video game cover
                      "dvd cover", -- [substance] aliases general:dvd cover
                      "bluray cover", -- [substance] aliases general:bluray cover
                      "small format functional",
                        "postcard",
                        "flyer",
                          "tear off flyer",
                      "irregular format functional",
                        "crest",
              "prototypically 3d object",
                "consumer device",
                  "black mirror",
                    "smartphone",
                      "google pixel smartphone", -- implies google pixel
                        "google pixel 4",
                "household object",
                  "furniture",
                  "appliance",
                    "major appliance",
                    "small appliance",
                "piece of clothes",
                "tool",
                  "medical device",
                    "medical test",
                  "sex toy", -- aliases general:sex toy
                  "bodyrelated tool",
                    "genital tool",
                      "speculum", -- aliases general:speculum
                      "dilation tape", -- aliases general:dilation tape
          "material",
            "material by assemblage",
              "strand-assembled material",
                "bunched-strand material",
                "interleaved-strand material",
                  "woven material",
                  "knitted material",
              "bonded material",
              "one-piece material",
                "hewn material",
                "molded material",
            "material by underlying form",
              "material from aggregate",
              "material from fibers",
            "material by underlying substance",
              "natural-seeming material",
                "plant-based material",
                  "mainly cellulose-based material",
                    "wood cellulose-based material",
                    "flax cellulose-based material",
                    "cotton cellulose-based material",
                    "hemp cellulose-based material",
                  "mainly lignin-based material",
                "animal-based material",
              "permanent-seeming material",
                "petroleoum-based material",
                "mineral-based material",
                "metal-based material",
            "material by common name",
              "paper", -- aliases general:paper; implies ???
              "canvas", -- [substance_part] aliases general:canvas (medium)
          "surface covering",
            "3d-ish surface covering", -- aliases general:unconventional media
            "2d-ish surface covering",
              "graphic art surface covering",
                "digital graphic art surface covering",
                "digital-seeming graphic art surface covering",
                "traditional graphic art surface covering",
                "traditional-seeming graphic art surface covering", -- [substance_part] aliases general:traditional media
                  "penlike seeming surface covering",
                    "ballpoint pen seeming surface covering", -- [substance_part] aliases general:ballpoint pen (medium)
                  "crayonlike seeming surface covering", 
                    "crayon seeming surface covering", -- [substance_part] aliases general:crayon (medium)
                    "coupy pencil seeming surface covering", -- [substance_part] aliases general:coupy pencil (medium)
                  "inklike seeming surface covering",
                    "ink seeming surface covering", -- [substance_part] aliases general:ink (medium)
                    "nib pen seeming surface covering", -- [substance_part] aliases general:nib pen (medium)
                    "calligraphy brush seeming surface covering", -- [substance_part] aliases general:calligraphy brush (medium),
                    "color ink seeming surface covering", -- [substance_part] aliases general:color ink (medium)
                  "graphitelike seeming surface covering",
                    "graphite seeming surface covering", -- [substance_part] aliases general:graphite (medium)
                    "charcoal seeming surface covering", -- [substance_part] aliases general:charcoal (medium)
                    "colored pencil seeming surface covering", -- [substance_part] aliases general:colored pencil (medium)
                  "painting seeming surface covering",
                    "acrylic paint seeming surface covering", -- [substance_part] aliases general:acrylic paint (medium)
                    "gouache seeming surface covering", -- [substance_part] aliases general:gouache (medium)
                    "oil paint seeming surface covering", -- [substance_part] aliases general:oil painting (medium)
                    "watercolor seeming surface covering", -- [substance_part] aliases general:watercolor (medium)
                  "watercolor pencil seeming surface covering", -- [substance_part] aliases general:watercolor pencil (medium)
                  "pastel seeming surface covering", -- [substance_part] aliases general:pastel (medium)
                "real digital graphic art surface covering", -- implies digital graphic art surface covering, digital-seeming graphic art surface covering
                "real traditional graphic art surface covering", -- implies traditional graphic art surface covering, traditional-seeming graphic art surface covering
                "faux digital graphic art surface covering", -- implies traditional graphic art surface covering, digital-seeming graphic art surface covering
                "faux traditional graphic art surface covering", -- implies digital graphic art surface covering, traditional-seeming graphic art surface covering; aliases general:faux traditional media
        "symbolic object",
          "flag",
        "hyperbody",
          "2d hyperbody",
            "conic section",
              "ellipse",
                "circle",
              "parabola",
              "hyperbola",
            "polygon",
              "n-sided polygon",
                "1-sided polygon",
                "2-sided polygon",
                "3-sided polygon", -- aliases general:triangle
                "4-sided polygon",
                "5-sided polygon",
                "6-sided polygon",
                "7-sided polygon",
                "8-sided polygon",
                "9-sided polygon",
                "10-sided polygon",
                "11-sided polygon",
                "12-sided polygon",
              "equilateral polygon",
              "equiangular polygon",
              "parallel sides polygon",
              "equilateral equiangular polygon",
                "convex regular polygon",
                  "3-sided convex regular polygon", -- cnm regular triangle
                "star regular polygon",
              "equilateral parallel sides polygon",
                "4-sided equilateral parallel sides polygon", -- cnm rhombus; aliases general:diamond (shape)
              "some other polygon",
                "cross",
                "x",
            "other 2d hyperbody",
              "sparkle",
              "heart",
          "3d hyperbody",
            "polyhedron",
      "body part",
        "body data",
          "body measurement",
          "body ratio",
        "body part grouping",
          "body part grouping by function",
            "sensory organ",
            "pleasurable organ",
              "crotch pleasurable organ",
            "ussy",
          "body part grouping by similarity",
            "digit",
            "teashi",
          "axis body part grouping",
            "y axis body part grouping",
              "bi-ly body part grouping",
                "upper body",
                "lower body",
        "general body part",
          "horn",
          "hair",
            "hair ear", -- aliases general:hair ears
          "forehead",
          "ear",
            "human ear",
            "animal ear", -- aliases general:animal ears
              "fake animal ear", -- aliases general:fake animal ears, can coexist with all other animal ears tags
                "animal ear headphones", -- aliases general:animal ear headphones
                  "bear ear headphones", -- aliases general:bear ear headphones
                  "cat ear headphones", -- aliases general:cat ear headphones
                  "rabbit ear headphones", -- aliases general:dog ear headphones
            "mechanical ear", -- aliases general:mechanical ears
            "pointy ear", -- aliases general:pointy ears
              "long pointy ear", -- aliases general:long pointy ears
          "iris",
          "pupil",
          "eye", -- aliases general:eyes
            "eyes with no pupils", -- aliases general:no pupils
            "eyes with pupils",
              "modified aperture pupil",
                "constricted pupil", -- aliases general:constricted pupils
                "dilated pupil", -- aliases general:dilated pupils
              "extra pupil", -- aliases general:extra pupils
              "unusual shaped pupil",
                "mismatched pupils", -- aliases general:mismatched pupils
                "rectangular pupil", -- aliases general:horizontal pupils
                "slit pupil", -- aliases general:slit pupils
                "symbol shaped pupil", -- aliases general:symbol-shaped pupils
                  "sparkle shaped pupil", -- aliases general:+ +
                  "heart shaped pupil", -- aliases general:heart-shaped pupils
                  "star shaped pupil", -- aliases general:star-shaped pupils
                  "cross shaped pupil", -- aliases general:cross-shaped pupils
                  "x shaped pupil", -- aliases general:x-shaped pupils
                  "flower shaped pupil", -- aliases general:flower-shaped pupils
                  "diamond shaped pupil", -- aliases general:diamond-shaped pupils
                  "rabbit shaped pupil", -- aliases general:rabbit-shaped pupils
                  "butterfly shaped pupil", -- aliases general:butterfly-shaped pupils
                  "triangle shaped pupil", -- aliases general:triangle-shaped pupils
                  "power symbol shaped pupil", -- aliases general:power symbol-shaped pupils
                  "drop shaped pupil", -- aliases general:drop-shaped pupils
                  "clover shaped pupil", -- aliases general:clover-shaped pupils
                  "money shaped pupil", -- aliases general:money-shaped pupils
                  "crescent shaped pupil", -- aliases general:crescent-shaped pupils
                  "skill shaped pupil", -- aliases general:skull-shaped pupils
                  "musical note shaped pupil", -- aliases general:musical note-shaped pupils
                  "lightning bolt shaped pupil", -- aliases general:lightning bolt-shaped pupils
                  "bone shaped pupil", -- aliases general:bone-shaped pupils
                  "paw shaped pupil", -- aliases general:paw-shaped pupils
                  "sprout shaped pupil", -- aliases general:sprout-shaped pupils
                  "cat shaped pupil", -- aliases general:cat-shaped pupils
                  "spade shaped pupil", -- aliases general:spade-shaped pupils
                  "crescent shaped pupil", -- aliases general:crescent-shaped pupils


          "nose",
          "cheek",
          "mouth",
          "tongue",
          "chin",
          "head",
          "face",
          "neck",
          "throat",
          "shoulder",
          "back",
          "wings",
          "limb",
            "arm",
            "leg",
          "elbow",
          "wrist",
          "stomach",
          "waist",
          "tail",
          "ass",
          "crotch",
          "chest",
          "breasts",
          "penis",
            "real penis", --
            "fake penis", -- aliases general:dildo; implies thing:sex toy
              "fake vibrating penis",
              "fake penis with suction cup", -- aliases general:suction cup dildo
          "vulva",
          "anus",
          "hip",
          "thigh",
          "knee",
          "calf",
          "ankle",
          "foot",
          "tentacle",

        "anatomical feature",
          "shoulder blades", -- aliases general:shoulder blades
        "anatomical category",
          "muscle",
    "abstract thing",
      "intellectual property",
        "corporate ip",
          "google",
            "google pixel",
            "google nexus",
            "google chrome",
            "android google", -- cnm android (google)
        "game ip",
          "mass effect series", -- cnm mass effect (series)
            "mass effect 3",
            "mass effect 2",
            "mass effect 1",
          "unholy arts",
          "growing up",
          "girl crush",
          "genshin impact",
          "dragon age inquisition",
          "teamfight tactics",
          "slay the spire",
          "sable game", -- cnm sable (game)
          "dungeon massage service",
          "bumble",
          "facebook",
          "hinge",
          "okc",
          "tinder",
          "whatsapp",
          "reddit",
          "bumble",
          "vscode",
          "discord",
          "fb messenger",
          "flightradar",
          "google",
          "hinge",
          "jisho",
          "mvg",
          "newpipe",
          "outlook",
          "reddit",
          "sms",
          "telegram",
          "the guardian",
          "wikipedia",
          "youtube",
          "her",
          "strava",
          "lishogi",
          "lichess",
          "ikea",
          "landefeld",
          "aws",
          "amazon",
          "anki",
          "github",
          "gitlab",
          "bitbucket",
          "chatgpt",
          "openai playground",
          "dbeaver",
          "hermes",
        "multimedia ip",
      "concept",
        "disciplinary concept",
          "philosophy concept",
        "day-to-day concept",
          "self",
            "employable characteristics",
          "style",
            "my look",
          "employment",
          "ownership",
          "culture",
          "presence",
            "participation",
              "enrollment",
          "money",
            "money compensation",
              "pay",
              "money gift",
              "money loan",
              "taxes",
                "payroll taxes",
            "money transfer",
              "direct debit",
          "internet",
          "location of residence",
          "housing",
            "room layout",
            "rental",
          "object",
            "object use",
          "danger",
            "fire danger",
              "fire prevention",
        "nation",
          "the netherlands",
        "location",
        "language",
          "english",
          "japanese",
          "german",
  },
  -- interaction = {
  --   "repetition",
  --     "patterning",
  --       "referential patterning",
  --         "self-referential patterning",
  --         "axis-referential patterning",
  --           "1-axis referential patterning",
  --           "2-axis referential patterning",
  --           "many-axis referential patterning"

  -- },

  interaction = {
    "grammatical case",
      "thematic case",
        "nuclear case",
          "agentive",
          "patientive",
          "themetive",
        "non-nuclear case",
          
      "spatial",
        "essive",
          "interessive",
    "visual",
  },
  
  composition = {
    "visual composition",
      "2d composition",
        "visual layer related composition",
          "visual layer composition",
            "foreground composition",
            "midground composition",
            "background composition",
          "visual layering composition",
        "perspective composition",
          "camera subject distance composition",
            "extreme closeup shot",
            "closeup shot", -- aliases general:close-up
            "medium closeup shot", 
            "medium shot", 
            "cowboylike shot",
            "medium full shot", 
            "full shot",
            "wide shot", -- aliases general:wide shot
            "extreme wide shot", -- aliases general:extreme wide shot
            "camera position",
          "camera position composition",
            "rotational camera position",
              "camera pitch",
                "camera pitch up",
                  "camera pitch 45 up",
                  "camera pitch 90 up",
                "camera pitch down",
                  "camera pitch 45 down",
                  "camera pitch 90 down",
                "camera pitch nonzero",
                  "camera pitch 45",
                  "camera pitch 90",
                "camera pitch zero",
                "camera pitch flipped",
              "camera yaw",
                "camera yaw left",
                  "camera yaw 45 left",
                  "camera yaw 90 left",
                "camera yaw right",
                  "camera yaw 45 right",
                  "camera yaw 90 right",
                "camera yaw nonzero",
                  "camera yaw 45",
                  "camera yaw 90",
                "camera yaw zero",
                "camera yaw flipped",
              "camera roll",
                "camera roll anticlockwise",
                  "camera roll 45 anticlockwise",
                  "camera roll 90 anticlockwise",
                "camera roll clockwise",
                  "camera roll 45 clockwise",
                  "camera roll 90 clockwise",
                "camera roll nonzero",
                  "camera roll 45",
                  "camera roll 90",
                "camera roll zero",
                "camera roll flipped",
              "camera rotational zero", 
            "translational camera position",
              "camera x",
                "camera x left",
                "camera x right",
                "camera x nonzero",
                "camera x zero",
              "camera y",
                "camera y up",
                "camera y down",
                "camera y nonzero",
                "camera y zero",
              "camera z",
                "camera z forward",
                "camera z backward",
                "camera z nonzero",
                "camera z zero",
              "camera translational zero",
            "composite camera position",
              "from above", -- aliases general:from above; implies composition:camera y up, composition:camera pitch down
              "from below", -- aliases general:from below; implies composition:camera y down, composition:camera pitch up
              "straight on", -- aliases general:straight-on; implies composition:camera rotational zero, composition:camera z backward
              "from side", -- aliases general:from side; implies composition:camera x nonzero, composition:camera yaw nonzero
              "from behind", -- aliases general:from behind; implies composition:camera z forward, composition:camera yaw flipped
        "bounding box composition",
          "crop",
            "crop roll",
              "crop roll anticlockwise",
                "crop roll 45 anticlockwise",
                "crop roll 90 anticlockwise",
              "crop roll clockwise",
                "crop roll 45 clockwise",
                "crop roll 90 clockwise",
              "crop roll nonzero",
                "crop roll 45",
                "crop roll 90",
              "crop roll zero",
              "crop roll flipped",
              "dutch angle", -- aliases general:dutch angle
            "crop rotational zero",           
        
        "complex composition",
        "resultant composition",
          "upside down", -- aliases general:upside down. There are many ways to get an upside down effect, so this tag can't imply anything about subject or camera setup.
        
        "subject setup",
          "subject setup genre",
            "still life", -- aliases general:still life
        "subject camera distance combination",
          "portrait shot", -- aliases general:portrait; implies compostion:closeup shot
          "upper body shot", -- aliases general:upper body; implies composition:medium shot
          "lower body shot", -- aliases general:lower body; implies composition:medium shot
          "cowboy shot", -- aliases general:cowboy shot; implies composition:cowboylike shot, composition:humanoid focus
          "feet out of frame shot", -- aliases general:feet out of frame; implies composition:medium full shot, composition:humanoid focus
          "full body shot", -- aliases general:full body; implies composition:full shot, composition:humanoid focus
          


  },
  cross_applications = {

                "agentlike interessive male agentlikes %2B%2B male agentlike", -- aliases general:boy sandwich
                "agentlike interessive female agentlikes %2B%2B female agentlike", -- aliases general:girl sandwich
                "agentlike + male agentlike and female agentlike",
                  "agentlike interessive male agentlike and female agentlike", -- aliases general:boy and girl sandwich
              "agentlike kantokukouing agentlike",
                "agentlike kawaigaruing agentlike",
                  "agentlike kawaigaruing agentlike (nonromantic)", -- aliases general:affectionate
                  "agentlike cuddling agentlike", -- aliases general:cuddling
              "related agentlike + agentlike",
                "family agentlike + agentlike",
                  "family agentlike + related agentlike",
                    "family agentlike + family agentlike", -- aliases general:family
                "agentlike interessive 2 agentlikes", -- aliases general:sandwich
                "agentlike lewding 2 agentlikes", -- aliases general:threesome
                      "male agentlike aijou hyougening male agentlike", -- aliases general:yaoi
                      "1 male agentlike + 2 male agentlikes", 
                        "1 male agentlike lewding 2 male agentlikes",-- aliases general:MMM threesome
                      "female agentlike aijou hyougening female agentlike", -- aliases general:yuri
                        "1 female agentlike lewding 2 female agentlikes",-- aliases general:FFF threesome
                    "female agentlike + male agentlike",
                      "1 female agentlike + 1 male agentlike",
                        "1 female agentlike aijou hyougening 1 male agentlike", -- aliases general:hetero
                      "1 female agentlike + 2 male agentlikes", 
                        "1 female agentlike lewding 2 male agentlikes",-- aliases general:MMF threesome
                      "2 female agentlikes + 1 male agentlike", 
                        "2 female agentlikes lewding 1 male agentlike",-- aliases general:FFM threesome
            "agentlike + body part",
              "agentlike + anatomical category",
                "agentlike + muscles",
                  "agentlike affecting muscles",
                    "agentlike envying muscles", -- aliases general:muscle envy
              "agentlike + general body part",
                "agentlike + breasts",
                  "agentlike + breasts",
                    "agentlike envying breasts",
                    "agentlike + large breasts",
                      "agentlike affecting large breasts",
                        "agentlike envier of large breasts", -- aliases general:breast envy
                    "agentlike + small breasts",
                      "agentlike affecting small breasts",
                        "agentlike envier of flat breasts", -- aliases general:flat awe
                    "agentlike affecting breasts",
                      "agentlike awed by breasts", -- aliases general:breast awe
            "agentlike carrying thing", -- aliases general:carrying
              "agentlike carrying thing on body part",
                "agentlike carrying thing on shoulder", -- aliases general:carrying over shoulder
                "agentlike carrying thing under arm", -- aliases general:carrying under arm
              "agentlike carrying object", 
              "agentlike carrying agentlike", -- aliases general:carrying person
                "princess carry", -- aliases general:princes carry
                "firemans carry", -- aliases general:fireman's carry
                "agentlike carrying agentlike on shoulder", -- aliases general:shoulder carry
                "agentlike carrying agentlike on back", -- aliases general:piggyback
                "agentlike carrying child agentlike", -- aliases general:child carry
                "agentlike carrying baby agentlike", -- aliases general:baby carry
        "object + x",
          "object + x",
            "body part + x",
              "general body part + x",
                "iris + x",
                  "iris + visual style",
                    "iris + color style",
                      "iris + SBCS^2^",
                        "iris + hue SBCS^2^",
                          "iris + hue polyadic SBCS^2^", -- aliases general:multicolored eyes
                          "iris + hue 1-adic SBCS^2^",
                            "iris + hue 1-adic range SBCS^2^",
                              "iris + hue 1-adic range SBCS^2^ palette",
                                "iris + aqua 1-adic range SBCS^2^ palette", -- aliases general:aqua eyes
                                "iris + black 1-adic range SBCS^2^ palette", -- aliases general:black eyes
                                "iris + blue 1-adic range SBCS^2^ palette", -- aliases general:blue eyes
                                "iris + brown 1-adic range SBCS^2^ palette", -- aliases general:brown eyes
                                "iris + green 1-adic range SBCS^2^ palette", -- aliases general:green eyes
                                "iris + grey 1-adic range SBCS^2^ palette", -- aliases general:grey eyes
                                "iris + orange 1-adic range SBCS^2^ palette", -- aliases general:orange eyes
                                "iris + pink 1-adic range SBCS^2^ palette", -- aliases general:pink eyes
                                "iris + purple 1-adic range SBCS^2^ palette", -- aliases general:purple eyes
                                "iris + red 1-adic range SBCS^2^ palette", -- aliases general:red eyes
                                "iris + white 1-adic range SBCS^2^ palette", -- aliases general:white eyes
                                "iris + yellow 1-adic range SBCS^2^ palette", -- aliases general:yellow eyes
                "pupil + x",
                  "pupil + visual style",
                    "pupil + color style",
                      "pupil + SBCS^2^",
                        "pupil + hue SBCS^2^",
                          "pupil + hue polyadic SBCS^2^", -- aliases general:multicolored pupils
                          "pupil + hue 1-adic SBCS^2^",
                            "pupil + hue 1-adic range SBCS^2^",
                              "pupil + hue 1-adic range SBCS^2^ palette",
                                "pupil + aqua 1-adic range SBCS^2^ palette", -- aliases general:aqua pupils
                                "pupil + black 1-adic range SBCS^2^ palette", -- aliases general:black pupils
                                "pupil + blue 1-adic range SBCS^2^ palette", -- aliases general:blue pupils
                                "pupil + brown 1-adic range SBCS^2^ palette", -- aliases general:brown pupils
                                "pupil + green 1-adic range SBCS^2^ palette", -- aliases general:green pupils
                                "pupil + grey 1-adic range SBCS^2^ palette", -- aliases general:grey pupils
                                "pupil + orange 1-adic range SBCS^2^ palette", -- aliases general:orange pupils
                                "pupil + pink 1-adic range SBCS^2^ palette", -- aliases general:pink pupils
                                "pupil + purple 1-adic range SBCS^2^ palette", -- aliases general:purple pupils
                                "pupil + red 1-adic range SBCS^2^ palette", -- aliases general:red pupils
                                "pupil + white 1-adic range SBCS^2^ palette", -- aliases general:white pupils
                                "pupil + yellow 1-adic range SBCS^2^ palette", -- aliases general:yellow pupils
                  "pupil + thing",
                    "pupil + object",
                      "pupil + body part",
                        "pupil + general body part",
                        
                "ear + x",
                  "ear + thing",
                    "ear + agentlike",
                      "ear + animallike",
                        "ear + imagined animal",
                          "ear + pokemon",
                        "ear + real animal",
                          "ear masking bat", -- aliases general:bat ears
                          "ear masking bear", -- aliases general:bear ears
                          "ear masking rabbit", -- aliases general:rabbit ears
                          "ear masking cat", -- aliases general:cat ears
                          "ear masking cow", -- aliases general:cow ears
                          "ear masking deer", -- aliases general:deer ears
                          "ear masking dog", -- aliases general:dog ears
                          "ear masking ferret", -- aliases general:ferret ears
                          "ear masking fox", -- aliases general:fox ears
                          "ear masking goat", -- aliases general:goat ears
                          "ear masking horse", -- aliases general:horse ears
                          "ear masking lion", -- aliases general:lion ears
                          "ear masking monkey", -- aliases general:monkey ears
                          "ear masking mouse", -- aliases general:mouse ears
                          "ear masking panda", -- aliases general:panda ears
                          "ear masking pikachu", -- aliases general:pikachu ears
                          "ear masking pig", -- aliases general:pig ears
                          "ear masking raccoon", -- aliases general:raccoon ears
                          "ear masking sheep", -- aliases general:sheep ears
                          "ear masking squirrel", -- aliases general:squirrel ears
                          "ear masking tiger", -- aliases general:tiger ears
                          "ear masking wolf", -- aliases general:wolf ears
                "limb + x",
                  "hand + x",
                    "hand + thing",
                      "hand + object",
                        "hand + body part",
                          "hand + general body part",
                            "hand + hip",
                              "hand tangent hip", -- aliases general:hand on feet
                                "hand tangent hip (reflexive voice)", 
                                  "1 hand tangent hip (reflexive voice)", -- aliases general:hand on own hip
                                  "2 hands tangent hip (reflexive voice)", -- aliases general:hands on own hip
                                "hand tangent hip (other)",
                                  "1 hand tangent hip (other)", -- aliases general:hand on another's hip
                                  "2 hands tangent hip (other)", -- aliases general:hands on another's hip
                              "hand grabbing or pulling hip", -- aliases general:hip grab; general:hip pull; general:grabbing hip; general:pulling hip
                                "hand grabbing or pulling hip (reflexive voice)", -- aliases general:grabbing own hip, general:pulling own hip
                                "hand grabbing or pulling hip (other)", -- aliases genereral:grabbing another's hip, general:pulling another's hip
                              "hand circumtangent hip", -- aliases general:hand around hip
                              "hand holding hip",
                                "hand holding 1 hip", -- aliases general:holding hip
                                "hand holding 2 hips", -- aliases general:holding hips
                            -- todo: mirror the above for horns, hair, forehead, ear, eyes
                        "hand + non body part",
                          "hand tangent non body part", 
                            "hand tangent non body part", 
                            "hand circumtangent non body part", 
                            "hand holding non body part", 
                      "hand + agentlike", 
                        "hand tangent agentlike",
                          "hand tangent agentlike",
                          "hand circumtangent agentlike",
                          "hand holding agentlike",
                  "arm + x",
                    "arm + thing",
                      "arm + object",
                        "arm + body part",
                          "arm + general body part",
                            "arm + neck", -- aliases general:arms around neck
                              "arm circumtangent neck", -- aliases general:arms around neck
                                "arm hugging neck",
                            "arm + waist", -- aliases general:arms around waist
                              "arm circumtangent waist", -- aliases general:arms around waist
                                "arm hugging waist", -- aliases general:hugging waist
                            "arm + back", -- aliases general:arms around back
                              "arm circumtangent back", -- aliases general:arms around back
                            "arm + leg",
                              "arm circumtangent leg",
                                "arm hugging leg", 
                                  "arm hugging leg (other)", -- aliases general:hugging another's leg
                                  "arm hugging leg (reflexive voice)", -- aliases general:hugging own leg
                            "arm + arm",
                              "arm circumtangent arm",
                                "arm circumtangent arm (other)",
                                  "1 arm circumtangent 1 arm", -- aliases general:locked arms
                              "2 arms circumtangent 1 arm", -- aliases general:arm hug
                        "arm + non body part",
                          "arm circumtangent non body part", 
                            "arm hugging non body part", -- aliases general:hugging object
                      "arm + agentlike", 
                        "arm circumtangent agentlike", 
                          "arm hugging agentlike", -- aliases general:hug
                "tongue + x",
                  "tongue + thing",
                    "tongue + object", -- aliases general:licking
                      "tongue + body part", -- aliases general:
                        "tongue + general body part", -- aliases general:
                          "tongue + genital", -- aliases general:
                            "tongue + primary genital", -- aliases general:oral
                              "tongue + penis", -- aliases general:
                                "tongue + fake penis", -- aliases general:licking dildo
                                "tongue + penis (inferential evidentiality)", -- aliases general:implied fellatio
                                "tongue + penis (retrospective aspect)", -- aliases general:after fellatio
                                "tongue + penis (reflexive voice)", -- aliases general:autofellatio
                                "tongue + penis (deep)", -- aliases general:deepthroat
                                "2 tongues + penis", -- aliases general:cooperative fellatio
                                "tongue + 2 penises", -- aliases general:double fellatio

                              "tongue + genital holelike", -- aliases general:
                                "tongue + vulva", -- aliases general:cunnilingus
                                  "tongue + vulva (reflexive voice)", -- aliases general:autoconnilingus
                                  "tongue + vulva (inferential evidentiality)", -- aliases general:implied cunnilingus
             
      "composition + x",
        "visual composition + x",
          "2d composition + x",
            "subjectivity related composition + x",
              "subjectivity composition + x",
                "subject composition + x",
                  "subject composition + thing",
                    "subject composition + object",
                      "subject composition + body part",
                        "subject composition + general body part",
                          "subject composition + eye", -- aliases general:eye focus
                    "subject compositin + agentlike",
                      "subject compositin + gendered agentlike",
                        "subject composition + male agentlike", -- aliasess general:male focus
      "effect + x",
        "visual effect + x",
          "2d effect + x",
            "post effect + x",
              "blur effect + x",
                "blur effect + visual composition",
                  "blur effect + 2d composition",
                    "blur effect + visual layer related composition",
                      "blur effect + visual layer composition",
                        "blur effect + foreground composition", -- aliases general:foreground blur
                        "blur effect + midground composition", -- aliases general:midground blur
                        "blur effect + background composition", -- aliases general:background blur
      "allusion + x",

  },
  allusion = {
    "certain allusion repetitiveness",
      "cliched allusion", -- aliases general:meme
      "certain allusion", -- aliases general:reference
    "certain allusion distance",
      "direct allusion", -- aliases general:source quote
      "direct allusion variation",
      "indirect allusion",
    "certain allusion stance",
      "humorous allusion", -- aliases general:parody
      "critical allusion",
  },
  creator = {
    
  },
  character = {
    "purple haired mpdg pornpen", -- cnm purple haired mpdg (pornpen)
  },
  creation_ware = {
    "creation location",
      "meatspace",
      "cyberspace",
    "creation method",
      "capturing",
      "generating",
      "manual creation",
    "creation instrument",
      "creation agent",
        "individual creator",
        "group of creators",
          "creator circle",
          "creator studio",
          "creator company",
      "creation tool",
        "hardware",
          "hardware brand",
            "xiaomi",
        "software",
    "creation setting",
    "creation location + x", -- implies creation_ware:creation location
      "meatspace + x", -- implies creation_ware:meatspace
        "meatspace + creation method", -- implies creation_ware:creation method
          "meatspace + capturing", -- implies creation_ware:capturing
            "meatspace + capturing + creation instrument", -- implies creation_ware:creation instrument
              "meatspace + capturing + creation tool", -- implies creation_ware:creation tool
                "meatspace + capturing + hardware", -- implies creation_ware:hardware
                  "smartphone",
                    "xiaomi smartphone",
                      "xiaomi redmi note 11 pro plus 5g",
                  "camera",
                    "integrated camera",
                      "front camera",
                      "rear camera",
                    "dedicated camera",
                      "dslr",
                      "mirrorless camera",
                  "scanner",
      "cyberspace + x", -- implies creation_ware:cyberspace
        "cyberspace + creation method", -- implies creation_ware:creation method
          "cyberspace + capturing", -- implies creation_ware:capturing
            "screen capture", -- aliases meta:screenshot
            "cyberspace + capturing + creation instrument", -- implies creation_ware:creation instrument
              "cyberspace + capturing + creation tool", -- implies creation_ware:creation tool
          "cyberspace + generating", -- implies creation_ware:generating
            "cyberspace + generating + creation instrument", -- implies creation_ware:creation instrument
              "cyberspace + generating + creation tool", -- implies creation_ware:creation tool
                "cyberspace + generating + software", -- implies creation_ware:software
                  "generative ai",
                    "generative ai model",
                      "image generation model",
                        "text to image model",
                          "trynectar text to image model",
                          "pornpen text to image model",
                            "pornpen anime text to image model",
                              "pornpen anime detailed model",
                              "pornpen anime v1 model",
                              "pornpen women accurate model",
                              "pornpen women realistic model",
                              "pornpen women detiailed model",
                              "pornpen men v1 model",
                              "pornpen missionary model",
                              "pornpen blowjob model",
                              "pornpen doggystyle model",
                    "generative ai interface",
                      "image generation interface",
                        "pornpen web interface",
                        "midjourney discord interface",
                        "trynectar interface",
          "cyberspace + manual creation", -- implies creation_ware:manual creation
            "cyberspace + manual creation + creation instrument", -- implies creation_ware:creation instrument
              "cyberspace + manual creation + creation tool", -- implies creation_ware:creation tool
                "cyberspace + manual creation + software", -- implies creation_ware:software
                  "graphics editor",
                    "still editor",
                      "2d graphics editor",
                        "image processing editor",
                          "adobe lightroom",
                        "raster graphics editor",
                          "gimp",
                          "photoshop",
                        "vector graphics editor",
                          "affinity designer",
                          "inkscape",
                    "video editor",
                      "davinci resolve",
          

  },
  general = {
    "mixed media", -- [substance] cnm traditional-seeming graphic art surface covering ++ digital-seeming graphic art surface covering
  },
  format = {
    "audio",
    "visual",
      "animated",
        -- as relates to how much:
        "n movements",
          "one movement",
            "single movement",
            "movement cycle",
          "multiple movements", -- if the movements together form a whole, use "single beat"
        "n beats",
          "one beat",
            "single beat",
            "beat cycle",
          "multiple beats", -- if the beats together form a whole, use "single scene"
        "n scenes",
          "one scene",
            "single scene",
          "multiple scenes", -- if the scenes together form a whole, use "single chapter" or "single act"
        "n chapters",
          "one chapter",
            "single chapter",
          "multiple chapters",
        "n acts",
          "one act",
            "single act",
            "act cycle",
          "multiple acts",
      "stil",

        "multipart", -- image consisting of multiple parts
          "comic", -- aliases ... with some sort of sequentiality. general:comic.
            "monolithic comic", -- consisting of n parts, with no further subdivisions
              "1koma", -- all of these have general:<n>koma aliased to them
              "2koma",
              "3koma",
              "4koma",
              "5koma",
              "6koma",
            "multistrip comic", -- consisting of n parts, with further subdivisions
              "multiple 1koma", -- all of these have general:multiple <n>koma aliased to them
              "multiple 2koma",
              "multiple 3koma",
              "multiple 4koma",
              "multiple 5koma",
              "multiple 6koma",
          "polyptych", -- with no sequentiality
            "diptych",
            "triptych", -- aliases general:triptych (art)
            "tetraptych",
        "paged media",
          "fixed page size",
            "din a4",
            "din a5",
            "din a6",
            "din a3",
            "din a2",
            "din a1",
          "n page",
            "single page",
            "multi page",
              "two page",
                "two page spread", -- aliases general:two-page spread
              "multi page spread",
          -- method of construction, may apply even when only one page is present
          "stacked paged media",
            "bound paged media",
              "stitch bound paged media",
              "thermally bound paged media",
              "punch bound paged media",
            "stapled paged media",
            -- by amount of pages, even when only one page is present
            "booklet",
              "flipbook",
            "book",
              "textbook",
          "folded paged media",
          "rolled paged media",
            "scroll",
          "digitally paginated paged media",
  },
  thing_namespace = {
    "thing",
    "substance",
    "focus",
    "theme",
    "accent",
    "framing",
    "incidental"
  },
  thing_other_namespace = {
    "substance",
    "focus",
    "theme",
    "accent",
    "framing",
    "incidental"
  },
  series_namespace = {
    "chapter index",
    "chapter title",
    "page index",
    "volume index",
    "episode index",
    "episode subindex",
    "season",
    "series",
    "character",
    "studio",
    "title",
    "prompt"
  },
  csl_type = {
    "article",
    "article-journal",
    "article-magazine",
    "article-newspaper",
    "bill",
    "book",
    "broadcast",
    "chapter",
    "classic",
    "collection",
    "dataset",
    "document",
    "entry",
    "entry-dictionary",
    "entry-encyclopedia",
    "event",
    "figure",
    "graphic",
    "hearing",
    "interview",
    "legal_case",
    "legislation",
    "manuscript",
    "map",
    "motion_picture",
    "musical_score",
    "pamphlet",
    "paper-conference",
    "patent",
    "performance",
    "periodical",
    "personal_communication",
    "post",
    "post-weblog",
    "regulation",
    "report",
    "review",
    "review-book",
    "software",
    "song",
    "speech",
    "standard",
    "thesis",
    "treaty",
    "webpage",
  },
  csl_title_keys = { "title", "title-short" },
  git_remote_types = {"github", "gitlab", "bitbucket"},
  useless_files = {".git", "node_modules", ".vscode"},
  youtube_upload_status = {
    "deleted",
    "failed",
    "processed",
    "rejected",
    "uploaded"
  },
  youtube_privacy_status = {
    "private",
    "public",
    "unlisted"
  },
  search_engine_id = {
    "wiktionary",
    "wikipedia",
    "jisho",
    "glottopedia",
    "ruby_apidoc",
    "python_docs",
    "merriam_webster",
    "assoc_cc",
    "deepl_en_ja",
    "deepl_de_en",
    "mdn",
    "scihub",
    "libgen",
    "semantic_scholar",
    "google_scholar",
    "google_images",
    "google_maps",
    "google",
    "danbooru",
    "gelbooru" 
  },
  likely_main_branch_name = {
    "main",
    "master",
    "trunk",
    "develop",
    "dev",
  },
  extension = {
    plaintext_table = {"csv", "tsv"},
    plaintext_assoc = { "", "yaml", "json", "toml", "ini", "ics"},
    xml = {"html", "xml", "svg", "rss", "atom"},
    image = {"png", "jpg", "gif", "webp", "svg"},
    db = {"db", "dbf", "mdb", "accdb", "db3", "sdb", "sqlite", "sqlite3", "nsf", "fp7", "fp5", "fp3", "fdb", "gdb", "dta", "pdb", "mde", "adf", "mdf", "ldf", "myd", "myi", "frm", "ibd", "ndf", "db2", "dbase", "tps", "dat", "dbase3", "dbase4", "dbase5", "edb", "kdb", "kdbx", "sdf", "ora", "dbk", "rdb", "rpd", "dbc", "dbx", "btr", "btrieve", "db3", "s3db", "sl3", "db2", "s2db", "sqlite2", "sl2"},
    sql = {"db", "sdb", "sqlite", "db3", "s3db", "sqlite3", "sl3", "db2", "s2db", "sqlite2", "sl2", "sql", "mdf", "ldf", "ndf", "myd", "frm", "ibd", "ora", "rdb"},
    sqlite = {"db", "sdb", "sqlite", "db3", "s3db", "sqlite3", "sl3", "db2", "s2db", "sqlite2", "sl2"},
    bin = {"jpg", "jpeg", "png", "gif", "pdf", "mp3", "mp4", "mov", "avi", "zip", "gz", 
    "tar", "tgz", "rar", "7z", "dmg", "exe", "app", "pkg", "m4a", "wav", "doc", 
    "docx", "xls", "xlsx", "ppt", "pptx", "psd", "ai", "mpg", "mpeg", "flv", "swf",
    "sketch", "db", "sql", "sqlite", "sqlite3", "sqlitedb", "odt", "odp", "ods", 
    "odg", "odf", "odc", "odm", "odb", "jar", "pyc"},
    audio = {
        "3gp",
        "aa",
        "aac",
        "aax",
        "act",
        "aiff",
        "alac",
        "amr",
        "ape",
        "au",
        "awb",
        "dct",
        "dss",
        "dvf",
        "flac",
        "gsm",
        "iklax",
        "ivs",
        "m4a",
        "m4b",
        "m4p",
        "mmf",
        "mp3",
        "mpc",
        "msv",
        "nmf",
        "ogg",
        "oga",
        "mogg",
        "opus",
        "ra",
        "rm",
        "raw",
        "rf64",
        "sln",
        "tta",
        "voc",
        "vox",
        "wav",
        "wma",
        "wv",
        "webm",
        "8svx"
    },
    video = {
      "3g2",
      "3gp",
      "amv",
      "asf",
      "avi",
      "drc",
      "flv",
      "f4v",
      "f4p",
      "f4a",
      "f4b",
      "gif",
      "gifv",
      "mng",
      "mkv",
      "m2v",
      "m4v",
      "mp4",
      "m4p",
      "m4v",
      "mpg",
      "mp2",
      "mpeg",
      "mpe",
      "mpv",
      "mxf",
      "nsv",
      "ogv",
      "ogg",
      "qt",
      "mov",
      "rm",
      "rmvb",
      "roq",
      "svi",
      "vob",
      "webm",
      "wmv",
      "yuv"
  },
  
    whisper_audio = {
      "mp3",
      "mp4",
      "mpeg",
      "mpga",
      "m4a",
      "wav",
      "webm"
    },
    hydrusable_file = {
      "jpg",
      "png",
      "gif",
      "webp",
      "tiff",
      "qoi",
      "ico",
      "bmp",
      "heif",
      "heic",
      "avif",
      "apng",
      "heifs",
      "heics",
      "avifs",
      "mp4",
      "webm",
      "mkv",
      "avi",
      "flv",
      "mov",
      "mpeg",
      "ogv",
      "rm",
      "wmv",
      "mp3",
      "ogg",
      "flac",
      "m4a",
      "ra",
      "tta",
      "wav",
      "wv",
      "wma",
      "swf",
      "pdf",
      "psd",
      "clip",
      "sai2",
      "kra",
      "svg",
      "xcf",
      "procreate"
     },
  
  },
  auth_processes = {
    "bearer", "basic", "manual"
  },
  mullvad_states ={
    "Connected", "Disconnected"
  },
  rfc3339like_dt_separators = {
    "-", "T", ":", "Z"
  },
  initial_headers = {"from", "to", "cc", "bcc", "subject"},
  youtube = {
    extant_upload_status = {
      "processed",
      "uploaded"
    }
  },
  html_entity_indicator = {
    encoded = {"&", ";"},
    decoded = {"\"", "'", "<", ">", "&"}
  },
  creation_specifier_type = {
    "watcher",
    "hotkey",
    "stream"
  },
  stream_state = {
    "booting",
    "active",
    "ended"
  },
  flag_profile_name = {
    "foreground",
    "background"
  },
  dcmp_names = {"year", "month", "day", "hour", "min", "sec"},
  dcmp_names_long = {"year", "month", "day", "hour", "minute", "second"},
  long_dt_seps = {" at "},
  addr_key = {"Formatted name", "First name", "Last name", "Street", "Code", "City", "Region", "Country", "Box", "Extended"},
  mod_char = {"c", "a", "s", "ct", "f"},
  mod_name = {"cmd", "alt", "shift", "ctrl", "fn"},
  email_headers_containin_emails = {"to", "cc", "bcc", "from", "reply-to"},
  vcard = {
    vcard_phone_type = {"home", "cell", "work", "pref", "pager", "voice", "fax", "voice"}, -- only those in both vcard 3.0 and 4.0
    vcard_email_type = {"home", "work", "pref", "internet"},
    vcard_address_type = {"home", "work", "pref", "text", "voice", "fax", "cell", "video", "pager", "textphone"},
    keys_with_vcard_type = {"Phone", "Email", "Address"}
  },
  unicode_prop = {
    "bin",
    "block",
    "cat",
    "char",
    "cpoint",
    "dec",
    "digraph",
    "hex",
    "html",
    "json",
    "keysym",
    "name",
    "plane",
    "props",
    "utf16be",
    "utf16le",
    "eutf8",
    "width",
    "xml"
  },
  emoji_prop = {
    "cldr",
    "cldr_full",
    "cpoint",
    "emoji",
    "group",
    "name",
    "subgroup",
  },
  synonyms_key = {"synonyms", "antonyms", "term"},
  shrink_specifier_key = {"type", "format", "quality", "resize", "result"},
  menu_item_key ={"path", "application", "AXTitle", "AXEnabled", "AXRole", "AXMenuItemMarkChar", "AXMenuItemCmdChar", "AXMenuItemCmdModifiers", "AXMenuItemCmdGlyph"},
  csl_key = {
    "type",
    "id",
    "categories",
    "language",
    "journalAbbreviation",
    "shortTitle",
    "author",
    "chair",
    "collection-editor",
    "compiler",
    "compiler",
    "composer",
    "container-author",
    "contributor",
    "curator",
    "director",
    "editor",
    "editorial-director",
    "executive-producer",
    "guest",
    "url-host",
    "illustrator",
    "interviewer",
    "narrator",
    "original-author",
    "performer",
    "producer",
    "recipient",
    "reviewed-author",
    "script-writer",
    "series-creator",
    "translator",
    "accessed",
    "available-date",
    "event-date",
    "issued",
    "original-date",
    "submitted",
    "abstract",
    "annote",
    "archive",
    "archive_collection",
    "archive_location",
    "archive-place",
    "authority",
    "call-number",
    "chapter-number",
    "citation-number",
    "citation-label",
    "collection-number",
    "collection-title",
    "container-title",
    "container-title-short",
    "dimensions",
    "division",
    "DOI",
    "edition",
    "event",
    "event-title",
    "event-place",
    "first-reference-note-number",
    "genre",
    "ISBN",
    "ISSN",
    "issue",
    "jurisdiction",
    "keyword",
    "locator",
    "medium",
    "note",
    "number",
    "number-of-pages",
    "number-of-volumes",
    "original-publisher",
    "original-publisher-place",
    "original-title",
    "page",
    "page-first",
    "part",
    "part-title",
    "PMCID",
    "PMID",
    "printing",
    "publisher",
    "publisher-place",
    "references",
    "reviewed-genre",
    "reviewed-title",
    "scale",
    "section",
    "source",
    "status",
    "supplement",
    "title",
    "title-short",
    "URL",
    "version",
    "volume",
    "volume-title",
    "volume-title-short",
    "year-suffix",
  },
  fs_attr_name = {
    "dev",
    "ino",
    "mode",
    "nlink",
    "uid",
    "gid",
    "rdev",
    "access",
    "change",
    "modification",
    "permissions",
    "creation",
    "size",
    "blocks",
    "blksize",
  },
  keys = {
    audiodevice_specifier = {
      "device",
      "subtype"
    }
  },
  base_letters = {
    "b",
    "o",
    "d",
    "x",
  },
  citable_object_id_indication_name = {
    "isbn",
    "doi",
    "isbn_part",
    "pmid",
    "pmcid",
    "accession",
    "issn_full",
    "urlmd5"
  },
  client_project_kind = {
    "translation"
  },
  billing_unit = {
    "line"
  },
  llm_chat_role = {
    "system",
    "user",
    "assistant",
    "function"
  },
  jxa_browser_name = {
    "Google Chrome"
  },
  jxa_tabbable_name = {
    "Google Chrome",
  },
  markdown_extension_set_name = {
    "basic",
    "featureful",
    "navigable",
    "citing",
    "styleable"
  },
  markdown_extension_name = {
    "yaml_metadata_block",
    "fenced_code_blocks",
    "backtick_code_blocks",
    "fenced_code_attributes",
    "line_blocks",
    "fancy_lists",
    "startnum",
    "definition_lists",
    "task_lists",
    "example_lists",
    "table_captions",
    "pipe_tables",
    "all_symbols_escapable",
    "strikeout",
    "superscript",
    "subscript",
    "tex_math_dollars",
    "raw_html",
    "footnotes",
    "inline_notes",
    "implicit_figures",
    "mark",
    "angle_brackets_escapable",
    "hard_line_breaks",
    "emoji",
    "autolink_bare_uris",
    "implicit_header_references",
    "citations",
    "header_attributes",
    "auto_identifiers",
    "gfm_auto_identifiers",
    "link_attributes",
    "fenced_divs"
  },
  type_name = {
    "string",
    "number",
    "boolean",
    "table",
    "function",
    "thread",
    "userdata",
    "nil"
  },
  mac_plist_type_name = {
    "string",
    "int",
    "integer",
    "float",
    "date",
    "data",
    "bool",
    "boolean",
    "dict",
    "array"
  },
  dynamic_structure_name = {
    "latex",
    "omegat"
  }
}