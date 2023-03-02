--- @class mergeOpts
--- @field isopts "isopts"
--- @field recurse? boolean | number
--- @field depth? number


--- @param opts? mergeOpts
--- @param ... table[]
--- @return table
function merge(opts, ...)
  local tables = {...}
  if not opts then return {} end 
  if opts.isopts == "isopts" then
    opts = tablex.deepcopy(opts)
  else -- opts is actually the first associative array
    table.insert(tables, 1, opts)
    opts = {}
  end

  opts.recurse = defaultIfNil(opts.recurse, true)
  opts.depth = crementIfNumber(opts.depth, "in")

  if #tables == 0 then return {} end
  local result = tablex.deepcopy(tables[1])
  for _, mergetable in wdefarg(ipairs)(tables) do 
    if type(mergetable) == "table" then
      for k, v in pairs(mergetable) do
        if type(v) == "table" then
          if type(result[k]) == "table" == true or opts.recurse == true or opts.recurse > opts.depth then
            result[k] = merge(opts, result[k], v)
          else
            result[k] = tablex.deepcopy(v)
          end
        else
          result[k] = v
        end
      end
    else
      error("mergeAssocArrRecursive: expected table, got " .. type(mergetable) .. "with contents:\n\n" .. json.encode(mergetable))
    end
  end
  return result
end