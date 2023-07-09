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