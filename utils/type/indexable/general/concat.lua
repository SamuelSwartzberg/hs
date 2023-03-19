--- @class concatOpts : glueOpts
--- @field isopts "isopts" this is just a flag to indicate that the first argument is actually an options table
--- @field sep? any | any[] separator to use between each element

function getSep(opts,i)
  if opts.sep then
    if isListOrEmptyTable(opts.sep) then
      return opts.sep[i]
    else
      if type(opts.sep) == "table" and opts.sep._contains then -- since we can split by a conditionSpec, we want to be able to use a conditionSpec as a separator to rejoin. However, _contains is the only value of a conditionSpec where we can be sure that using it as a separator will recreate the original list (all others are not reversible)
        return opts.sep._contains
      else
        return opts.sep
      end
    end
    
  end
end

--- joins together n indexables. Accepts input in a variety of ways: The first argument may be opts, or not, and the non-opts elements may be provided as a list or as varargs. The only requirement is that if we want to call concat with exactly one list considered as a single arg (not sure why we would want to, but anyway), it must be wrapped in another list, to distinguish it from a list of args.
--- @generic T : indexable
--- @generic O : indexable
--- @param opts? concatOpts | T opts may be opts, or actually be the first element
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
  local sep = getSep(opts,1)
  for i, input in ipairs(inputs) do
    if sep then
      outputs = glue(outputs, sep)
    end
    outputs = glue(outputs, input)
    sep = getSep(opts,i)
  end
  return outputs
end