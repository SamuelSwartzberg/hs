-- contents is the kind of object in the json file provided by ff

--- @type ItemSpecifier
StateWindowItemSpecifier = {
  type = "state-window-item",
  properties = {
    getables = {
      ["state-json-matched-geometry-table"] = function(self)
        local geometry = self:get("rect").table
        inspPrint(geometry)
        geometry = transposeAssocArrKeys(geometry, {x = "screenX", y = "screenY", w = "width", h = "height"})
        return geometry
      end,
      ["window-in-state-json"] = function(self) -- utterly insanely, there is no better way to correlate hs.windows and the windows in the json we're using here than to check if they have the same height, width, and top left point
        local geometry = self:get("state-json-matched-geometry-table")
        return valueFind(
          self:get("application-item"):get("state-as-json").windows,
          function(json_window)
            -- inspPrint(json_window)
            for k, v in pairs(geometry) do
              print(v)
              print(json_window[k])
              if not isClose(v, json_window[k]) then
                return false
              end
            end
            return true
          end
        )
      end,
      ["simple-property"] = function(self, prop)
        return self:get("window-in-state-json")[prop]
      end,
    },
    doThisables = {
      
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateStateWindowItem = bindArg(NewDynamicContentsComponentInterface, StateWindowItemSpecifier)

