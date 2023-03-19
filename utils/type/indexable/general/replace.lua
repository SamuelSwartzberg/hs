
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
  opts = tablex.deepcopy(opts) or {}
  if not isListOrEmptyTable(opts) then opts = {opts} end

  --- allow for tr-like operation with two lists
  if #opts == 2 and isListOrEmptyTable(opts[1]) and isListOrEmptyTable(opts[2]) then
    local resolvedopts = {}
    for i = 1, #opts[1] do
      push(resolvedopts, {cond = opts[1][i], proc = opts[2][i]})
    end
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
  for _, opt in ipairs(opts) do
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
    local parts, removed = split(res, cond, opts)
    removed = map(removed, returnUnpack, {"v", "kv"})
  
    local sep
    if mode == "replace" and not (type(proc) == "string" or isListOrEmptyTable(proc)) then -- we actually have to process the removed items to get the new items
      sep = map(
        removed,
        proc,
        {opts.args or "v", "v"}
      )    
    elseif mode == "remove" then
      -- no-op
    else
      sep = opts.processor
    end
    res = concat({
      isopts = "isopts",
      sep = sep,
    }, parts)
  end
  return res
end