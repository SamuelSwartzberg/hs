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

  inspPrint(tbl)
  f = f or returnAny
  opts = defaultOpts(opts)
  tbl = getDefaultInput(tbl)

  -- set defaults

  opts.recurse = defaultIfNil(opts.recurse, false)
  if opts.depth == nil then opts.depth = 0 
  else opts.depth = opts.depth + 1 end 
  opts.treat_as_leaf = defaultIfNil(opts.treat_as_leaf, false)

  local isLeaf = getIsLeaf(opts.treat_as_leaf)

  -- process non-function f into function f

  if type(f) == "table" then
    local tblproc = f
    if f._k or f._f then 
      if f._k then
        if type(f._k) == "string" then
          f = function(arg)
            print("hello")
            if type(arg) == "table" and arg[tblproc._k] ~=nil then
              return arg[tblproc._k]
            else
              if tblproc._ret == "orig" then
                print("reting arg")
                return arg
              else
                return nil
              end
            end
          end
        else
          f = function(arg)
            if type(arg) == "table" then
              local res = {}
              for _, k in iprs(tblproc._k) do
                table.insert(res, arg[k])
              end
              return res
            else
              return tblproc._ret == "orig" and arg or nil
            end
          end
        end
      elseif f._f then
        local frmt = f._f
        f = function(...)
          return string.format(frmt, ...)
        end
      end
    else
      f = function(arg)
        return tblproc[arg]
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

  inspPrint(tbl)

  local manual_counter = 0
  for k, v in wdefarg(iterator)(tbl) do
    print("k")
    inspPrint(k)
    inspPrint(res)
    if not opts.mapcondition or findsingle(v, opts.mapcondition) then
      print("depth: " .. opts.depth)
      print("recurse: " .. tostring(opts.recurse))
      if opts.depth > 100 then
        error("map: depth exceeded 100")
      end
      if shouldRecurse(opts) and not (type(v) ~= "table" or isLeaf(v)) then
        addToRes({k, map(v, f, opts)}, res, opts, k, v)
      else
        local retriever
        retriever, manual_counter = getRetriever(tbl, k, v, manual_counter)
        local args = getArgs(retriever, opts)
        inspPrint(args)
        local tempres = {f(table.unpack(args))}
        print("tempres")
        inspPrint(tempres)
        print("v")
        inspPrint(v)
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