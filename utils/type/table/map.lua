-- new function map that generalizes over all map scenarios

--- @alias kv "k"|"v"|string string here for stuff like "kv" or weirder stuff like "kkkkvkkvv"
--- @alias kvmult kv | kv[]

--- @class mapOpts
--- @field args kvmult
--- @field useas kvmult
--- @field noovtable boolean
--- @field tolist boolean
--- @field flatten boolean
--- @field mapcondition conditionSpec TODO NOT USED YET

--- @generic OT : string | number | boolean | nil
--- @param tbl table | `OT`
--- @param f? function | table | string
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

  -- process non-function f into function f

  if type(f) == "table" then
    local tbl = f
    f = function(arg)
      return tbl[arg]
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
      res[newkey] = newval
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

  return res
end