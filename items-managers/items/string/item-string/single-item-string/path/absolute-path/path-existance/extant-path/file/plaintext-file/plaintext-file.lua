

--- @type ItemSpecifier
PlaintextFileItemSpecifier = {
  type = "plaintext-file",
  properties = {
    getables = {
      --- polymorphically defined here and on dir to allow choosing on file immediately if plaintext file, and on the  dir otherwise
      ["path-content-item"] = function(self)
        return self:get("str-item", "file-contents")
      end,
      ["to-line-array"] = function(self) 
        return ar(stringx.splitlines(self:get("file-contents")))
      end,
      ["descendants-to-line-array"] = function(self) return self:get("to-line-array") end, -- polymorphic implementation
      ["is-m3u-file"] = function(self)
        return stringy.endswith(self:get("resolved-path"), "m3u")
      end,
      ["is-plaintext-table-file"] = function(self)
        return is.path.usable_as_filetype(self:get("c"), "plaintext-table")
      end,
      ["is-plaintext-dictionary-file"] = function(self)
        return is.path.usable_as_filetype(self:get("c"), "plaintext-dictionary")
      end,
      ["is-plaintext-tree-file"] = function(self)
        return is.path.usable_as_filetype(self:get("c"), "plaintext-tree")
      end,
      ["is-executable-code-file"] = returnTrue, -- determining whether a file is executable code is difficult, as there are so many programming languages and extensions, so I'm just gonna assert it's true and not implement any polymorphic behavior in executable-code-file
      ["is-gitignore-file"] = function(self)
        return stringy.endswith(self:get("resolved-path"), ".gitignore")
      end,
      ["is-log-file"] = function(self)
        return stringy.endswith(self:get("resolved-path"), ".log")
      end,
      ["is-email-file"] = function(self)
        local parent_dir_name = self:get("parent-dir-name")
        return 
          stringy.endswith(self:get("resolved-path"), ".eml") or 
          parent_dir_name == "new" or
          parent_dir_name == "cur"
      end,
      ["is-newsboat-urls-file"] = function(self)
        return stringy.endswith(self:get("resolved-path"), "/urls")
      end,
      ["is-md-file"] = function(self)
        return pathSlice(self:get("resolved-path"), "-1:-1", { ext_sep = true, standartize_ext = true })[1] == "md"
      end,
    },
    doThisables = {
      ["append-line-and-commit"] = function(self, line)
        dothis.plaintext_file.append_line(self:get("c"), line)
        self:doThis("git-commit-self", ("Added line: %s to %s"):format(line, self:get("relative-path-from", self:get("git-root-dir"))))
        self:doThis("git-push")
      end,
      ["choose-item-remove-and-choose-action"] = function(self, splitter)
        local parts = stringx.split(self:get("file-contents"), splitter)
        ar(parts):doThis("choose-item", function(part)
          parts = filter(parts, {
            _exactly = part,
            _invert = true,
          })
          self:doThis("overwrite-file-content", stringx.join(splitter, parts))
          st(part):doThis("choose-action")
        end)
      end,


    }
  },
  potential_interfaces = ovtable.init({
    { key = "m3u-file", value = CreateM3uFileItem },
    { key = "plaintext-table-file", value = CreatePlaintextTableFileItem },
    { key = "plaintext-dictionary-file", value = CreatePlaintextDictionaryFileItem },
    { key = "plaintext-tree-file", value = CreatePlaintextTreeFileItem },
    { key = "executable-code-file", value = CreateExecutableCodeFileItem },
    { key = "gitignore-file", value = CreateGitignoreFileItem },
    { key = "log-file", value = CreateLogFileItem },
    { key = "email-file", value = CreateEmailFileItem },
    { key = "newsboat-urls-file", value = CreateNewsboatUrlsFileItem },
    { key = "md-file", value = CreateMdFileItem },
    
  }),
  action_table = concat(getChooseItemTable({
    { 
      d = "cnt",
      i = "🎒",
      key = "file-contents"
    },{
      d = "cntchln",
      i = "🎒🀇📏",
      key = "file-contents-utf8-chars"
    },{
      d = "cntbln",
      i = "🎒8️⃣📏",
      key = "file-contents-bytes"
    },{
      d = "cnthd",
      i = "🎒👆",
      key = "file-contents-head"
    },{
      d = "cnttl",
      i = "🎒👇",
      key = "file-contents-tail"
    }
  }), {
    {
      text = "👉🎒全⩶　ccntlns.",
      key = "choose-action-on-result-of-get",
      args = "to-line-array"
    },
    {
      text = "👉🎒⩶　ccntln.",
      key = "choose-item-and-then-action-on-result-of-get",
      args = "to-line-array"
    },
    {
      text = "👉✂️🎒⩶　ccutcntln.",
      key = "choose-item-remove-and-choose-action",
      args = "\n"
    },{
      text = "🫳⩶ appdln.",
      key = "do-interactive",
      args = { thing = "line", key = "append-line"}
    }
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePlaintextFileItem = bindArg(NewDynamicContentsComponentInterface, PlaintextFileItemSpecifier)