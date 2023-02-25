--- @type ItemSpecifier
PassCommandSpecifier = {
  type = "pass-command",
  properties = {
    getables = {
      ["get-thing"] = function(self, specifier)
        if isListOrEmptyTable(specifier.thing) then
          specifier.thing = table.concat(specifier.thing, "/")
        end
        local raw = getOutputArgsSimple(
          "pass",
          "show",
          specifier.thing .. "/" .. specifier.name
        )
        return raw
      end,
      ["json"] = function(self,specifier)
        local raw = self:get("get-thing", specifier)
        return json.decode(raw)
      end,
    },
    doThisables = {
      ["add-thing"] = function(self, specifier)
        if isListOrEmptyTable(specifier.thing) then
          specifier.thing = table.concat(specifier.thing, "/")
        end
        run({
          "yes",
          { value = specifier.payload, type = "quoted" },
          "|",
          "pass",
          "add",
          specifier.thing .. "/" .. specifier.name
        }, true)
      end,
      ["add-json"] = function(self, specifier)
        specifier.payload = json.encode(specifier.data)
        self:doThis("add-thing", specifier)
      end,
      ["add-password"] = function(self, specifier)
        specifier.thing = "passw"
        specifier.payload = specifier.password
        self:doThis("add-thing", specifier)
      end,
      ["add-username"] = function (self, specifier)
        run({
          "echo", "-n",
          { value = specifier.username, type = "quoted" },
          ">",
          env.MPASSUSERNAME .. "/" .. specifier.name .. ".txt"
        }, true)
      end
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePassCommand = bindArg(NewDynamicContentsComponentInterface, PassCommandSpecifier)
