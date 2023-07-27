---@alias indexable string|any[]|table|orderedtable

--- @class sliceSpec
--- @field start? integer|conditionSpec inclusive (both when positive, negative and for any conditionSpec). Default 1
--- @field stop? integer|conditionSpec inclusive (both when positive, negative and for any conditionSpec). Default -1 ≙ #thing 
--- @field step? integer May also be negative. Default 1
--- @field sliced_indicator? any Optional indicator to be added to the result when changed as a result of slicing, e.g. for adding ellipses. Default nil (no indicator)
--- @field fill? any Optional value to fill any positions that were sliced away with, such that the result is the same length as the original. Default nil (no filling)
--- @field last_start? boolean When using a conditionSpec for start, this indicates that the last matching element should be used instead of the first. Default false
--- @field last_stop? boolean When using a conditionSpec for stop, this indicates that the last matching element should be used instead of the first. Default false

--- @alias sliceSpecLike sliceSpec | string string here is a shorthand parsed as [<start>]:[<stop>][:[<step>]]

--- slices an indexable
--- - start and stop are inclusive, (positive and negative)
--- - negative step to reverse
--- - start < first index or stop > last index will be clamped to the first and last index respectively, thus preventing errors when out of bounds
--- - start > stop (if pos step) or start < stop (if neg step) will return an empty table
--- @generic T : indexable
--- @param thing T
--- @param start_or_spec? integer|string|sliceSpec if we're specifying the start, stop and step as separate arguments, otherwise a sliceSpec or a string to be parsed as a sliceSpec
--- @param stop? conditionSpec integer if we're specifying the start, stop and step as separate arguments, otherwise nil
--- @param step? integer see above
--- @return T, sliceSpec
function slice(thing, start_or_spec, stop, step)

  local spec = {}

  -- parse the slice spec if it's a string or table

  if type(start_or_spec) == "table" then
    spec = get.table.copy(start_or_spec, false)
  elseif type(start_or_spec) == "string" then
    local stripped_str = stringy.strip(start_or_spec)
    local start_str, stop_str, step_str = onig.match(
      stripped_str, 
      "^\\[?(-?\\d*):(-?\\d*)(?::(-?\\d+))?\\]?$"
    )
    spec.start = get.string_or_number.int_by_rounded_or_nil(start_str)
    spec.stop = get.string_or_number.int_by_rounded_or_nil(stop_str)
    spec.step = get.string_or_number.int_by_rounded_or_nil(step_str)

  else
    spec.start = start_or_spec
    spec.stop = stop
    spec.step = step
  end

  if spec.start and type(spec.start) ~= "number" then
    spec.start = find(thing, spec.start, {ret = "i", last = spec.last_start})
  end

  if spec.stop and type(spec.stop) ~= "number" then
    spec.stop = find(thing, spec.stop, {ret = "i", start = spec.start, last = spec.last_stop})
  end

  local is_assoc = type(thing) == "table" and not is.table.array(thing)



  -- implement various functions polymorphically depending on the type of thing

  local new_thing = getEmptyResult(thing)

  -- set defaults

  if not spec.step then spec.step = 1 end
  if not spec.start then spec.start = 1 end
  if not spec.stop then spec.stop = transf.indexable.length(thing) end

  -- resolve negative indices

  if spec.start < 0 then
    spec.start = transf.indexable.length(thing) + spec.start + 1
  end
  if spec.stop < 0 then
    spec.stop = transf.indexable.length(thing) + spec.stop + 1
  end

  -- clamp indices to ensure we don't go out of bounds (+/-1 because we want over/underindexing to produce an empty thing, not the last element)

  spec.start = get.comparable.clamp(spec.start, 1, transf.indexable.length(thing) + 1)
  spec.stop = get.comparable.clamp(spec.stop, 1-1, transf.indexable.length(thing))

  -- handle cases where users have passed conditions that will result in an infinite loop
  -- currently: return empty thing
  -- consider: reverse the step

  if spec.start > spec.stop and spec.step > 0 then
    return new_thing, spec
  elseif spec.start < spec.stop and spec.step < 0 then
    return new_thing, spec
  end

  -- build the slice
  
  for i = spec.start, spec.stop, spec.step do
    if is_assoc then
      new_thing = append(new_thing, {elemAt(thing, i, "kv")})
    else
      new_thing = append(new_thing, elemAt(thing, i))
    end
  end

  if spec.fill then
    local prepend = transf.indexable.unspecified_equivalent_empty_indexable(thing)
    for i = 1, spec.start - 1 do
      prepend = append(prepend, spec.fill)
    end

    local postpend = transf.indexable.unspecified_equivalent_empty_indexable(thing)
    for i = spec.stop + 1, transf.indexable.length(thing) do
      postpend = append(postpend, spec.fill)
    end

    new_thing = concat(prepend, new_thing, postpend)
  end

  if spec.sliced_indicator then
    if spec.start > 1 then
      if is.any.array(new_thing) and not is.any.array(spec.sliced_indicator) then
        new_thing = concat({spec.sliced_indicator}, new_thing)
      else
        new_thing = concat(spec.sliced_indicator, new_thing)
      end
    end
    if spec.stop < transf.indexable.length(thing) then
      new_thing = concat(new_thing, spec.sliced_indicator)
    end
  end

  return new_thing, spec
end