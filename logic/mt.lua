r = {
  g = {
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
    char_range = {
      printable_ascii = "\\x20-\\x7E",
      ascii = "\\x00-\\x7F",
    },
    date = {
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

fixedstr = {
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
  tree_node_keys = {"pos", "children", "parent", "text", "tag", "attrs", "cdata"},
  apis_that_dont_support_authorization_code_fetch = {"google"},
  csl_title_keys = { "title", "title-short" },
  remote_types = {"github", "gitlab", "bitbucket"},
  useless_files = {".git", "node_modules", ".vscode"},
  filetype = {
    ["plaintext-table"] = {"csv", "tsv"},
    ["plaintext-dictionary"] = { "", "yaml", "json", "toml", "ini", "ics"},
    ["plaintext-tree"] = {"html", "xml", "svg", "rss", "atom"},
    xml = {"html", "xml", "svg", "rss", "atom"},
    image = {"png", "jpg", "gif", "webp", "svg"},
    ["db"] = {"db", "dbf", "mdb", "accdb", "db3", "sdb", "sqlite", "sqlite3", "nsf", "fp7", "fp5", "fp3", "fdb", "gdb", "dta", "pdb", "mde", "adf", "mdf", "ldf", "myd", "myi", "frm", "ibd", "ndf", "db2", "dbase", "tps", "dat", "dbase3", "dbase4", "dbase5", "edb", "kdb", "kdbx", "sdf", "ora", "dbk", "rdb", "rpd", "dbc", "dbx", "btr", "btrieve", "db3", "s3db", "sl3", "db2", "s2db", "sqlite2", "sl2"},
    ["sql"] = {"db", "sdb", "sqlite", "db3", "s3db", "sqlite3", "sl3", "db2", "s2db", "sqlite2", "sl2", "sql", "mdf", "ldf", "ndf", "myd", "frm", "ibd", "ora", "rdb"},
    ["possibly-sqlite"] = {"db", "sdb", "sqlite", "db3", "s3db", "sqlite3", "sl3", "db2", "s2db", "sqlite2", "sl2"},
    ["shell-script"] = { "sh", "bash", "zsh", "fish", "csh", "tcsh", "ksh", "zsh", "ash", "dash", "elvish", "ion", "nu", "oksh", "osh", "rc", "rksh", "xonsh", "yash", "zsh" },
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
  
    ["whisper-audio"] = {
      "mp3",
      "mp4",
      "mpeg",
      "mpga",
      "m4a",
      "wav",
      "webm"
    }
  
  },
  auth_processes = {
    "bearer", "basic", "manual"
  },
  mullvad_states ={
    "Connected", "Disconnected"
  },
  initial_headers = {"from", "to", "cc", "bcc", "subject"},
  datelib = {
    gettable_units  = { "date", "year", "isoyear", "month", "yearday", "weekday", "isoweekday", "weeknum", "isoweeknum", "day", "time", "hours", "minutes", "seconds", "fracs", "ticks" },
    addable_units = { "years", "months", "days", "hours", "minutes", "seconds", "ticks" }
  },
  markdown_extensions = {
    basic = {
      "yaml_metadata_block"
    },
    featureful = {
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
    },
    navigable = {
      "implicit_header_references"
    },
    citing = {
      "citations",
    },
    styleable = {
      "header_attributes",
      "auto_identifiers",
      "gfm_auto_identifiers",
      "link_attributes",
      "fenced_divs"
    }
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
  date = {
    date_component_names = {"year", "month", "day", "hour", "min", "sec"},
    date_component_names_long = {"year", "month", "day", "hour", "minute", "second"},
    long_dt_seps = {" at "}
  },
  addr_key = {"Formatted name", "First name", "Last name", "Street", "Code", "City", "Region", "Country", "Box", "Extended"},
  email_headers_containin_emails = {"to", "cc", "bcc", "from", "reply-to"},
  vcard = {
    phone_key = {"home", "cell", "work", "pref", "pager", "voice", "fax", "voice"}, -- only those in both vcard 3.0 and 4.0
    email_key = {"home", "work", "pref", "internet"},
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
  }
}