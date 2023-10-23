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
  unique_field_separator = "Y:z:Y",
  int_by_large = 2^51, -- a bit smaller than the maximum 2^53 to allow for some wiggle room
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
  danbooru_category_name_arr = {
    "general",
    "artist",
    "copyright",
    "character",
    "meta",
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
      result =  "thing:thing:{{[ d.my(d.prts[1]) ]}} ++ thing:{{[ d.my(d.prts[2]) ]}}",
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
      action = "thing:"
        .. "thing:{{[ d.my(d.prts[1]) .. d.bracket(d.my(d.prts[2])) ]}}" 
        .. " +{{[ d.my(d.prts[3]) ]}}"
        .. " thing:{{[ d.my(d.prts[5]) ]}}"
        .. " {{[ d.slash(d.my(d.prts[4])) ]}}"
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
      action = "thing:"
        .. " +{{[ d.my(d.prts[1]) ]}}"
        .. " thing:{{[ d.my(d.prts[3]) ]}}"
        .. " {{[ d.slash(d.my(d.prts[2])) ]}}"
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
      result = "thing:thing:bodypartlike:tongue +essive+ {{[ d.my(d.prts[2]) ]}}"
    }, {
      danbooru_tags = {
        fetch = "too many *",
        prts_extractor = function(name)
          return get.str.str_arr_by_onig_regex_match(name, "^general:(too many) (.*)$")
        end,
      },
      result = "thing:{{[ d.my(d.prts[2]) ]}}{{[ d.bracket(d.my(d.prts[1])) ]}}"
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
      result = "thing:{{[ d.my(d.prts[2]) ]}} ++ {{[ d.my(d.prts[1)) ]}}"
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
      
      result = "thing:{{[ d.my(d.prts[1] .. ' nation') ]}} ++ {{[ d.my(d.prts[2)) ]}}",
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
      result = "thing:{{[ d.my(d.prts[1] .. ' culture') ]}} ++ {{[ d.my(d.prts[2)) ]}}"
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
            "blowjob",
            "cunnilingus",
          }
        },
      },
      result = "{{[ d.my(d.prts[2]) ]}}/{{[ d.my(d.prts[1)) ]}}"
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
            "blowjob",
            "cunnilingus",
            "penetration"
          }
        },
      },
      result = "{{[ d.modify(d.my(d.prts[2]), d.my(d.prts[1)), 2) ]}}"
    }, {
      danbooru_tags = {
        fetch = "cooperative *",
        prts_extractor = function(name)
          return get.str.str_arr_by_onig_regex_match(name, "^general:(cooperative) (.*)$")
        end,
      },
      result = "{{[ d.modify(d.my(d.prts[2]), d.my(d.prts[1)), 1) ]}}"
    },{
      danbooru_tags = {
        fetch = "self*",
        prts_extractor = function(name)
          return get.str.str_arr_by_onig_regex_match(name, "^general:(self)(.*)$")
        end,
      },
      result = "" -- TODO. We have a problem here: the combined things are namespace:val /modification, but the uncombined things are not. So we would need to add a thing: to the beginning for some, but not for others. Obviously, that can't work. Solutions: Find a way to not prefix the combined things with a namespace (problematic), or find a way to auto add a namespace to unnamespaced things. The latter could work (have a list of valid namespaces, check each item -> does it start with a valid namespace? If not, add a default namespace.), the main problem is, when do we apply it? We need to make sure that it's applied before we add parents or siblings based on it, otherwise these will target the wrong thing.
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
        
        combine = "general:{{[ d.prts[2] ]}} {{[ d.prts[1] ]}}",
      },
      result =  "thing:thing:deviation:unintentional ++ thing:deviation:from ideal ++ thing:{{[ d.my(d.prts[2]) ]}}", -- TODO: not sure if this is really how I want to deal with this. 
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
      result = "thing:thing:agentlike +{{[d.my(d.prts[2])]}}+ {{[ d.my(d.prts[1]) ]}}"
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
    {"thing:thing:bodypartlike:oral parts +essive+ thing:bodypartlike:crotch pleasurable organ", "general:oral"},
    {"thing:thing:bodypartlike:oral parts +essive+ thing:bodypartlike:phallic object", "general:fellatio"},
    {"thing:thing:bodypartlike:oral parts +essive+ thing:bodypartlike:vulva", "general:cunnilingus"},
    {"thing:thing:agentlike +thing:activity:awe+ bodypartlike:flat breasts", "flat awe"},
    {"thing:thing:agentlike +thing:activity:envy+ bodypartlike:flat breasts", "flat envy"},
  },
  note_key = {
    "positive_prompt", -- what the creator was told to create
    "negative_prompt", -- what the creator was told not to create
    "proximate_source_description", -- description of the fobject on the proximate source
  },
  all_namespace = {

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
    "creation_title", -- the title as chosen by the creator

    -- proximate source tag namespaces

    "proximate_source", -- A global namespace item which describes something about how I encountered the object. This could be the uploader, the website, the subreddit, etc.
    "proximate_source_title", -- the title as chosen by the proximate source, most often the uploader

    -- acquisition tag namespaces - how did I acquire the object? This is not the same as sharing, as I may have acquired the object in a way that doesn't involve sharing, e.g. by creating it myself.

    "acquisition", -- A global namespace item which describes something about how, when, where, in what context etc. I acquired the object.
    "acquisition_title", -- the title during acqusition. I'm not sure if this is ever different from creation_title or proximate_source_title.
    "acquisition_context", -- the context of my life this object was created or encountered in. Can be general, e.g. edu, work, leisure, etc., or more specific, e.g. freelance translation. The more specific ones should be tag children of the more general ones. 

    -- use tag namespaces - why did I keep the object? What do I use it for?

    "use", -- A global namespace item which describes something about why I kept the object, or how I'd like to use it in the future.
    "use_title", -- the title during use. For example, a funny name I give the object.
    
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
  global_namespace_taking_key_name_arr = {
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