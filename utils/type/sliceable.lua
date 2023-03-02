--- @class sliceSpec
--- @field start? conditionSpec
--- @field stop? conditionSpec
--- @field step? integer
--- @field sliced_indicator? any
--- @field fill? any

--- @alias sliceLArgOverload fun(thing: any[], start_or_spec?: conditionSpec, stop?: conditionSpec, step?: integer): any[]
--- @alias sliceLSpecOverload fun(thing: any[], start_or_spec: sliceSpec | string): any[]
--- @alias sliceSArgOverload fun(thing: string, start_or_spec?: conditionSpec, stop?: conditionSpec, step?: integer): string
--- @alias sliceSSpecOverload fun(thing: string, start_or_spec: sliceSpec | string): string

--- both start and stop are 1-indexed, for both positive and negative values
--- both start and stop are inclusive
--- @type sliceLArgOverload | sliceLSpecOverload | sliceSArgOverload | sliceSSpecOverload
function slice(thing, start_or_spec, stop, step)

  local spec = {}

  -- parse the slice spec if it's a string or table

  if type(start_or_spec) == "table" then
    spec = tablex.copy(start_or_spec)
  elseif type(start_or_spec) == "string" then
    local stripped_str = stringy.strip(start_or_spec)
    local start_str, stop_str, step_str = onig.match(
      stripped_str, 
      "^\\[?(\\d+)(?::(\\d+))?(?::(\\d+))?\\]?$"
    )
    spec.start = toNumber(start_str, "int", "nil")
    spec.stop = toNumber(stop_str, "int", "nil")
    spec.step = toNumber(step_str, "int", "nil")

  else
    spec.start = start_or_spec
    spec.stop = stop
    spec.step = step
  end

  if not type(spec.start) == "number" then
    spec.start = finder(thing, spec.start)
  end

  if not type(spec.stop) == "number" then
    spec.stop = finder(thing, spec.stop, spec.start)
  end


  -- implement various functions polymorphically depending on the type of thing

  local new_thing = returnEmpty(thing)
  

  -- set defaults

  if not spec.step then spec.step = 1 end
  if not spec.start then spec.start = 1 end
  if not spec.stop then spec.stop = #thing end

  -- resolve negative indices

  if spec.start < 0 then
    spec.start = len(thing) + spec.start + 1
  end
  if spec.stop < 0 then
    spec.stop = len(thing) + spec.stop + 1
  end

  -- clamp indices to ensure we don't go out of bounds

  spec.start = clamp(spec.start, 1, len(thing))
  spec.stop = clamp(spec.stop, 1, len(thing))

  -- handle cases where users have passed conditions that will result in an infinite loop
  -- currently: return empty thing
  -- consider: reverse the step

  if spec.start > spec.stop and spec.step > 0 then
    return new_thing
  elseif spec.start < spec.stop and spec.step < 0 then
    return new_thing
  end

  -- build the slice
  
  for i = spec.start, spec.stop, spec.step do
    new_thing = append(new_thing, elemAt(thing, i))
  end

  if spec.fill then
    local prepend = returnEmpty(thing)
    for i = 1, spec.start - 1 do
      prepend = append(prepend, spec.fill)
    end

    local postpend = returnEmpty(thing)
    for i = spec.stop + 1, len(thing) do
      postpend = append(postpend, spec.fill)
    end

    new_thing = concat(prepend, new_thing, postpend)
  end

  if spec.sliced_indicator and len(new_thing) < len(thing) then
    new_thing = append(new_thing, spec.sliced_indicator)
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

function finder(thing, search, startsearch)
  error("TODO: finder really should just be a polymorphic aspect of `find`")
  startsearch = (startsearch + 1) or 1
  if type(thing) == "string" then
    return onig.find(thing, search, startsearch) 
  else
    return find(slice(thing, startsearch), search, {"v", "k"})
  end
end

function append(thing, addition)
  if type(thing) == "string" then
    return thing .. addition
  else
    local new_thing = tablex.deepcopy(thing)
    new_thing[#new_thing + 1] = addition
    return new_thing
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
