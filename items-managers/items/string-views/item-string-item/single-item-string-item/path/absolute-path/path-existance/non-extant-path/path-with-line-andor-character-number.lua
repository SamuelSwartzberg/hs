--- @type ItemSpecifier
PathWithLineAndorCharacterNumberItemSpecifier = {
  type = "path-with-line-andor-character-number",
  properties = {
    getables = {
      ["path-part"] = function (self)
        return stringy.split(self:get("contents"), ":")[1]
      end,
      ["number-part"] = function(self)
        local number_parts = listSlice(stringy.split(self:get("contents"), ":"), 2)
        return stringx.join(":", number_parts)
      end,
    },
    doThisables = {
      ["vscode-open-and-go-to"] = function (self)
        runHsTaskProcessOutput({
          "open",
          "-a",
           { value = "Visual Studio Code", type = "quoted" },
          { value = self:get("path-part"), type = "quoted" }
        }, function ()
          doKeyboardSeries({ specifier_list = {
            { modifiers = { "ctrl" }, text = "g" },
            { text = self:get("number-part") },
            { modifiers = {}, text = "return" },
          }})
        end)
      end
    },
    
  },

  action_table = {
    {
      text = "🔷🆙 vsgt.",
      key = "vscode-open-and-go-to",
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathWithLineAndorCharacterNumberItem = bindArg(NewDynamicContentsComponentInterface, PathWithLineAndorCharacterNumberItemSpecifier)
