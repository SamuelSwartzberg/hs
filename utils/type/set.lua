
-- sadly, since my language server doesn't support generics on class fields at the moment, we need to recreate all methods of 'combine' on our own so we can add type annotations using generics :(
-- while we're doing that, I'm also going to transform them into functions that return a table instead of an iterator

--- gets the k-combinations of a list
--- @generic T
--- @param list T[]
--- @param k integer 
--- @return T[][]
function combinations(list, k)
  if k == 0 then
    return {{}}
  else 
    return statefulNokeyIteratorToTable(combine.combn, list, k)
  end
end



--- @generic T
--- @param list T[]
--- @return T[][]
function permutations(list)
  if #list == 0 then
    return {{}}
  else
    return statefulNokeyIteratorToTable(combine.permute, list)
  end
end

--- @generic T
--- @param list T[]
--- @return T[][]
function powerset(list)
  if #list == 0 then
    return {{}}
  else
    local output = listConcat( statefulNokeyIteratorToTable(combine.powerset, list), {{}} )
    return output
  end
end

-- ops on sets

--- @generic T, U
--- @param set1 T[]
--- @param set2 U[]
--- @return (T|U)[]
function setUnion(set1, set2)
  local new_list = listConcat(set1, set2)
  return toSet(new_list)
end

--- @generic T, U
--- @param set1 T[]
--- @param set2 U[]
--- @return (T|U)[]
function setIntersection(set1, set2)
  local new_list = {}
  for _, v in ipairs(set1) do
    if find(set2, v) then
      new_list[#new_list + 1] = v
    end
  end
  return toSet(new_list)
end

--- @generic T, U
--- @param set1 T[]
--- @param set2 U[]
--- @return boolean
function setEquals(set1, set2)
  if #set1 ~= #set2 then return false end
  for _, v in ipairs(set1) do
    if not find(set2, v) then
      return false
    end
  end
  return true
end

--- @generic T, U
--- @param set1 T[]
--- @param set2 U[]
--- @return boolean
function setIsSubset(set1, set2)
  for _, v in ipairs(set1) do
    if not find(set2, v) then
      return false
    end
  end
  return true
end

--- @generic T, U
--- @param set1 T[]
--- @param set2 U[]
--- @return boolean
function setIsSuperset(set1, set2)
  return setIsSubset(set2, set1)
end

--- @generic T, U
--- @param set1 T[]
--- @param set2 U[]
--- @return (T|U)[]
function setDifference(set1, set2)
  local new_list = {}
  for _, v in ipairs(set1) do
    if not find(set2, v) then
      new_list[#new_list + 1] = v
    end
  end
  return toSet(new_list)
end

--- @generic T, U
--- @param set1 T[]
--- @param set2 U[]
--- @return (T|U)[]
function setSymmetricDifference(set1, set2)
  local new_list = {}
  for _, v in ipairs(set1) do
    if not find(set2, v) then
      new_list[#new_list + 1] = v
    end
  end
  for _, v in ipairs(set2) do
    if not find(set1, v) then
      new_list[#new_list + 1] = v
    end
  end
  return toSet(new_list)
end