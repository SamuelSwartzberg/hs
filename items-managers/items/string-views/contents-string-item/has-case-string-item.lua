--- @type ItemSpecifier
HasUppercaseStringItemSpecifier = {
  type = "has-uppercase-string-item",
  properties = {
    getables = {
      ["contents-as-all-lowercase"] = function(self) return self:get("contents"):lower() end,
      ["contents-as-lower-snake-case"] = function(self) return eutf8.lower(replace(self:get("contents"), to.case.snake)) end,
      ["contents-as-lower-kebap-case"] = function (self)
        return eutf8.lower(replace(self:get("contents"), to.case.kebap))
      end
    }
  },
  action_table = getChooseItemTable({
    {
      description = "al",
      emoji_icon = "🪂",
      key = "contents-as-all-lowercase"
    },
    {
      description = "snl",
      emoji_icon = "🐍🪂",
      key = "contents-as-lower-snake-case"
    },
    {
      description = "kbl",
      emoji_icon = "🍢🪂",
      key = "contents-as-lower-kebap-case"
    }
  })

}

--- @type BoundNewDynamicContentsComponentInterface
CreateHasUppercaseStringItem = bindArg(NewDynamicContentsComponentInterface, HasUppercaseStringItemSpecifier)

--- @type ItemSpecifier
HasLowercaseStringItemSpecifier = {
  type = "has-lowercase-string-item",
  properties = {
    getables = {
      ["contents-as-all-uppercase"] = function(self) return self:get("contents"):upper() end,
      ["contents-as-upper-snake-case"] = function(self) return eutf8.upper(replace(self:get("contents"), to.case.snake)) end,
      ["contents-as-upper-kebap-case"] = function (self)
        return eutf8.upper(replace(self:get("contents"), to.case.kebap))
      end
    }
  },
  action_table = getChooseItemTable({
    {
      description = "au",
      emoji_icon = "🧗‍♀️",
      key = "contents-as-all-uppercase"
    },
    {
      description = "snu",
      emoji_icon = "🐍🧗‍♀️",
      key = "contents-as-upper-snake-case"
    },
    {
      description = "kbu",
      emoji_icon = "🍢🧗‍♀️",
      key = "contents-as-upper-kebap-case"
    }
  })

}

--- @type BoundNewDynamicContentsComponentInterface
CreateHasLowercaseStringItem = bindArg(NewDynamicContentsComponentInterface, HasLowercaseStringItemSpecifier)
