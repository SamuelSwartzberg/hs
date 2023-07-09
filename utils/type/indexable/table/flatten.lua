
--- @class flattenItems For each, if true, the flattened result will include the corresponding value from the original table. Default is false.
--- @field path boolean
--- @field depth boolean
--- @field key boolean
--- @field value boolean
--- @field keystop boolean
--- @field valuestop boolean

--- @alias flattenItemsArr ("path" | "depth" | "key" | "value" | "keystop" | "valuestop" )[] An array of strings, each string represents a key of the flattenItems class.

--- @class flattenOpts
--- @field treat_as_leaf? "assoc" | "list" | boolean Defines what type of value should be treated as a leaf node during the flatten operation, besides all primitive values. Default is "assoc".
--- @field add_nonleaf? boolean If true, the function will add non-leaf nodes to the output table. Default is false.
--- @field mode? "list" | "path-assoc" | "assoc" Defines how the output should be structured. "list" for a flat list, "path-assoc" for an associative array with paths as keys, "assoc" for a generic associative array. Default is "list".
--- @field val? boolean | "plain-value" | "plain-key" | "path" | "depth" | "key" | "keystop" | "valuestop" | flattenItemsArr | flattenItems Defines what values to include in the flattened result. Default is "plain-value", which means the value of the original table will be included in the flattened result.
--- @field join_path? string The string used to join path segments when constructing the string path. Relevant only if the mode is "path-assoc" or if the val includes "path". Default is nil.
--- @field recurse? boolean | integer Defines how deep the recursion should go when flattening. False means no recursion, true means infinite recursion, and an integer means recursion up to that depth. Default is true.
--- @field path? any[]
--- @field depth? integer Specifies the initial depth level to start the flattening from. Default is 0. In general, this should not be set by the user, rather the `recurse` option should be used instead. This field is mainly used internally to keep track of the current depth level.
--- @field indentation? integer: Specifies the number of spaces per depth level for keystop calculation. Relevant only if val.keystop is true. Default is 2.
--- @field nooverwrite? boolean If true, the function will not overwrite existing values in the output table. Default is false.

--- @param tbl table The table to flatten.
--- @param opts? flattenOpts An optional set of options for the flatten operation.
--- @param visited? table An optional table to keep track of already visited nodes during the flatten operation to avoid infinite recursion.
--- @return table The table resulting from the flatten operation, structured according to the provided options.
function flatten(tbl, opts, visited)

  if not opts then opts = {} 
  else opts = get.table.copy(opts) end
  visited = get.any.default_if_nil(visited, {})

  -- set defaults

  opts.treat_as_leaf = get.any.default_if_nil(opts.treat_as_leaf, "assoc")
  opts.add_nonleaf = get.any.default_if_nil(opts.add_nonleaf, false)
  opts.mode = get.any.default_if_nil(opts.mode, "list")
  opts.val = get.any.default_if_nil(opts.val, "plain-value")
  opts.recurse = get.any.default_if_nil(opts.recurse, true)
  opts.path = get.any.default_if_nil(opts.path, {})
  if opts.depth == nil then opts.depth = 0 
  else opts.depth = opts.depth + 1 end
  opts.indentation = get.any.default_if_nil(opts.indentation, 2)

  -- process incl shorthand

  if type(opts.val) == "boolean" then
    opts.val = {
      path = opts.val,
      depth = opts.val,
      value = opts.val
    }
  elseif is.any.array(opts.val) then
    local newval = {}
    for _, v in transf.array.index_value_stateless_iter(opts.val) do
      newval[v] = true
    end
    opts.val = newval
  elseif type(opts.val) == "string" then
    if opts.val == "plain-value" then
      -- no-op
    else
      local key = opts.val
      opts.val = {}
      opts.val[key] = true
      opts.val.value = true
    end
  end

  local path_in_res, res_should_be_plain
  if opts.join_path or opts.mode == "path-assoc" then
    path_in_res = opts.val.path -- whether the path is supposed to be in the result,
    if opts.val == "plain-value" then 
      res_should_be_plain = true
      opts.val = {} 
    end
    opts.val.path = true
    opts.val.value = true
  end

  -- create leaf detector

  local isLeaf = getIsLeaf(opts.treat_as_leaf)

  local addfunc
  if opts.mode == "list" or opts.mode == "path-assoc" then
    addfunc = dothis.array.push
  elseif opts.mode == "assoc" then
    addfunc = function(tbl, item, key) 
      if not opts.nooverwrite or not tbl[key] then
        tbl[key] = item
      end
    end
  else
    error("flatten: invalid value for opts.mode: " .. tostring(opts.mode))
  end

  local function valAddfunc(tbl, v, k)
    if opts.val == "plain-value" then
      addfunc(tbl, v, k)
    elseif opts.val == "plain-key" then
      addfunc(tbl, k, k)
    else
      local newitem = {}
      if opts.val.value then newitem.value = v end
      if opts.val.key then newitem.key = k end
      if opts.val.path then newitem.path = concat(opts.path, k) end
      if opts.val.depth then newitem.depth = opts.depth end
      if opts.val.valuestop then newitem.valuestop = #v end
      if opts.val.keystop then newitem.keystop = (opts.depth) * opts.indentation + #k end
      addfunc(tbl, newitem, k)
    end
  end

  if opts.mode ~= "list" then -- force output to be an assoc arr if we need to
    opts.output = "table"
  end

  local res = getEmptyResult(tbl, opts)
  visited[tostring(tbl)] = res

  for k, v in get.indexable.key_value_stateless_iter(tbl) do
    if type(v) ~= "table" or isLeaf(v) then
      valAddfunc(res, v, k)
    else
      if shouldRecurse(opts) then
        if opts.add_nonleaf then
          valAddfunc(res, v, k)
        end
        local newopts = get.table.copy(opts)
        newopts.path = concat(opts.path, k)
        local subres
        if visited[tostring(v)] then
          subres = visited[tostring(v)]
        else
          subres = flatten(v, newopts, visited)
        end
        for subk, subv in get.indexable.key_value_stateless_iter(subres) do
          addfunc(res, subv, subk)
        end
      else
        valAddfunc(res, v, k)
      end
    end
  end

  if opts.join_path and opts.depth == 0 then
    for k, v in get.indexable.key_value_stateless_iter(res) do
      v.path = table.concat(v.path, opts.join_path)
    end
  end
  
  if opts.mode == "path-assoc" and opts.depth == 0 then
    local newres = {}
    for k, v in transf.array.index_value_stateless_iter(res) do
      local val
      if res_should_be_plain then
        val = v.value
      else
        val = v
        if not path_in_res then val.path = nil end
      end
      newres[v.path] = val
    end
    res = newres
  end

  return res
end