
ArrayOfPlaintextFilesSpecifier = {
  type = "array-of-plaintext-files",
  properties = {
    getables = {
      ["map-to-array-of-split-file-contents"] = function(self, sep)
        return self:get("map-to-array-of-contents"):get("to-resplit-string-array-assume-sep", sep)
      end,
      ["map-to-line-array-of-file-contents"] = function(self)
        return self:get("map-to-array-of-split-file-contents", "\n")
      end,
      ["map-to-line-array-of-file-contents-with-no-empty-strings"] = function(self)
        return self:get("map-to-array-of-contents"):get("to-resplit-string-array-assume-sep-no-empty-strings", "\n")
      end,
      ["is-array-of-plaintext-dictionary-files"] = bind(isArrayOfInterfacesOfType, {a_use, "plaintext-dictionary-file" }),
      ["is-array-of-email-files"] = bind(isArrayOfInterfacesOfType, {a_use, "email-file" }),
    },
    doThisables = {
      ["choose-file-and-tab-fill-with-items"] = function(self, item_sep)
        self:doThis("choose-item", function(item) 
          item:get("str-item", "file-contents")
            :doThis("tab-fill-with-items",item_sep) 
        end)
      end,
      ["choose-file-and-tab-fill-with-lines"] = function(self)
        self:doThis("choose-file-and-tab-fill-with-items", "\n")
      end,
      ["choose-file-and-paste"] = function(self)
        self:doThis("choose-item", function(item) 
          item:get("str-item", "file-contents"):doThis("paste-contents")
        end)
      end,
      ["choose-file-template-eval-and-paste"] = function(self)
        self:doThis("choose-item", function(item) 
          item:get("str-item", "file-contents"):get("str-item", "template-evaluated-contents"):doThis("paste-contents")
        end)
      end,
    },
  },
  action_table = {
    {
      text = "👉⩶👊　clnact.",
      key = "choose-item-and-then-action-on-result-of-get",
      args = { key = "map-to-line-array-of-file-contents-with-no-empty-strings" }
    },
    {
      text = "👉⩶📜👊　clnarract.",
      key = "choose-action-on-result-of-get",
      args = { key = "map-to-line-array-of-file-contents-with-no-empty-strings" }

    }
  },
  potential_interfaces = ovtable.init({
    { key = "array-of-plaintext-dictionary-files", value = CreateArrayOfPlaintextDictionaryFiles },
    { key = "array-of-email-files", value = CreateArrayOfEmailFiles },
  }),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfPlaintextFiles = bindArg(NewDynamicContentsComponentInterface, ArrayOfPlaintextFilesSpecifier)