

tblmap = {
  whitespace = {
    escaped = {
      ["\n"] = "\\n",
      ["\t"] = "\\t",
      ["\f"] = "\\f",
      ["\r"] = "\\r",
      ["\0"] = "\\0"
    },
  },
  char = {
    name = {
      ["\t"] = "tab",
      ["\n"] = "newline",
      [","] = "comma",
      [";"] = "semicolon",
      ["."] = "period",
      [":"] = "colon",
      ["!"] = "exclamation mark",
      ["?"] = "question mark",
      ["("] = "left parenthesis",
      [")"] = "right parenthesis",
      ["["] = "left bracket",
      ["]"] = "right bracket",
      ["{"] = "left brace",
      ["}"] = "right brace",
      ["'"] = "single quote",
      ['"'] = "double quote",
      ["*"] = "asterisk",
      ["-"] = "minus",
      ["_"] = "underscore",
      ["="] = "equals",
      ["+"] = "plus",
      ["<"] = "less than",
      [">"] = "greater than",
      ["/"] = "slash",
      ["\\"] = "backslash",
      ["|"] = "vertical bar",
      ["~"] = "tilde",
      ["`"] = "backtick",
      ["@"] = "at sign",
      ["#"] = "pound sign",
      ["$"] = "dollar sign",
      ["%"] = "percent sign",
      ["^"] = "caret",
      ["&"] = "ampersand",
      [" "] = "space",
    }
  },
  mod = {
    mod_symbol = {
      cmd = "⌘",
      alt = "⌥",
      shift = "⇧",
      ctrl = "⌃",
      fn = "fn",
    },
    mod_name = {
      cmd = "cmd",
      alt = "alt",
      shift = "shift",
      ctrl = "ctrl",
      fn = "fn",
    },
    mod_char = {
      cmd = "c",
      alt = "a",
      shift = "s",
      ctrl = "ct",
      fn = "f",
    },
  },
  
  date_component_name = {
    seconds = {
      sec = 1,
      min = 60,
      hour = 60 * 60,
      day = 60 * 60 * 24,
      week = 60 * 60 * 24 * 7,
      month = 60 * 60 * 24 * 30,
      year = 60 * 60 * 24 * 365,
    },
    rfc3339like_dt_format_part = {
      sec = "%S",
      min = "%M",
      hour = "%H",
      day = "%d",
      week = "%W",
      month = "%m",
      year = "%Y",
    },
    rfc3339like_dt_string_format_part = {
      sec = "%02d",
      min = "%02d",
      hour = "%02d",
      day = "%02d",
      week = "%02d",
      month = "%02d",
      year = "%04d",
    },
    rfc3339like_dt_string_format_part_fallback = {
      sec = "??",
      min = "??",
      hour = "??",
      day = "??",
      week = "??",
      month = "??",
      year = "????",
    },
    rfc3339like_dt_separator = {
      year = "-",
      month = "-",
      day = "T",
      hour = ":",
      min = ":",
      sec = "Z",
    },
    prev_rfc3339like_dt_separator = {
      year = nil,
      month = "-",
      day = "-",
      hour = "T",
      min = ":",
      sec = ":",
    },
    rfc3339like_dt_format_string = {
      year = "%Y",
      month = "%Y-%m",
      day = "%Y-%m-%d",
      hour = "%Y-%m-%dT%H",
      min = "%Y-%m-%dT%H:%M",
      sec = "%Y-%m-%dT%H:%M:%SZ",
    },
    max_date_component_value = {
      sec = 60,
      min = 60,
      hour = 24,
      day = 30,
      month = 12,
    },
    min_date_component_value = {
      sec = 0,
      min = 0,
      hour = 0,
      day = 1,
      month = 1,
    },
    date_component_index = {
      year = 1,
      month = 2,
      day = 3,
      hour = 4,
      min = 5,
      sec = 6,
    },
    date_component_name_long = {
      year = "year",
      month = "month",
      day = "day",
      hour = "hour",
      min = "minute",
      sec = "second",
    },

  },
  date_component_index = {
    date_component_name = {
      [1] = "year",
      [2] = "month",
      [3] = "day",
      [4] = "hour",
      [5] = "min",
      [6] = "sec",
    },
  },
  date_format_name = {
    date_format = {
      ["rfc3339-date"] = "%Y-%m-%d",
      ["rfc3339-time"] = "%H:%M:%S",
      ["rfc3339-datetime"] = "%Y-%m-%dT%H:%M:%SZ",
      ["american-date"] = "%m/%d/%Y",
      ["american-time"] = "%I:%M:%S %p",
      ["american-datetime"] = "%m/%d/%Y %I:%M:%S %p",
      ["german-date"] = "%d.%m.%Y",
      ["german-time"] = "%H:%M:%S",
      ["german-datetime"] = "%d.%m.%Y %H:%M:%S",
      ["email"] = "%a, %d %b %Y %H:%M:%S %z"
    },
  },
  int = {
    weekday_mon1_en = {
      [1] = "Monday",
      [2] = "Tuesday",
      [3] = "Wednesday",
      [4] = "Thursday",
      [5] = "Friday",
      [6] = "Saturday",
      [7] = "Sunday"
    },
  },
  weekday_mon1_en = {
    int = {
      ["Monday"] = 1,
      ["Tuesday"] = 2,
      ["Wednesday"] = 3,
      ["Thursday"] = 4,
      ["Friday"] = 5,
      ["Saturday"] = 6,
      ["Sunday"] = 7
    }
  },
  lang = {
    voice = {
      en = "Alex",
      ja = "Kyoko.premium"
    }
  },
  secondary_api_name = {
    api_name = {
      youtube = "google"
    },
    endpoint_prefix = {
      youtube = "youtube/v3"
    },
    default_params = {
      youtube = {
        part = "snippet",
      }
    }
  },
  api_name = {
    host = {
      dropbox = "api.dropboxapi.com/2",
      danbooru = "danbooru.donmai.us",
      openai = "api.openai.com/v1",
      hydrus = "127.0.0.1:45869",
      httpbin = "httpbin.org",
      google = "www.googleapis.com",
    },
    scheme = {
      hydrus = "http://",
    },
    auth_header = {
      hydrus = "Hydrus-Client-API-Access-Key"
    },
    token_where = {
      hydrus = "header",
      danbooru = "param",
      dropbox = "header",
      openai = "header",
      google = "header",
    },
    token_type = {
      google = "oauth2",
      dropbox = "oauth2",
    },
    username_pw_where = {

    },
    auth_process = {
      hydrus = "" -- "" means no auth process. Even though it's using keys for auth, it doesn't use the Bearer indicator
    },
    oauth2_url = {
      dropbox = "api.dropboxapi.com/oauth2/token",
      google = "https://accounts.google.com/o/oauth2/token"
    },
    oauth2_authorization_url = {
      dropbox = "https://www.dropbox.com/oauth2/authorize",
      google = "https://accounts.google.com/o/oauth2/auth"
    },
    needs_scopes = {
      google = true
    },
    scopes = {
      google = "https://www.googleapis.com/auth/youtube"
    },
    empty_post_body = {
      dropbox = "null"
    },
    empty_post_body_raw_type = {
      dropbox = "application/json"
    },
    additional_auth_params = {
      google = {
        access_type = "offline", 
        prompt = "consent"
      }
    },
  },
  extension = {
    likely_field_separator = {
      csv = ",",
      tsv = "\t",
    },
    likely_record_separator = {
      csv = "\n",
      tsv = "\n",
    },
  },
  pandoc_format = {
    extension = {
      pdf = "pdf",
      beamer = "pdf",
      revealjs = "html",
    }
  },
  application_name = {
    history_sql_query = {
      Firefox = "SELECT visit_date/1000000 AS timestamp,title,url " .. 
      "FROM moz_places " ..
      "INNER JOIN moz_historyvisits ON moz_places.id = moz_historyvisits.place_id " ..
      "ORDER BY timestamp DESC;",
      Newpipe = "SELECT access_date/1000 AS timestamp,title,url " .. 
      "FROM stream_history " ..
      "INNER JOIN streams ON stream_history.stream_id = streams.uid " ..
      "ORDER BY timestamp DESC;"
    },
    history_file_path = {
      Firefox = env.MAC_FIREFOX_PLACES_SQULITE,
      Newpipe = env.NEWPIPE_STATE_DIR .. "/history.db"
    },
    backup_type = {
      Firefox = "browser",
      Newpipe = "media"
    },
    backup_condition = {
      Firefox = function()
        return not is.mac_application_name.running("Firefox")
      end,
      Newpipe = function()
        return is.path.extant_path(tblmap.application_name.history_file_path.Newpipe)
      end
    },
    before_backup = {
      Newpipe = dothis.newpipe.extract_backup
    },
  },
  mac_application_name = {
    recent_full_action_path = {
      OmegaT = {"Project", "Open Recent Project"}
    },
    reload_full_action_path = {
      LibreOffice = {"File", "Reload"}
    },
  },
  search_engine = {
    url = {
      wiktionary = "https://en.wiktionary.org/wiki/%s",
      wikipedia = "https://en.wikipedia.org/wiki/%s",
      youtube = "https://www.youtube.com/results?search_query=%s",
      jisho = "https://jisho.org/search/%s",
      glottopedia = "https://glottopedia.org/index.php?search=",
      ["ruby-apidoc"] = "https://apidock.com/ruby/search?query=%s",
      ["python-docs"] = "https://docs.python.org/3/search.html?q=%s",
      ["merriam-webster"] = "https://www.merriam-webster.com/dictionary/%s",
      ["dict-cc"] = "https://www.dict.cc/?s=%s",
      ["deepl-en-ja"] = "https://www.deepl.com/translator#en/ja/%s",
      ["deepl-de-en"] = "https://www.deepl.com/translator#de/en/%s",
      mdn = "https://developer.mozilla.org/en-US/search?q=%s",
      scihub = "https://sci-hub.st/%s",
      libgen = "https://libgen.rs/search.php?req=%s",
      ["semantic-scholar"] = "https://www.semanticscholar.org/search?q=%s",
      ["google-scholar"] = "https://scholar.google.com/scholar?q=%s",
      ["google-images"] = "https://www.google.com/search?tbm=isch&q=%s",
      ["google-maps"] = "https://www.google.com/maps/search/%s",
      google = "https://www.google.com/search?q=%s",
      ["danbooru"] = "https://danbooru.donmai.us/posts?tags=%s",
      ["gelbooru"] = "https://gelbooru.com/index.php?page=post&s=list&tags=%s",
    },
    spaces_percent = {
      jisho = true,
      ["deepl-en-ja"] = true,
      ["deepl-de-en"] = true,
    }
  },
  host = {
    remote_type = {},
    blob_host = {},
    raw_host = {},
  },
  remote_type = {
    blob_indicator = {
      github = "blob/",
      gitlab = "blob/",
      bitbucket = "src/",
    },
    blob_default_host = {
      github = "github.com",
      gitlab = "gitlab.com",
      bitbucket = "bitbucket.org",
    },
    raw_indicator = {
      
      github = "",
      gitlab = "raw/",
      bitbucket = "raw/",
    },
    raw_default_host = {
      github = "raw.githubusercontent.com",
      gitlab = "gitlab.com",
      bitbucket = "bitbucket.org",
    },
  },
  base_letter = {
    base = {
      b = 2,
      o = 8,
      d = 10,
      x = 16,
    }
  },
  dynamic_structure_name = {
    dynamic_structure = {
      latex = {
        citations = "write_file:",
        ["main.tex"] = "write_template:comp.templates.latex_main",
        citable_objects = "create_path:"
      },
      omegat = {
        dictionary = "create_path:",
        glossary = "create_path:",
        omegat = "create_path:",
        source = "create_path:",
        target = "create_path:",
        tm = "create_path:",
        ["data.yaml"] = "write_template:comp.templates.data_yaml"
      }
    }
  },
  project_type = {
    build_command = {
      latex =  "pdflatex main.tex && biber main && pdflatex main.tex && pdflatex main.tex",
      npm = "npm run build",
      cargo = "cargo build",
    },
    install_command = {
      npm = "npm run install",
    },
    project_materials_list = {
      omegat = {
        "tm",
        "glossary"
      }
    }
  },
  action_specifier_word = {
    emoji = {
      open = "🗄",
      remove = "🗑",
      delete = "🗑",
      empty = "🗑🎒",
      content = "🎒",
      vscode = "🔷",
      finder = "👤",
      parent = "👩‍👧",
      choose = "👉",
      downloads = "📥",
      zip = "🤐",
      size = "📏",
      libreoffice = "✳️📄",
      source = "🌀",
      target = "🎯",
      create = "🌄",
      all = "全",
      translation = "🅰️🈴",
      email = "📧",
      string = "💻🔡",
      multiline = "⩶⩶",
      summary = "📚💬",
      playback_backwards = "⏪",
      playback_forwards = "⏩",
      playback_first = "⏪⏪",
      playback_last = "⏩⏩",
      sixty = "6️⃣0️⃣",
      fifteen = "1️⃣5️⃣",
      chapter_backwards = "↖️",
      chapter_forwards = "↗️",
      chapter_first = "↖️↖️",
      chapter_last = "↗️↗️",
      playlist_backwards = "⬅️",
      playlist_forwards = "➡️",
      playlist_first = "⬅️⬅️",
      playlist_last = "➡️➡️",
      cycle_pause = "⏯",
      stop = "⏹",
      cycle_loop_playlist = "🔁",
      cycle_loop_playback = "🔂1️⃣",
      cycle_shuffle = "🔀",
      url = "🔗",
      title = "👒",
      line = "⩶",
      action = "👊",
      array = "📜",
      fill = "✍️",
      wiktionary = "⬜️",
      wikipedia = "🏐",
      youtube = "🟥▶️",
      jisho = "🟩",
      glottopedia = "🟧",
      ["ruby-apidoc"] = "🔴",
      ["python-docs"] = "🐍",
      ["merriam-webster"] = "🆎",
      ["dict-cc"] = "📙",
      ["deepl-en-ja"] = "🟦🇺🇸🇯🇵",
      ["deepl-de-en"] = "🟦🇩🇪🇺🇸",
      deepl = "🟦",
      en = "🇺🇸",
      ja = "🇯🇵",
      de = "🇩🇪",
      mdn = "🦊",
      scihub = "🦅",
      libgen = "⛴",
      ["semantic-scholar"] = "👩‍🔧🎓",
      ["google-scholar"] = "🏳️‍🌈🎓",
      ["google-images"] = "🏳️‍🌈🖼",
      ["google-maps"] = "🏳️‍🌈🗺",
      google = "🏳️‍🌈",
      maps = "🗺",
      image = "🖼",
      scholar = "🎓",
      search = "🔍",
      join = "🤝",
      option = "🔘",
      option_string = "--",
      prefix = "↞",
      suffix = "↠",
      common = "🌏",
      repeated = "🔁",
      browser = "🌐",
      session = "📚",
      add = "📌",
      pass_item_name = "🔑🗃",
      password = "🔑",
      otp = "⌚️🗝",
      path = "📂",
      recovery_key = "↺🗝",
      security_question = "🎭❓",
      username = "👤🔤",
      default = "🔘⚫️",
      ["or"] = "|",
      ["and"] = "&"
    },
    description = {
      open = "op",
      remove = "rm",
      delete = "rm",
      empty = "empt",
      content = "cnt",
      vscode = "vsc",
      finder = "fd",
      parent = "prnt",
      choose = "c",
      downloads = "dl",
      zip = "zip",
      size = "sz",
      libreoffice = "lo",
      source = "src",
      target = "tgt",
      create = "crt",
      all = "all",
      translation = "trans",
      email = "em",
      string = "str",
      multiline = "ml",
      summary = "sum",
      playback = "pb",
      backwards = "bwd",
      forwards = "fwd",
      first = "fst",
      last = "lst",
      sixty = "60",
      fifteen = "15",
      chapter = "ch",
      playlist = "pl",
      cycle = "cyc",
      pause = "ps",
      stop = "stp",
      loop = "lp",
      shuffle = "shuf",
      url = "url",
      title = "ttl",
      line = "ln",
      action = "act",
      array = "arr",
      fill = "fll",
      wiktionary = "wkt",
      wikipedia = "wp",
      youtube = "yt",
      jisho = "ji",
      glottopedia = "gl",
      ["ruby-apidoc"] = "rb",
      ["python-docs"] = "py",
      ["merriam-webster"] = "mw",
      ["dict-cc"] = "dc",
      ["deepl-en-ja"] = "dej",
      ["deepl-de-en"] = "dde",
      ["semantic-scholar"] = "ss",
      ["google-scholar"] = "gs",
      ["google-images"] = "gi",
      ["google-maps"] = "gm",
      google = "go",
      ["danbooru"] = "db",
      ["gelbooru"] = "gb",
      maps = "mp",
      image = "img",
      scholar = "sclr",
      search = "s",
      join = "jn",
      option = "opt",
      option_string = "optstr",
      prefix = "pre",
      suffix = "suf",
      common = "cmn",
      repeated = "rpt",
      browser = "br",
      add = "add",
      pass_item_name = "pitnm",
      password = "pw",
      otp = "otp",
      path = "pth",
      recovery_key = "rky",
      security_question = "secq",
      username = "usrnm",
    }
  },
  stream_attribute = {
    true_emoji = {
      loop = "🔂",
      shuffle = "🔀",
    },
    false_emoji =  {
      video = "🙈",
      pause = "▶️",
    }
  },
  thing_name = {
    chooser_image_partial_retriever_specifier = {

    },
    chooser_text_partial_retriever_specifier = {
      string = {
        thing_name = "summary",
        precedence = -999
      },
      stream_created_item_specifier = {
        thing_name = "summary_line"
      }
    },
    chooser_subtext_partial_retriever_specifier = {
      stream_created_item_specifier = {
        thing_name = "source_path"
      }
    },
    placeholder_text_partial_retriever_specifier = {
      
    },
  },
  state_type = {
    state_transition_table = {
      stream_state = {
        booting = {
          [true] = 'active',
          [false] = 'booting'
        },
        active = {
          [true] = 'active',
          [false] = 'ended'
        },
        ended = {
          [true] = 'ended',
          [false] = 'ended'
        }
      }
    }
  },
  binary_specifier_name = {
    binary_specifier = {
      inf_no = {
        vt = "inf",
        vf = "no"
      }
    }
  },
  stream_creation_specifier_flag_profile_name ={
    stream_creation_specifier_flag_profile = {
      foreground = {
        ["loop-playlist"] = false,
        shuffle = false,
        pause = false,
        ["no-video"] = false,
      },
      background = {
        ["loop-playlist"] = true,
        shuffle = true,
        pause = true,
        ["no-video"] = true,
      }
    }
  }
}

