
ls = {
  lua_escapable_ascii_char_arr = {
    "\a", "\b", "\f", "\n", "\r", "\t", "\v", "\\", "\"", "\'",
  },
  stream_boolean_attribute_arr = {
    "loop",
    "shuffle",
    "video",
    "pause",
    "loop-playlist",
    "no-video",
  },
  mouse_button_char_arr = {"l", "m", "r"},
  lua_regex_metacharacter_arr = {"%", "^", "$", "(", ")", ".", "[", "]", "*", "+", "-", "?"},
  general_regex_metacharacter_arr =  {"\\", "^", "$", ".", "[", "]", "*", "+", "?", "(", ")", "{", "}", "|", "-"},
  str_arr_by_small_words = {
    "a", "an", "and", "as", "at", "but", "by", "en", "for", "if", "in", "of", "on", "or", "the", "to", "v", "v.", "via", "vs", "vs."
  },
  host_arr_by_booru_hosts = {
    "gelbooru.com",
    "danbooru.donmai.us",
    "yande.re",
  },
  project_type_arr = {
    "latex",
    "omegat",
    "npm",
    "cargo",
    "sass"
  },
  backup_type_arr = {
    "facebook",
    "telegram",
    "signal",
    "discord"
  },
  pandoc_basic_format_arr = {
    "asciidoc",
    "asciidoc_legacy",
    "asciidoctor",
    "beamer",
    "biblatex",
    "bibtex",
    "chunkedhtml",
    "commonmark",
    "commonmark_x",
    "context",
    "creole",
    "csljson",
    "csv",
    "docbook",
    "docbook4",
    "docbook5",
    "docx",
    "dokuwiki",
    "dzslides",
    "endnotexml",
    "epub",
    "epub2",
    "epub3",
    "fb2",
    "gfm",
    "haddock",
    "html",
    "html4",
    "html5",
    "icml",
    "ipynb",
    "jats",
    "jats_archiving",
    "jats_articleauthoring",
    "jats_publishing",
    "jira",
    "json",
    "latex",
    "man",
    "markdown",
    "markdown_mmd",
    "markdown_phpextra",
    "markdown_strict",
    "markua",
    "mediawiki",
    "ms",
    "muse",
    "native",
    "odt",
    "opendocument",
    "opml",
    "org",
    "pdf",
    "plain",
    "pptx",
    "revealjs",
    "ris",
    "rst",
    "rtf",
    "s5",
    "slideous",
    "slidy",
    "t2t",
    "tei",
    "texinfo",
    "textile",
    "tikiwiki",
    "tsv",
    "twiki",
    "typst",
    "vimwiki",
    "xwiki",
    "zimwiki"
  },
  booru_rating_arr = {
    "general",
    "sensitive",
    "safe", -- safe ≙ general or sensitive
    "questionable",
    "explicit"
  },
  danbooru_category_name_arr = {
    "general",
    "artist",
    "copyright",
    "character",
    "meta",
  },
  external_tag_namespace_arr = {
    "general",
    "artist",
    "copyright",
    "character",
    "meta",
    "rating", -- rating is considered a distinct type of thing by danbooru, but not after being parsed by hydrus
    "crgroup",
    "ehtextlanguage",
    "proxusr",
    "proxsrc",
  },
  danbooru_hydrus_inference_specifier_arr = {
    
    {
      danbooru_tags = {
        prts = {
          {
            "suit",
            "headwear",
            -- more later, currently just proof of concept
          }, {
            "red",
            "blue",
            "green",
            "yellow",
            "purple",
            "orange",
            "pink",
            "brown",
            "black",
            "white",
            "grey",
            "aqua",
            "beige",
          }
        },
        
        combine = "general:{{[ d.prts[2] ]}} {{[ d.prts[1] ]}}",
      },
    },
    {
      danbooru_tags = {
        prts = {
          {
            "hand",
            "arm"
          }, {
            "s",
            "",
          }, {
            "on",
            "around"
          }, {
            "",
            "own",
            "another's"
          }, {
            "face",
            "waist",
            "cheek",
            -- more later, currently just proof of concept
          }
        },
      },
      result = function(d)
        return d.create({
          nonmodifier_parts = {
            d.my(d.prts[1]),
            d.my(d.prts[3]),
            d.my(d.prts[5]),
          },
          modifiers = {
            d.my(d.prts[2]),
          },
          inference = d.my(d.prts[4])
        })
      end,
    },  {
      danbooru_tags = {
        prts = {
          {
            "hugging",
            "grabbing",
            "pulling",
            "touching",
            "holding",
          }, {
            "",
            "own",
            "another's"
          }, {
            "face",
            "waist",
            "cheek",
            -- more later, currently just proof of concept
          }
        },
      },
      result = function (d)
        return  d.create({
          nonmodifier_parts = {
            "thing:agentlike",
            d.my(d.prts[1]),
            d.my(d.prts[3]),
          },
          inference = d.my(d.prts[2])
        })
      end
    }, {
      danbooru_tags = {
        fetch = "* focus",
        prts_extractor = function(name)
          return get.str.str_arr_by_onig_regex_match(name, "^general:(.*) (focus)$")
        end,
        combine = "general:{{[ d.prts[2] ]}} {{[ d.prts[1] ]}}",
      },
      result = "{{[ d.prts[1] ]}}:{{[ d.my(d.prts[2]) ]}}"
    }, {
      danbooru_tags = {
        fetch = "licking *",
        prts_extractor = function(name)
          return get.str.str_arr_by_onig_regex_match(name, "^general:(licking) (.*)$")
        end,
      },
      result = "{thing:bodypartlike:tongue + essive + {{[ d.my(d.prts[2]) ]}}}"
    }, {
      danbooru_tags = {
        fetch = "too many *",
        prts_extractor = function(name)
          return get.str.str_arr_by_onig_regex_match(name, "^general:(too many) (.*)$")
        end,
      },
      result = function (d)
        return d.create({
          parts = {
            d.my(d.prts[2]),
          },
          modifiers = {
            d.my(d.prts[1]),
          },
        })
      end
    }, {
      danbooru_tags = {
        prts = {
          {
            "german",
            "english",
            "latin",
            -- TODO
          },
          {
            "ranguage",
            "text",
          }, 
        },
      },
      result = "{{{[ d.my(d.prts[2]) ]}} + {{[ d.my(d.prts[1)) ]}}}"
    }, {
      danbooru_tags = {
        prts = {
          {
            "german",
            "british",
            "russian",
            "united states"
            -- TODO
          },
          {
            "flag",
            "army",
            "air force",
            "navy",
          }
        },
      },
      other = {
        sib = {
          { "thing:identity:{{[ d.prts[1] ]}}", "general:{{[ d.prts[1] ]}} nation" }
        },
        parent = {
          { "thing:real national subdivision", "{{[ d.my(d.prts[1] .. ' nation') ]}}" },
          { "thing:identity:{{[ d.prts[1] ]}}", "{{[ d.my(d.prts[1] .. ' nation') ]}}" },
        },
      },
      
      result = function (d)
        return d.create({
          parts = {
            d.my(d.prts[1] .. ' nation'),
            d.my(d.prts[2]),
          },
        })
      end
    }, {
      danbooru_tags = {
        prts = {
          {
            "german",
            "russian",
            -- TODO
          },
          {
            "clothes",
          }
        },
      },
      other = {
        sib = {
          { "thing:identity:{{[ d.prts[1] ]}}", "general:{{[ d.prts[1] ]}} culture" }
        },
        parent = {
          { "thing:real national culture", "{{[ d.my(d.prts[1] .. ' culture') ]}}" },
          { "thing:culture:{{[ d.prts[1] ]}}", "{{[ d.my(d.prts[1] .. ' culture') ]}}" },
        },
      },
      result = function (d)
        return d.create({
          parts = {
            d.my(d.prts[1] .. ' culture'),
            d.my(d.prts[2]),
          },
        })
      end
    },{
      danbooru_tags = {
        prts = {
          {
            "implied",
            "after",
            "stealth",
            "mutual",
            "public",
            "clothed",
          },
          {
            "oral",
            "fellatio",
            "cunnilingus",
          }
        },
      },
      result = function (d)
        return d.modify(d.my(d.prts[2]), {
          inference = d.my(d.prts[1])
        })
      end
    },{
      danbooru_tags = {
        prts = {
          {
            "double",
            "triple",
            "quadruple",
            "multiple",
          },
          {
            "oral",
            "fellatio",
            "cunnilingus",
            "penetration"
          }
        },
      },
      result = function (d)
        return d.modify(d.my(d.prts[2]), {
          modifiers = {[2] = d.my(d.prts[1])}
        })
      end
    }, {
      danbooru_tags = {
        fetch = "cooperative *",
        prts_extractor = function(name)
          return get.str.str_arr_by_onig_regex_match(name, "^general:(cooperative) (.*)$")
        end,
      },
      result = function (d)
        return d.modify(d.my(d.prts[2]), {
          modifiers = {d.my(d.prts[1])}
        })
      end
    }, {
      danbooru_tags = {
        fetch = "interlocked *",
        prts_extractor = function(name)
          return get.str.str_arr_by_onig_regex_match(name, "^general:(interlocked) (.*)$")
        end,
      },
      result = function (d)
        return d.create({
          parts = {
            d.my(transf.str.str_by_nonplural(d.prts[2])),
            "thing:spatial relation:circumtangent"
          },
          inference = "thing:reciprocal voice"
        })
      end
    },{
      danbooru_tags = {
        fetch = "* touching",
        prts_extractor = function(name)
          return get.str.str_arr_by_onig_regex_match(name, "^general:(.*) touching$")
        end,
      },
      result = function (d)
        return d.create({
          parts = {
            d.my(transf.str.str_by_nonplural(d.prts[2])),
            "thing:spatial relation:tangent"
          },
          inference = "thing:reflexive voice"
        })
      end
    },{
      danbooru_tags = {
        prts = {
          {
            "masturbation",
            "fingering",
            "lactation",
            "pussy juice drip",
            "female ejaculation",
            "cunnilingus",
            "penetration",
            "tribadism",
            "nipple tweak",
            "breast sucking",
            "anilingus",
            "fellatio",
            "breastfeeding"
          }, {
            "through clothes"
          }
        }
      },
      result = function (d)
        return d.modify(
          d.my(d.prts[1]),
          {
          inference = "thing:spatial relation:through clothes"
        })
      end
    },{
      danbooru_tags = {
        prts = {
          {
            "cum",
          }, {
            "in",
            "on"
          }, {
            "body",
            "breasts",
            "hair",
            "tongue",
            "stomach",
            "male",
            "penis",
            "legs",
            "hands",
            "feet",
            "self",
            "pectorals",
            "eyewear",
            "floor",
            "fingers",
            "back",
            "armpits",
            "figure",
            "food",
            "chest",
            "gloves",
            "object",
            "skirt",
            "tail",
            "lips",
            "sheets",
            "crotch",
            "bed",
            "mask",
            "testicles",
            "goggles",
            "neck",
            "horns",
            "underside",
            "wall",
            "desk",
            "picture",
            "wings",
            "portrait",
            "pubic hair",
            "ears",
            "halo",
            "camera",
            "window",
            "pussy",
            "mouth",
            "hair",
            "ass",
            "clothes",
            "uterus",
            "nose",
            "container",
            "cup",
            "panties",
            "navel",
            "throat",
            "bowl",
            "eye",
            "footwear",
            "headwear",
            "cloaca",
            "nipple",
            "ear",
            "mouth"
          }
        }
      },
      result = function (d)
        return d.modify(
          d.my(d.prts[1]),
          {
            inference = "thing:spatial relation:through clothes"
          }
        )
      end
    },{
      danbooru_tags = {
        prts = {
          {
            "self ",
            "auto"
          },{
            "hug",
            "exposure",
            "breast sucking",
            "wedgie",
            "bondage",
            "milking",
            "fisting",
            "facial",
            "arousal",
            "fellatio",
            "paizuri",
            "cunnilingus",
            "defenestration",
            "penetration",
            "tentacle sex",
            "footjob",
            "insemination",
            "anilingus"
          }
        },
        combine = "general:{{[ d.prts[1] ]}}{{[ d.prts[2] ]}}",
        
      },
      result = function (d)
        return d.modify(d.my(d.prts[2]), {
          inference = "thing:reflexive voice"
        })
      end,
    },{
      danbooru_tags = {
        prts = {
          {
            "bad",
          }, {
            "anatomy",
            "feet",
            "foot",
            "hand",
            "hands",
            "proportions",
            "perspective",
            "leg",
            "arm",
            "neck",
            "reflection",
            "gun anatomy",
            "vulva",
            "face",
            "ass",
            "singing",
            "multiple views",
            "vehicle anatomy"
          }
        },
        
      },
      result =  "thing:thing:deviation:unintentional + thing:deviation:from ideal + thing:{{[ d.my(d.prts[2]) ]}}", -- TODO: not sure if this is really how I want to deal with this. 
    },{
      danbooru_tags = {
        prts = {
          {
            "breast",
            "muscle",
            "penis",
            "height",
            "ass",
            "hair",
            "food"
          },
          {
            "envy",
            "awe",
          }
        },
      },
      result = function (d)
        return d.create({ parts = { 'thing:thing:agentlike', d.my(d.prts[2]), d.my(d.prts[1])}})
      end
    }, {
      danbooru_tags = {
        prts = {
          {
            "english",
          },
        },
        combine = "ehtextlanguage:{{[ d.prts[1] ]}}"
      },
      result = function (d)
        return d.create({
          parts = {
            d.my(d.prts[1]),
            "text"
          }
        })
      end
    },
  },
  two_strs__arr_arr_by_siblings = {
    {"foreground:blur", "general:blurry foreground"},
    {"background:blur", "general:blurry foreground"},
    {"general:british navy", "general:royal navy"},
    {"general:hugging arm", "general:arm hug"},
    {"general:interlocked arms", "general:locked arms"},
    {"general:hugging", "general:hug"},
    {"general:german nation", "general:germany"},
    {"{thing:bodypartlike:oral parts + essive + thing:bodypartlike:crotch pleasurable organ}", "general:oral"},
    {"{thing:bodypartlike:oral parts + essive + thing:bodypartlike:phallic object}", "general:fellatio"},
    {"{thing:bodypartlike:oral parts + essive + thing:bodypartlike:vulva}", "general:cunnilingus"},
    {"{thing:agentlike + thing:activity:awe + bodypartlike:flat breasts}", "flat awe"},
    {"{thing:agentlike + thing:activity:envy + bodypartlike:flat breasts}", "flat envy"},
    {"general:cum in uterus", "general:internal cumshot"},
    {"thing:language:translation", "ehtextlanguage:translated"}
  },
  root_hydrus_note_namespace_arr = {
    "prompt:positive", -- what the creator was told to create
    "prompt:negative", -- what the creator was told not to create
    "proximate_source_description:any", -- description of the fobject on the proximate source
    "proximate_source_description:original",
    "proximate_source_description:tl:en"
  },
  root_hydrus_tag_namespace_arr = {

    -- global tag namespace

    "global", -- This describes the global namespace set, which is also used below.

    -- thing tag namespaces - what can be percieved in the fobjectlike, or inferred only from the fobjectlike and a reasonable knowledge of the world? What importance does it have to the fobjectlike?
    
    "thing", -- A global namespace item which describes something that can be percieved in the fobjectlike, or inferred only from the fobjectlike and a reasonable knowledge of the world.
    "substance", -- A global namespace item which describes the fobjectlike itself, rather than one of its parts or something contained within. thing:apple means it contains an apple, substance:apple means it is an apple. thing:aqua 1-adic range SBCS^2^ means there is something aqua, substance:aqua 1-adic range SBCS^2^ means the object is a color sample of aqua.
    "substance_part", -- A global namespace item which describes something that contributes to the substance of the fobjectlike. E.g. substance_part:apple means that a recognizable part of the fobjectlike itself is an apple. substance_part:photo means that a recognizable part of the fobjectlike itself is a photo.
    "focus", -- A global namespace item which describes the main focus of the fobjectlike. E.g. focus:apple means the apple is the main focus of the object.
    "theme", -- A global namespace item which describes something that is important throughout the fobjectlike, but not necessarily the main focus. E.g. theme:apple might mean that apples are strategically placed around the object to symbolize temptation, or just because it's a food picture with a fall-apple theme.
    "accent", -- A global namespace item which describes something that has some amount of focus within the fobjectlike, but not as much as the focus or theme. E.g. thing:dagger means it contains a dagger, accent:dagger might mean that there is a dagger in the background as an easter egg or foreshadowing.
    "framing", -- A global namespace item which describes something that gives major context to the fobjectlike. E.g. framing:dagger might mean that the fobjectlike is a dagger with some intericate metalwork, where the metalwork is the focus, but the dagger is the framing. framing:web browser might mean that the focus is some content on the web, but the web browser what gives it context and meaning. This does not mean that anything e.g. in a web browser must be tagged with framing:web browser, if that fact is unimportant to the fobjectilke.
    "incidental", -- A global namespace item which describes something that is present in the fobjectlike, but is not important to it at all.
    "foreground", -- A global namespace item which describes something that is in the foreground of the fobjectlike.
    "midground", -- A global namespace item which describes something that is in the midground of the fobjectlike.
    "background", -- A global namespace item which describes something that is in the background of the fobjectlike.

    -- creation tag namespaces
    
    "creation", -- A global namespace item that describes something about the creation of the object. This could be a creator, an object used in its creation, a location, or the like.
    "creation_title", -- title item as chosen by the creator. A title item starts with original:,  tl:<language>, or any:, to indicate language and origin.

    -- proximate source tag namespaces

    "proximate_source", -- A global namespace item which describes something about how I encountered the object. This could be the uploader, the website, the subreddit, etc.
    "proximate_source_title", -- title item as chosen by the proximate source.

    -- acquisition tag namespaces - how did I acquire the object? This is not the same as sharing, as I may have acquired the object in a way that doesn't involve sharing, e.g. by creating it myself.

    "acquisition", -- A global namespace item which describes something about how, when, where, in what context etc. I acquired the object.
    "acquisition_title", -- title item as chosen by the acquisition source.

    -- use tag namespaces - why did I keep the object? What do I use it for?

    "use", -- A global namespace item which describes something about why I kept the object, or how I'd like to use it in the future.
    "use_title", -- the title item during use. For example, a funny name I give the object.
    
    -- series tag namespaces - where within some general series does this object fit?

    "chapter_index", -- numerical index of a chapter, e.g. 25
    "chapter_title", -- title of a chapter, e.g. "Can't stop won't stop can't stop"
    "page_index", -- numerical index of a page within a chapter or work, e.g. 11
    "volume_index", -- numerical index of a volume, e.g. 3
    "episode_index", -- numerical index of an episode, e.g. 3
    "episode_subindex", -- numerical index of an object within an episode, e.g. 5. In principle, episode_timestamp would be better, but this is exists where that information isn't easily available or has been lost.
    "episode_timestamp", -- timestamp of an object within an episode, e.g. 00:03:12.
    "season_index", -- numerical index of a season, e.g. 3
    "season_subindex", -- numerical index of an object within a season, especially for openings and endings
    "episode_role", -- role of an object within an episode, e.g. opening, ending, insert song, etc.

    -- general meta tag namespaces - tags with a more general purpose, that don't fit into any of the above categories.

    "date", -- date of acquisition in (partial) RFC3339 format
    "collection", -- a wide field that allows grouping objects in a way where I don't want to create a specific tag namespace, potentially only temporarily. Prefer more specific namespaces where possible.
    "creation_lat", -- latitude of the object as a decimal number, if applicable. E.g. 48.137154.
    "creation_lon", -- longitude of the object as a decimal number, if applicable. E.g. 11.576124
    "under_management", -- If this namespace contains a value, this means that we're managing the object for another person or organization, which is what this namespace will contain.

  },
  global_value_taking_root_hydrus_tag_namespace_arr = {
    "thing",
    "substance",
    "substance_part",
    "focus",
    "theme",
    "accent",
    "framing",
    "incidental",
    "foreground",
    "midground",
    "background",
    "creation",
    "proximate_source",
    "acquisition",
    "use",
  },
  composition = {
    "visual composition",
      "2d composition",
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
  csl_type_arr = {
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
  csl_title_key_arr = { "title", "title-short" },
  git_remote_type_arr = {"github", "gitlab", "bitbucket"},
  name_of_useless_file_arr = {".git", "node_modules", ".vscode"},
  youtube_upload_status_arr = {
    "deleted",
    "failed",
    "processed",
    "rejected",
    "uploaded"
  },
  youtube_privacy_status_arr = {
    "private",
    "public",
    "unlisted"
  },
  search_engine_id_arr = {
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
  likely_main_branch_name_arr = {
    "main",
    "master",
    "trunk",
    "develop",
    "dev",
  },
  plaintext_table_extension_arr = {"csv", "tsv"},
  plaintext_assoc_extension_arr = { "", "yaml", "json", "toml", "ini", "ics"},
  image_extension_arr = {"png", "jpg", "gif", "webp", "svg"},
  db_extension_arr = {"db", "dbf", "mdb", "accdb", "db3", "sdb", "sqlite", "sqlite3", "nsf", "fp7", "fp5", "fp3", "fdb", "gdb", "dta", "pdb", "mde", "adf", "mdf", "ldf", "myd", "myi", "frm", "ibd", "ndf", "db2", "dbase", "tps", "dat", "dbase3", "dbase4", "dbase5", "edb", "kdb", "kdbx", "sdf", "ora", "dbk", "rdb", "rpd", "dbc", "dbx", "btr", "btrieve", "db3", "s3db", "sl3", "db2", "s2db", "sqlite2", "sl2"},
  sql_extension_arr = {"db", "sdb", "sqlite", "db3", "s3db", "sqlite3", "sl3", "db2", "s2db", "sqlite2", "sl2", "sql", "mdf", "ldf", "ndf", "myd", "frm", "ibd", "ora", "rdb"},
  sqlite_extension_arr = {"db", "sdb", "sqlite", "db3", "s3db", "sqlite3", "sl3", "db2", "s2db", "sqlite2", "sl2"},
  bin_extension_arr = {"jpg", "jpeg", "png", "gif", "pdf", "mp3", "mp4", "mov", "avi", "zip", "gz", 
  "tar", "tgz", "rar", "7z", "dmg", "exe", "app", "pkg", "m4a", "wav", "doc", 
  "docx", "xls", "xlsx", "ppt", "pptx", "psd", "ai", "mpg", "mpeg", "flv", "swf",
  "sketch", "db", "sql", "sqlite", "sqlite3", "sqlitedb", "odt", "odp", "ods", 
  "odg", "odf", "odc", "odm", "odb", "jar", "pyc"},
  audio_extension_arr = {
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
  video_extension_arr = {
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

  whisper_extension_arr = {
    "mp3",
    "mp4",
    "mpeg",
    "mpga",
    "m4a",
    "wav",
    "webm"
  },
  hydrusable_extension_arr = {
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
  rfc3339like_dt_separator_arr = {
    "-", "T", ":", "Z"
  },
  rfc3339like_dt_format_str_arr = {
    "%Y",
    "%Y-%m",
    "%Y-%m-%d",
    "%Y-%m-%dT%H",
    "%Y-%m-%dT%H:%M",
    "%Y-%m-%dT%H:%M:%SZ",
  },
  lower_strict_kebap_case_arr_by_email_headers_initial = {"from", "to", "cc", "bcc", "subject"},
  youtube_exists_upload_status_arr = {
    "processed",
    "uploaded"
  },
  creation_specifier_type_arr = {
    "watcher",
    "hotkey",
    "stream"
  },
  stream_state_arr = {
    "booting",
    "active",
    "ended"
  },
  flag_profile_name_arr = {
    "foreground",
    "background"
  },
  bin_specifier_name_arr = {
    "inf_no"
  },
  dcmp_name_arr = {"year", "month", "day", "hour", "min", "sec"},
  dcmp_name_long_arr = {"year", "month", "day", "hour", "minute", "second"},
  vcard_addr_key_arr = {"Formatted name", "First name", "Last name", "Street", "Code", "City", "Region", "Country", "Box", "Extended"},
  mod_char_arr = {"c", "a", "s", "ct", "f"},
  mod_symbol_arr = {"⌘", "⌥", "⇧", "⌃", "fn"},
  mod_name_arr = {"cmd", "alt", "shift", "ctrl", "fn"},
  rfc3339like_dt_str_format_part_arr = {"%02d", "%04d"},
  api_name_arr = {"dropbox", "danbooru", "openai", "hydrus", "httpbin", "google", "osm"},
  secondary_api_name_arr = {"youtube"},
  api_request_kv_location_arr = {"header", "param", "header+param", "payload"},
  http_authentication_scheme_arr = {"Basic", "Digest", "Bearer"},
  token_type_arr = {"simple", "oauth2"},
  rfc3339like_dt_format_part_arr = {
    "%Y", "%m", "%d", "%H", "%M", "%S"
  },
  mac_voice_name_arr = {
    "Agnes",
    "Albert",
    "Alex",
    "Alice",
    "Alva",
    "Amelie",
    "Anna",
    "Bad",
    "Bahh",
    "Bells",
    "Boing",
    "Bruce",
    "Bubbles",
    "Carmit",
    "Cellos",
    "Damayanti",
    "Daniel",
    "Deranged",
    "Diego",
    "Ellen",
    "Fiona",
    "Fred",
    "Good",
    "Hysterical",
    "Ioana",
    "Joana",
    "Junior",
    "Kanya",
    "Karen",
    "Kathy",
    "Kyoko",
    "Laura",
    "Lekha",
    "Luciana",
    "Mariska",
    "Mei-Jia",
    "Melina",
    "Milena",
    "Moira",
    "Monica",
    "Nora",
    "Paulina",
    "Pipe",
    "Princess",
    "Ralph",
    "Samantha",
    "Sara",
    "Satu",
    "Sin-ji",
    "Tarik",
    "Tessa",
    "Thomas",
    "Ting-Ting",
    "Trinoids",
    "Veena",
    "Vicki",
    "Victoria",
    "Whisper",
    "Xander",
    "Yelda",
    "Yuna",
    "Zarvox",
    "Zosia",
    "Zuzana",
  },
  lower_strict_kebap_case_arr_by_email_headers_containin_emails = {"to", "cc", "bcc", "from", "reply-to"},
  vcard_phone_type_arr = {"home", "cell", "work", "pref", "pager", "voice", "fax", "voice"}, -- only those in both vcard 3.0 and 4.0
  vcard_email_type_arr = {"home", "work", "pref", "internet"},
  vcard_address_type_arr = {"home", "work", "pref", "text", "voice", "fax", "cell", "video", "pager", "textphone"},
  vcard_key_with_vcard_type_arr = {"Phone", "Email", "Address"},
  unicode_char_prop_arr = {
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
  unicode_emoji_prop_arr = {
    "cldr",
    "cldr_full",
    "cpoint",
    "emoji",
    "group",
    "name",
    "subgroup",
  },
  menu_item_key_arr ={"path", "application", "AXTitle", "AXEnabled", "AXRole", "AXMenuItemMarkChar", "AXMenuItemCmdChar", "AXMenuItemCmdModifiers", "AXMenuItemCmdGlyph"},
  csl_key_arr = {
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
  fs_attr_name_arr = {
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
  base_letter_arr = {
    "b",
    "o",
    "d",
    "x",
  },
  citable_object_id_indication_name_arr = {
    "isbn",
    "doi",
    "isbn_part",
    "pmid",
    "pmcid",
    "accession",
    "issn_full",
    "urlmd5"
  },
  client_project_kind_arr = {
    "translation"
  },
  billing_unit_arr = {
    "line"
  },
  llm_chat_role_arr = {
    "system",
    "user",
    "assistant",
    "function"
  },
  jxa_browser_name_arr = {
    "Google Chrome"
  },
  jxa_tabbable_name_arr = {
    "Google Chrome",
  },
  markdown_extension_set_name_arr = {
    "basic",
    "featureful",
    "navigable",
    "citing",
    "styleable"
  },
  markdown_extension_name_arr = {
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
  type_name_arr = {
    "string",
    "number",
    "boolean",
    "table",
    "function",
    "thread",
    "userdata",
    "nil"
  },
  mac_plist_type_name_arr = {
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
  dynamic_structure_name_arr = {
    "latex",
    "omegat"
  }
}

ls_by_union = {
  global_or_external_tag_namespace_arr = transf.two_arrs.arr_by_appended(
    ls.global_value_taking_root_hydrus_tag_namespace_arr,
    ls.external_tag_namespace_arr
  )
}