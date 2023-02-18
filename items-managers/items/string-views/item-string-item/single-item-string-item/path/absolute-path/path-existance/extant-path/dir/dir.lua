--- @type ItemSpecifier
DirItemSpecifier = {
  type = "dir",
  properties = {

    getables = {
      ["is-parent-dir"] = function(self)
        return not dirIsEmpty(self:get("contents"))
      end, 
      ["is-empty-dir"] = function(self)
        return dirIsEmpty(self:get("contents"))
      end,
      ["is-dir-by-path"] = function()
        return true
      end,
      ["is-logging-dir"] = function(self)
        return stringy.endswith(self:get("contents"), "_logs")
      end,

      ["path-content-item"] = function(self)
        return self.root_super
      end,
      
      -- the following methods can be implemented here, even though we don't know yet if we have descendants or only children, since we implement self:get("descendant-string-array") polymorphically, and as such getting 'descendants' actually gets children if there are no descendants

      ["descendant-string-item-array"] = function(self) 
        return self:get("descendant-string-array"):get("to-string-item-array") 
      end,
      ["descendant-file-only-string-item-array"] = function(self)
        return self:get("descendant-string-item-array"):get("filter-to-array-of-files")
      end,
      ["descendant-dir-only-string-item-array"] = function(self)
        return self:get("descendant-string-item-array"):get("filter-to-array-of-dirs")
      end,
      ["descendants-any-pass"] = function(self, query) return self:get("descendant-string-item-array"):get("some-pass", query) end,
      ["descendants-to-line-array"] = function(self) 
        return self:get("descendant-file-only-string-item-array")
          :get("map-to-line-array-of-file-contents-with-no-empty-strings")
      end,
      ["descendant-filename-only-array"] = function(self)
        return self:get("descendant-string-array"):get("map-to-new-array", function(item)
          return getLeafWithoutPathOrExtension(item)
        end)
      end,
      ["descendant-filename-only-string-item-array"] = function(self)
        return self:get("descendant-filename-only-array"):get("to-string-item-array")
      end,
      ["find-descendant"] = function(self, func)
        return valueFind(self:get("descendants-string-array"), func)
      end,
      ["descendant-ending-with"] = function(self, ending)
        return self:get("find-descendant", function(item)
          return stringy.endswith(item, ending)
        end)
      end,
      ["descendant-ending-with-to-string-item"] = function(self, ending)
        return CreateStringItem(self:get("descendant-ending-with", ending))
      end,

      ["find-or-create-child-dir"] = function(self, specifier)
        local child = self:get("find-child", specifier.find_func)
        if child == nil or not isDir(child) then
          self:doThis("create-empty-dir-in-dir", specifier.default_name)
          child = self:get("parent-dir-path") .. "/" .. specifier.default_name
        end
        return child
      end,
      ["find-or-create-logging-date-managed-child-dir"] = function(self, specifier)
        return self:get("find-or-create-child-dir", {
          find_func = function(item)
            return specifier.find_identifier_suffix .. stringy.endswith(item, "_logs")
          end,
          default_name = 
            "1970-01-01--" ..
            ( 
              specifier.readable_name_part and 
                specifier.readable_name_part .. "_" or 
                ""
            ) 
            .. specifier.find_identifier_suffix .. "_logs"
        })
      end,

      -- alias methods for polymorphism with files:

      ["dir-or-file-any-pass"] = function(self, query) return self:get("descendants-any-pass", query) end,
      ["cd-and-task"] = function(self)
        return {
          "cd",
          { value = self:get("path-ensure-final-slash"), type = "quoted" },
          "&&",
        }
      end,
      ["related-path-gui"] = function(self)
        return CreateStringItem(promptSingleDir(self:get("contents")))
      end,
      ["related-path-with-subdirs-gui"] = function(self)
        return CreateStringItem(chooseDirAndPotentiallyCreateSubdirs(self:get("contents") .. "/"))
      end,
      ["ls"] = function (self)
        return getOutputArgsSimple("ls", "-F", "-1", { value = self:get("contents"), type = "quoted" })
      end,
      ["tree"] = function(self)
        return getOutputArgsSimple("tree", "--noreport", "-F", { value = self:get("contents"), type = "quoted" })
      end,
    },
  
    doThisables = {
      ["copy-into"] = function(self, source)
        srctgt("copy", source, self:get("contents"))
      end,
      ["move-into"] = function(self, source)
        srctgt("move", source, self:get("contents"), "any", true, true)
      end,
      ["create-empty-file-in-dir"] = function(self, name)
        local path = self:get("path-ensure-final-slash") .. name
        writeFile(path, "", "not-exists")
      end,
      ["create-empty-dir-in-dir"] = function(self, name)
        local path = self:get("path-ensure-final-slash") .. name
        createDir(path)
      end,
      ["create-child-as-project-dir"] = function(self, specifier)
        self:doThis("create-empty-dir-in-dir", specifier.name)
        CreateStringItem(self:get("contents") .. "/" .. specifier.name):doThis("initalize-as-project-dir", specifier.type)
      end,
      ["create-file-with-contents"] = function(self, specifier)
        local path = self:get("path-ensure-final-slash") .. specifier.name
        writeFile(path, specifier.contents)
      end,
      ["table-to-fs-children-dispatch"] = function(self, specifier) 
        -- assumes a table where all values are of the same type
        local child_filenames = self:get("child-leaf-only-array")
        for k, v in pairs(specifier.payload) do
          local desired_name = k

          -- allow for regex names 
          if stringy.startswith(k, "match:") then
            local search_string = eutf8.sub(k, 7)
            local match = child_filenames:get("find", function(item)
              return eutf8.match(item, search_string)
            end)
            if match then
              desired_name = match
            else 
              desired_name = search_string
            end
          end

          local child = CreateStringItem(self:get("path-ensure-final-slash") .. desired_name)

          specifier.payload = v

          child:doThis("table-to-fs", specifier)

        end
      end,

      ["git-init"] = function(self)
        self:doThis("cd-and-run-this-task", { "git", "init" })
      end,
      ["initialize-as-git-dir"] = function(self)
        self:doThis("git-init")
        self:doThis("create-empty-file-in-dir", ".gitignore")
      end,
      ["rm-dir"] = function(self)
        hs.fs.rmdir(self:get("contents"))
      end,
      ["empty-dir"] = function(self)
        delete(self:get("contents"), "dir", "empty")
      end,
      ["choose-descendant"] = function(self)
        self:get("descendant-string-array"):doThis("choose-item-and-then-action")
      end,
      ["choose-descendant-file"]  = function(self)
        self:get("descendant-file-only-string-item-array"):doThis("choose-item-and-then-action")
      end,
      ["choose-descendant-dir"]  = function(self)
        self:get("descendant-dir-only-string-item-array"):doThis("choose-item-and-then-action")
      end,
      ["choose-descendant-string-item-dir"]  = function(self)
        self:get("descendant-dir-only-string-item-array"):doThis("choose-item-and-then-action")
      end,
      ["send-in-email"] = function(self, do_after)
        local temp_file = createUniqueTempFile("", "email.zip")
        zipFile(self:get("contents"), temp_file, function()
          delete(temp_file)
          if do_after then
            do_after()
          end
        end)
      end,
      ["create-child-file-and-choose-action"] = function(self, filename)
        local path = self:get("contents") .. "/" .. filename
        writeFile(path, "", "not-exists")
        CreateStringItem(path):doThis("choose-action")
      end,
      ["create-child-dir-and-choose-action"] = function(self, dirname)
        local path = self:get("contents") .. "/" .. dirname
        createDir(path)
        CreateStringItem(path):doThis("choose-action")
      end,
      ["create-descendant-file-and-choose-action"] = function(self, filename)
        self:get("descendant-dir-only-string-item-array"):doThis("choose-item", function(dir)
          dir:doThis("create-child-file-and-choose-action", filename)
        end)
      end,
      ["choose-action-on-descendant-line-array"] = function(self)
        self:get("descendants-to-line-array"):get("to-string-item-array"):doThis("choose-action")
      end,


    }
  },
  potential_interfaces = ovtable.init({
    { key = "parent-dir", value = CreateParentDirItem },
    { key = "empty-dir", value = CreateEmptyDirItem },
    { key = "dir-by-path", value = CreateDirByPathItem },
    { key = "logging-dir", value = CreateLoggingDir },
  }),
  action_table = listConcat(getChooseItemTable({
    {
      description = "ls",
      emoji_icon = "🗂️",
      key = "ls",
    },
    {
      description = "tree",
      emoji_icon = "🌲",
      key = "tree",
    },
  }),{
    {
      text = "👉🌄🔽📁 ccrchlddir.",
      key = "do-interactive",
      args = {thing = "dir name", key = "create-child-dir-and-choose-action"}
    },
    {
      text = "👉🌄🔽📄 ccrchldfl.",
      key = "do-interactive",
      args = {thing = "file name", key = "create-child-file-and-choose-action"}
    },{
      text = "👉🌄⏬📄 ccrcdescfl.",
      key = "do-interactive",
      args = {thing = "file name", key = "create-descendant-file-and-choose-action"}
    },{
      text = "🗑 rmdir.",
      key = "rm-dir",
    },{
      text = "🗑🎒 empdir.",
      key = "empty-dir",
    },
    {
      text = "👉⏬ cdesc.",
      key = "choose-descendant"
    },{
      text = "👉⏬📁 cdescdir.",
      key = "choose-descendant-dir"
    },{
      text = "👉⏬📄 cdescfl.",
      key = "choose-descendant-file"
    },{
      text = "🌄🔽🏗 crchldproj.",
      key = "do-interactive",
      args = { 
        key = "create-child-as-project-dir",
        thing = { 
          type = "project type (npm, omegat)",
          name = "project name"
        } 
      }
    },{
      text = "👉⏬📄🎒⩶　cdescflcntln.",
      key = "choose-action-on-descendant-line-array"
    }
  })
}


--- @type BoundNewDynamicContentsComponentInterface
CreateDirItem = bindArg(NewDynamicContentsComponentInterface, DirItemSpecifier)