emj = tblmap.action_specifier_word.emoji
dsc = tblmap.action_specifier_word.description

tblmap.thing_name.action_specifier_array = {
  stream_created_item_specifier = {
    {
      e = emj.cycle_pause,
      d = dsc.cycle .. dsc.pause,
      dothis = dothis.stream_created_item_specifier.cycle_pause,
    }, {
      e = emj.stop,
      d = dsc.stop,
      dothis = dothis.stream_created_item_specifier.stop,
    }, {
      e = emj.playlist_first,
      d = dsc.playlist .. dsc.first,
      dothis = dothis.stream_created_item_specifier.set_playlist_first 
    }, {
      e = emj.playback_first,
      d = dsc.playback .. dsc.first,
      dothis = dothis.stream_created_item_specifier.set_playback_first
    }, {
      e = emj.playlist_forwards,
      d = dsc.playlist .. dsc.forwards,
      dothis = dothis.stream_created_item_specifier.playlist_forwards
    }, {
      e = emj.playlist_backwards,
      d = dsc.playlist .. dsc.backwards,
      dothis = dothis.stream_created_item_specifier.playlist_backwards
    }, {
      e = emj.cycle_shuffle,
      d = dsc.cycle .. dsc.shuffle,
      dothis = dothis.stream_created_item_specifier.cycle_shuffle
    }, {
      e = emj.cycle_loop_playlist,
      d = dsc.cycle .. dsc.loop .. dsc.playlist,
      dothis = dothis.stream_created_item_specifier.cycle_loop_playlist
    }, {
      e = emj.cycle_loop_playback,
      d = dsc.cycle .. dsc.loop .. dsc.playback,
      dothis = dothis.stream_created_item_specifier.cycle_loop_playback
    }, {
      e = emj.playback_forwards .. emj.fifteen,
      d = dsc.playback .. dsc.forwards .. dsc.fifteen,
      dothis = dothis.stream_created_item_specifier.set_playback_seconds_relative,
      args = 15
    }, {
      e = emj.playback_backwards .. emj.fifteen,
      d = dsc.playback .. dsc.backwards .. dsc.fifteen,
      dothis = dothis.stream_created_item_specifier.set_playback_seconds_relative,
      args = -15
    }, {
      e = emj.playback_forwards .. emj.sixty,
      d = dsc.playback .. dsc.forwards .. dsc.sixty,
      dothis = dothis.stream_created_item_specifier.set_playback_seconds_relative,
      args = 60
    }, {
      e = emj.playback_backwards .. emj.sixty,
      d = dsc.playback .. dsc.backwards .. dsc.sixty,
      dothis = dothis.stream_created_item_specifier.set_playback_seconds_relative,
      args = -60
    }, {
      e = emj.chapter_forwards,
      d = dsc.chapter .. dsc.forwards,
      dothis = dothis.stream_created_item_specifier.chapter_forwards
    }, {
      e = emj.chapter_backwards,
      d = dsc.chapter .. dsc.backwards,
      dothis = dothis.stream_created_item_specifier.chapter_backwards
    }, {
      e = emj.title,
      d = dsc.title,
      getfn = transf.stream_created_item_specifier.title
    }, {
      e = emj.url,
      d = dsc.url,
      getfn = transf.stream_created_item_specifier.current_url
    }, {
      e = emj.create .. emj.url,
      d = dsc.create .. dsc.url,
      getfn = transf.stream_created_item_specifier.creation_urls
    }
  },
  indexable_array = {
    {
      e = emj.common .. emj.prefix,
      d = dsc.common .. dsc.prefix,
      getfn = transf.indexable_array.longest_common_prefix_indexable
    }, {
      e = emj.common .. emj.suffix,
      d = dsc.common .. dsc.suffix,
      getfn = transf.indexable_array.longest_common_suffix_indexable
    }
  },
  plaintext_file_array = {
    {
      e = emj.content .. emj.line .. emj.array,
      d = dsc.content .. dsc.line .. dsc.array,
      getfn = transf.plaintext_file_array.content_lines_array
    },
  },
  string_array = {
    {
      e = emj.fill,
      d = dsc.fill,
      dothis = dothis.string_array.fill_with
    }, {
      e = emj.repeated .. emj.option_string,
      d = dsc.repeated .. dsc.option_string,
      getfn = transf.string_array.repeated_option_string
    },{
      e = emj.multiline .. emj.string,
      d = dsc.multiline .. dsc.string,
      getfn = transf.string_array.multiline_string
    },
  },
  url_array = {
    {
      e = emj.open .. emj.browser,
      d = dsc.open .. dsc.browser,
      dothis = dothis.url_array.open_all
    }, {
      e = emj.create .. emj.session,
      d = dsc.create .. dsc.session,
      dothis = dothis.url_array.create_as_session_in_msessions
    }, {
      e = emj.add .. emj.url,
      d = dsc.add .. dsc.url,
      dothis = dothis.url_array.create_as_url_files_in_murls
    }
  },
  pass_item_name = {
    {
      e = emj
    }
  },
  otp_pass_item_name = {
    {
      e = emj.otp,
      d = dsc.otp,
      getfn = transf.pass_item_name.otp
    }, {
      e = emj.otp .. emj.path,
      d = dsc.otp .. dsc.path,
      getfn = transf.pass_item_name.otp_absolute_path
    }
  },
  passw_pass_item_name = {
    {
      e = emj.password,
      d = dsc.password,
      getfn = transf.pass_item_name.password
    }, {
      e = emj.password .. emj.path,
      d = dsc.password .. dsc.path,
      getfn = transf.pass_item_name.password_absolute_path
    }
  },
  recovery_pass_item_name = {
    {
      e = emj.recovery_key,
      d = dsc.recovery_key,
      getfn = transf.pass_item_name.recovery_key
    }, {
      e = emj.recovery_key .. emj.path,
      d = dsc.recovery_key .. dsc.path,
      getfn = transf.pass_item_name.recovery_key_absolute_path
    }
  },
  secq_pass_item_name = {
    {
      e = emj.security_question,
      d = dsc.security_question,
      getfn = transf.pass_item_name.security_question
    }, {
      e = emj.security_question .. emj.path,
      d = dsc.security_question .. dsc.path,
      getfn = transf.pass_item_name.security_question_absolute_path
    }
  },
  username_pass_item_name = {
    {
      e = emj.username,
      d = dsc.username,
      getfn = transf.pass_item_name.username
    }, {
      e = emj.username .. emj.path,
      d = dsc.username .. dsc.path,
      getfn = transf.pass_item_name.username_absolute_path
    }
  },
  login_pass_item_name = {
    {
      e = emj.fill .. emj.pass_item_name,
      d = dsc.fill .. dsc.pass_item_name,
      dothis = dothis.login_pass_item_name.fill
    }, {
      e = emj.username .. emj["or"] .. emj.default,
      d = dsc.username .. dsc["or"] .. dsc.default,
      getfn = transf.pass_item_name.username_or_default
    }
  },
}

-- make sure to automatically normalize any input to tblmap

for k, v in transf.native_table.key_value_stateless_iter(tblmap) do
  local thing_to_normalize = k 
  for k2, v2 in transf.native_table.key_value_stateless_iter(v) do
    setmetatable(
      v2,
      {
        __index = function(t, k)
          local key = k
          if normalize[thing_to_normalize] then
            key = normalize[thing_to_normalize][k]
          end
          return rawget(t, key)
        end
      }
    )
  end
end