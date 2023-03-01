--- @generic T
--- @param list T[]
--- @param sample_size? integer defaults to 2
--- @return string
function listSampleString(list, sample_size)
  if not sample_size then sample_size = 2 end
  local listSample = slice(list, 1, sample_size)
  local outstr = stringx.join(", ", listSample)
  if #list > sample_size then
    outstr = outstr .. ", ..."
  end
  return outstr
end
