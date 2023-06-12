--- @type ItemSpecifier
HasUppercaseStringItemSpecifier = {
  type = "has-uppercase-string",
  properties = {
    getables = {
      ["contents-as-all-lowercase"] = function(self) return self:get("c"):lower() end,
      ["contents-as-lower-snake-case"] = function(self) return eutf8.lower(replace(self:get("c"), to.case.snake)) end,
      ["contents-as-lower-kebap-case"] = function (self)
        return eutf8.lower(replace(self:get("c"), to.case.kebap))
      end
    }
  },
  action_table = {
    {
      d = "al",
      i = "🪂",
      key = "contents-as-all-lowercase"
    },
    {
      d = "snl",
      i = "🐍🪂",
      key = "contents-as-lower-snake-case"
    },
    {
      d = "kbl",
      i = "🍢🪂",
      key = "contents-as-lower-kebap-case"
    }
  }

}

--- @type BoundNewDynamicContentsComponentInterface
CreateHasUppercaseStringItem = bindArg(NewDynamicContentsComponentInterface, HasUppercaseStringItemSpecifier)

--- @type ItemSpecifier
HasLowercaseStringItemSpecifier = {
  type = "has-lowercase-string",
  properties = {
    getables = {
      ["contents-as-all-uppercase"] = function(self) return self:get("c"):upper() end,
      ["contents-as-upper-snake-case"] = function(self) return eutf8.upper(replace(self:get("c"), to.case.snake)) end,
      ["contents-as-upper-kebap-case"] = function (self)
        return eutf8.upper(replace(self:get("c"), to.case.kebap))
      end
    }
  },
  action_table = getChooseItemTable({
    {
      d = "au",
      i = "🧗‍♀️",
      key = "contents-as-all-uppercase"
    },
    {
      d = "snu",
      i = "🐍🧗‍♀️",
      key = "contents-as-upper-snake-case"
    },
    {
      d = "kbu",
      i = "🍢🧗‍♀️",
      key = "contents-as-upper-kebap-case"
    }
  })

}

--- @type BoundNewDynamicContentsComponentInterface
CreateHasLowercaseStringItem = bindArg(NewDynamicContentsComponentInterface, HasLowercaseStringItemSpecifier)
