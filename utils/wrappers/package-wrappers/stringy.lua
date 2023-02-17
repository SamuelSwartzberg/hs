--- @type fun(s: string, sep?: string): string[]
function stringySplit(str, sep)
  return stringy.split(str, sep)
end

--- @type fun(s: string, sep?: string): string[]
function stringySplitFiltered(str, sep)
  return listFilterEmptyString(stringy.split(str, sep))
end