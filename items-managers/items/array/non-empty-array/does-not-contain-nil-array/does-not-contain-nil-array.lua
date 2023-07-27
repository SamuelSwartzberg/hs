typeOfPrimitiveOrInterface = function(item)
  if type(item) == "table" and item.get then
    return item:get("type")
  else
    return type(item)
  end
end

allTypesOfPrimitiveOrInterface = function(item)
  if type(item) == "table" and item.get then
    return item:get("types-of-all-valid-interfaces")
  else
    return {type(item)}
  end
end

DoesNotContainNilArraySpecifier = {
  type = "does-not-contain-nil-array",
  properties = {
    getables = {
      ["to-does-not-contain-nil-array"] = function(self) return self end,
      ["is-homogeneous-array"] = function(self)
        local first = self:get("first")
        local type = typeOfPrimitiveOrInterface(first)
        return self:get("all-pass", function(item) return typeOfPrimitiveOrInterface(item) == type end)
      end,
      ["is-non-homogeneous-array"] = function(self) -- because our object system supports something similar to multiple inheritance, an array may be both a homogeneous and a non-homogeneous array at the same time. In particular, for homogeneous, we check if the root type is the same, but something may be non-homogeneous if only a single subtype is different
        local first = self:get("first")
        local types = allTypesOfPrimitiveOrInterface(first)
        return not self:get("all-pass", function(item) return allTypesOfPrimitiveOrInterface(item) == types end)
      end,
    },
    doThisables = {
    },
  },
  action_table = {
    {
      text = "👉 c.",
      key = "choose-item-and-then-action"
    }
  },
  ({
    { key = "homogeneous-array", value = CreateHomogeneousArray },
    { key = "non-homogeneous-array", value = CreateNonHomogeneousArray },
  })
  
  }

--- @type BoundNewDynamicContentsComponentInterface
CreateDoesNotContainNilArray = bindArg(NewDynamicContentsComponentInterface, DoesNotContainNilArraySpecifier)