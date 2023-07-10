---reverse an indexable
---@generic T : indexable
---@param thing T
---@return T
function rev(thing)
  if type(thing) == "string" then
    return eutf8.reverse(thing)
  elseif type(thing) == "table" then
    if not thing.isovtable then
      return get.stateless_iter_component_array.table(transf.stateless_iter.stateless_iter_component_array(get.indexable.reversed_key_value_stateless_iter(thing)))
    else
      return get.stateless_iter_component_array.table(transf.stateless_iter.stateless_iter_component_array(get.indexable.reversed_key_value_stateless_iter(thing)), {toovtable = true});
    end
  else
    error("rev only works on strings, lists, and tables. got " .. type(thing) .. " when processing:\n\n" .. json.encode(thing))
  end
end