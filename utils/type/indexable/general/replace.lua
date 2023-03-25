
--- @alias procSpec string | any[] | mapProcessor

--- @class replaceOpts : splitOpts
--- @field mode? "before" | "after" | "replace" | "remove" what to do with the matched element. "before" and "after" will insert the (result of the) proc before or after the matched element, "replace" will replace the matched element with the proc, and "remove" will remove the matched element without using the proc
--- @field args kvmult controls what arguments are passed to the proc
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
  opts = copy(opts) or {}
  if not isListOrEmptyTable(opts) then opts = {opts} end

  --- allow for tr-like operation with two lists
  if #opts == 2 and isListOrEmptyTable(opts[1]) and isListOrEmptyTable(opts[2]) then
    local resolvedopts = {}
    for i = 1, #opts[1] do
      push(resolvedopts, {cond = opts[1][i], proc = opts[2][i]})
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
  local mode, args, cond, proc, findopts = globalopts.mode, globalopts.args, globalopts.cond, globalopts.proc, globalopts.findopts
  mode = defaultIfNil(mode, "before")
  cond = defaultIfNil(cond, "\"")
  proc = defaultIfNil(proc, "\\")

  local res = thing
  for _, opt in iprs(opts) do
    if isListOrEmptyTable(opt) and #opt == 2 then
      opt = {cond = opt[1], proc = opt[2]}
    end
    matchall = defaultIfNil(opt.matchall, matchall)
    mode = defaultIfNil(opt.mode, mode)
    args = defaultIfNil(opt.args, args)
    cond = defaultIfNil(opt.cond, cond)
    proc = defaultIfNil(opt.proc, proc)

  
    if not opt.cond and type(proc) == "table" and not isListOrEmptyTable(proc) then
      cond = {_list = keys(proc)} -- if no condition is specified, use the keys of the processor table as the condition
    end
  
    local splitopts = {
      mode = mode,
      findopts = findopts
    }
    if splitopts.mode == "replace" then
      splitopts.mode = "remove"
    end
    local parts, removed = split(res, cond, splitopts)
    inspPrint(parts)
    inspPrint(removed)
    -- removed = map(removed, returnUnpack, {"v", "kv"}) TODO: uncomment once we've reached the map tests without failing
  
    local sep
    if mode == "replace" then -- we actually have to process the removed items to get the new items
      if
        not (isListOrEmptyTable(proc) or type(proc) == "string")  -- proc must be processed by map
        or (type(thing) == "table" and not isListOrEmptyTable(thing))  -- thing must be processed by map
      then
        error("currently, using this is not supported since we need to test map first")
        sep = map(
          removed,
          proc,
          {args or "v", "v"}
        )
      else
        sep = proc
      end
    elseif mode == "remove" then
      -- no-op
    else
      sep = proc
    end
    inspPrint(sep)
    -- TODO: if every element in thing is replaced, parts will be an empty list. In that case, concat won't be able to infer what type of indexable to return, so we need some way to solve that. We could have sep be parts in that case? Or maybe there's a better way?
    res = concat({
      isopts = "isopts",
      sep = sep,
    }, parts)
  end
  return res
end