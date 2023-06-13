

function isArrayOfInterfacesOfType(self, type)
  local res = get.array.all_pass(self:get("c"), function(item) 
    local inner_res =  not not item:get("is-" .. type) 
    return inner_res
  end)
  return res
end

local rrq = bindArg(relative_require, "items-managers.items.array.non-empty-array.does-not-contain-nil-array.homogeneous-array.array-of-interfaces")

rrq("array-of-arrays")
rrq("managed-array")
rrq("array-of-non-array-interfaces")
rrq("array-of-interfaces")