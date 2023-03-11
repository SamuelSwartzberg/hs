--- @param str string
--- @return string[]
function bytechars(str)
  local t = {}
  for i = 1, #str do
    t[i] = str:sub(i, i)
  end
  return t
end


--- @param str string
--- @return string[]
function chars(str)
  local t = {}
  for i = 1, eutf8.len(str) do
    t[i] = eutf8.sub(str, i, i)
  end
  return t
end

--- @param str string
--- @return string[]
function lines(str)
  return stringy.split(
    stringy.strip(str),
    "\n"
  )
end