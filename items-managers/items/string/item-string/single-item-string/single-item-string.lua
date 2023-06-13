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
      ["is-url"] = function(self) return memoize(isUrl)(self:get("c")) end,
      ["is-path"] = function(self) return memoize(is.string.looks_like_path)(self:get("c")) end,
      ["is-printable-ascii-string-item"] = function(self) 
        return memoize(onig.find)(self:get("c"), mt._r.charset.printable_ascii)
      end,
      ["is-potentially-parsable-date"] = function(self)
        local res = eutf8.find(self:get("c"), "%d%d") -- this doesn't guarantee that this is a date, we'll check that within the potentiallyParsableDateItem subclass. This is just a quick check to see if it's worth trying to parse it
        return res
      end,
      ["synonyms-av-to-array"] = function(self)
        return ar(transf.word.synonyms.array_av(self:get("c")))
      end,
      ["synonyms-th-to-array"] = function(self)
        return transf.table_array.item_array_of_item_tables(
          transf.word.synonyms.array_syn_tbls(self:get("c"))
        )
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
    {
      text = "👉📚 csynav.",
      key = "choose-item-and-then-action-on-result-of-get",
      args = { key = "synonyms-av-to-array" }
    },{
      text = "👉📚 csynth.",
      key = "choose-synonym-th"
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateSingleItemStringItem = bindArg(NewDynamicContentsComponentInterface, SingleItemStringItemSpecifier)
