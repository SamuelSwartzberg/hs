


--- @type ItemSpecifier
MultilineStringItemSpecifier = {
  type = "multiline-string-item",
  properties = {
    getables = {
      ["parsed-as-yaml"] = function(self) -- not guaranteed to work, as the string may not be yaml. ensure this yourself
        return yaml.load(self:get("contents"))
      end,
      ["lines"] = function(self)
        return stringy.split(self:get("contents"), "\n")
      end,
      ["tail"] = function(self, n)
        n = n or 10
        local lines = self:get("lines")
        return table.concat(slice(lines, #lines - n + 1, #lines), "\n")
      end,
      ["head"] = function(self, n)
        n = n or 10
        local lines = self:get("lines")
        return table.concat(slice(lines, 1, n), "\n")
      end,
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
  action_table = concat(
    getChooseItemTable({
      {
        description = "fld",
        emoji_icon = "πΊ",
        key = "fold"
      },{
        description = "lnhd",
        emoji_icon = "β©Άπ",
        key = "head"
      },{
        description = "lntl",
        emoji_icon = "β©Άπ",
        key = "tail"
      }
    }),{
      {
        text = "πβ©Άγcln.",
        key = "split-and-choose-action",
        args = "\n"
      },
      {
        text = "ππ crsess.",
        key = "save-session",
      }
    }
  )
}

--- @type BoundNewDynamicContentsComponentInterface
CreateMultilineStringItem = bindArg(NewDynamicContentsComponentInterface, MultilineStringItemSpecifier)