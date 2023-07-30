to = {
  url = {
    decoded = {
      {
        mode = "replace",
        cond = {_r = "%%%x%x", _regex_engine = "eutf8"},
        proc = transf.percent_encoded_octet.char
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


