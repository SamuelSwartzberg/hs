

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
  mouse_button_string = {
    mouse_button_function_name = {
      l = "leftClick",
      r = "rightClick",
      m = "middleClick"
    }
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
  mod_name = {
    mod_symbol = {
      cmd = "⌘",
      alt = "⌥",
      shift = "⇧",
      ctrl = "⌃",
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
  rfc3339like_dt_format_part = {
    date_component_name = {
      ["%Y"] = "year",
      ["%m"] = "month",
      ["%d"] = "day",
      ["%H"] = "hour",
      ["%M"] = "min",
      ["%S"] = "sec",
    },
  },
  date_component_name_long = {
    date_component_name = {
      year = "year",
      month = "month",
      day = "day",
      hour = "hour",
      minute = "min",
      second = "sec",
    },
  },
  seconds = {
    date_component_name = {
      sec = 1,
      min = 60,
      hour = 60 * 60,
      day = 60 * 60 * 24,
      week = 60 * 60 * 24 * 7,
      month = 60 * 60 * 24 * 30,
      year = 60 * 60 * 24 * 365,
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
      ["email"] = "%a, %d %b %Y %H:%M:%S %z",
      ["detailed"] = "%A, %Y-%m-%d %H:%M:%S"
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
    normalized_extension =  {
      jpeg = "jpg",
      jpg = "jpg",
      htm = "html",
      html = "html",
      yml = "yaml",
      yaml = "yaml",
      markdown = "md",
      md = "md",
    },
  },
  pandoc_format = {
    extension = {
      pdf = "pdf",
      beamer = "pdf",
      revealjs = "html",
    }
  },
  sql_history_using_application_name = {
    backup_condition = {
      Firefox = function()
        return not is.mac_application_name.running("Firefox")
      end,
      Newpipe = function()
        return is.path.extant_path(tblmap.sql_history_using_application_name.history_file_path.Newpipe)
      end
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
      ["ruby_apidoc"] = "https://apidock.com/ruby/search?query=%s",
      ["python_docs"] = "https://docs.python.org/3/search.html?q=%s",
      ["merriam_webster"] = "https://www.merriam-webster.com/dictionary/%s",
      ["dict_cc"] = "https://www.dict.cc/?s=%s",
      ["deepl_en_ja"] = "https://www.deepl.com/translator#en/ja/%s",
      ["deepl_de_en"] = "https://www.deepl.com/translator#de/en/%s",
      mdn = "https://developer.mozilla.org/en-US/search?q=%s",
      scihub = "https://sci-hub.st/%s",
      libgen = "https://libgen.rs/search.php?req=%s",
      ["semantic_scholar"] = "https://www.semanticscholar.org/search?q=%s",
      ["google_scholar"] = "https://scholar.google.com/scholar?q=%s",
      ["google_images"] = "https://www.google.com/search?tbm=isch&q=%s",
      ["google_maps"] = "https://www.google.com/maps/search/%s",
      google = "https://www.google.com/search?q=%s",
      ["danbooru"] = "https://danbooru.donmai.us/posts?tags=%s",
      ["gelbooru"] = "https://gelbooru.com/index.php?page=post&s=list&tags=%s",
    },
    param_is_path = {
      wikipedia = true,
      wiktionary = true,
      jisho = true,
      ["merriam_webster"] = true,
      ["deepl_en_ja"] = true,
      ["deepl_de_en"] = true,
      scihub = true,
      ["google_maps"] = true,
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
        citations = "write_file",
        ["main.tex"] = {"write_template","comp.templates.latex_main"},
        citable_objects = "create_dir"
      },
      omegat = {
        dictionary = "create_dir",
        glossary = "create_dir",
        omegat = "create_dir",
        source = "create_dir",
        target = "create_dir",
        tm = "create_dir",
        ["data.yaml"] = {"write_template","comp.templates.data_yaml"},
        ["omegat.project"] = {"write_template", "comp.templates.omegat"}
      },
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
      local_image_file = {
        thing_name = "hs_image",
        precedence = 999
      },
      image_url = {
        thing_name = "hs_image",
        precedence = 999
      },
      image_data_url = {
        thing_name = "hs_image",
        precedence = 999
      },
    },
    chooser_text_partial_retriever_specifier = {
      string = {
        thing_name = "singleline_string_by_folded",
        precedence = -999
      },
      audiodevice_specifier = {
        thing_name = "name",
        precedence = 999
      },
      stream_created_item_specifier = {
        thing_name = "summary_line"
      },
      csl_table = {
        thing_name = "apa_string",
        precedence = 999
      },
      menu_item_table = {
        thing_name = "summary",
        precedence = 999
      },
      syn_specifier = {
        thing_name = "summary",
        precedence = 999
      },
      array = {
        thing_name = "summary",
        precedence = 1
      },
      pair = {
        thing_name = "dict_entry_string",
        precedence = 999
      },
      date = {
        thing_name = "summary",
        precedence = 999
      },
      contact_table = {
        thing_name = "summary",
        precedence = 999
      }
    },
    chooser_subtext_partial_retriever_specifier = {
      stream_created_item_specifier = {
        thing_name = "source_path"
      }
    },
    placeholder_text_partial_retriever_specifier = {
      
    },
    initial_selected_index_partial_retriever_specifier = {
      audiodevice_specifier_array = {
        thing_name = "active_audiodevice_specifier_index",
        precedence = 999
      }
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