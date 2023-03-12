-- new function map that generalizes over all map scenarios

--- @alias kv "k"|"v"|string string here for stuff like "kv" or weirder stuff like "kkkkvkkvv"
--- @alias kvmult kv | kv[]

--- @class mapOpts : tableProcOpts
--- @field flatten boolean
--- @field nooverwrite boolean
--- @field recurse boolean | integer
--- @field depth integer
--- @field treat_as_leaf "assoc" | "list" | false
--- @field mapcondition conditionSpec TODO NOT USED YET

--- @alias mapProcessor function | {_k: string | string[], _ret?: "orig" | nil} | {_f: string} | table | string

--- @generic OT : string | number | boolean | nil
--- @param tbl table | `OT`
--- @param f? mapProcessor
--- @param opts? kvmult | kvmult[] | mapOpts
--- @return table | OT
function map(tbl, f, opts)

  f = f or returnAny
  opts = defaultOpts(opts)
  tbl = getDefaultInput(tbl, opts)

  -- set defaults

  opts.recurse = defaultIfNil(opts.recurse, false)
  opts.depth = crementIfNumber(opts.depth, "in")
  opts.treat_as_leaf = defaultIfNil(opts.treat_as_leaf, false)

  local isLeaf = getIsLeaf(opts.treat_as_leaf)

  -- process non-function f into function f

  if type(f) == "table" then
    local tbl = f
    if #values(f) == 1 then 
      if f._k then
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
      elseif f._f then
        local frmt
        f = function(...)
          return string.format(frmt, ...)
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

  local iterator = getIterator(tbl, opts)
  local res = getEmptyResult(tbl, opts)


  for k, v in wdefarg(iterator)(tbl) do
    if not opts.mapcondition or findsingle(v, opts.mapcondition) then
      if opts.recurse == true or opts.recurse > opts.depth and not isLeaf(v) then
        addToRes({k, map(v, f, opts)}, res, opts, k, v)
      else
        local args = getArgs(opts.args, k, v)
        local tempres = {f(table.unpack(args))}
        if opts.flatten and type(tempres[1]) == "table" then -- flatten is enabled, and we've returned an element we want to flatten
          for resk, resv in pairs(tempres) do
            addToRes({resk,resv}, res, opts, k, v)
          end
        else
          addToRes(tempres, res, opts, k, v)
          
        end
      end
    else
      addToRes({k, v}, res, opts, k, v)
    end

  
  end

  return res
end