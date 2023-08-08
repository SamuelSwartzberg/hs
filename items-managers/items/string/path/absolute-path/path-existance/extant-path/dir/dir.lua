--- @type ItemSpecifier
DirItemSpecifier = {
  type = "dir",
  properties = {

    getables = {
      ["descendants-to-line-array"] = function(self) 
        return self:get("descendant-file-only-string-item-array")
          :get("map-to-line-array-of-file-contents-with-no-empty-strings")
      end,
      ["descendant-ending-with-to-string-item"] = function(self, ending)
        return st(self:get("descendant-ending-with", ending))
      end,

      ["find-or-create-child-dir"] = function(self, specifier)
        local child = get.dir.extant_path_by_child_w_fn(self:get("c"), specifier.find_func)
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
    },
  
    doThisables = {
      ["initialize-as-git-dir"] = function(self)
        self:doThis("git-init")
        self:doThis("create-empty-file-in-dir .gitignore")
      end,
      ["send-in-email"] = function(self, do_after)
        local temp_file = dothis.absolute_path.write_file(nil, "")
        dothis.extant_path.zip_to_absolute_path(self:get("c"), temp_file)
        dothis.absolute_path.delete
        if do_after then
          do_after()
        end
      end,
    }
  })
}


--- @type BoundNewDynamicContentsComponentInterface
createPathItem = bindArg(NewDynamicContentsComponentInterface, DirItemSpecifier)