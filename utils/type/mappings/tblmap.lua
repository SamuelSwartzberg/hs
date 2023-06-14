
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
  
  dt_component = {
    seconds = {
      second = 1,
      minute = 60,
      hour = 60 * 60,
      day = 60 * 60 * 24,
      week = 60 * 60 * 24 * 7,
      month = 60 * 60 * 24 * 30,
      year = 60 * 60 * 24 * 365,
    },
    format_part = {
      second = "%S",
      minute = "%M",
      hour = "%H",
      day = "%d",
      week = "%W",
      month = "%m",
      year = "%Y",
    },
    RFC3339_separator = {
      year = "-",
      month = "-",
      day = "T",
      hour = ":",
      minute = ":",
      second = "Z",
    },
    rfc3339 = {
      year = "%Y",
      month = "%Y-%m",
      day = "%Y-%m-%d",
      hour = "%Y-%m-%dT%H",
      minute = "%Y-%m-%dT%H:%M",
      second = "%Y-%m-%dT%H:%M:%SZ",
    },
    max = {
      second = 60,
      minute = 60,
      hour = 24,
      day = 30,
      month = 12,
    },
    min = {
      second = 0,
      minute = 0,
      hour = 0,
      day = 1,
      month = 1,
    },
    few_char_name = {
      second = "sec",
      minute = "min",
      hour = "hour",
      day = "day",
      month = "month",
      year = "year",
    },
    index = {
      year = 1,
      month = 2,
      day = 3,
      hour = 4,
      minute = 5,
      second = 6,
    }

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
    date_component = {
      [1] = "year",
      [2] = "month",
      [3] = "day",
      [4] = "hour",
      [5] = "minute",
      [6] = "second",
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
        return is.path.exists(tblmap.application_name.history_file_path.Newpipe)
      end
    },
    before_backup = {
      Newpipe = dothis.newpipe.extract_backup
    }
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
      ["danbooru"] = "https://danbooru.donmai.us/posts?tags=%s",
      ["gelbooru"] = "https://gelbooru.com/index.php?page=post&s=list&tags=%s",
    },
    short = {
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
      ["danbooru"] = "db",
      ["gelbooru"] = "gb",
    },
    i = {
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
      mdn = "🦊",
      scihub = "🦅",
      libgen = "⛴",
      ["semantic-scholar"] = "👩‍🔧🎓",
      ["google-scholar"] = "🏳️‍🌈🎓",
      ["google-images"] = "🏳️‍🌈🖼",
      ["google-maps"] = "🏳️‍🌈🗺",
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
  }
}

-- make sure to automatically normalize any input to tblmap

for k, v in pairs(tblmap) do
  local thing_to_normalize = k 
  for k2, v2 in pairs(v) do
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