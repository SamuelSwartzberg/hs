--- @type ItemSpecifier
SingleItemStringItemSpecifier = {
  type = "single-item-string-item",
  properties = {
    doThisables = {
      ["choose-synonym-th"] = function(self)
        self:get("synonyms-th-to-array")
          :doThis("choose-item", function(item)
            item:doThis("choose-synonym", function(synonym)
              pasteMultilineString(synonym)
            end)
          end)
      end,
    },
    getables = {
      ["is-url"] = function(self) return isUrl(self:get("contents")) end,
      ["is-path"] = function(self) return looksLikePath(self:get("contents")) end,
      ["is-printable-ascii-string-item"] = function(self) 
        return not eutf8.find(self:get("contents"), "[^%w%p%s]")
      end,
      ["is-application"] = function(self) 
        return valuesContain(
          getUserUsefulFilesInPath("/Applications/", false, true),
          self:get("contents") .. ".app"
        )
      end,
      ["is-potentially-parsable-date"] = function(self)
        local res = eutf8.find(self:get("contents"), "%d%d") -- this doesn't guarantee that this is a date, we'll check that within the potentiallyParsableDateItem subclass. This is just a quick check to see if it's worth trying to parse it
        return res
      end,
      ["synonyms-av"] = function(self) -- uses thesaurus.altavista
        return CreateShellCommand("synonyms"):get("synonyms-raw", self:get("contents"))
      end,
      ["synonyms-av-to-array"] = function(self)
        return CreateArray(stringy.split(self:get("synonyms-av"), "\t")):get("to-does-not-contain-nil-array")
      end,
      ["synonyms-th"] = function(self) -- uses thesaurus.com
        return CreateShellCommand("syn"):get("synonyms", self:get("contents"))
      end,
      ["synonyms-th-to-array"] = function(self)
        return CreateShellCommand("syn"):get("synonyms-to-array-of-synonyms-tables", self:get("contents"))
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "url", value = CreateURLItem },
    { key = "path", value = CreatePathItem },
    { key = "printable-ascii-string-item", value = CreatePrintableAsciiStringItem },
    { key = "application", value = CreateApplicationItem },
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
