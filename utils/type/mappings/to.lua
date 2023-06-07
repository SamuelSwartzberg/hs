to = {
  case = {
    snake = {
      {
        cond = {
          _r = "[^%w%d]+",
          _regex_engine = "eutf8",
          _ignore_case = true,
        },
        mode = "replace",
        proc = "_"
      }, {
        cond = {
          _start = "_"
        },
        mode = "remove"
      }, {
        cond = {
          _stop = "_"
        },
        mode = "remove"
      }, {
        cond = {
          _r = "_{2,}",
        },
        mode = "replace",
        proc = "_"
      }
    },
    kebap = {{
      cond = {
        _r = "[^%w%d]+",
        _regex_engine = "eutf8",
        _ignore_case = true,
      },
      mode = "replace",
      proc = "-"}, {
        cond = {
          _start = "-"
        },
        mode = "remove"
      }, {
        cond = {
          _stop = "-"
        },
        mode = "remove"
      }, {
        cond = {
          _r = "-{2,}",
        },
        mode = "replace",
        proc = "-"
      }
    },
    capitalized = {
      mode = "replace",
      cond = {_r = "."},
      limit = 1,
      proc = eutf8.upper
    },
    notcapitalized = {
      mode = "replace",
      cond = {_r = "."},
      limit = 1,
      proc = eutf8.lower
    },
  },
  url = {
    decoded = {
      {
        mode = "replace",
        cond = {_r = "%%%x%x", _regex_engine = "eutf8"},
        proc = transf.percent.char
      },
      {
        mode = "replace",
        cond = "+",
        proc = " "
      }
    }
  },
  regex = {
    lua_escaped = {mt._contains.lua_metacharacters, {"%"}},
    general_escaped = {mt._contains.regex_metacharacters, {"\\"}},
  },
  resolved = {
    doi = {cond = {_r = mt._r.id.doi_prefix }, proc = "https://doi.org/", mode = "replace" }
  },
  string = {
    escaped_single_quote_safe = {
      {
        cond = {
          _r = "'",
          _regex_engine = "eutf8"
        },
        proc = "\\'",
        mode = "replace"
      }
    },
    escaped_double_quote_safe = {
      {
        cond = {
          _r = '"',
          _regex_engine = "eutf8"
        },
        proc = '\\"',
        mode = "replace"
      }
    },
    escaped_csv_field_contents = {
      {
        cond = {_r = '"', _regex_engine = "eutf8"},
        proc = "\n",
        mode = "replace"
      }, {
        cond = {_r = '""', _regex_engine = "eutf8"},
        proc = '\\n',
        mode = "replace"
      }
    }
  }
}


