function returnAny(...)
  return ...
end

--- @param ... any
--- @return integer
function returnNumArgs(...)
  local args = {...}
  return #args
end


--- @generic T : string | any[]
--- @param thing T
--- @return T
function returnEmpty(thing)
  if type(thing) == "string" then
    return ""
  else
    return {}
  end
end

--- @param regex string
--- @return string
function whole(regex)
  return "^" .. regex .. "$"
end

function returnPoisonable()
  local dirty = false
  local returnfn
  returnfn = function(...)
    if dirty then
      error("poisoned " .. tostring(returnfn))
    end
    dirty = true
    return {...}
  end
  return returnfn
end