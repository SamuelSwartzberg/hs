--- @alias startstoplike integer | string

--- @alias sliceSpec {start: startstoplike, stop?: startstoplike, step?: integer}
--- @alias sliceLArgOverload fun(thing: any[], start_incl_or_spec?: startstoplike, stop_incl?: startstoplike, step?: integer): any[]
--- @alias sliceLSpecOverload fun(thing: any[], start_incl_or_spec: sliceSpec | string): any[]
--- @alias sliceSArgOverload fun(thing: string, start_incl_or_spec?: startstoplike, stop_incl?: startstoplike, step?: integer): string
--- @alias sliceSSpecOverload fun(thing: string, start_incl_or_spec: sliceSpec | string): string

--- both start and stop are 1-indexed, for both positive and negative values
--- both start and stop are inclusive
--- @type sliceLArgOverload | sliceLSpecOverload | sliceSArgOverload | sliceSSpecOverload
function slice(thing, start_incl_or_spec, stop_incl, step)
  local start_incl

  -- parse the slice spec if it's a string or table

  if type(start_incl_or_spec) == "table" then
    start_incl = start_incl_or_spec.start
    stop_incl = start_incl_or_spec.stop
    step = start_incl_or_spec.step
  elseif type(start_incl_or_spec) == "string" then
    local stripped_str = stringy.strip(start_incl_or_spec)
    local start_str, stop_str, step_str = onig.match(
      stripped_str, 
      "^\\[?(\\d+)(?::(\\d+))?(?::(\\d+))?\\]?$"
    )
    start_incl = toNumber(start_str, "int", "nil")
    stop_incl = toNumber(stop_str, "int", "nil")
    step = toNumber(step_str, "int", "nil")

  else
    start_incl = start_incl_or_spec
  end

  local function startstoplike_pos(search, startsearch)
    startsearch = (startsearch + 1) or 1
    if type(thing) == "string" then
      return onig.find(thing, search, startsearch) 
    else
      return find(slice(thing, startsearch), search, {"v", "k"})
    end
  end

  if type(start_incl) == "string" then
    start_incl = startstoplike_pos(start_incl)
  end

  if type(stop_incl) == "string" then
    stop_incl = startstoplike_pos(stop_incl, start_incl)
  end


  -- implement various functions polymorphically depending on the type of thing

  local len_func, new_thing
  if type(thing) == "string" then
    len_func = eutf8.len
    new_thing = ""
    append_func = function(str, ind)
      return str .. eutf8.sub(thing, ind, ind)
    end
  else
    len_func = function(t)
      return #t
    end
    new_thing = {}
    append_func = function(t, ind)
      t[#t + 1] = thing[ind]
      return t
    end
  end

  -- set defaults

  if not step then step = 1 end
  if not start_incl then start_incl = 1 end
  if not stop_incl then stop_incl = #thing end

  -- resolve negative indices

  if start_incl < 0 then
    start_incl = len_func(thing) + start_incl + 1
  end
  if stop_incl < 0 then
    stop_incl = len_func(thing) + stop_incl + 1
  end

  -- clamp indices to ensure we don't go out of bounds

  start_incl = clamp(start_incl, 1, len_func(thing))
  stop_incl = clamp(stop_incl, 1, len_func(thing))

  -- handle cases where users have passed conditions that will result in an infinite loop
  -- currently: return empty thing
  -- consider: reverse the step

  if start_incl > stop_incl and step > 0 then
    return new_thing
  elseif start_incl < stop_incl and step < 0 then
    return new_thing
  end

  -- build the slice and return it
  
  for i = start_incl, stop_incl, step do
    new_thing = append_func(new_thing, i)
  end
  return new_thing
end

function elemAt(thing, ind)
  if type(thing) == "string" then
    return eutf8.sub(thing, ind, ind)
  else
    return thing[ind]
  end
end

function rev(thing)
  if type(thing) == "string" then
    return eutf8.reverse(thing)
  else
    local new_list = {}
    for i = #thing, 1, -1 do
      new_list[#new_list + 1] = thing[i]
    end
    return new_list
  end
end

function len(thing)
  if type(thing) == "string" then
    return eutf8.len(thing)
  else
    return #thing
  end
end

function glue(base, addition)
  if type(base) == "string" then
    return base .. addition
  else
    if not base then base = {} 
    else base = tablex.deepcopy(base) end
    if type(addition) == "nil" then
      -- do nothing
    elseif not isListOrEmptyTable(addition) then
      base[#base + 1] = addition
    else
      for _, v in ipairs(addition) do
        base[#base + 1] = v
      end
    end
    return base
  end
end


--- @class prefixOpts
--- @field rev boolean

--- @generic T : string|any[]
--- @param list `T`[]
--- @param opts? prefixOpts
--- @return T
function longestCommonPrefix(list, opts)
  opts = tablex.deepcopy(opts) or {}
  if opts.rev then
    list = map(list, rev)
  end

  local res = reduce(list, function(acc, thing)
    local isstring =type(thing) == "string"
    local last_matching_index = 0
    for i = 1, len(thing) do
      if elemAt(thing, i) == elemAt(acc, i) then
        last_matching_index = i
      else
        break
      end
    end

    return slice(acc, 1, last_matching_index) or ( isstring and "" or {} )
  end, list[1])

  if opts.rev then
    res = rev(res)
  end

  return res
end

--- @class concatOpts
--- @field isopts "isopts"
--- @field sep? any | any[]

--- @generic T, U
--- @param ... T[] | T | nil
--- @return (T | U)[]
function concat(...)
  local lists = {...}
  if not opts then return {} end
  if type(opts) == "table" and opts.isopts == "isopts" then
    -- no-op
  else -- opts is actually the first list
    table.insert(lists, 1, opts)
    opts = {}
  end

  if #lists == 1 and isListOrEmptyTable(lists[1]) then
    lists = lists[1]
  end

  local new_list = {}
  for i, list in ipairs(lists) do
    glue(new_list, list)
    if opts.sep then
      local sep
      if type(opts.sep) == "table" then
        sep = opts.sep[i]
      else
        sep = opts.sep
      end
      glue(new_list, sep)
    end
  end
  return new_list
end

--- @generic T : string|any[]
--- @param thing T
--- @param n integer
--- @return T
function multiply(thing, n)
  local newthing = {}
  for i = 1, n do
    newthing = concat(newthing, thing)
  end
  return newthing
end
