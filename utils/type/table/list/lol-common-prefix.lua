
--- @generic T
--- @param list_of_lists `T`[][]
--- @return T[]
function lolCommonPrefix(list_of_lists)
  return reduce(list_of_lists, function(acc, list)
    return slice(acc, 1, find(list, {
      _exactly = acc[1],
      _invert = true,
    }, "k") - 1)
  end, list_of_lists[1])
end