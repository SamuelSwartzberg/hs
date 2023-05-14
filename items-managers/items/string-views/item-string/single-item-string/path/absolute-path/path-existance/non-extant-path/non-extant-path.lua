--- @type ItemSpecifier
NonExtantPathItemSpecifier = {
  type = "non-extant-path",
  properties = {
    getables = {
      ["is-path-with-line-andor-character-number"] = function(self)
        return self:get("contents"):match(":%d+$")
      end,
    },
    doThisables = {
      ["write-file-contents"] = function(self, contents)
        writeFile(self:get("contents"), contents, "not-exists")
      end,
      ["overwrite-file-contents"] = function (self, contents)
        writeFile(self:get("contents"), contents, "not-exists") -- same as write-file-contents since file doesn't exist
      end,
      ["append-file-contents"] = function (self, contents)
        writeFile(self:get("contents"), contents, "not-exists") -- same as write-file-contents since file doesn't exist
      end,
      ["create-self-as-empty-dir"] = function(self)
        createPath(self:get("contents"))
      end,
        
      ["table-to-fs-children-dispatch"] = function(self, specifier)
        for k, v in prs(specifier.payload) do
          local child  = CreateStringItem(self:get("path-ensure-final-slash") .. k)
          specifier.payload = v
          child:doThis("table-to-fs", specifier)
        end
      end,
      
    },
    

  },
  potential_interfaces = ovtable.init({
    {key = "path-with-line-andor-character-number", value = CreatePathWithLineAndorCharacterNumberItem},
  }),
  action_table = {
    {
      text = "👉🌄📁 ccrdir.",
      key = "do-multiple",
      args = {
        { key = "create-self-as-empty-dir" },
        { key = "choose-action-on-str-item-result-of-get", args = "contents" } 
      }
    },{
      text = "👉🌄📄 ccrfl.",
      key = "do-multiple",
      args = {
        { key = "write-file-contents" },
        { key = "choose-action-on-str-item-result-of-get", args = "contents" } 
      }
    },
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateNonExtantPathItem = bindArg(NewDynamicContentsComponentInterface, NonExtantPathItemSpecifier)
