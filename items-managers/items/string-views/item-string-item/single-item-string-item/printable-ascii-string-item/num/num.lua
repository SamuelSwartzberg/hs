--- @type ItemSpecifier
NumItemSpecifier = {
  type = "num-item",
  properties = {
    getables = {
      ["numeric-equivalent"] = function(self)
        return tonumber(self:get("contents"))
      end,
      ["to-number-interface"] = function(self)
        return CreateNumber(self:get("numeric-equivalent"))
      end,
      ["random-of-length"] = function(self, type)
        return self:get("to-number-interface"):get("random-" .. type .. "-of-length")
      end,
      ["codepoint-to-unicode-prop-table"] = function(self)
        return self:get("to-number-interface"):get("codepoint-to-unicode-prop-table")
      end,
      ["eutf8-to-unicode-prop-table"] = function(self)
        return self:get("to-number-interface"):get("eutf8-to-unicode-prop-table")
      end,
      ["to-date-obj-item"] = function(self, adjustment_factor)
        return CreateNumber(self:get("numeric-equivalent")):get("to-date-obj-item", adjustment_factor)
      end
    },
  },
  action_table = listConcat(
    getChooseItemTable({
      {
        description = "rndb64",
        emoji_icon = "🎰🔠6️⃣4️⃣",
        key = "random-of-length",
        args = {
          "base64"
        }
      },{
        description = "rndpint",
        emoji_icon = "🎰🔢➕#️",
        key = "random-of-length",
        args = {
          "pos-int"
        }
      },{
        description = "rndalnum",
        emoji_icon = "🎰🔠🔡🔢",
        key = "random-of-length",
        args = {
          "alphanum"
        }
      },{
        description = "rndlalnum",
        emoji_icon = "🎰🔡🔢",
        key = "random-of-length",
        args = {
          "lower-alphanum"
        }
      }
    }), {
      {
        text = "👉🔢 cnm.",
        key = "choose-action-on-result-of-get",
        args = { key = "to-number-interface"}
      },{
        text = "👉🦄 cucp.", -- unicode codepoint chooser
        key = "choose-action-on-result-of-get",
        args = { key = "codepoint-to-unicode-prop-table"}
      },{
        text = "👉🦄⑧ ceutf8." ,
        key = "choose-action-on-result-of-get",
        args = { key = "eutf8-to-unicode-prop-table"}
      },{
        text = "👉📅 cdt.",
        key = "choose-action-on-result-of-get",
        args = { key = "to-date-obj-item"}
      },{
        text = "👉📅 cdtms.",
        key = "choose-action-on-result-of-get",
        args = { key = "to-date-obj-item", args = 1000}
      }
    }
  ),
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateNumItem = bindArg(NewDynamicContentsComponentInterface, NumItemSpecifier)


