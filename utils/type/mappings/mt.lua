_r_comp = {
  lua = {
    date = {
      long_dt_seps = {" at "},
      sep = "[_%-%.:;%s/T]",
      sep_opt = "[_%-%.:;%s/T]?",
      y = "(%d%d%d%d)",
      y_s = "(%d%d)",
      m = "(%d%d)",
      d = "(%d%d)",
      h = "(%d%d)",
      min = "(%d%d)",
      s = "%d%d",
    }
  }
}
mt = {
  _contains = {
    lua_metacharacters = {"%", "^", "$", "(", ")", ".", "[", "]", "*", "+", "-", "?"},
    regex_metacharacters =  {"\\", "^", "$", ".", "[", "]", "*", "+", "?", "(", ")", "{", "}", "|", "-"},
    small_words = {
      "a", "an", "and", "as", "at", "but", "by", "en", "for", "if", "in", "of", "on", "or", "the", "to", "v", "v.", "via", "vs", "vs."
    },
    unique_record_separator  = "__ENDOFRECORD5579__",
    unique_field_separator = "Y:z:Y",
  },
  _list = {
    tree_node_keys = {"pos", "children", "parent", "text", "tag", "attrs", "cdata"},
    apis_that_dont_support_authorization_code_fetch = {"google"},
    useless_files = {".git", "node_modules", ".vscode"},
    auth_processes = {
      "bearer", "basic", "manual"
    },
    khal = {
      parseable_format_components = {
        "uid",
        "calendar",
        "start",
        "title",
        "description",
        "location",
        "end",
        "url",
      }
    },
    html_entity_indicator = {
      encoded = {"&", ";"},
      decoded = {"\"", "'", "<", ">", "&"}
    },
    date = {
      dt_component_few_chars = {"year", "month", "day", "hour", "min", "sec"}
    },
    addr_key = {"Formatted name", "First name", "Last name", "Street", "Code", "City", "Region", "Country", "Box", "Extended"},
    vcard = {
      phone_key = {"home", "cell", "work", "pref", "pager", "voice", "fax", "voice"}, -- only those in both vcard 3.0 and 4.0
      email_key = {"home", "work", "pref", "internet"}
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
    }
  },
  _r = {
    text_bloat = {
      youtube = {
        video = "[\\-【 \\(]*(?:Official )?(?:Music Video|Video|MV)(?: full)?[\\-】 \\)]*",
        misc = "[\\-【  \\(]*(?:Audio|TVアニメ|Official)[\\-】 \\)]*",
        channel_topic_producer = "[\\-【 \\(]*(?:Official|YouTube|Music|Topic|SMEJ|VEVO|Channel|チャンネル ?){1, 3})[\\-】 \\)]*",
        slash_suffix = " */ *[^/]+$"
      }
    },
    case = {
      snake = "[a-zA-Z0-9_]+",
      upper_snake = "[A-Z0-9_]+",
      lower_snake = "[a-z0-9_]+",
      lower = "[a-z]+",
      upper = "[A-Z]+",
    },
    syntax = {
      dice = "(?:\\d+)?d\\d+(?:[/x\\*]\\d+)?(?:[+-]\\d+)?",
      point = "([\\-\\d]+)..*?([\\-\\d]+)"
    },
    charset = {
      printable_ascii = "[\\x20-\\x7E]+",
      ascii = "[\\x00-\\x7F]+",
    },
    date = {
      rfc3339 = "\\d{4}(?:" ..
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
    ..")?"
    },
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
    id = {
      issn = "[0-9]{4}-?[0-9]{3}[0-9xX]",
      isbn = "(?:(?:[0-9]{13}|[0-9]{9}[0-9xX]))",
      uuid = "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}",
      doi = "(?:10\\.\\d{4,9}/[-._;()/:A-Z0-9]+)",
      doi_prefix = "^(?:https?://)?(?:dx.)?doi(?:.org/|:)?"
    },
    whitespace = {
      large = "[\t\r\n]"
    },
    url = {
      host = {
        subpart = {
          domain_and_tld = "(\\w+\\.\\w+)$",
          domain = "(\\w+)\\.\\w+$",
          tld = "\\w+\\.(\\w+)$"
        }
      }
    },
    version = {
      semver = "(\\d+)(?:\\.(\\d+)(?:\\.(\\d+)(?:\\-([\\w.-]+))?(?:\\+([\\w.-]+))?)?)?",
    }
  },
  _r_lua = {
    without_extension_and_extension = "(.+)%.([^%.]+)",
    classes = {
      sep = "[_%-%.:;%s/T]",
    },
    date = {
      full_datetime = _r_comp.lua.data.y .. _r_comp.lua.data.sep_opt .. _r_comp.lua.data.m .. _r_comp.lua.data.sep_opt .. _r_comp.lua.data.d .. _r_comp.lua.data.sep_opt .. _r_comp.lua.data.h .. _r_comp.lua.data.sep_opt .. _r_comp.lua.data.min .. _r_comp.lua.data.sep_opt .. _r_comp.lua.data.s .. "Z?",
      noseconds_datetime = _r_comp.lua.data.y .. _r_comp.lua.data.sep_opt .. _r_comp.lua.data.m .. _r_comp.lua.data.sep_opt .. _r_comp.lua.data.d .. _r_comp.lua.data.sep_opt .. _r_comp.lua.data.h .. _r_comp.lua.data.sep_opt .. _r_comp.lua.data.min .. "Z?",
      nominutes_noseconds = _r_comp.lua.data.y .. _r_comp.lua.data.sep_opt .. _r_comp.lua.data.m .. _r_comp.lua.data.sep_opt .. _r_comp.lua.data.d .. _r_comp.lua.data.sep_opt .. _r_comp.lua.data.h .. "Z?",
      full_date = _r_comp.lua.data.y .. _r_comp.lua.data.sep_opt .. _r_comp.lua.data.m .. _r_comp.lua.data.sep_opt .. _r_comp.lua.data.d,
      sep_month = _r_comp.lua.data.y .. _r_comp.lua.data.sep .. _r_comp.lua.data.m,
      short_date = _r_comp.lua.data.y_s .. _r_comp.lua.data.sep_opt .. _r_comp.lua.data.m .. _r_comp.lua.data.sep_opt .. _r_comp.lua.data.d,
      onlyear = _r_comp.lua.data.y
    }
  }
}
