-- new function map that generalizes over all map scenarios

--- @alias kv "k"|"v"|string string here for stuff like "kv" or weirder stuff like "kkkkvkkvv"
--- @alias kvmult kv | kv[]

--- @class mapOpts
--- @field args kvmult
--- @field useas kvmult
--- @field noovtable boolean
--- @field tolist boolean
--- @field flatten boolean
--- @field nooverwrite boolean
--- @field recurse boolean | integer
--- @field depth integer
--- @field treat_as_leaf "assoc" | "list" | false
--- @field mapcondition conditionSpec TODO NOT USED YET

--- @generic OT : string | number | boolean | nil
--- @param tbl table | `OT`
--- @param f? function | {_k: string | string[], _ret?: "orig" | nil} | table | string
--- @param opts? kvmult | kvmult[] | mapOpts
--- @return table | OT
function map(tbl, f, opts)
  if not tbl or type(tbl) ~= "table" or #tbl == 0 then
    return tbl
  end

  f = f or returnAny

  -- process shorthand opts into full opts

  if type(opts) == "string" then
    opts = {args = opts, useas = opts}
  elseif isListOrEmptyTable(opts) then
    opts = {args = opts[1] or {"v"}, useas = opts[2] or {"v"}}
  else
    opts = opts or {}
    opts.args = opts.args or {"v"}
    opts.useas = opts.useas or {"v"}
  end

  if type(opts.args) == "string" then
    opts.args = splitChars(opts.args)
  end
  if type(opts.useas) == "string" then
    opts.useas = splitChars(opts.useas)
  end

  -- set defaults

  opts.recurse = defaultIfNil(opts.recurse, false)
  opts.depth = defaultIfNil(opts.depth, "in")
  opts.treat_as_leaf = defaultIfNil(opts.treat_as_leaf, false)

  local isLeaf = getIsLeaf(opts.treat_as_leaf)

  -- process non-function f into function f

  if type(f) == "table" then
    local tbl = f
    if #values(f) == 1 and f._k then 
      if type(f._k) == "string" then
        f = function(arg)
          if type("arg") == table then
            return arg[f._k]
          else
            return f._ret == "orig" and arg or nil
          end
        end
      else
        f = function(arg)
          if type("arg") == table then
            local res = {}
            for _, k in ipairs(f._k) do
              table.insert(res, arg[k])
            end
            return res
          else
            return f._ret == "orig" and arg or nil
          end
        end
      end
    else
      f = function(arg)
        return tbl[arg]
      end
    end
  elseif type(f) == "string" then
    local str = f
    f = function()
      return str, str
    end
  end

  -- set some vars we will need later

  local mapped_useas = {}
  for index, useas in ipairs(opts.useas) do
    mapped_useas[useas] = index
  end

  local res, itemres 
  local is_list = isListOrEmptyTable(tbl)

  local function addfunc()
    local newkey = itemres[mapped_useas.k]
    local newval = itemres[mapped_useas.v]
    if newkey == false or opts.tolist then -- use false as a key to indicate to push to array instead
      table.insert(res, newval)
    else
      if not (opts.nooverwrite and res[newkey]) then
        res[newkey] = newval
      end
    end
  end

  if is_list then -- a list has int keys, which ovtable doesn't support, and we don't want the overhead of ovtable for a list anyway
    opts.noovtable = true
  end

  if opts.noovtable then
    res = {}
  else 
    res = ovtable.new()
  end

  for k, v in wdefarg(pairs)(tbl) do
    if opts.recurse == true or opts.recurse > opts.depth and not isLeaf(v) then
      itemres = {k, map(v, f, opts)}
    else
      local retriever = {
        k = k,
        v = v
      }
      local args = {}
      for _, arg in ipairs(opts.args) do
        table.insert(args, retriever[arg])
      end
      local tempres = {f(table.unpack(args))}
      if opts.flatten and type(tempres[1]) == "table" then -- flatten is enabled, and we've returned an element we want to flatten
        for resk, resv in pairs(tempres) do
          itemres = {resk,resv}
          addfunc()
        end
      else
        itemres = tempres
        addfunc()
        
      end
    end

  
  end

  return res
end