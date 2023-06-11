

--- @type ItemSpecifier
FileItemSpecifier = {
  type = "file",
  properties = {
    getables = {
      ["is-image-file"] = function(self) 
        return is.path.usable_as_filetype(self:get("c"), "image") 
      end,
      ["is-plaintext-file"] = function(self) 
        return not is.path.usable_as_filetype(self:get("c"), "binary")
      end,
      ["is-binary-file"] = function(self) 
        return is.path.usable_as_filetype(self:get("c"), "binary")
      end,
      ["dir-or-file-any-pass"] = function(self, query) return query(self) end,
      ["file-contents"] = function(self)
        return stringy.strip(readFile(self:get("c"), "error"))
      end,
      ["descendant-file-only-string-item-array"] = function(self)
        return ar({self.root_super})
      end,
      ["cd-and-task"] = function(self)
        return self:get("cd-to-parent-dir-and-task")
      end,
      ["name-of-parent-with-current-extension"] = function(self)
        local extension = self:get("path-leaf-extension") or ".file"
        local parent_path = self:get("parent-dir-path")
        local new_path = parent_path .. extension
        return new_path
      end,
    },
  
    doThisables = {
      ["overwrite-file-contents"] = function (self, contents)
        writeFile(self:get("c"), contents, "exists")
      end,
      ["append-file-contents"] = function (self, contents)
        writeFile(self:get("c"), contents, "exists", true, "a")
      end,
      ["rm-file"] = function (self)
        delete(self:get("c"))
      end,
      ["rename-to-parent"] = function(self)
        self:doThis("move-safe", self:get("name-of-parent-with-current-extension"))
      end,
      ["empty-file"] = function(self)
        writeFile(self:get("c"), "", "exists")
      end,
      ["send-in-email"] = function(self, do_after)
        sendEmailInteractive({}, transf.path.attachment(self:get("completely-resolved-path")), editorEditFunc, do_after)
      end,
      ["edit-file-interactive"] = function(self, do_after)
        run({
          "$VISUAL",
          { value = self:get("completely-resolved-path"), type = "quoted" },
        }, do_after)
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "image-file", value = CreateImageFileItem },
    { key = "plaintext-file", value = CreatePlaintextFileItem },
    { key = "binary-file", value = CreateBinaryFileItem },
  }),
  action_table = {
    {
      text = "🗑 rmfl.",
      key = "rm-file",
    },
    {
      text = "🗑🎒 empfl.",
      key = "empty-file",
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateFileItem = bindArg(NewDynamicContentsComponentInterface, FileItemSpecifier)