to = {
  case = {
    snake = {
      cond = {
        _r = "[^%w%d]",
        _regex_engine = "eutf8",
        _ignore_case = true,
      },
      mode = "replace",
      proc = "_"
    },
    kebap = {
      cond = {
        _r = "[^%w%d]",
        _regex_engine = "eutf8",
        _ignore_case = true,
      },
      mode = "replace",
      proc = "-"
    },
    capitalized = {
      mode = "replace",
      cond = {_r = "^."},
      proc = eutf8.upper
    },
    notcapitalized = {
      mode = "replace",
      cond = {_r = "^."},
      proc = eutf8.lower
    },
  },
  url = {
    decoded = {
      {
        mode = "replace",
        cond = {_r = "%%(%x%x)", _regex_engine = "eutf8"},
        proc = transf.char.hex
      },
      {
        mode = "replace",
        cond = " ",
        proc = "+"
      }
    }
  },
  regex = {
    lua_escaped = {{mt._contains.lua_metacharacters}, {"%"}},
    general_escaped = {
      map(mt._contains.regex_metacharacters, function(v) return {v, "\\" .. v} end),
      {processor = tblmap.whitespace.escaped, mode = "replace" }
    }
  },
  resolved = {
    doi = {cond = {_r = mt._r.id.doi_prefix }, processor = "https://doi.org/", mode = "replace" }
  }
}


