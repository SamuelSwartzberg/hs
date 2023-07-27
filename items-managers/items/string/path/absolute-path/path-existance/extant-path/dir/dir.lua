--- @type ItemSpecifier
DirItemSpecifier = {
  type = "dir",
  properties = {

    getables = {
      ["is-logging-dir"] = function(self)
        return stringy.endswith(self:get("resolved-path"), "_logs")
      end,
      ["descendants-any-pass"] = function(self, query) return self:get("descendant-string-item-array"):get("some-pass", query) end,
      ["descendants-to-line-array"] = function(self) 
        return self:get("descendant-file-only-string-item-array")
          :get("map-to-line-array-of-file-contents-with-no-empty-strings")
      end,
      ["descendant-ending-with-to-string-item"] = function(self, ending)
        return st(self:get("descendant-ending-with", ending))
      end,

      ["find-or-create-child-dir"] = function(self, specifier)
        local child = get.dir.find_child(self:get("c"), specifier.find_func)
        if child == nil or not is.absolute_path.dir(child) then
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
      ["ls"] = function (self)
        return run({"ls", "-F", "-1", { value = self:get("completely-resolved-path"), type = "quoted" }})
      end,
      ["tree"] = function(self)
        return run({"tree", "--noreport", "-F", { value = self:get("completely-resolved-path"), type = "quoted" }})
      end,
    },
  
    doThisables = {
      ["create-empty-file-in-dir"] = function(self, name)
        local path = self:get("path-ensure-final-slash") .. name
        dothis.absolute_path.write_file_if_nonextant_path(path, "")
      end,
      ["create-empty-dir-in-dir"] = function(self, name)
        local path = self:get("path-ensure-final-slash") .. name
        dothis.absolute_path.create_dir(path)
      end,
      ["create-child-as-project-dir"] = function(self, specifier)
        self:doThis("create-empty-dir-in-dir", specifier.name)
        st(self:get("completely-resolved-path") .. "/" .. specifier.name):doThis("initalize-as-project-dir", specifier.type)
      end,
      ["create-file-with-contents"] = function(self, specifier)
        local path = self:get("path-ensure-final-slash") .. specifier.name
        dothis.absolute_path.write_file(path, specifier.contents)
      end,
      ["table-to-fs-children-dispatch"] = function(self, specifier) 
        -- assumes a table where all values are of the same type
        local child_filenames = transf.dir.children_leaves_array(self:get("c"))
        for k, v in transf.table.key_value_iter(specifier.payload) do
          local desired_name = k

          -- allow for regex names 
          if stringy.startswith(k, "match:") then
            local search_string = eutf8.sub(k, 7)
            local match = find(child_filenames, function(item)
              return eutf8.match(item, search_string)
            end)
            if match then
              desired_name = match
            else 
              desired_name = search_string
            end
          end

          local child = st(self:get("path-ensure-final-slash") .. desired_name)

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
        dothis.absolute_path.delete(self:get("c")))
      end,
      ["empty-dir"] = function(self)
        dothis.absolute_path.empty_dir(self:get("c"))
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
        local temp_file = dothis.absolute_path.write_file(nil, "")
        dothis.extant_path.zip_to_absolute_path(self:get("c"), temp_file)
        dothis.absolute_path.delete
        if do_after then
          do_after()
        end
      end,
      ["create-child-file-and-choose-action"] = function(self, filename)
        local path = self:get("completely-resolved-path") .. "/" .. filename
        dothis.absolute_path.write_file_if_nonextant_path(path, "")
        st(path):doThis("choose-action")
      end,
      ["create-child-dir-and-choose-action"] = function(self, dirname)
        local path = self:get("completely-resolved-path") .. "/" .. dirname
        dothis.absolute_path.create_dir(path)
        st(path):doThis("choose-action")
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
  ({
    { key = "parent-dir", value = CreateParentDirItem },
    { key = "empty-dir", value = CreateEmptyDirItem },
    { key = "dir-by-path", value = createPathByPathItem },
    { key = "logging-dir", value = CreateLoggingDir },
  }),
  (getChooseItemTable({
    {
      d = "ls",
      i = "🗂️",
      key = "ls",
    },
    {
      d = "tree",
      i = "🌲",
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
createPathItem = bindArg(NewDynamicContentsComponentInterface, DirItemSpecifier)