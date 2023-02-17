--- @param str string
--- @param start_incl? number
--- @param stop_excl? number
--- @param step? number
function stringSlice(str, start_incl, stop_excl, step)
  if not step then step = 1 end
  if not start_incl then start_incl = 1 end
  if not stop_excl then stop_excl = #str end

  local res = ""
  if start_incl < 0 then
    start_incl = eutf8.len(str) + start_incl + 1
  end
  if stop_excl < 0 then
    stop_excl = eutf8.len(str) + stop_excl + 1
  end
  for i = start_incl, stop_excl, step do
    res = res .. eutf8.sub(str, i, i)
  end
  return res
end

--- @alias stringSliceSpec {start: integer, stop: integer, step: integer}
--- @param str string
--- @param spec stringSliceSpec
--- @return string
function stringSliceSpec(str, spec)
  return stringSlice(str, spec.start, spec.stop, spec.step)
end

--- @param str string
--- @param notation string
--- @return string
function stringSliceNotation(str, notation)
  local start, stop, step = parsePythonlikeSliceNotation(notation)
  return stringSlice(str, start, stop, step)
end


--- @param str string
--- @return integer, integer, integer
function parsePythonlikeSliceNotation(str)
  local stripped_str = stringy.strip(str)
  local start, stop, step = onig.match(
    stripped_str, 
    "^(\\d+)(?::(\\d+))?(?::(\\d+))?$"
  )
  start = tonumber(start) or 1
  stop = tonumber(stop) or 1
  step = tonumber(step) or 1
  return start, stop, step
end

