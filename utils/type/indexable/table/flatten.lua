
--- @class flattenItems
--- @field path boolean
--- @field depth boolean
--- @field value boolean
--- @field keystop boolean
--- @field valuestop boolean

--- @alias flattenItemsArr ("path" | "depth" | "value" | "keystop" | "valuestop" )[]

--- @class flattenOpts
--- @field treat_as_leaf? "assoc" | "list" | false
--- @field mode? "list" | "path-assoc" | "assoc"
--- @field val? boolean | "plain" |  "path" | "depth" | "keystop" | "valuestop" | flattenItemsArr | flattenItems
--- @field join_path? string
--- @field recurse? boolean | integer `false` means no recursion, `true` means infinite recursion, `integer` means recursion up to that depth
--- @field path? any[]
--- @field depth? integer
--- @field indentation? integer only relevant if val.keystop is true
--- @field nooverwrite? boolean

--- @param tbl table
--- @param opts? flattenOpts
--- @return table
function flatten(tbl, opts)

  if not opts then opts = {} 
  else opts = copy(opts) end

  -- set defaults

  opts.treat_as_leaf = defaultIfNil(opts.treat_as_leaf, "assoc")
  opts.mode = defaultIfNil(opts.mode, "list")
  opts.val = defaultIfNil(opts.val, "plain")
  opts.recurse = defaultIfNil(opts.recurse, true)
  opts.path = defaultIfNil(opts.path, {})
  opts.depth = crementIfNumber(opts.depth, "in")
  opts.indentation = defaultIfNil(opts.indentation, 2)

  -- process incl shorthand

  if type(opts.val) == "boolean" then
    opts.val = {
      path = opts.val,
      depth = opts.val,
      value = opts.val
    }
  elseif isListOrEmptyTable(opts.val) then
    local newval = {}
    for _, v in iprs(opts.val) do
      newval[v] = true
    end
    opts.val = newval
  elseif type(opts.val) == "string" then
    if opts.val == "plain" then
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
    if opts.val == "plain" then 
      res_should_be_plain = true
      opts.val = {} 
    end
    opts.val.path = true
  end

  -- create leaf detector

  local isLeaf = getIsLeaf(opts.treat_as_leaf)

  local addfunc
  if opts.mode == "list" or opts.mode == "path-assoc" then
    addfunc = push
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
    if opts.val == "plain" then
      addfunc(tbl, v, k)
    else
      local newitem = {}
      if opts.val.value then newitem.value = v end
      if opts.val.path then newitem.path = concat(opts.path, k) end
      if opts.val.depth then newitem.depth = opts.depth end
      if opts.val.valuestop then newitem.valuestop = #v end
      if opts.val.keystop then newitem.keystop = (opts.depth) * opts.indentation + #k end
      addfunc(tbl, newitem, k)
    end
  end

  local res

  for k, v in prs(tbl) do
    if isLeaf(v) then
      valAddfunc(res, v, k)
    else
      if opts.recurse == true or opts.recurse > opts.depth then
        local newopts = copy(opts)
        newopts.path = concat(opts.path, k)
        local subres = flatten(v, newopts)
        for k, v in prs(subres) do
          valAddfunc(res, v, k)
        end
      else
        valAddfunc(res, v, k)
      end
    end
  end

  if opts.join_path and opts.depth == 0 then
    for k, v in prs(res) do
      v.path = table.concat(v.path, opts.join_path)
    end
  end
  
  if opts.mode == "path-assoc" and opts.depth == 0 then
    local newres = {}
    for k, v in prs(res) do
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