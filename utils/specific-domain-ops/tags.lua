--- @param name_of_pairs string
--- @return { [string]: string }
function promptUserToAddNKeyValuePairs(name_of_pairs)
  local pairs = prompt("pairs", name_of_pairs, "array")
  return mapPairNewPairOvtable(pairs, function(i, pair)
    return pair[1], pair[2]
  end)
end