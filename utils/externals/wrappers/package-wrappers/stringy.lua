--- @type fun(s: string, sep?: string): string[]
function stringySplitFiltered(str, sep)
  return filter(stringy.split(str, sep, true))
end