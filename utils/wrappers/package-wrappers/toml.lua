
--- @param s string
--- @return any
function tomlDecode(s)
  local succ, raw_decode = pcall(toml.decode, s)
  if succ then
    return mapValueNewValueRecursive(
      raw_decode,
      function (value)
        if value == 0 then
          return false
        elseif value == 1 then
          return true
        else
          return value
        end
      end) -- fix bug in library where booleans are represented as 0 and 1. Will of course prevent 0 and 1 from being used as values.
  else
    return nil
  end
end