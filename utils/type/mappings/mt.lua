mt = {
  _contains = {
    lua_metacharacters = {"%", "^", "$", "(", ")", ".", "[", "]", "*", "+", "-", "?"},
    regex_metacharacters =  {"\\", "^", "$", ".", "[", "]", "*", "+", "?", "(", ")", "{", "}", "|", "-"},
    small_words = {
      "a", "an", "and", "as", "at", "but", "by", "en", "for", "if", "in", "of", "on", "or", "the", "to", "v", "v.", "via", "vs", "vs."
    }
  },
  _list = {
    tree_node_keys = {"pos", "children", "parent", "text", "tag", "attrs", "cdata"},
    nokey_endpoints = {"channels"},
    apis_that_dont_support_authorization_code_fetch = {"google"},
    useless_files = {".git", "node_modules", ".vscode"},
    html_entity_indicator = {
      encoded = {"&", ";"},
      decoded = {"\"", "'", "<", ">", "&"}
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
    }
  },
  _r_lua = {
    without_extension_and_extension = "(.+)%.([^%.]+)"
  }
}
