
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
    symbol = {
      cmd = "⌘",
      alt = "⌥",
      shift = "⇧",
      ctrl = "⌃",
      fn = "fn",
    }
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
      httpbin = "httpbin.org"
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
    empty_post_body_content_type = {
      dropbox = "application/json"
    },
  },
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