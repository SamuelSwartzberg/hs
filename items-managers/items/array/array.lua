

ArraySpecifier = {
  type = "array",
  properties = {
    getables = {
      ["length"] = function(self) return #transf.native_table_or_nil.value_array(self:get("c")) end,
      ["is-empty-array"] = function(self) return self:get("length") == 0 end,
      ["is-non-empty-array"] = function(self) return self:get("length") > 0 end,
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

function ar(contents, managed_array_type)
  if contents == nil then contents = {} end
  local interface_specifier = ArraySpecifier 
  if managed_array_type then 
    interface_specifier = concat(
      ArraySpecifier,
      { properties = { getables = { 
        ["is-managed-array"] = function() return true end,
        ["is-managed-" .. managed_array_type .. "-array"] = function() return true end
      } } }
    )
  end
  return RootInitializeInterface(interface_specifier, contents)
end