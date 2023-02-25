

--- @type ItemSpecifier
PlaintextFileItemSpecifier = {
  type = "plaintext-file",
  properties = {
    getables = {
      --- polymorphically defined here and on dir to allow choosing on file immediately if plaintext file, and on the  dir otherwise
      ["path-content-item"] = function(self)
        return self:get("str-item", "file-contents")
      end,
      ["lines-of-file-contents"] = function(self)
        return stringy.split(self:get("file-contents"), "\n")
      end,
      ["file-contents-tail"] = function(self, n)
        n = n or 10
        local lines = self:get("lines-of-file-contents")
        return table.concat(lines, "\n", #lines - n + 1, #lines)
      end,
      ["file-contents-head"] = function(self, n)
        n = n or 10
        local lines = self:get("lines-of-file-contents")
        return table.concat(lines, "\n", 1, n)
      end,
      ["first-line-of-file-contents"] = function(self)
        return self:get("lines-of-file-contents")[1]
      end,
      ["last-line-of-file-contents"] = function(self)
        local lines = self:get("lines-of-file-contents")
        return lines[#lines]
      end,
      ["nth-line-of-file-contents"] = function(self, n)
        return self:get("lines-of-file-contents")[n]
      end,
      ["range-lines-of-file-contents"] = function(self, specifier)
        return slice(self:get("lines-of-file-contents"), specifier)
      end,
      ["range-chars-of-file-contents"] = function(self, specifier)
        return slice(self:get("file-contents"), specifier)
      end,
      ["file-contents-to-string"] = function(self) return self:get("file-contents") end,
      ["file-contents-to-tsv-dict"] = function(self)
        return self:get("str-item", "file-contents"):get("to-array-of-string-arrays", { upper = "\n", lower = "\t" })
      end,
      ["to-line-array"] = function(self) 
        return CreateArray(stringx.splitlines(self:get("file-contents")))
      end,
      ["descendants-to-line-array"] = function(self) return self:get("to-line-array") end, -- polymorphic implementation
      ["is-m3u-file"] = function(self)
        return stringy.endswith(self:get("contents"), "m3u")
      end,
      ["is-plaintext-table-file"] = function(self)
        return isUsableAsFiletype(self:get("contents"), "plaintext-table")
      end,
      ["is-plaintext-dictionary-file"] = function(self)
        return isUsableAsFiletype(self:get("contents"), "plaintext-dictionary")
      end,
      ["is-plaintext-tree-file"] = function(self)
        return isUsableAsFiletype(self:get("contents"), "plaintext-tree")
      end,
      ["is-executable-code-file"] = returnTrue, -- determining whether a file is executable code is difficult, as there are so many programming languages and extensions, so I'm just gonna assert it's true and not implement any polymorphic behavior in executable-code-file
      ["is-gitignore-file"] = function(self)
        return stringy.endswith(self:get("contents"), ".gitignore")
      end,
      ["is-log-file"] = function(self)
        return stringy.endswith(self:get("contents"), ".log")
      end,
      ["is-email-file"] = function(self)
        local parent_dir_name = getParentDirname(self:get("contents"))
        return 
          stringy.endswith(self:get("contents"), ".eml") or 
          parent_dir_name == "new" or
          parent_dir_name == "cur"
      end,
      ["is-newsboat-urls-file"] = function(self)
        return stringy.endswith(self:get("contents"), "/urls")
      end,
      ["is-md-file"] = function(self)
        return getStandartizedExtension(self:get("contents")) == "md"
      end,
      ["file-contents-utf8-chars"] = function(self)
        return eutf8.len(self:get("file-contents"))
      end,
      ["file-contents-bytes"] = function(self)
        return string.len(self:get("file-contents"))
      end,
    },
    doThisables = {
      ["append-lines"] = function(self, lines)
        if self:get("range-chars-of-file-contents", { start = -1, stop = -1 }) ~= "\n" then
          self:get("append-file-contents", "\n")
        end
        self:doThis("append-file-contents", stringx.join("\n", lines) .. "\n")
      end,
      ["set-lines"] = function(self, lines)
        self:doThis("overwrite-file-content", stringx.join("\n", lines) .. "\n")
      end,
      ["append-line"] = function(self, line)
        self:doThis("append-lines", { line })
      end,
      ["set-line"] = function(self, line)
        self:doThis("set-lines", { line })
      end,
      ["append-line-and-commit"] = function(self, line)
        self:doThis("append-line", line)
        self:doThis("git-commit-self", ("Added line: %s to %s"):format(line, self:get("relative-path-from", self:get("git-root-dir"))))
        self:doThis("git-push")
      end,
      ["set-line-and-commit"] = function(self, line)
        self:doThis("set-line", line)
        self:doThis("git-commit-self", ("Set line: %s to %s"):format(line, self:get("relative-path-from", self:get("git-root-dir"))))
        self:doThis("git-push")
      end,
      ["choose-item-remove-and-choose-action"] = function(self, splitter)
        local parts = stringx.split(self:get("file-contents"), splitter)
        CreateArray(parts):doThis("choose-item", function(part)
          parts = listFilter(parts, function(p) return p ~= part end)
          self:doThis("overwrite-file-content", stringx.join(splitter, parts))
          CreateStringItem(part):doThis("choose-action")
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
  action_table = listConcat(getChooseItemTable({
    { 
      description = "cnt",
      emoji_icon = "🎒",
      key = "file-contents"
    },{
      description = "cntchln",
      emoji_icon = "🎒🀇📏",
      key = "file-contents-utf8-chars"
    },{
      description = "cntbln",
      emoji_icon = "🎒8️⃣📏",
      key = "file-contents-bytes"
    },{
      description = "cnthd",
      emoji_icon = "🎒👆",
      key = "file-contents-head"
    },{
      description = "cnttl",
      emoji_icon = "🎒👇",
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