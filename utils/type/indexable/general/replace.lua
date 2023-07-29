
--- @alias procSpec string | any[] | mapProcessor

--- @class replaceOpts : splitOpts
--- @field mode? "before" | "after" | "replace" | "remove" what to do with the matched element. "before" and "after" will insert the (result of the) proc before or after the matched element, "replace" will replace the matched element with the proc, and "remove" will remove the matched element without using the proc
--- @field args kvmult controls what arguments are passed to the proc
--- @field ret kvmult
--- @field cond? conditionSpec the condition to match
--- @field proc? procSpec the proc to run on the matched element

--- @alias conditonProcSpecPair (conditionSpec | procSpec)[] imagine the type annotation was actually [conditionSpec, procSpec] but lua doesn't support that
--- @alias replaceSpec replaceOpts | conditonProcSpecPair
--- @alias conditionProcSpecParallelList (conditionSpec[] | procSpec[])[] imagine the type annotation was actually [conditionSpec[], procSpec[]] but lua doesn't support that

--- replace elements in an indexable
--- @generic T : indexable
--- @param thing T
--- @param opts? replaceOpts | replaceSpec[] | conditionProcSpecParallelList thus you can all it as replace(<thing>, { cond = ..., ...}), replace(<thing>, { {cond = ..., ...}, {cond = ..., ...}, ...}), or replace(<thing>, { {cond1, proc1}, {cond2, proc2}, ...}), or replace(<thing>, { {cond1, cond2, ...}, {proc1, proc2, ...} })
--- @param globalopts? replaceOpts global options that will be used if the options are not specified on the current opt element, which is especially useful when using non-assoc array syntax to specify the opts
--- @return T
function replace(thing, opts, globalopts)
  if opts == nil then return thing end
  opts = get.table.copy(opts) or {}
  if not is.any.array(opts) then opts = {opts} end

  --- allow for tr-like operation with two lists
  if #opts == 2 and is.any.array(opts[1]) and is.any.array(opts[2]) then
    local resolvedopts = {}
    local lastproc
    for i = 1, #opts[1], 1 do
      lastproc = opts[2][i] or lastproc
      dothis.array.push(resolvedopts, {cond = opts[1][i], proc = lastproc})
    end
    opts = resolvedopts
  end


  -- opts get set with the following precedence:
  -- 1. opts on the current opt element
  -- 2. opts on the globalopts
  -- 3. opts of the previous opt element
  -- 4. default opts
  -- however, if the current opt has a proc of type table, then the cond will be overwritten unless it is explicitly set

  globalopts = globalopts or {}
  local mode, args, ret, cond, proc, findopts, limit = globalopts.mode, globalopts.args, globalopts.ret, globalopts.cond, globalopts.proc, globalopts.findopts, globalopts.limit
  mode = get.any.default_if_nil(mode, "replace")
  cond = get.any.default_if_nil(cond, "\"")
  proc = get.any.default_if_nil(proc, "\\")

  local res = thing
  for _, opt in transf.array.index_value_stateless_iter(opts) do
    if is.any.pair(opt) then
      opt = {cond = opt[1], proc = opt[2]}
    end
    matchall = get.any.default_if_nil(opt.matchall, matchall)
    mode = get.any.default_if_nil(opt.mode, mode)
    args = get.any.default_if_nil(opt.args, args)
    ret = get.any.default_if_nil(opt.ret, ret)
    cond = get.any.default_if_nil(opt.cond, cond)
    proc = get.any.default_if_nil(opt.proc, proc)
    limit = get.any.default_if_nil(opt.limit, limit)

  
    if not opt.cond and type(proc) == "table" and not is.table.array(proc) then
      cond = {_list = transf.table_or_nil.key_array(proc)} -- if no condition is specified, use the keys of the processor table as the condition
    end
  
    local splitopts = {
      mode = mode,
      findopts = findopts,
      limit = limit
    }
    if splitopts.mode == "replace" then
      splitopts.mode = "remove"
    end
    local parts, removed = split(res, cond, splitopts)
    removed = map(removed, function(mapv)
      if is.any.array(mapv) and #mapv == 1 then
        mapv = mapv[1]
      end
      return false, mapv
    end, {"v", "kv"}) 
    local sep
    if mode == "replace" then -- we actually have to process the removed items to get the new items
      if
        not (is.any.array(proc) or type(proc) == "string")  -- proc must be processed by map
        or (type(thing) == "table" and not is.any.array(thing))  -- thing must be processed by map
      then
        sep = map(
          removed,
          proc,
          {
            args = args, 
            ret = ret,
            recurse = 2,
          }
        )
      else
        sep = proc
      end
    elseif mode == "remove" then
      -- no-op
    else
      sep = proc
    end


    local needs_type_added = #parts == 0 or (is.any.array(parts[1]) and #parts[1] == 0)

    -- if there is no first element, or the first element is an empty list, then we need to add a type to the first element, since concat infers how it should concat based on the first element
    if needs_type_added then
      if type(thing) == "table" then
        if not is.table.array(thing) then
          if thing.isovtable then
            parts[1] = ovtable.new() -- due to the check above, we know that we're not overwriting any information. Same for below
          else
            parts[1] = transf.table.determined_assoc_arr_table({})
          end
        else
          parts[1] = transf.table.determined_array_table({})
        end
      end
    end
    res = concat({
      isopts = "isopts",
      sep = sep,
    }, parts)
  end
  return res
end