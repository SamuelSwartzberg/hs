
--- Binary type with two arbitrary values
--- @param vt any
--- @param vf any
function Binary(vt, vf)
  local binary = {
    vt = vt,
    vf = vf,
  }

  --- @param state boolean
  --- @return any
  function binary:get(state)
    if state then
      return self.vt
    else
      return self.vf
    end
  end

  --- @param state any
  --- @return boolean
  function binary:getBool(state)
    if state == self.vt then
      return true
    elseif state == self.vf then
      return false
    else
      error("Invalid state")
    end
  end

  --- @param state boolean
  --- @return any
  function binary:invBool(state)
    return self:get(not state)
  end

  --- @param state any
  --- @return any
  function binary:invV(state)
    return self:get(not self:getBool(state))
  end

  --- @param state any
  --- @return any
  function binary:inv(state)
    if type(state) == "boolean" or state == nil then
      return self:invBool(state)
    else
      return self:invV(state)
    end
  end

  return binary
end

InfNo = Binary("inf", "no")