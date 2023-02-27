--- @alias sliceSpec {start: integer, stop?: integer, step?: integer}
--- @alias sliceLArgOverload fun(thing: any[], start_incl_or_spec?: integer, stop_incl?: integer, step?: integer): any[]
--- @alias sliceLSpecOverload fun(thing: any[], start_incl_or_spec: sliceSpec | string): any[]
--- @alias sliceSArgOverload fun(thing: string, start_incl_or_spec?: integer, stop_incl?: integer, step?: integer): string
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