--- fast string functions. Typically, we have more polymorphic or featureful versions of these functions elsewhere, but these are the fastest versions, trading off features for speed.

--- @param str string
--- @param anyof string[]
--- @return boolean
function anyOfFast(str, anyof)
  for i = 1, #anyof do
    local res = stringy.find(str, anyof[i])
    if res then
      return true
    end
  end
  return false
end

--- @param str string
--- @param allof string[]
--- @return boolean
function allOfFast(str, allof)
  for i = 1, #allof do
    local res = stringy.find(str, allof[i])
    if not res then
      return false
    end
  end
  return true
end

--- @param str string
--- @param starts string
--- @param ends string
--- @return boolean
function startsEndsWithFast(str, starts, ends)
  return stringy.startswith(str, starts) and stringy.endswith(str, ends)
end