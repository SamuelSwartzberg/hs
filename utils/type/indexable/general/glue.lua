---@class glueOpts : appendOpts
---@field recurse? boolean | number if true, recurse into tables, if false, don't, if a number, recurse until that depth
---@field depth? number the current depth of recursion

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
        opts.depth = crementIfNumber(opts.depth, "in")
        opts.recurse = defaultIfNil(opts.recurse, true)
        for k, v in prs(addition) do
          if type(v) == "table" and not isList(v) then -- we could recurse
            if 
              type(base[k]) ~= "table" 
              or isList(base[k])
              or not opts.recurse 
              or (
                type(opts.recurse) == "number" and 
                (opts.recurse < opts.depth)
              ) 
            then -- we shouldn't recurse, just simply add as a k-v pair
              base = append(base, {k, v}, opts)
            else
              base[k] = glue(base[k], v, opts)
            end
          else -- we can't recurse, just simply add as a k-v pair
            base = append(base, {k, v}, opts)
          end
        end
      end
    end
    return base
  end
end
