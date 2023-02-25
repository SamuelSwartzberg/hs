

--- @type ItemSpecifier
FileItemSpecifier = {
  type = "file",
  properties = {
    getables = {
      ["is-image-file"] = function(self) 
        return isUsableAsFiletype(self:get("contents"), "image") 
      end,
      ["is-plaintext-file"] = function(self) 
        return isPlaintextFile(self:get("contents"))
      end,
      ["is-binary-file"] = function(self) 
        return not isPlaintextFile(self:get("contents"))
      end,
      ["dir-or-file-any-pass"] = function(self, query) return query(self) end,
      ["file-contents"] = function(self)
        return stringy.strip(readFileOrError(self:get("contents")))
      end,
      ["descendant-file-only-string-item-array"] = function(self)
        return CreateArray({self.root_super})
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
        writeFile(self:get("contents"), contents, "exists")
      end,
      ["append-file-contents"] = function (self, contents)
        writeFile(self:get("contents"), contents, "exists", true, "a")
      end,
      ["rm-file"] = function (self)
        delete(self:get("contents"))
      end,
      ["rename-to-parent"] = function(self)
        self:doThis("move-safe", self:get("name-of-parent-with-current-extension"))
      end,
      ["empty-file"] = function(self)
        writeFile(self:get("contents"), "", "exists")
      end,
      ["send-in-email"] = function(self, do_after)
        sendEmailInteractive({}, asAttach(self:get("contents")), editorEditFunc, do_after)
      end,
      ["edit-file-interactive"] = function(self, do_after)
        run({
          "$VISUAL",
          { value = self:get("contents"), type = "quoted" },
        }, do_after)
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "image-file", value = CreateImageFileItem },
    { key = "plaintext-file", value = CreatePlaintextFileItem },
    { key = "binary-file", value = CreateBinaryFileItem },
  }, true),
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