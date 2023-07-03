
ArrayOfDateRelatedItemsSpecifier = {
  type = "array-of-date-relateds",
  properties = {
    getables = {
      ["smallest-largest-date"] = function(self)
        return {
          self:get("smallest-date"),
          self:get("largest-date")
        }
      end,
      ["smallest-largest-date-to-new-array"] = function(self)
        return CreateArrayOfDateRelatedItems(self:get("smallest-largest-date"))
      end,
      ["to-array-of-date-objs"] = function(self)
        return self:get("map-to-new-array", function(item)
          return item:get("to-date-obj")
        end)
      end,
      ["smallest-largest-date-to-path-leaf-date-range"] = function(self)
        return string.format("%s_to_%s", self:get("smallest-date"), self:get("largest-date"))
      end,
      ["is-in-range"] = function(self, date) -- date must be a date-related-item, or a raw rfc3339 date
        if date.get and date:get("is-date-related-item") then
          date = date:get("c")
        end
        return self:get("smallest-date") <= date and date <= self:get("largest-date")
      end,
      ["get-all-between"] = function(self, component)
        local smallest, largest = self:get("smallest-date"):get("as-date-obj"), self:get("largest-date"):get("as-date-obj")
        local dates = {}
        local current = smallest
        while current <= largest do
          dates[#dates+1] = current:fmr(tblmap.date_component_name.rfc3339like_dt_format_string[component])
          current["add" .. component .. "s"](current, 1)
        end
        return dates
      end,
    },
    doThisables = {
     
    },
  },
  action_table = {},
  
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfDateRelatedItems = bindArg(NewDynamicContentsComponentInterface, ArrayOfDateRelatedItemsSpecifier)