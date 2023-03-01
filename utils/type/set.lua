
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
