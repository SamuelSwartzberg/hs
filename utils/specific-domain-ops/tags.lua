--- @param name_of_pairs string
--- @return { [string]: string }
function promptUserToAddNKeyValuePairs(name_of_pairs)
  local pairs = prompt("pairs", name_of_pairs, "array")
  return transf.pair_array.dict(pairs) -- doesn't exist yet, todo
end