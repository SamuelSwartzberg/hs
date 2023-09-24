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
    "danbooru",
    "reddit",
    "aliexpress"
  },
  ai_creators = {
    "pornpen",
    "midjourney",
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
    "creator",
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

    -- series tags - where within some general series does this object fit?

    "chapter_index", -- numerical index of a chapter, e.g. 25
    "chapter_title", -- title of a chapter, e.g. "Can't stop won't stop can't stop"
    "page_index", -- numerical index of a page within a chapter or work, e.g. 11
    "volume_index", -- numerical index of a volume, e.g. 3
    "episode_index", -- numerical index of an episode, e.g. 3
    "episode_subindex", -- numerical index of an object within an episode, e.g. 5. In principle, episode_timestamp would be better, but this is exists where that information isn't easily available or has been lost.
    "episode_timestamp", -- timestamp of an object within an episode, e.g. 00:03:12.
    "season_index", -- numerical index of a season, e.g. 3

    -- creation tags - who, when, where, and how was this object created?

    "creator", -- name of an original creator of the tagged object. This should not be used for someone who shared the object, but did not create it. However, the contribution doesn't have to be major. If the creator appears in the image, other tags may also apply, such as person:<name> or general:signature, or others.
    "official_title", -- the official title of a work, if applicable. E.g. "The Lord of the Rings: The Fellowship of the Ring", "One Hundred Years of Solitude", etc. Bear in mind that this isn't the title of the series, but of the specific work. If the work is part of a series, the series tag should be used instead.
    "studio", -- mostly used by parsers, but can be used to indicate the studio that produced a work. I'll probably alias all of these to creator:<studio name>.
    "digitization_method", -- by their nature, all objects I'm tagging are digital. How did they get that way? E.g. scan, screenshot, photo
    "semver", -- semantic version of a work, e.g. 1.0.0
    "creation_use", -- what the object was created for. Don't use this when the message tags could apply, and also consider if general tags might not be sufficient. So, if this is a photo of an antique contract, creation_use:contract *could* be used, but why not just use format:contract and maybe general:yellowed paper?
    "creation_stage", -- what stage of the creation process the object is in. E.g. brainstorming, conceptualization, mockup, final_product, etc. Don't forget to add any relevant general tags. So if you have a mockup that which uses a smartphone mockup, add general:smartphone_mockup.
    "completeness", -- how complete the creator considers the object to be. E.g. complete, incomplete, abandoned, creation_stage_of_other_object
    "creation_ware", -- the thing that was used to create the item. Can be both software and hardware. E.g. photoshop, iphone 11 pro, canon eos 5d mark iv, etc. Through tag parent/child relationships, this will add a fair few tags. e.g. creation_ware:photoshop -> creation_ware:raster graphics editor -> creation_ware:graphics editor -> creation_ware:visual editor -> creation_ware:software.

    -- creation tags > creation settings tags - what settings were used to create the object?

    "prompt", -- if creator:ai or a child tag of creator:ai, what the prompt was. e.g. "a picture of a cat"
    -- in the future, I may add more tags for specific settings, e.g. "brush size", "f-stop", etc.

    -- creation tags > location tags - where was the object created?
    -- if the location is also visually identifiable in the object, don't forget to add the corresponding general:<location name> (<location type>) tag, e.g. general:berlin (city)
    "lat", -- latitude of the object as a decimal number, if applicable. E.g. 48.137154.
    "lon", -- longitude of the object as a decimal number, if applicable. E.g. 11.576124
    "country",
    "city",
    "venue", -- a specific name of a location, e.g. My mom's house, 2016 italy rental, etc.
    "tourism", -- works like the OSM tourism field

    -- percievable tags - what can be percieved in the object, or inferred from it and a reasonable knowledge of the world? (however, not from me & my context)
    
    "character", -- name of a character that appears in the tagged object in some way, for example their face, their name as text, or some other unambiguous reference
    "person", -- like character, but for real people.
    "series", -- The title of series or copyrights involved. really should be called 'copyright'. Works like danbooru, however danbooru also has some things that I think should really be series/copyright under general (e.g. some brands), which I alias to a series: tag.
    "service", -- the main service that the object features. If something about the object or why I kept it only makes sense in the context of a specific service, this tag should be used, else prefer proximate_source. Any service will automatically also apply the corresponding series tag, e.g. service:reddit -> series:reddit.
    "format", -- the format of the thing or the thing mainly featured (in the case of digitalizations, etc.). E.g. single page, triptych, 4koma. Answers: What is the fundamental structure of the object? Some danbooru unnamespaced tags are aliased to this.
    "medium", -- the medium or media of the thing, such as voice, watercolor, mixed media, etc. Answers: What techniques/styles were fundamental to creating this object. Danbooru tags such as watercolor (medium) are aliased to subtags of this, however there are also (medium) tags that are not aliased to this, such as photoshop (medium). For that, see creation_ware.

    "general", -- this is my namespace for what would be unnamespaced tags on most boorus. Anything that is percievable or reasonably inferrable, but not covered by the other percievable tags, should go here. Tag names here follow danbooru's guidelines to a large extent.

    -- important illocutionary message tags - what is the object trying to tell me? 

    "message_force", -- what illocutionary force does the message have
    "message_direction", -- what direction does the message have? e.g. inbound, outbound
    "message_change", -- what kind of change does the message have? e.g. change_of_amount, increase, decrease, change_of_state, commencement, ...
    "message_subject", -- i.e. the general locutionary content. What is the force about? e.g. money, employment, housing, etc.
    -- there'd be some reason to add a "message_audience" tag, but for now I think I'm well enough served by tagging that with person:<name>, given the audience's name is likely to be mentioned or implied in the object, which forces me to tag it with person:<name> anyway. Thus there'd be a lot of redundancy.

    -- sharing tags - many objects I encounter were shared in some way, such that I was able to encounter them. These tags are for that.

    "proximate_source", -- the location where I encountered an object, or where it was shared. E.g. reddit, danbooru, etc. Many downloaders automatically populate this tag, but setting it manually is not strictly necessary.
    "proximate_source_page_type", -- the type of the page where I encountered the object. E.g. post, thread, product page, etc.
    "proximate_source_subdivision", -- the subdivision of the proximate_source where I encountered the object. E.g. the subreddit, the board, etc.
    "proximate_source_title", -- the title of the proximate_source. E.g. the reddit post title
    "proximate_source_use", -- what was the object used for on the proximate_source? For many proximate sources there isn't an interesting one, but for example for amazon, this could be product_picture
    "uploader", -- the uploader/sharer of the object on the proximate_source. E.g. the reddit username, or the twitter handle.

    -- acquisition tags - how did I acquire the object? This is not the same as sharing, as I may have acquired the object in a way that doesn't involve sharing, e.g. by creating it myself.

    "date", -- date of acquisition in (partial) RFC3339 format
    "occasion", -- the occasion the object was acquired in/for. This may be specific e.g. 2025 trip to canada, or more general, e.g. christmas. 
    "acquisition_context", -- the context of my life this object was created or encountered in. Can be general, e.g. edu, work, leisure, etc., or more specific, e.g. freelance translation. The more specific ones should be tag children of the more general ones. The difference between this and occasion is that an occasion is a temporally bounded event, while an acquisition_context is an area of my life that may or may not be temporally bounded. In a sense, these are orthogonal to each other. If I have a christmas party at my workplace, I would tag the occasion as christmas (or perhaps 2015 christmas party, with corresponding parents), and the acquisition_context as work (or perhaps 2012-2017 graphic design job). So if I was wondering what I did at christmas, I could just search occasion:christmas, even though I spent the 2015 christmas at work, and perhaps another at home.
    "acquisition_institution", -- the institution that I created the object at/for or encountered it in.. E.g. university of melbourne, etc. 
    "period", -- Some processes or organizations categorize things into periods, even where the `date` field may lie outside of those periods. Financial years & quarters, academic years, semesters, trimesters, etc. This tag is for those. If it's not a recognized period, consider using `occasion` or another tag instead. Specific examples: "winter semester 2020", "2018 school year". Inheritance is set up thus that e.g. winter semester 2020 -> winter semester & 2020 semester -> semester, 2018 school year -> school year


    -- metatexual tags - what larger ideas are reflected or involved in the object?

    "topic", -- the main topic the content is about. The possible values are the same as "concept", the difference is that "topic" is used for the main topic, while "concept" is used for all concepts that are involved in the object. 
    "concept", -- concepts at issue in the object. e.g. "existentialism", "kuhnian scientific theory", "ru-verbs"

    -- use tags - why did I keep the object? What do I use it for?

    "use", -- Without complex semantics, what might I want to use the iamge for? e.g. reaction_face, inspiration, etc. 

    -- general meta tags - tags with a more general purpose, that don't fit into any of the above categories.

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
    "2023 stw berlin housing", -- canonical name: 2023- stw berlin housing
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
    "2022 mycontrol", -- canonical name: 2022- mycontrol
    "ownership",
    "interests",
    "dev",
    "language",
    "japanese",
    "systems",
    "2022 hammerspoon" -- canonical name: 2022- hammerspoon
  },
  acquisition_institution = {
    "tu",
    "hu",
    "fu",
    "ur",
    "primary"

  },
  services = {
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
    "google chrome",
    "hermes"
  },
  series = {
    "mass effect series", -- canonical name: mass effect (series)
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
    "sable game", -- canonical name: sable (game)
    "dungeon massage service"
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
    "reflection",
      "medium reflection",
      "very reflection",
      "incredibly reflection",
  },
  message_force = {
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
  },
  message_subject = {
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
  },
  illocutionary_change = {
    "change of amount",
        "increase",
        "decrease",
      "complete change",
        "commencement",
        "pause",
        "resumption",
        "cessation",
      "change of state",
        "modification",
      "unchanged continuation"
  },
  illocutionary_direction = {
    "inbound",
    "outbound",
  },
  digitization_method = {
    "natively digital",
      "generation",
      "export",
      "screen capture",
    "natively physical",
      "camera",
      "scan",
  },
  things = {
    "grouping",
      "too many",
    "agentlikes", -- anything that is an agent, or is shaped like one, or otherwise similar
      "gendered agentlikes",
        "male agentlike",
        "female agentlike",
        "nonbinary agentlike",
        "agender agentlike",
        "genderfluid agentlike",
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
        "real animal",
        "imagined animal",
      "robot", -- aliases general:robot
        "robot animallike", -- also implies things:animallike
        "semihumanoid robot", -- also implies things:semihumanoid, just decided to put it here arbitrarily
          "humanoid robot", -- also implies things:humanoid, just decided to put it here arbitrarily
            "human-passing humanoid robot", -- aliases general:android
            "non human-passing humanoid robot", -- aliases general:humanoid robot
          "mecha", -- aliases general:mecha; giant andor piloted robot
            "walker mecha", -- aliases general:walker; implies things:leg hemihumanoid

        
    "object",
      "tool",
        "sex toy", -- aliases general:sex toy
        "bodyrelated tool",
          "genital tool",
            "speculum", -- aliases general:speculum
            "dilation tape", -- aliases general:dilation tape
      "symbolic object",
        "flag",
          "dutch flag",
      "body part",
        "general body part",
          "eyes", -- aliases general:eyes
            "eyes with colored iris",
              "aqua eyes", -- aliases general:aqua eyes
              "black eyes", -- aliases general:black eyes
              "blue eyes", -- aliases general:blue eyes
              "brown eyes", -- aliases general:brown eyes
              "green eyes", -- aliases general:green eyes
              "grey eyes", -- aliases general:grey eyes
              "orange eyes", -- aliases general:orange eyes
              "purple eyes", -- aliases general:purple eyes
              "pink eyes", -- aliases general:pink eyes
              "red eyes", -- aliases general:red eyes
              "white eyes", -- aliases general:white eyes
              "yellow eyes", -- aliases general:yellow eyes
              "amber eyes", -- aliases general:amber eyes
          "hair",
            "hair ears", -- aliases general:hair ears
          "ears",
            "human ears",
            "animal ears", -- aliases general:animal ears
              "fake animal ears", -- aliases general:fake animal ears, can coexist with all other animal ears tags
                "animal ear headphones", -- aliases general:animal ear headphones
                  "bear ear headphones", -- aliases general:bear ear headphones
                  "cat ear headphones", -- aliases general:cat ear headphones
                  "rabbit ear headphones", -- aliases general:dog ear headphones
              "bat ears", -- aliases general:bat ears
              "bear ears", -- aliases general:bear ears
              "rabbit ears", -- aliases general:rabbit ears
              "cat ears", -- aliases general:cat ears
              "cow ears", -- aliases general:cow ears
              "deer ears", -- aliases general:deer ears
              "dog ears", -- aliases general:dog ears
              "ferret ears", -- aliases general:ferret ears
              "fox ears", -- aliases general:fox ears
              "goat ears", -- aliases general:goat ears
              "horse ears", -- aliases general:horse ears
              "kemonomimi mode", -- aliases general:kemonomimi mode
              "lion ears", -- aliases general:lion ears
              "monkey ears", -- aliases general:monkey ears
              "mouse ears", -- aliases general:mouse ears
              "panda ears", -- aliases general:panda ears
              "pikachu ears", -- aliases general:pikachu ears
              "pig ears", -- aliases general:pig ears
              "raccoon ears", -- aliases general:raccoon ears
              "sheep ears", -- aliases general:sheep ears
              "squirrel ears", -- aliases general:squirrel ears
              "tiger ears", -- aliases general:tiger ears
              "wolf ears", -- aliases general:wolf ears
            "mechanical ears", -- aliases general:mechanical ears
            "pointy ears", -- aliases general:pointy ears
              "long pointy ears", -- aliases general:long pointy ears
          "tongue",
          "face",
          "shoulder",
          "back",
          "genital",
            "chest",
              "breasts",
            "primary genital",
              "penis",
                "real penis", --
                "fake penis", -- aliases general:dildo; implies thing:sex toy
                  "fake vibrating penis",
                  "fake penis with suction cup", -- aliases general:suction cup dildo
              "genital holelike",
                "vulva",
                "anus",
        "anatomical feature",
          "shoulder blades", -- aliases general:shoulder blades
        "anatomical category",
          "muscle",
          
  },
  -- if extant, the first part of the with is the active part, the second is the passive part
  arrangement = {
    "agentlike with any",
      "agentlike emoting about any",
        "agentlike emoting about body part",
          "agentlike emoting about anatomical category",
            "agentlike emoting about muscles",
              "agentlike envying muscles", -- aliases general:muscle envy
          "agentlike emoting about general body part",
            "agentlike emoting about breasts",
              "agentlike envying breasts",
                "agentlike envying large breasts", -- aliases general:breast envy
                "agentlike envying flat breasts", -- aliases general:flat awe
              "breast awe", -- aliases general:breast awe
      "agentlike holding any",
      "agentlike carrying any", -- aliases general:carrying
        "agentlike carrying any on body part",
          "agentlike carrying any on shoulder", -- aliases general:carrying over shoulder
          "agentlike carrying any under arm", -- aliases general:carrying under arm
        "agentlike carrying object", 
        "agentlike carrying agentlike", -- aliases general:carrying person
          "princess carry", -- aliases general:princes carry
          "firemans carry", -- aliases general:fireman's carry
          "agentlike carrying agentlike on shoulder", -- aliases general:shoulder carry
          "agentlike carrying agentlike on back", -- aliases general:piggyback
          "agentlike carrying child agentlike", -- aliases general:child carry
          "agentlike carrying baby agentlike", -- aliases general:baby carry
      
    "object with object",
      "object with body part",
        "object with genital",
          "object with penis",
            "body part with penis",
          "object with vulva",
            "spread vulva", -- aliases general:spread pussy
      "body part with object",
        "tongue with object", -- aliases general:licking
          "tongue with body part", -- aliases general:
            "tongue with general body part", -- aliases general:
              "tongue with genital", -- aliases general:
                "tongue with primary genital", -- aliases general:oral
                  "tongue with penis", -- aliases general:
                    "tongue with fake penis", -- aliases general:licking dildo
                    "tongue with penis (implied)", -- aliases general:implied fellatio
                    "tongue with penis (after)", -- aliases general:after fellatio
                    "tongue with penis (after)", -- aliases general:after fellatio

                  "tongue with genital holelike", -- aliases general:
                    "tongue with vulva", -- aliases general:cunnilingus
                      "tongue with vulva (own)", -- aliases general:autoconnilingus
                      "tongue with vulva (implied)", -- aliases general:implied cunnilingus



    
  },
  composition = {
    "resultant composition",
      "upside down", -- aliases general:upside down. There are many ways to get an upside down effect, so this tag can't imply anything about subject or camera setup.
    
    "subject setup",
      "subject setup genre",
        "still life", -- aliases general:still life
      "thing focus",
        "object focus",
          "body part focus",
            "general body part focus",
              "eye focus", -- aliases general:eye focus
        "humanoid focus",
          "male focus", 
    "subject framing combination",
      "portrait shot", -- aliases general:portrait, implies compostion:closeup shot
      "upper body shot", -- aliases general:upper body, implies composition:medium shot
      "lower body shot", -- aliases general:lower body, implies composition:medium shot
      "cowboy shot", -- aliases general:cowboy shot, implies composition:cowboylike shot, composition:humanoid focus
      "feet out of frame shot", -- aliases general:feet out of frame, implies composition:medium full shot, composition:humanoid focus
      "full body shot", -- aliases general:full body, implies composition:full shot, composition:humanoid focus
    "crop setup",
      "rotational crop position",
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
    "camera setup",
      "framing",
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


  },
  effects = {
    "cameralike effect",
      "lens effect", -- an effect due to the fact that cameras use lenses
        "lens artifact",
          "lens flare", -- aliases general:lens flare
          "bokeh", -- aliases general:bokeh
          "chromatic aberration", -- aliases general:chromatic aberration
        "expousre triangle effect",
          "exposure effect",
            "motion blur", -- aliases general:motion blur
      "signal processing effect",
        "film effect", 
          "film grain", -- aliases general:film grain
        
       
    "post effect",
      "symbolic effects",

      "insert",
        "cut-in",
  },
  allusion = {

  },
  medium = {
    "visual",
      "still",
        "photography",
        "artificial visual media", -- not created by capturing reality
          "traditionallike media",
            "recognizable surface",
              "canvas", -- aliases general:canvas (medium)
              "paper", -- DO NOT alias general:paper to this
            "penlike",
              "ballpoint pen", -- aliases general:ballpoint pen (medium)
            "crayonlike", 
              "crayon", -- aliases general:crayon (medium)
              "coupy pencil", -- aliases general:coupy pencil (medium)
            "inklike",
              "ink", -- aliases general:ink (medium)
              "nib pen", -- aliases general:nib pen (medium)
              "calligraphy brush", -- aliases general:calligraphy brush (medium),
              "color ink", -- aliases general:color ink (medium)
            "graphitelike",
              "graphite", -- aliases general:graphite (medium)
              "charcoal", -- aliases general:charcoal (medium)
              "colored pencil", -- aliases general:colored pencil (medium)
            "painting",
              "acrylic paint", -- aliases general:acrylic paint (medium)
              "gouache", -- aliases general:gouache (medium)
              "oil paint", -- aliases general:oil painting (medium)
              "watercolor", -- aliases general:watercolor (medium)
            "watercolor pencil", -- aliases general:watercolor pencil (medium)
            "pastel", -- aliases general:pastel (medium)
            "traditional media",
            "faux traditional media",
          "digital media",
            "2d",
            "3d",
        "object media",
        "unconventional media",
        "mixed media", -- tag this if two or more of photography, object media, traditional media, digital media, and unconventional media apply, but not if two different subtype tags apply. e.g. watercolor and ballpoint pen is not mixed media (with how common it is to use two different implements, that'd be insane)

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
        "standalone whole", -- this can coexist with multipart image or with paged media, as long as the whole makes sense on its own
          "pure art", 
          "functional art",
            "large format functional",
              "poster",
                "movie poster",
            "medium format functional",
              "cover", -- aliases general:cover
                "standalone print media cover", -- aliases general:cover page
                  "novel cover", -- aliases general:novel cover
                  "doujin cover", -- aliases general:doujin cover
                  "manga cover", -- aliases general:manga cover
                "album cover", -- aliases general:album cover
                "magazine cover", -- aliases general:magazine cover
                "video game cover", -- aliases general:video game cover
                "dvd cover", -- aliases general:dvd cover
                "bluray cover", -- aliases general:bluray cover
            "small format functional",
              "postcard",
              "flyer",
                "tear off flyer",
            "irregular format functional",
              "crest",
            "styled object",
              "calendar", -- aliases general:calendar (medium)
          "pure functionality",
            "user interface", -- implies general:user interface, but is not aliased
              "os user interface", -- the typical user interface of an operating system, covering the entire screen. On android, this means an app or the home screen plus notification bar and potentially software buttons.
                "smartphone user interface", -- aliases general:fake phone screenshot
                "desktop user interface",
              "app user interface", -- the user interface of an app or program covering the entire screen. Protyptically in the kind of screenshots cmd+shift+5 can take
            "document",
              "slide",
                "latex slide", -- you know the one
              "cv",
            "thingy",
              "icon",
  },
  general_tags = {
    "smartphone mockup",
    "google pixel 4"
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
    "creator",
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
  }
}