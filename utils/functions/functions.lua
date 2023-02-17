--- @param cond boolean 
--- @param ifTrue any
--- @param ifFalse any
--- @return any
function ternary(cond, ifTrue, ifFalse)
  if cond then
    return ifTrue
  else
    return ifFalse
  end
end

--- @param val any
--- @param default any
--- @return any
function defaultIfNil(val, default)
  return ternary(val == nil, default, val)
end