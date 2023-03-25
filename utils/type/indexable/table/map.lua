--- @alias kv "k"|"v"|"i"|string string here for stuff like "kv" or weirder stuff like "kkkkvkkvv". "i" is for indices when they need to be distinguished from keys
--- @alias kvmult kv | kv[]

--- @class mapOpts : tableProcOpts
--- @field flatten? boolean whether to flatten the result into the root tbl
--- @field nooverwrite? boolean whether to overwrite existing keys
--- @field recurse? boolean | integer whether/how to recurse into subtables
--- @field depth? integer the current depth of recursion, if any. only used internally
--- @field treat_as_leaf? "assoc" | "list" | false what to treat as a leaf node (i.e. what to not recurse into)
--- @field mapcondition? conditionSpec TODO NOT IMPLEMENTED YET

--- mapProcessor will processed into a function as follows:
---   - if it's a function, it's used as is
---   - if it's a table with a _k field, the arg is treated as a table, and the value of _k is used as the key to get the value from the table
---     - in that case, the _ret field determines the behavior if the arg is not a table. if _ret is "orig", the arg is returned, otherwise nil is returned
---   - if it's a table with a _f field, the arg is treated as a format string, and the arg(s) is/are used as the arguments to string.format
---  - if it's a generic table with none of the above, the arg is treated as a key, and the value of that key is returned
---  - if it's a string, that same string is returned as both the key and the value, without caring about the arg at all (this seems odd, but allows some useful ops when combined with the `ret` option of mapOpts)
--- @alias mapProcessor function | {_k: string | string[], _ret?: "orig" | nil} | {_f: string} | table | string


--- @param tbl table
--- @param f? mapProcessor
--- @param opts? kvmult | kvmult[] | mapOpts
--- @return table
function map(tbl, f, opts)

  f = f or returnAny
  opts = defaultOpts(opts)
  tbl = getDefaultInput(tbl)

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
            if type(arg) == table then
              return arg[f._k]
            else
              return f._ret == "orig" and arg or nil
            end
          end
        else
          f = function(arg)
            if type("arg") == table then
              local res = {}
              for _, k in iprs(f._k) do
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

  local iterator = getIterator(opts)
  local res = getEmptyResult(tbl, opts)

  local manual_counter = 0
  for k, v in wdefarg(iterator)(tbl) do
    if not opts.mapcondition or findsingle(v, opts.mapcondition) then
      if opts.recurse == true or opts.recurse > opts.depth and not isLeaf(v) then
        addToRes({k, map(v, f, opts)}, res, opts, k, v)
      else
        local retriever
        retriever, manual_counter = getRetriever(tbl, k, v, manual_counter)
        local args = getArgs(retriever, opts)
        local tempres = {f(table.unpack(args))}
        if opts.flatten and type(tempres[1]) == "table" then -- flatten is enabled, and we've returned an element we want to flatten
          for resk, resv in prs(tempres) do
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