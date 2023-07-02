

--- @type ItemSpecifier
FileItemSpecifier = {
  type = "file",
  properties = {
    getables = {
      ["is-image-file"] = function(self) 
        return get.path.usable_as_filetype(self:get("c"), "image") 
      end,
      ["is-plaintext-file"] = function(self) 
        return not get.path.usable_as_filetype(self:get("c"), "binary")
      end,
      ["is-binary-file"] = function(self) 
        return get.path.usable_as_filetype(self:get("c"), "binary")
      end,
      ["name-of-parent-with-current-extension"] = function(self)
        local extension = self:get("path-leaf-extension") or ".file"
        local parent_path = self:get("parent-dir-path")
        local new_path = parent_path .. extension
        return new_path
      end,
    },
  
    doThisables = {
      ["rename-to-parent"] = function(self)
        self:doThis("move-safe", self:get("name-of-parent-with-current-extension"))
      end,
      ["send-in-email"] = function(self, do_after)
        dothis.email_specifier.send({body = transf.path.attachment(self:get("completely-resolved-path")} do_after)
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
      e = emj.remove,
      key = "rm-file",
    },
    {
      i = emj.empty,
      d = "empfl",
      key = "empty-file",
    },
    {
      i = emj.open .. emj.libreoffice,
      d = "oplbr",
      dothis = bind(dothis.path.open_app, {a_use, "LibreOffice"})
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateFileItem = bindArg(NewDynamicContentsComponentInterface, FileItemSpecifier)