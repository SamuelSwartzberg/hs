function getIsLeaf(treat_as_leaf)
  if treat_as_leaf == "assoc" then
    return function(v) return not isListOrEmptyTable(v) end
  elseif treat_as_leaf == "list" then
    return isListOrEmptyTable
  elseif treat_as_leaf == false then
    return returnFalse
  else
    error("flatten: invalid value for treat_as_leaf: " .. tostring(treat_as_leaf))
  end
end