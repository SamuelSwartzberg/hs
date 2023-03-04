---@alias indexable string|any[]|orderedtable

--- @class sliceSpec
--- @field start? conditionSpec
--- @field stop? conditionSpec
--- @field step? integer
--- @field sliced_indicator? any
--- @field fill? any
--- @field last_start? boolean
--- @field last_stop? boolean

--- @generic T : indexable
--- @param thing T
--- @param start_or_spec conditionSpec|sliceSpec
--- @param stop? conditionSpec
--- @param step? integer
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
    spec.start = find(thing, spec.start, {ret = "k", last = spec.last_start})
  end

  if not type(spec.stop) == "number" then
    spec.stop = find(thing, spec.stop, {ret = "k", start = spec.start, last = spec.last_stop})
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


---@param thing indexable
---@param ind any
---@return any
function elemAt(thing, ind)
  if type(thing) == "string" then
    return eutf8.sub(thing, ind, ind)
  elseif type(thing) == "table" then
    if isListOrEmptyTable(thing) then
      return thing[ind]
    else
      return thing:getindex(ind)
    end
  end
end

---@generic T : indexable
---@param thing T
---@return T
function rev(thing)
  if type(thing) == "string" then
    return eutf8.reverse(thing)
  elseif type(thing) == "table" then
    if isListOrEmptyTable(thing) then
      local new_list = {}
      for i = #thing, 1, -1 do
        new_list[#new_list + 1] = thing[i]
      end
      return new_list
    else
      return iterToTable(thing:revpairs())
    end
  else
    error("rev only works on strings, lists, and tables. got " .. type(thing) .. " when processing:\n\n" .. json.encode(thing))
  end
end

---@param thing indexable
---@return integer
function len(thing)
  if type(thing) == "string" then
    return eutf8.len(thing)
  elseif type(thing) == "table" then
    if isListOrEmptyTable(thing) then
      return #thing
    else
      return #values(thing)
    end
  else
    error("len only works on strings, lists, and tables. got " .. type(thing) .. " when processing:\n\n" .. json.encode(thing))
  end
end

---@class appendOpts
---@field nooverwrite? boolean

---add a single element to an indexable
---@generic T : indexable
---@param base `T`
---@param addition any
---@param opts? appendOpts
---@return T
function append(base, addition, opts)
  opts = opts or {}
  if type(base) == "string" then
    if not base then base = "" end
    if not addition then return base end
    return base .. addition
  elseif type(base) == "table" then
    local new_thing = tablex.deepcopy(base) 
    if not addition then return new_thing end
    if isListOrEmptyTable(base) then
      new_thing[#new_thing + 1] = addition
      return new_thing
    else
      if base.isassoc == "isassoc" then base.isassoc = nil end
      if #values(addition) >= 2 then
        if not opts.nooverwrite or not new_thing[addition[1]] then
          new_thing[addition[1]] = addition[2]
        end
        return new_thing
      else
        error("can't append a non-pair to an assoc arr")
      end
    end
  else
    error("append only works on strings, lists, and tables. got " .. type(base) .. " when processing:\n\n" .. json.encode(base))
  end
end

---@class glueOpts : appendOpts
---@field recurse? boolean | number
---@field depth? number

---add a single element to an indexable, but where that element may be mushed into the base in the process
---@generic T : indexable
---@param base `T`
---@param addition any
---@param opts? glueOpts
---@return T
function glue(base, addition, opts)
  opts = opts or {}
  if type(addition) ~= "table" then
    return append(base, addition, opts)
  else
    if isListOrEmptyTable(addition) then
      if isListOrEmptyTable(base) then
        for _, v in ipairs(addition) do
          base = append(base, v, opts)
        end
      else
        base = append(base, addition, opts) -- if the base is an assoc arr, and we're gluing a list, we're just gonna treat it as a value to append
      end
    else
      if isListOrEmptyTable(base) then -- if the base is a list, and we're gluing an assoc arr, we're just gonna treat it as a value to append
        base = append(base, addition, opts)
      else
        opts.depth = crementIfNumber(opts.depth, "in")
        opts.recurse = defaultIfNil(opts.recurse, true)
        for k, v in pairs(addition) do
          if type(v) == "table" then
            if not type(base[k]) == "table" or not opts.recurse or opts.recurse < opts.depth then
              base = append(base, {k, v}, opts)
            else
              base[k] = glue(base[k], v, opts)
            end
          else
            base = append(base, {k, v}, opts)
          end
        end
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

--- @class concatOpts : glueOpts
--- @field isopts "isopts"
--- @field sep? any | any[]


--- @generic T : indexable
--- @param opts? concatOpts
--- @param ... T
--- @return T
function concat(opts, ...)
  local inputs = {...}
  if not opts then return {} end
  if type(opts) == "table" and opts.isopts == "isopts" then
    -- no-op
  else -- opts is actually the first list
    table.insert(inputs, 1, opts)
    opts = {}
  end

  if #inputs == 1 and isListOrEmptyTable(inputs[1]) then -- was called with a single list instead of varargs, but we can handle that
    inputs = inputs[1]
  end

  local outputs = {}
  local sep
  for i, input in ipairs(inputs) do
    if sep then
      outputs = glue(outputs, sep)
    end
    outputs = glue(outputs, input)
    if opts.sep then
      if isListOrEmptyTable(sep) then
        sep = opts.sep[i]
      else
        if opts.sep._contains then -- since we can split by a conditionSpec, we want to be able to use a conditionSpec as a separator to rejoin. However, _contains is the only value of a conditionSpec where we can be sure that using it as a separator will recreate the original list (all others are not reversible)
          sep = opts.sep._contains
        else
          sep = opts.sep
        end
      end
      
    end
  end
  return outputs
end

--- @generic T : indexable
--- @param thing T
--- @param n integer
--- @param opts? concatOpts
--- @return T
function multiply(thing, n, opts)
  local newthing = {}
  for i = 1, n do
    newthing = concat(newthing, thing, opts)
  end
  return newthing
end

--- @class splitOpts
--- @field includesep? boolean
--- @field findopts? findOptsWShorthand

--- @generic T : indexable
--- @param thing T
--- @param sep conditionSpec
--- @param opts? splitOpts
--- @return T[]
function split(thing, sep, opts)
  opts = tablex.deepcopy(opts) or {}
  local splintervals = find(
    thing,
    sep,
    {
      ret = "kv",
      findall = true
    }
  )

  if len(splintervals) <= 1 then
    return {thing}
  end

  local res = {}
  local lastend = 1
  for _, pair in ipairs(splintervals) do
    local start, match = table.unpack(pair)
    local matchlength 
    if type(match) == "string" then
      matchlength = len(match)
    else
      matchlength = 1
    end
    local sliceend = start - 1
    if opts.includeSep then
      sliceend = start
    end
    local fragment = slice(thing, lastend, sliceend)
    push(res, fragment)
    local stop = start + matchlength - 1
    lastend = stop + 1
  end

  local lastfragment = slice(thing, lastend)
  push(res, lastfragment)

  return res
end

--- @generic T : indexable
--- @param thing T
--- @param n integer
--- @return T[]
function chunk(thing, n)
  return split(thing, function(k) return (k - 1) % n == 0 end, { includesep = true , findopts = { args = "k"} })
end

--- @class spliceOpts : appendOpts
--- @field start? integer
--- @field overwrite? boolean

--- @generic T : indexable
--- @param thing1 T
--- @param thing2 T
--- @param opts? spliceOpts | integer
--- @return T
function splice(thing1, thing2, opts)
  if type(opts) == "number" then
    opts = {start = opts}
  else
    opts = tablex.deepcopy(opts) or {}
  end
  opts.start = opts.start or 1
  opts.overwrite = opts.overwrite or false
  local res = {}
  local before = slice(thing1, 1, opts.start - 1)
  if opts.overwrite then
    local after = slice(thing1, opts.start + len(thing2))
    res = concat(before, thing2, after)
  else
    local after = slice(thing1, opts.start)
    res = concat(before, thing2, after)
  end
  return res
end