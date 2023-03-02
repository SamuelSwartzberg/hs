--- @type ItemSpecifier
UniCommandSpecifier = {
  type = "uni-command",
  properties = {
    getables = {
      ["uni-text"] = function(self, specifier)
        local res = getOutputTask(merge({
          "uni",
          specifier.subcommand,
          "-compact",
          "-format=all",
          {
            value = specifier.query,
            type = "quoted"
          },
          "-as=json"
        }, specifier.extra_options))
        return res
      end,
      ["uni-raw-json"] = function(self, specifier)
        return json.decode(self:get("uni", specifier))
      end,
      ["uni-to-parsed-table"] = function (self, specifier)
        return map(
          self:get("uni-raw-json", specifier),
          function (char)
            return CreateTable(char)
          end
        )
      end,
      ["identify"] = function(self, str)
        return self:get("uni-to-parsed-table", {
          subcommand = "identify",
          query = str
        })
      end,
      ["print"] = function(self, query)
        return self:get("uni-to-parsed-table", {
          subcommand = "print",
          query = query
        })
      end,
      ["identify-first"] = function(self, str)
        return CreateTable(self:get("uni-raw-json", {
          subcommand = "identify",
          query = str
        })[1])
      end,
      ["print-first"] = function(self, query)
        return CreateTable(self:get("uni-raw-json", {
          subcommand = "print",
          query = query
        })[1])
      end,
    },

    doThisables = {
      
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateUniCommand = bindArg(NewDynamicContentsComponentInterface, UniCommandSpecifier)
