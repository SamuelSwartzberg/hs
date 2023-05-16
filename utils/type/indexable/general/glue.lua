---@class glueOpts : appendOpts
---@field recurse? boolean | number if true, recurse into tables, if false, don't, if a number, recurse until that depth
---@field depth? number the current depth of recursion

--- @param base any
--- @param addition any
--- @param opts glueOpts
function recursiveMerge(base, addition, opts)
  opts.depth = crementIfNumber(opts.depth, "in")
  opts.recurse = defaultIfNil(opts.recurse, true)
  inspPrint(base)
  inspPrint(addition)
  local no_recurse = not opts.recurse 
    or (
      type(opts.recurse) == "number" and 
      (opts.recurse < opts.depth)
    )
  for k, v in prs(addition) do
    if 
      not no_recurse and
      type(v) == "table" and not isList(v) and
      type(base[k]) == "table" and not isList(base[k])
    then --recurse
      print("recursing into "..k)
      base[k] = recursiveMerge(base[k], v, opts)
    else -- we can't recurse, just simply add as a k-v pair
      print("adding ".. k )
      base = append(base, {k, v}, opts)
    end
  end
  print("returning")
  inspPrint(base)
  return base
end

---add a single element to an indexable, but where that element may be mushed into the base in the process.
--- the output is guaranteed to be of the same type as the base
--- - glue(string, string2) -> append(string, string)
--- - glue(list, list2) -> append each element of list2 to list
--- - glue(assocarr, assocarr2) -> append each pair of assocarr2 to assocarr, may recurse if recurse is true
--- - glue(list, assocarr) -> append assocarr to list
--- - glue(assocarr, list) -> assume list is pair, append list to assocarr (this will fail if the list is not a pair)
---@generic T : indexable
---@param base `T`
---@param addition any
---@param opts? glueOpts
---@return T
function glue(base, addition, opts)
  print("---glue---")
  opts = opts or {}
  if type(addition) ~= "table" then
    return append(base, addition, opts) -- glue(string, string2)
  elseif isEmptyTable(addition) then
    return base -- appending an empty table to anything is a no-op
  elseif isUndeterminableTable(base) then
    return addition
  else
    if isList(addition) then
      if isList(base) then -- glue(list, list2)
        for _, v in iprs(addition) do
          base = append(base, v, opts)
        end
      else -- glue(assocarr, list)
        base = append(base, addition, opts) 
      end
    else
      if isList(base) then -- glue(list, assocarr) if the base is a list, and we're gluing an assoc arr, we're just gonna treat it as a value to append
        base = append(base, addition, opts)
      else -- glue(assocarr, assocarr2)
        base = recursiveMerge(base, addition, opts)
      end
    end
    print("finally returning")
    inspPrint(base)
    return base
  end
end
