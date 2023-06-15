--- @type ItemSpecifier
SingleItemStringItemSpecifier = {
  type = "single-item-string",
  properties = {
    doThisables = {
      ["choose-synonym-th"] = function(self)
        self:get("synonyms-th-to-array")
          :doThis("choose-item", function(item)
            item:doThis("choose-synonym", function(synonym)
              st(synonym):doThis("choose-action")
            end)
          end)
      end,
    },
    getables = {
      ["is-url"] = bc(isUrl),
      ["is-path"] = bc(is.string.looks_like_path),
      ["is-printable-ascii-string-item"] = function(self) 
        return memoize(onig.find)(self:get("c"), mt._r.charset.printable_ascii)
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "url", value = CreateURLItem },
    { key = "path", value = CreatePathItem },
    { key = "printable-ascii-string-item", value = CreatePrintableAsciiStringItem },
    { key = "potentially-parsable-date", value = CreatePotentiallyParseableDateItem },
  }),
  action_table = {
    
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateSingleItemStringItem = bindArg(NewDynamicContentsComponentInterface, SingleItemStringItemSpecifier)
