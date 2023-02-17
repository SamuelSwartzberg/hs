---tr all chars in from to chars in to (1:1), similar to the cli tool `tr`
---@param s string
---@param from string
---@param to string
---@return string
function stringTr(s, from, to)
  for i = 1, #from do
    s = eutf8.gsub(s, eutf8.sub(from, i, i), eutf8.sub(to, i, i))
  end
  return s
end

---tr all chars in from to the same char(s) in to (n:1)
---@param s string
---@param from string
---@param to string
---@return string
function stringTrAllToSame(s, from, to)
  for i = 1, #from do
    s = eutf8.gsub(s, eutf8.sub(from, i, i), to)
  end
  return s
end
