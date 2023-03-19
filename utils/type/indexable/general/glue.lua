---@class glueOpts : appendOpts
---@field recurse? boolean | number if true, recurse into tables, if false, don't, if a number, recurse until that depth
---@field depth? number the current depth of recursion

---add a single element to an indexable, but where that element may be mushed into the base in the process:
---  glue(string, string2) -> append(string, string)
---  glue(list, list2) -> append each element of list2 to list
---  glue(list, assocarr) -> append assocarr to list
---  glue(assocarr, list) -> assume list is pair, append list to assocarr (this will fail if the list is not a pair)
---  glue(assocarr, assocarr2) -> append each pair of assocarr2 to assocarr, may recurse if recurse is true
---@generic T : indexable
---@param base `T`
---@param addition any
---@param opts? glueOpts
---@return T
function glue(base, addition, opts)
  opts = opts or {}
  if type(addition) ~= "table" then
    return append(base, addition, opts)
  else
    if isListOrEmptyTable(addition) then
      if isListOrEmptyTable(base) then
        for _, v in ipairs(addition) do
          base = append(base, v, opts)
        end
      else
        base = append(base, addition, opts) -- if the base is an assoc arr, and we're gluing a list, we're just gonna treat it as a value to append
      end
    else
      if isListOrEmptyTable(base) then -- if the base is a list, and we're gluing an assoc arr, we're just gonna treat it as a value to append
        base = append(base, addition, opts)
      else
        opts.depth = crementIfNumber(opts.depth, "in")
        opts.recurse = defaultIfNil(opts.recurse, true)
        for k, v in pairs(addition) do
          if type(v) == "table" then
            if not type(base[k]) == "table" or not opts.recurse or opts.recurse < opts.depth then
              base = append(base, {k, v}, opts)
            else
              base[k] = glue(base[k], v, opts)
            end
          else
            base = append(base, {k, v}, opts)
          end
        end
      end
    end
    return base
  end
end
