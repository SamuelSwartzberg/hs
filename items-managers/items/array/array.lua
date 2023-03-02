

ArraySpecifier = {
  type = "array",
  properties = {
    getables = {
      ["length"] = function(self) return #values(self:get("contents")) end,
      ["is-empty-array"] = function(self) return self:get("length") == 0 end,
      ["is-non-empty-array"] = function(self) return self:get("length") > 0 end,
      ["with-appended"] = function(self, other_array)
        local to_append
        if isListOrEmptyTable(other_array) then
          to_append = other_array
        elseif type(other_array) == "table" and other_array.get then 
          to_append = other_array:get("contents")
        elseif other_array == nil then 
          to_append = nil 
        else
          to_append = { other_array }
        end
        return CreateArray(
          listConcat(
            self:get("contents"), 
            to_append
          )
        )
      end,
    },
    doThisables = {
    },
  },
  potential_interfaces = ovtable.init({
    {key = "non-empty-array", value = CreateNonEmptyArray },
    {key = "empty-array", value = CreateEmptyArray},
    {key = "managed-array", value = CreateManagedArray}
  }),
  action_table = {}
  
}

function CreateArray(contents, managed_array_type)
  if contents == nil then contents = {} end
  local interface_specifier = ArraySpecifier 
  if managed_array_type then 
    interface_specifier = merge(
      ArraySpecifier,
      { properties = { getables = { 
        ["is-managed-array"] = function() return true end,
        ["is-managed-" .. managed_array_type .. "-array"] = function() return true end
      } } }
    )
  end
  return RootInitializeInterface(interface_specifier, contents)
end