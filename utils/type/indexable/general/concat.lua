--- @class concatOpts : glueOpts
--- @field isopts "isopts"
--- @field sep? any | any[]


--- @generic T : indexable
--- @generic O : indexable
--- @param opts? concatOpts
--- @param ... T
--- @return O -- concat return may have the same type as its input, but it may also change type, as in the case of concating a list of strings
function concat(opts, ...)
  local inputs = {...}
  if not opts then return {} end
  if type(opts) == "table" and opts.isopts == "isopts" then
    -- no-op
  else -- opts is actually the first list
    table.insert(inputs, 1, opts)
    opts = {}
  end

  if #inputs == 1 and isListOrEmptyTable(inputs[1]) then -- was called with a single list instead of varargs, but we can handle that
    inputs = inputs[1]
  end

  local outputs = {}
  local sep
  for i, input in ipairs(inputs) do
    if sep then
      outputs = glue(outputs, sep)
    end
    outputs = glue(outputs, input)
    if opts.sep then
      if isListOrEmptyTable(sep) then
        sep = opts.sep[i]
      else
        if opts.sep._contains then -- since we can split by a conditionSpec, we want to be able to use a conditionSpec as a separator to rejoin. However, _contains is the only value of a conditionSpec where we can be sure that using it as a separator will recreate the original list (all others are not reversible)
          sep = opts.sep._contains
        else
          sep = opts.sep
        end
      end
      
    end
  end
  return outputs
end