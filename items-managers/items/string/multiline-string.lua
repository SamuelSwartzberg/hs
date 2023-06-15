


--- @type ItemSpecifier
MultilineStringItemSpecifier = {
  type = "multiline-string",
  properties = {
    getables = {
    },
    doThisables = {
      ["save-session"] = function(self)
        self:get("to-string-item-array", "\n")
          :get("to-does-not-contain-nil-array")
          :get("to-homogeneous-array-of-type", "url")
          :doThis("create-session")
      end,
      ["tab-fill-with-lines"] = function (self)
        self:doThis("tab-fill-with-items", "\n")
      end
    }
  },
  action_table = {
      {
        d = "fld",
        i = "🗺",
        getfn = transf.string.folded
      },{
        d = "lnhd",
        i = "⩶👆",

      },{
        d = "lntl",
        i = "⩶👇",
        key = "tail"
      },
    
      {
        text = "👉⩶　cln.",
        key = "split-and-choose-action",
        args = "\n"
      },
      {
        text = "🌄📚 crsess.",
        key = "save-session",
      }
    }
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateMultilineStringItem = bindArg(NewDynamicContentsComponentInterface, MultilineStringItemSpecifier)